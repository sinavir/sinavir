import asyncio
import logging

import aioredis
import websockets

from ragb import settings

logging.basicConfig(level=logging.DEBUG)

CONNECTIONS = set()


async def handler(websocket):
    logging.debug("New connection")
    CONNECTIONS.add(websocket)
    try:
        await websocket.wait_closed()
    finally:
        CONNECTIONS.discard(websocket)


async def process_events():
    """Listen to events in Redis and process them."""
    logging.info("Connecting to REDIS")
    redis = aioredis.from_url(settings.REDIS_URI)
    pubsub = redis.pubsub()
    logging.info("Waiting for events")
    await pubsub.subscribe("light_changes")
    async for message in pubsub.listen():
        if message["type"] != "message":
            continue
        payload = message["data"].decode()
        logging.info(f"New message: {repr(payload)}")
        websockets.broadcast(CONNECTIONS, payload)


async def main():
    async with websockets.serve(
        handler, settings.WEBSOCKET_HOST, settings.WEBSOCKET_PORT
    ):
        await process_events()  # runs forever


def run():
    asyncio.run(main())


if __name__ == "__main__":
    run()

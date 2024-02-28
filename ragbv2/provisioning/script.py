import json
import pprint

import sseclient


def with_requests(url, headers):
    """Get a streaming response for the given event feed using requests."""
    import requests

    return requests.get(url, stream=True, headers=headers)


def with_urllib3(url, headers):
    """Get a streaming response for the given event feed using urllib3."""
    import urllib3

    http = urllib3.PoolManager()
    return http.request("GET", url, preload_content=False, headers=headers)


url = "http://127.0.0.1:9999/api/sse"
headers = {"Accept": "text/event-stream"}
response = with_requests(url, headers)  # or with_requests(url, headers)
client = sseclient.SSEClient(response)
for event in client.events():
    pprint.pprint(json.loads(event.data))

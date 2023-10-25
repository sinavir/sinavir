from setuptools import setup

setup(
    name="carottepy",
    version="1.0.2",
    packages=["carottepy", "lib_carotte"],
    install_requires=[
        "colored-traceback",
        "assignhooks",
        "colorama",
    ],
    entry_points={
        "console_scripts": [
            "carotte.py = carottepy:main",
        ]
    },
)

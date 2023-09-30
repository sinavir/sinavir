import argparse
import pathlib
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument(
    "templates_root",
    help="The root of my templates. eg: '.provisioning/templates'",
)
args = parser.parse_args()

root = pathlib.Path(args.templates_root)

npins_enable_templates = [i.parent for i in root.glob("*/npins")]

for template in npins_enable_templates:
    print(f"Updating {template}...")
    subprocess.check_call(["npins", "update"], cwd=template)

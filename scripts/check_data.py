import argparse
import sys

# Parse arguments:
parser = argparse.ArgumentParser(
    prog = 'Check JSON data',
    description = 'Validates if JSON data is not null and delivers a default.',
    epilog = '© Florian Zedler @ 2024-03-03'
)
parser.add_argument(
    '-i', '--input',
    type = str,
    help = 'Input Json data'
)
parser.add_argument(
    '-c', '--check',
    action = 'store_false',
    default = True,
    help = 'True: Checks if the input is valid; False: Always return error JSON'
)
parser.add_argument(
    '-e', '--error_json',
    type = str,
    default = '{ "status": "Error" }',
    help= 'Overrides the default error json'
)

# Init:
args = parser.parse_args()
result = args.error_json

# If pipeline is detected:
if not sys.stdin.isatty():
    args.input = sys.stdin.read()

# If json is set and check is enabled:
if args.check and args.input:
    result = args.input

# Return result:
sys.stdout.write(result)
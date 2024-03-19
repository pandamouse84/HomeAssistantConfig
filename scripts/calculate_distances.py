from math import sin, cos, sqrt, atan2, radians
import json
import argparse
import sys

# Parse arguments:
parser = argparse.ArgumentParser(
    prog = 'Get nearest object',
    description = 'Out of a list of json objects the nearest object will be returned.',
    epilog = '© Florian Zedler @ 2024-03-03'
)
parser.add_argument(
    '-i', '--input',
    type = str,
    help = 'Input Json data'
)
parser.add_argument(
    '-la', '--latitude',
    type = float,
    required = True,
    help = 'Latitude of the point to which the nearest object shall be found.'
)
parser.add_argument(
    '-lo', '--longitude',
    type = float,
    required = True,
    help= 'Longitude of the point to which the nearest object shall be found.'
)
parser.add_argument(
    '-md', '--max_distance',
    type = float,
    required = True,
    help= 'Maximal distance to check the data'
)
parser.add_argument(
    '-d', '--debug',
    action = 'store_true',
    default = False,
    help= 'Ignores max distance and gets first object in the json array'
)
parser.add_argument(
    '-e', '--error_json',
    type = str,
    default = '{ "status": "Error" }',
    help= 'Overrides the default error json'
)

# Init:
args = parser.parse_args()
json_error = json.loads(args.error_json)
json_object = json_error

# If pipeline is detected:
if not sys.stdin.isatty():
    args.input = sys.stdin.read()

if args.input:
    json_object = json.loads(args.input)

# Define the function to calculate the distance between two points:
def get_distance(lat1, lon1, lat2, lon2):
    r = 6371.0087714
    lat1 = radians(lat1)
    lon1 = radians(lon1)
    lat2 = radians(lat2)
    lon2 = radians(lon2)
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return r * c

# Define the function get the nearest object:
def get_distances(json_object, lat, lon, MaxDistance, temp_result):
    validItems = []
    for item in json_object["data"]:
        distance = get_distance(lat, lon, item["latitude"], item["longitude"])
        item["distance"] = distance
        if distance <= MaxDistance:
            validItems.append(item)
    if len(validItems) > 0:
        temp_result = json.loads('{ "status": "OK", "data": [] }')
        temp_result["data"] = min(validItems, key=lambda x: x["distance"])
    result = temp_result
    return result

# If json is set get the nearest distance
if json_object["status"] == "OK":
    json_object = get_distances(json_object, args.latitude, args.longitude, args.max_distance, json_error)
    # Debug
    if args.debug and json_object["status"] == "Error":
        json_object = json_object["data"][0]

# Return result:
result = json.dumps(json_object, ensure_ascii = False)
sys.stdout.write(result)
from flask import Flask, render_template, jsonify, request
from SParking.parking_database.db_funcs import add_parking_location_db, get_best_parking_location_available, save_parking_location, catch_parking_db, free_catch_parking
import subprocess
import json


app = Flask(__name__)


def add_parking_location(latitude, longitude, num_spots):
    parking_id = add_parking_location_db(latitude, longitude, num_spots)
    print(parking_id)
    subprocess.run(
        ["C:/Program Files/R/R-4.2.0/bin/Rscript.exe", "../statistics/ADD_PARKING_LOCATION.R", f"{parking_id}",
         f"{longitude}", f"{latitude}", f"{num_spots}"])


@app.route('/get_radius_to_ask_saving', methods=['POST'])
def get_radius_to_ask_saving():
    data_from_client = request.get_json()
    print(data_from_client)
    response = json.loads(subprocess.check_output(
        ["C:/Program Files/R/R-4.2.0/bin/Rscript.exe", "../statistics/get_data.R", "5",
         f"{data_from_client['dst']['longitude']}", f"{data_from_client['dst']['latitude']}",
         f"{data_from_client['time']}"]))

    print(response)

    return {'r': response['r'], 'parking_ids': response['parking_ids']}


@app.route('/get_parking_suggestion', methods=['POST'])
def get_parking_suggestion():
    data_from_client = request.get_json()

    return {'response': get_best_parking_location_available(data_from_client['parking_ids'])}


@app.route('/save_parking', methods=['POST'])
def save_parking():
    data_from_client = request.get_json()
    latitude, longitude = save_parking_location(data_from_client['parking_id'])
    return {'latitude': latitude, 'longitude': longitude}


@app.route('/catch_parking', methods=['POST'])
def catch_parking():
    data_from_client = request.get_json()
    catch_parking_db(data_from_client['parking_id'])
    return "Success"


@app.route('/free_parking', methods=['POST'])
def free_parking():
    data_from_client = request.get_json()
    free_catch_parking(data_from_client['parking_id'])
    return "Success"


# {
#  src: {latitude: ..., longitude: ...},
#  dst: {latitude: ..., longitude: ...},
#  time: ...
# }

if __name__ == '__main__':
    app.run(host="0.0.0.0")
    # add_parking_location(5.46, 6.67, 10)

from flask import Flask, render_template, jsonify, request

app = Flask(__name__)


@app.route('/get_statistic_dst_parking_loc', methods=['POST'])
def get_statistic_dst_parking_loc():

    return "This is home page"


if __name__ == '__main__':
    app.run()

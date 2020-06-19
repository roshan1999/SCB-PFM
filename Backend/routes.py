from route import *
from flask import jsonify


@app.route('/',methods = ['GET'])
def home():
    return jsonify({'message':'Presenting PFM api'})

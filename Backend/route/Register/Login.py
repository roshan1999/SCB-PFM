from myapp import app
from ..Token import *
from datetime import datetime, timedelta
import jwt
from werkzeug.security import generate_password_hash, check_password_hash
from flask import request, jsonify, make_response
from model import User
# Using Basic Auth for Login
@app.route('/login')
def login():
    auth = request.authorization
    # Validation : If not a valid authorization format (Basic auth).
    if not auth or not auth.username or not auth.password:
        print("auth unsuccessful");
        return make_response('Could not verify auth', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})

    user = User.query.filter_by(email=auth.username).first()
    # Validation : User doesn't exist
    if not user:
        print(auth.username,auth.password);
        print("user search unsuccessful");
        return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})
    # Validation : User exists, password incorrect
    if check_password_hash(user.password, auth.password):
        token = jwt.encode({'public_id' : user.public_id, 'exp' : datetime.utcnow() + timedelta(minutes=24*60)}, app.config['SECRET_KEY'])
        print(auth.username,auth.password);
        return jsonify({'token' : token.decode('UTF-8') , 'name' : user.name, 'mail' : user.email})

    return make_response('Could not verify', 401, {'WWW-Authenticate' : 'Basic realm="Login required!"'})

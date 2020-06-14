from myapp import app
import uuid
import jwt
from datetime import datetime, timedelta
from ..Token import *
from flask import request, jsonify, make_response
from model import OtpTable, User
from werkzeug.security import generate_password_hash, check_password_hash

@app.route('/register', methods=['POST'])
def create_user():
    data = request.get_json()
    sessionId = data['sessionId']
    otp = OtpTable.query.filter_by(session=sessionId).first()

    if(otp.verified == False):
        print(otp.verified);
        return jsonify({"message":"OTP not verified"},401)

    hashed_password = generate_password_hash(data['password'], method='sha256')
    new_user = User(public_id=str(uuid.uuid4()), name=data['name'], password=hashed_password, email = data['email'], admin=False)
    db.session.add(new_user)
    db.session.commit()
    token = jwt.encode({'public_id' : new_user.public_id, 'exp' : datetime.utcnow() + timedelta(minutes=30)}, app.config['SECRET_KEY'])
    return jsonify({'message' : token.decode('UTF-8')})

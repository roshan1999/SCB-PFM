from myapp import app
from ..Token import *
import datetime
from datetime import datetime,timedelta
from .Otpgen import generateOTP
from flask import request, jsonify
import uuid
from model import OtpTable
# Get OTP by providing mobile Number

@app.route('/getOTP',methods = ['POST'])
def gen_otp():
    data = request.get_json()
    print(data)
    mobile_no = data['mobileNo']
    otp_gen = generateOTP()
    print(otp_gen)
    session_id=str(uuid.uuid4())
    t = datetime.now()+timedelta(seconds = 90)
    new_otp = OtpTable(session = session_id, otp = otp_gen,expiry = t, mobileNo = mobile_no, verified = False)
    db.session.add(new_otp)
    db.session.commit()
    return jsonify({'message':session_id})

# Verify otp by providing sessionId and OTP
# Body = session_id and otp to verify
@app.route('/checkOTP',methods = ['POST'])
def check_otp():
    data = request.get_json()
    otp = data['OTP']
    session_id = data['sessionId']
    otp_session = OtpTable.query.filter_by(session = session_id).first()

    # Append a status tag.
    if (otp_session.expiry<=datetime.now()):
            db.session.delete(otp_session)
            db.session.commit()
            return jsonify({"message":"OTP expired"})

    if str(otp_session.otp)==otp :
        otp_session.verified = True
        print(otp_session.verified);
        db.session.commit();
        return jsonify({'message':'OTP true'})

    db.session.delete(otp_session)
    db.session.commit()
    return jsonify({'message':'OTP false'})

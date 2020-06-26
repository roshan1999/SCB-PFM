from myapp import db,ma

class OtpTable(db.Model):
    session = db.Column(db.String(50),primary_key = True)
    otp = db.Column(db.Integer)
    expiry = db.Column(db.DateTime)
    mobileNo = db.Column(db.String(20))
    verified = db.Column(db.Boolean)

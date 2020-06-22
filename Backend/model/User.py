from myapp import db,ma
class User(db.Model):
    __tablename__ = 'user'
    public_id = db.Column(db.String(50), unique=True,primary_key = True)
    name = db.Column(db.String(50))
    email = db.Column(db.String(50))
    password = db.Column(db.String(80))
    admin = db.Column(db.Boolean)
    ##Relationships --
    goals = db.relationship('Goal', backref='owner', lazy='dynamic') ## One to Many Relationship
    reminders = db.relationship('Reminder', backref = 'owner',lazy = "dynamic") ## One to Many relationship
    categorys = db.relationship('Category',backref = 'owner',lazy = "dynamic")  ## One to Many relationship
    transactions = db.relationship('Transaction',backref ='owner',lazy = "dynamic")

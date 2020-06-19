from myapp import db,ma

class Goal(db.Model):
    __tablename__ = 'goal'
    id = db.Column(db.Integer, primary_key=True)
    due_date = db.Column(db.Date, nullable=False)
    description = db.Column(db.String(200))
    amount_total = db.Column(db.Integer, nullable=False)
    amount_saved = db.Column(db.Integer)
    public_id = db.Column(db.String, db.ForeignKey('user.public_id'), nullable=False)

    def __init__(self, due_date, description, amount_total, amount_saved, public_id):
        self.due_date = due_date
        self.description = description
        self.amount_total = amount_total
        self.amount_saved = amount_saved
        self.public_id = public_id

class GoalSchema(ma.Schema):
    class Meta:
        fields = ('id', 'due_date', 'description','amount_total', 'amount_saved')

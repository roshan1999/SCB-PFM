from myapp import db,ma
class Reminder(db.Model):
  __tablename__ = 'reminder'
  id = db.Column(db.Integer, primary_key=True)
  amount = db.Column(db.Integer)
  due_date = db.Column(db.Date)
  description = db.Column(db.String(300))
  achieved = db.Column(db.Boolean) # Will set to 1 when user will mark reminder as complete
  public_id = db.Column(db.String(50), db.ForeignKey('user.public_id'),nullable = False)

  def __init__(self, amount, due_date, description, achieved,public_id):
    self.amount = amount
    self.due_date = due_date
    self.description = description
    self.achieved = achieved
    self.public_id = public_id


class ReminderSchema(ma.Schema):
  class Meta:
    fields = ('id', 'amount', 'due_date', 'description', 'achieved','public_id',)

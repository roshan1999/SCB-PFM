from myapp import db,ma
class Transaction(db.Model):
  __tablename__ = 'transaction'
  id = db.Column(db.Integer, primary_key=True)
  amount = db.Column(db.Integer)
  date = db.Column(db.Date)
  description = db.Column(db.String(300))
  category_id = db.Column(db.Integer,db.ForeignKey('category.id'),nullable = False)
  public_id = db.Column(db.String(50), db.ForeignKey('user.public_id'),nullable = False)

  def __init__(self, amount, date, description, category_id,public_id):
    self.amount = amount
    self.date = date
    self.description = description
    self.category_id = category_id
    self.public_id = public_id


class TransactionSchema(ma.Schema):
  class Meta:
    fields = ('id', 'amount', 'date', 'description', 'category_id','public_id',)

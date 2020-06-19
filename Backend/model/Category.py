from myapp import db,ma

class Category(db.Model):
  __tablename__ = 'category'
  id = db.Column(db.Integer, primary_key=True)
  amount = db.Column(db.Integer)
  label = db.Column(db.String(300))
  month = db.Column(db.Date) ## Format -- (01-MM-YYYY)
  cat_type = db.Column(db.Boolean) ## Income = 0/Expense = 1
  public_id = db.Column(db.String(50), db.ForeignKey('user.public_id'),nullable = False)


  def __init__(self, label, month, cat_type,public_id,amount = 0):
    self.amount = amount
    self.label = label
    self.month = month
    self.cat_type = cat_type
    self.public_id = public_id


class CategorySchema(ma.Schema):
  class Meta:
    fields = ('id', 'amount', 'label', 'month', 'cat_type','public_id')

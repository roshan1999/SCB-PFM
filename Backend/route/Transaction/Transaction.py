from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
from datetime import datetime

# Create a Transactino
@app.route('/transaction', methods=['POST'])
@token_required
def add_transaction(current_user):
  amount = request.json['amount']
  date = request.json['date']
  description = request.json['description']
  print
  date_form = datetime.strptime(date, "%d-%m-%Y")
  print(date)
  user_public_id = current_user.public_id
  stri = str(date_form.year) + "-"+str(date_form.month)+"-"+"1"
  my_date = datetime.strptime(stri, "%Y-%m-%d")
  category = Category.query.filter_by(public_id = user_public_id, label = request.json['label'], month = my_date).first();
  print(my_date)
  category.amount = category.amount + int(amount)

  new_transaction = Transaction(amount, date, description, category.id, user_public_id)

  db.session.add(new_transaction)
  db.session.commit()

  return transaction_schema.jsonify(new_transaction)


# Get All Transaction
@app.route('/transaction', methods=['GET'])
@token_required
def get_transactions(current_user):
  user = User.query.filter_by(public_id = current_user.public_id).first()
  result = user.transactions.order_by(Transaction.date.desc())
  return transactions_schema.jsonify(result)


# Get Single Transaction
@app.route('/transaction/<id>', methods=['GET'])
@token_required
def get_transaction(current_user,id):
  transaction = transaction.query.get(id)
  return transaction_schema.jsonify(transaction)



# Update a Transaction
@app.route('/transaction/<id>', methods=['PATCH'])
@token_required
def update_transaction(current_user,id):
  transact = transaction.query.get(id)

  new_req = request.json
  for key,value in new_req.items():
      setattr(transact,key,value)

  db.session.commit()

  return transaction_schema.jsonify(transact)

# Delete Transaction
@app.route('/transaction/<id>', methods=['DELETE'])
@token_required
def delete_transaction(current_user, id):
  transact = Transaction.query.get(id)
  cat_id = transact.category_id
  my_date_month = transact.date.month
  my_date_year = transact.date.year
  stri = str(my_date_year) + "-"+str(my_date_month)+"-"+"1"
  my_date = datetime.strptime(stri, "%Y-%m-%d")
  print(my_date)
  category = Category.query.filter_by(public_id = current_user.public_id, month = my_date, id = cat_id).first();
  print(category)
  category.amount = category.amount - transact.amount
  db.session.delete(transact)
  db.session.commit()

  return transaction_schema.jsonify(transact)

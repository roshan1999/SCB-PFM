from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response

# Create a Transactino
@app.route('/transaction', methods=['POST'])
@token_required
def add_transaction(current_user):
  amount = request.json['amount']
  date = request.json['date']
  description = request.json['description']
  print(date)
  user_public_id = current_user.public_id
  category = Category.query.filter_by(public_id = user_public_id, label = request.json['label']).first();
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
  result = user.transactions.all()
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
  category = Category.query.filter_by(public_id = current_user.public_id, label = request.json['label']).first();
  category.amount = category.amount - transact.amount
  db.session.delete(transact)
  db.session.commit()

  return transaction_schema.jsonify(transact)

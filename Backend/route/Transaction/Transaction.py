from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
from datetime import datetime

# Create a Transactinon
@app.route('/transaction', methods=['POST'])
@token_required
def add_transaction(current_user):
  amount = request.json['amount']
  date_form = datetime.strptime(request.json['date'],"%d-%m-%Y")
  description = request.json['description']
  print
  print(date_form)
  user_public_id = current_user.public_id
  stri = str(date_form.year) + "-"+str(date_form.month)+"-"+"1"
  my_date = datetime.strptime(stri, "%Y-%m-%d")
  try:
      category = Category.query.filter_by(public_id = user_public_id, label = request.json['label'], month = my_date).first();
      print(my_date)
      category.amount = category.amount + int(amount)
  except:
      print("category not found... adding category")
      label = request.json['label']
      month = my_date
      if(label=="Salary" or label=="Rental" or label =="Other income" or label=="Income"):
          cat_type=0
      else:
          cat_type=1
      user_public_id = current_user.public_id
      category = Category(label, month, cat_type, user_public_id)
      category.amount = category.amount + int(amount)
      print(category.amount)
      db.session.add(category)
      db.session.commit()

  new_transaction = Transaction(amount, date_form, description, category.id, user_public_id)
  print(new_transaction.amount)
  db.session.add(new_transaction)
  db.session.commit()

  return transaction_schema.jsonify(new_transaction)


# Get All Transaction
@app.route('/transaction', methods=['GET'])
@token_required
def get_transactions(current_user):
  user = User.query.filter_by(public_id = current_user.public_id).first()
  lst = list()
  result = user.transactions.order_by(Transaction.date.desc()).all()
  print(result)
  for transact in result:
      dc = dict()
      cat_id = transact.category_id
      my_date_month = transact.date.month
      my_date_year = transact.date.year
      stri = str(my_date_year) + "-"+str(my_date_month)+"-"+"1"
      my_date = datetime.strptime(stri, "%Y-%m-%d")
      category = Category.query.filter_by(public_id = current_user.public_id, month = my_date, id = cat_id).first();
      dc["id"] = transact.id
      dc["amount"] = transact.amount
      date = transact.date.strftime("%d-%m-%Y")
      dc["date"] = date
      dc["description"] =transact.description
      dc["label"] =category.label
      dc["type"] = category.cat_type
      lst.append(dc)
  return jsonify(lst)


# Get Single Transaction
@app.route('/transaction/<id>', methods=['GET'])
@token_required
def get_transaction(current_user,id):
  transaction = transaction.query.get(id)
  print(transaction)
  return transaction_schema.jsonify(transaction)



# Update a Transaction
@app.route('/transaction', methods=['PATCH'])
@token_required
def update_transaction(current_user):
  transact = Transaction.query.get(request.json["id"])
  cat_id = transact.category_id
  my_date_month = transact.date.month
  my_date_year = transact.date.year
  stri = str(my_date_year) + "-"+str(my_date_month)+"-"+"1"
  my_date = datetime.strptime(stri, "%Y-%m-%d")
  category = Category.query.filter_by(public_id = current_user.public_id, month = my_date, id = cat_id).first();
  new_req = request.json
  for key,value in new_req.items():
      if(key == "amount"):
          print(category.amount)
          category.amount = category.amount - transact.amount
          print(category.amount)
          category.amount+=int(value)
          print(category.amount)
      if(key!="id"):
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

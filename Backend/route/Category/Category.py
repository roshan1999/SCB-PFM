from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
from datetime import datetime, timedelta
import calendar
# Create a Category
@app.route('/category', methods=['PATCH'])
@token_required
def add_category(current_user):
  label = request.json['label']
  month = datetime.strptime(request.json['month'], "%d-%m-%yy") ## Format (01-MM-YYYY)
  cat_type = request.json['cat_type']
  amount = request.json['amount']
  user_public_id = current_user.public_id
  new_category = Category(label, month, cat_type, user_public_id)

  db.session.add(new_category)
  db.session.commit()

  return category_schema.jsonify(new_category)

# Get All Categorys
@app.route('/category', methods=['GET'])
@token_required
def get_categorys(current_user):
  user_categorys = User.query.filter_by(public_id = current_user.public_id).first()
  result = user_categorys.categorys.all()
  return categorys_schema.jsonify(result)


# Adding a transaction to a Category(Updating the amount)
@app.route('/category/<id>', methods=['PUT'])
@token_required
def update_category(current_user, id):
  category = Category.query.get(id)

  amount = request.json['amount']

  category.amount = category.amount + int(amount)

  db.session.commit()

  return category_schema.jsonify(category)


@app.route('/category/<month>', methods=['GET'])
@token_required
def monthly_categorys(current_user,month):
  user_categorys = User.query.filter_by(public_id = current_user.public_id).first()
  date_start = datetime.strptime(month,"%d-%m-%Y")
  stri = str(date_start.year) + "-"+str(date_start.month)+"-"+"1"
  my_date = datetime.strptime(stri, "%Y-%m-%d")
  last_day = calendar.monthrange(date_start.year,date_start.month)[1]
  date_end = date_start + timedelta(days = last_day-1)
  print(my_date,date_end)
  result = user_categorys.categorys.filter(Category.month.between(my_date,date_end))
  return categorys_schema.jsonify(result)

# TODO: Get total amount spent in a particular category(in a particular month)
# TODO : Fetch amount for total transactino in that month from transaction table.
# @app.route('/category/<label>/<month_year>')
# @token_required
# def get_amount_month(current_user,month_year):
#     category_month = Category.query.filter(user_public_id==current_user.public_id and month==month_year)
#     total_amount_month = 0
#     for category in category_month:
#         total_amount_month = total_amount_month + category.amount
#     return jsonify({"amoount in month":total_amount_month})


# Delete Category
@app.route('/category/<id>', methods=['DELETE'])
@token_required
def delete_category(current_user, id):
# TODO: Handle transaction of deleted Category
  category = Category.query.get(id)
  db.session.delete(category)
  db.session.commit()

  return category_schema.jsonify(category)

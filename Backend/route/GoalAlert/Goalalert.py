from myapp import app
from ..Token import *
from model import *
from flask import request, jsonify, make_response
from sqlalchemy import func
from datetime import datetime, date
import json
import dateutil.relativedelta
# Get all goals


@app.route('/alert', methods=['GET'])
@token_required
def get_alert_goal(current_user):
  amount_complete=0
  goal_saving_needed_per_month = []
  global goal_due_month
  amount_achieved=0
  user_goal = User.query.filter_by(public_id=current_user.public_id).first()
  result = user_goal.goals.filter(func.DATE(Goal.due_date) > date.today()).order_by(Goal.due_date)
  today = date.today()
  for u in result:
      goal_due_month = u.due_date
      goal_due_month = goal_due_month.replace(day=1) ## First day of that month
      months_remaining = (goal_due_month.year - today.year)*12 + (goal_due_month.month-today.month)
      print(months_remaining)
      if months_remaining>0:
          goal_saving_needed_per_month.append((u.amount_total-u.amount_saved)/months_remaining)
  print(goal_saving_needed_per_month)

  
  first_date = today.replace(day=1)
  next_month = first_date + dateutil.relativedelta.relativedelta(months= 1)
  last_month = first_date - dateutil.relativedelta.relativedelta(months=1)

  monthly_income = Category.query.filter_by(public_id = current_user.public_id,cat_type = False, month = first_date)
  total_income = 0
  for income in monthly_income:
      total_income += income.amount
  
  monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = last_month)
  total_expense = 0
  for expense in monthly_expense:
      total_expense += expense.amount

  print(total_income)
  print(total_expense)
  trigger = (total_income-total_expense) - sum(goal_saving_needed_per_month)
  if trigger<0:
   return jsonify({"message" : "Alert Generated"}) 
  else:
      return  jsonify({"message" : "Your goals are on track"})


from myapp import app
from ..Token import *
from model import *
from flask import request, jsonify, make_response
from sqlalchemy import func
from datetime import datetime, date
import json
import dateutil.relativedelta
# Get alert

@app.route('/alert')
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
  behind = 0-trigger
  if trigger<0:
   return jsonify({"message" : "fail","trivia":"You goals will not be achieved. Save "+str(behind)+" more to get back on track"}) 
  else:
      return  jsonify({"message" : "success"})


@app.route('/divide_savings')
@token_required
def divide_savings(current_user):
    alert = []
    alert.append(get_alert_goal(current_user))
    user_goal = User.query.filter_by(public_id=current_user.public_id).first()
    result = user_goal.goals.filter(func.DATE(Goal.due_date) > date.today()).order_by(Goal.due_date)
    today = date.today()
    this_month = today.replace(day=1)

    monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = this_month)
    total_expense = 0
    for expense in monthly_expense:
        total_expense += expense.amount
    response = get_alert_goal(current_user)
    print(response,type(response))
    response_from_alert = response.json()
    print(response_from_alert)
    income_this_month = response_from_alert['this_month_income']
    goal_saving_needed_this_month = response_from_alert['goal_saving_needed_this_month']
    print(goal_saving_needed_this_month)
    print(income_this_month)
    balance = income_this_month - total_expense
    if(balance<0):
        return jsonify({"message":"Not enough balance to divide any amount"})
        
    total_month_goal_amount = sum(goal_saving_needed_this_month)
    for goal in goal_saving_needed_this_month:
        goal = (goal/total_month_goal_amount)*balance
        ## Add this in respective goals using Update method

    return jsonify({"message":"Savings divided into goals","each_goal_got":goal_saving_needed_this_month})


@app.route('/linegraph' , methods=['GET'])
@token_required
def get_income_of_four_month(current_user):
    today = date.today()
    this_date = today.replace(day=1)
    previous1_month = this_date
    previous2_month = this_date - dateutil.relativedelta.relativedelta(months=1)
    previous3_month = this_date - dateutil.relativedelta.relativedelta(months=2)
    previous4_month = this_date - dateutil.relativedelta.relativedelta(months=3)
    month1_expense = monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = previous1_month)
    month2_expense = monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = previous2_month)
    month3_expense = monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = previous3_month)
    month4_expense = monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = previous4_month)
    month1_total_expense = 0
    if month1_expense is None:
        month1_total_expense=0
    else:
        for i in month1_expense:
            month1_total_expense += i.amount  
    month2_total_expense = 0
    if month2_expense is None:
        month2_total_expense=0
    else:
        for i in month2_expense:
            month2_total_expense += i.amount
    month3_total_expense = 0
    if month3_expense is None:
        month3_total_expense=0
    else:
        for i in month3_expense:
            month3_total_expense += i.amount 
    month4_total_expense = 0
    if month4_expense is None:
        month4_total_expense=0
    else:
        for i in month4_expense:
            month4_total_expense += i.amount
    return jsonify({"amount1" : month1_total_expense , "amount2" : month2_total_expense, "amount3" : month3_total_expense , "amount4" : month4_total_expense})
    

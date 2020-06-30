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

  ##This is previous months expense
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
    user_goal = User.query.filter_by(public_id=current_user.public_id).first()
    result = user_goal.goals.filter(func.DATE(Goal.due_date) > date.today()).order_by(Goal.due_date)
    today = date.today()
    this_month = today.replace(day=1)
    first_date = today.replace(day=1)

    ##Current months expense
    monthly_expense = Category.query.filter_by(public_id = current_user.public_id,cat_type = True, month = this_month)
    total_expense = 0
    for expense in monthly_expense:
        total_expense += expense.amount

    ##Current month income
    monthly_income = Category.query.filter_by(public_id = current_user.public_id,cat_type = False, month = first_date)
    total_income = 0
    for income in monthly_income:
         total_income += income.amount
    print(total_income);
    print(total_expense);
    # response = get_alert_goal()
    # print(response,type(response))
    # response_from_alert = response.json()
    # print(response_from_alert)
    goal_saving_needed_this_month = []
    for u in result:
      goal_due_month = u.due_date
      goal_due_month = goal_due_month.replace(day=1) ## First day of that month
      months_remaining = (goal_due_month.year - today.year)*12 + (goal_due_month.month-today.month)
      print(months_remaining)
      if months_remaining>0:
          goal_saving_needed_this_month.append((u.amount_total-u.amount_saved)/months_remaining)


    balance = total_income - total_expense
    if(balance<0):
        return jsonify({"message":"Not enough balance to divide any amount"})

    total_month_goal_amount = sum(goal_saving_needed_this_month)
    if(total_month_goal_amount==0):
        return jsonify({"message":"You have achieved all your goals"})

    final_goal = list()
    for goal in goal_saving_needed_this_month:
        goal = (goal/total_month_goal_amount)*balance
        final_goal.append(goal)
    print(final_goal)
    ## Add this in respective goals using Update method
    i = 0
    print("Balance = "+str(balance));
    for goal in result:
        print(goal.amount_saved)
        print(goal_saving_needed_this_month[i])
        goal.amount_saved += final_goal[i]
        print(goal.description)
        print(goal.amount_saved)
        i = i + 1

    db.session.commit()
    return jsonify({"message":"Savings divided into goals","each_goal_got":goal_saving_needed_this_month})


@app.route('/linegraph' , methods=['GET'])
@token_required
def get_income_of_four_month(current_user):
    today = date.today()
    lst1 = []
    lst2 = []
    this_date = today.replace(day=1)
    previous1_month = this_date
    previous2_month = this_date - dateutil.relativedelta.relativedelta(months=1)
    previous3_month = this_date - dateutil.relativedelta.relativedelta(months=2)
    previous4_month = this_date - dateutil.relativedelta.relativedelta(months=3)
    month1_expense = Category.query.filter_by(public_id = current_user.public_id, month = previous1_month)
    month2_expense = Category.query.filter_by(public_id = current_user.public_id, month = previous2_month)
    month3_expense = Category.query.filter_by(public_id = current_user.public_id, month = previous3_month)
    month4_expense = Category.query.filter_by(public_id = current_user.public_id, month = previous4_month)
    month1_total_expense = 0
    month1_total_income = 0
    if month1_expense is None:
        month1_total_expense=0
    else:
        for i in month1_expense:
            if i.cat_type is True:
                month1_total_expense += i.amount
            else:
                month1_total_income += i.amount
    lst1.append(month1_total_expense)
    lst2.append(month1_total_income)
    month2_total_expense = 0
    month2_total_income = 0
    if month2_expense is None:
        month2_total_expense=0
    else:
        for i in month2_expense:
            if i.cat_type is True:
                month2_total_expense += i.amount
            else:
                month2_total_income += i.amount
    lst1.append(month2_total_expense)
    lst2.append(month2_total_income)
    month3_total_expense = 0
    month3_total_income = 0
    if month3_expense is None:
        month3_total_expense=0
    else:
        for i in month3_expense:
            if i.cat_type is True:
                month3_total_expense += i.amount
            else:
                month3_total_income += i.amount
    lst1.append(month3_total_expense)
    lst2.append(month3_total_income)
    month4_total_expense = 0
    month4_total_income = 0
    if month4_expense is None:
        month4_total_expense=0
    else:
        for i in month4_expense:
            if i.cat_type is True:
                month4_total_expense += i.amount
            else:
                month4_total_income += i.amount
    lst1.append(month4_total_expense)
    lst2.append(month4_total_income)
    print(lst2)
    return jsonify({"amount" : lst1 , "amount1" : lst2})

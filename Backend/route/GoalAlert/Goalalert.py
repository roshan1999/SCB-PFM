from myapp import app
from ..Token import *
from model import *
from flask import request, jsonify, make_response
from sqlalchemy import func
from datetime import date
import json
# Get all goals


@app.route('/goal/<bal>', methods=['GET'])
@token_required
def get_alert_goal(current_user,bal):
  amount_complete=0
  amount_achieved=0
  user_goal = User.query.filter_by(public_id=current_user.public_id).first()
  print(bal)
  result = user_goal.goals.filter(func.DATE(Goal.due_date) > date.today()).order_by(Goal.due_date)
  for u in result:
      amount_achieved += u.__dict__['amount_saved']
      amount_complete += u.__dict__['amount_total']
  maxdate=(u.__dict__['due_date']-date.today()).days
  trigger = (int(bal)-(amount_complete-amount_achieved))/maxdate
  if trigger<0:
   return jsonify({"message" : "failure"}) 
  else:
      return  jsonify({"message" : "success" })


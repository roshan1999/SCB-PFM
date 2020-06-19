from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
from sqlalchemy import func
from datetime import datetime
# Get all goals
@app.route('/goal', methods=['GET'])
@token_required
def get_goal(current_user):
  user_goal = User.query.filter_by(public_id=current_user.public_id).first()
  result = user_goal.goals.filter(func.DATE(Goal.due_date) > datetime.today()).order_by(Goal.due_date)
  db.session.commit()
  return goals_schema.jsonify(result)

# Create a goal
@app.route('/goal', methods=['POST'])
@token_required
# can use for update(by maintaing flag)
def add_goal(current_user):
  due_date = datetime.strptime(request.json['due_date'], "%d-%m-%Y")
  description = request.json['description']
  amount_total = request.json['amount_total']
  amount_saved = request.json['amount_saved']
  public_id = current_user.public_id
  new_goal = Goal(due_date, description, amount_total, amount_saved, public_id)
  print(amount_total)
  db.session.add(new_goal)
  db.session.commit()
  return goal_schema.jsonify(new_goal)

@app.route('/goal', methods=['PATCH'])
@token_required
# can use for update(by maintaing flag)
def update_goal(current_user):
  due_date = datetime.strptime(request.json['due_date'],"%Y-%m-%d")
  description = request.json['description']
  amount_total = request.json['amount_total']
  amount_saved = request.json['amount_saved']
  public_id = current_user.public_id
  goal = Goal.query.get(request.json["id"]);
  goal.due_date = due_date
  goal.description = description
  goal.amount_total = amount_total
  goal.amount_saved = amount_saved
  print(amount_total)
  print(goal)
  db.session.commit()
  return goal_schema.jsonify(goal)


@app.route('/goal', methods = ['PUT'])
@token_required
def amt_goal (current_user):
    print("called")
    print(request.json['amount'])
    amt = request.json['amount']
    goal_id = request.json['id']
    goal_fetch = Goal.query.get(goal_id)
    goal_fetch.amount_saved+=int(amt)
    db.session.commit()
    return goal_schema.jsonify(goal_fetch)

@app.route('/goal/<id>', methods=['DELETE'])
@token_required
def delete_goal(current_user, id):
  goal_to_delete = Goal.query.get(id)
  db.session.delete(goal_to_delete)
  db.session.commit()
  return goal_schema.jsonify(goal_to_delete)

from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
# Get all goals
@app.route('/goal', methods=['GET'])
@token_required
def get_goal(current_user):
  user_goal = User.query.filter_by(public_id=current_user.public_id).first()
  result = user_goal.goals.all()
  db.session.commit()
  return goals_schema.jsonify(result)

# Create a goal
@app.route('/goal', methods=['POST'])
@token_required
# can use for update(by maintaing flag)
def add_goal(current_user):
  due_date = request.json['due_date']
  description = request.json['description']
  amount_total = request.json['amount_total']
  amount_saved = request.json['amount_saved']
  public_id = current_user.public_id
  new_goal = Goal(due_date, description, amount_total, amount_saved, public_id)
  print(amount_total)
  db.session.add(new_goal)
  db.session.commit()

  return goal_schema.jsonify(new_goal)

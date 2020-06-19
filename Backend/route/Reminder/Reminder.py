from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
from datetime import datetime

# Create a Reminder
@app.route('/reminder', methods=['POST'])
@token_required
def add_reminder(current_user):
  amount = request.json['amount']
  due_date = datetime.strptime(request.json['due_date'] , "%d-%m-%Y")
  description = request.json['description']
  achieved = 0
  user_public_id = current_user.public_id

  new_reminder = Reminder(amount, due_date, description, achieved, user_public_id)

  db.session.add(new_reminder)
  db.session.commit()

  return reminder_schema.jsonify(new_reminder)


# Get All Reminders
@app.route('/reminder', methods=['GET'])
@token_required
def get_reminders(current_user):
  user_rem = User.query.filter_by(public_id = current_user.public_id).first()
  result = user_rem.reminders.order_by(Reminder.due_date.asc())
  return reminders_schema.jsonify(result)


# Get Single Reminder
@app.route('/reminder/<id>', methods=['GET'])
@token_required
def get_reminder(current_user,id):
  reminder = Reminder.query.get(id)
  return reminder_schema.jsonify(reminder)


# Mark a Reminder as complete(Also adding it as a transaction)
@app.route('/reminder/done/<id>',methods = ['PATCH'])
@token_required
def mark_rem_complete(current_user,id):
    reminder = Reminder.query.get(id)
    reminder.achieved= True
    ## Also add this to transactions and which category that transaction will fall in

    db.session.commit()
    return reminder_schema.jsonify(reminder)


# Update a Reminder
@app.route('/reminder', methods=['PATCH'])
@token_required
def update_reminder(current_user):
  reminder = Reminder.query.get(request.json["id"])

  reminder.amount = request.json['amount']
  reminder.due_date = datetime.strptime(request.json['due_date'],"%d-%m-%Y")
  reminder.description = request.json['description']
  reminder.achieved = 0

  db.session.commit()

  return reminder_schema.jsonify(reminder)

# Delete Reminder
@app.route('/reminder/<id>', methods=['DELETE'])
@token_required
def delete_reminder(current_user, id):
  reminder = Reminder.query.get(id)
  db.session.delete(reminder)
  db.session.commit()

  return reminder_schema.jsonify(reminder)

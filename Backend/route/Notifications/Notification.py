from myapp import app
from ..Token import *
from model import *
from flask import request, jsonify, make_response
import datetime
from sqlalchemy import func

# Get All Reminders in next 3 days.
@app.route('/notification/reminder', methods=['GET'])
@token_required
def get_reminders_notification(current_user):
  user_rem = User.query.filter_by(public_id=current_user.public_id).first()
  today = datetime.datetime.today()
  date3= today + datetime.timedelta(days=3)
  result = user_rem.reminders.filter(func.Date(Reminder.due_date)<=date3 , func.Date(Reminder.due_date)>today).order_by(func.DATE(Reminder.due_date))
  return reminders_schema.jsonify(result)

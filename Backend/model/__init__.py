from .Category import *
from .Goal import *
from .Otp import *
from .Reminder import *
from .User import *
from .Transaction import *

goal_schema = GoalSchema()
goals_schema = GoalSchema(many=True)

reminder_schema = ReminderSchema()
reminders_schema = ReminderSchema(many=True)

category_schema = CategorySchema()
categorys_schema = CategorySchema(many=True)

transaction_schema = TransactionSchema()
transactions_schema = TransactionSchema(many=True)

db.create_all()

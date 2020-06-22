from myapp import app
from ..Token import *
from model import *
from flask import request,jsonify,make_response
@app.route('/user', methods=['GET'])
@token_required
def get_one_user(current_user,):

    user = User.query.filter_by(public_id=current_user.public_id).first()

    if not user:
        return jsonify({'message' : 'No user found!'})

    user_data = {}
    user_data['public_id'] = user.public_id
    user_data['name'] = user.name
    user_data['email']  = user.email
    user_data['password'] = user.password
    user_data['admin'] = user.admin

    return jsonify({'user' : user_data})

@app.route('/user', methods=['PUT'])
@token_required
def promote_user(current_user):
    if not current_user.admin:
        return jsonify({'message' : 'Cannot perform that function!'})

    user = User.query.filter_by(public_id=current_user.public_id).first()

    if not user:
        return jsonify({'message' : 'No user found!'})

    user.admin = True
    db.session.commit()

    return jsonify({'message' : 'The user has been promoted!'})

@app.route('/user', methods=['DELETE'])
@token_required
def delete_user(current_user):
    if not current_user.admin:
        return jsonify({'message' : 'Cannot perform that function!'})

    user = User.query.filter_by(public_id=public_id).first()

    if not user:
        return jsonify({'message' : 'No user found!'})

    db.session.delete(user)
    db.session.commit()

    return jsonify({'message' : 'The user has been deleted!'})


@app.route('/allUsers', methods=['GET'])
@token_required
def get_all_users(current_user):

    if not current_user.admin:
        return jsonify({'message' : 'Cannot perform that function!'})

    users = User.query.all()

    output = []

    for user in users:
        user_data = {}
        user_data['public_id'] = user.public_id
        user_data['name'] = user.name
        user_data['email'] = user.email
        user_data['password'] = user.password
        user_data['admin'] = user.admin
        output.append(user_data)

    return jsonify({'users' : output})

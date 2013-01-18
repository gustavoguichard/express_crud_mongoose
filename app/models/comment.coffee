# comment schema
mongoose = require "mongoose"
Schema = mongoose.Schema
CommentSchema = new Schema
  body:
    type: String
    default: ""
  _user:
    type: Schema.ObjectId
    ref: "User"
  createdAt:
    type: Date
    default: Date.now

  user: {}

mongoose.model "Comment", CommentSchema
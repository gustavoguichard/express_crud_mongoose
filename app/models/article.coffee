# Article schema
mongoose = require "mongoose"
Schema = mongoose.Schema
getTags = (tags) ->
  tags.join ","

setTags = (tags) ->
  tags.split ","

ArticleSchema = new Schema(
  title:
    type: String
    default: ""
    trim: true
  body:
    type: String
    default: ""
    trim: true
  user:
    type: Schema.ObjectId
    ref: "User"
  comments: [
    type: Schema.ObjectId
    ref: "Comment"
  ]
  tags:
    type: []
    get: getTags
    set: setTags
  image:
    cdnUri: String
    files: []
  categories: []
  createdAt:
    type: Date
    default: Date.now
)

ArticleSchema.path("title").validate ((title) ->
  title.length > 0
), "Article title cannot be blank"
ArticleSchema.path("body").validate ((body) ->
  body.length > 0
), "Article body cannot be blank"
mongoose.model "Article", ArticleSchema
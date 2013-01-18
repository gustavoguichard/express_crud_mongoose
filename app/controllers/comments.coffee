mongoose = require "mongoose"
Comment = mongoose.model "Comment"
exports.create = (req, res) ->
  comment = new Comment req.body
  article = req.article
  comment._user = req.user
  comment.save (err) ->
    throw new Error("Error while saving comment")  if err
    article.comments.push comment._id
    article.save (err) ->
      throw new Error("Error while saving article")  if err
      res.redirect "/articles/" + article.id + "#comments"
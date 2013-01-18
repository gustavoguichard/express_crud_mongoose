mongoose = require("mongoose")
Article = mongoose.model("Article")
Imager = require("imager")
_ = require("underscore")

# New article
exports.new = (req, res)->
  res.render "articles/new",
    title: "New Article"
    article: new Article {}

# Create an article
exports.create = (req, res) ->
  article = new Article(req.body)
  imagerConfig = require("../../config/imager")
  imager = new Imager(imagerConfig, "S3")
  article.user = req.user
  imager.upload req.files.image, ((err, cdnUri, files) ->
    return res.render("400")  if err
    if files.length
      article.image =
        cdnUri: cdnUri
        files: files
    article.save (err) ->
      if err
        res.render "articles/new",
          title: "New Article"
          article: article
          errors: err.errors

      else
        res.redirect "/articles/" + article._id

  ), "article"

# Edit an article
exports.edit = (req, res) ->
  res.render "articles/edit",
    title: "Edit " + req.article.title
    article: req.article

# Update article
exports.update = (req, res) ->
  article = req.article
  article = _.extend(article, req.body)
  article.save (err, doc) ->
    if err
      res.render "articles/edit",
        title: "Edit Article"
        article: article
        errors: err.errors
    else
      res.redirect "/articles/" + article._id

# View an article
exports.show = (req, res) ->
  res.render "articles/show",
    title: req.article.title
    article: req.article
    comments: req.comments

# Delete an article
exports.destroy = (req, res) ->
  article = req.article
  article.remove (err) ->
    
    # req.flash('notice', 'Deleted successfully')
    res.redirect "/articles"

# Listing of Articles
exports.index = (req, res) ->
  perPage = 5
  page = (if req.param("page") > 0 then req.param("page") else 0)
  # sort by date
  Article.find({}).populate("user", "name").sort(createdAt: -1).limit(perPage).skip(perPage * page).exec (err, articles) ->
    return res.render("500")  if err
    Article.count().exec (err, count) ->
      res.render "articles/index",
        title: "List of Articles"
        articles: articles
        page: page
        pages: count / perPage
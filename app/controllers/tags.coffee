mongoose = require "mongoose"
Article = mongoose.model "Article"
exports.index = (req, res) ->
  perPage = 5
  page = if req.param("page") > 0 then req.param("page") else 0
  # sort by date
  Article.find(tags: req.param("tag")).populate("user", "name").sort(createdAt: -1).limit(perPage).skip(perPage * page).exec (err, articles) ->
    return res.render("500") if err
    Article.count(tags: req.param("tag")).exec (err, count) ->
      res.render "articles/index",
        title: "List of Articles"
        articles: articles
        page: page
        pages: count / perPage
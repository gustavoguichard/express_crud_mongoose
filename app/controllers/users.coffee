mongoose = require("mongoose")
User = mongoose.model("User")
exports.signin = (req, res) ->

# auth callback
exports.authCallback = (req, res, next) ->
  res.redirect "/"

# login
exports.login = (req, res) ->
  res.render "users/login",
    title: "Login"
    message: req.flash("error")

# sign up
exports.signup = (req, res) ->
  res.render "users/signup",
    title: "Sign up"
    user: new User()

# logout
exports.logout = (req, res) ->
  req.logout()
  res.redirect "/login"

# session
exports.session = (req, res) ->
  res.redirect "/"

# signup
exports.create = (req, res) ->
  user = new User(req.body)
  user.provider = "local"
  user.save (err) ->
    if err
      return res.render("users/signup",
        errors: err.errors
        user: user
      )
    req.logIn user, (err) ->
      return next(err)  if err
      res.redirect "/"

# show profile
exports.show = (req, res) ->
  user = req.profile
  res.render "users/show",
    title: user.name
    user: user
### 
Module dependencies.
###
express = require("express")
mongoStore = require("connect-mongo")(express)
flash = require("connect-flash")
viewHelpers = require("../app/helpers")
module.exports = (app, config, passport) ->
  app.set "showStackError", true
  
  # should be placed before express.static
  app.use express.compress(
    filter: (req, res) ->
      console.log res.getHeader("Content-Type")
      /json|text|javascript|css/.test res.getHeader("Content-Type")

    level: 9
  )
  app.use express.static(config.root + "/public")
  app.use express.logger("dev")
  
  # set views path, template engine and default layout
  app.set "views", config.root + "/app/views"
  app.set "view engine", "jade"
  app.configure ->
    
    # dynamic helpers
    app.use viewHelpers(config)
    
    # cookieParser should be above session
    app.use express.cookieParser()
    
    # bodyParser should be above methodOverride
    app.use express.bodyParser()
    app.use express.methodOverride()
    
    # express/mongo session storage
    app.use express.session(
      secret: "noobjs"
      store: new mongoStore(
        url: config.db
        collection: "sessions"
      )
    )
    
    # connect flash for flash messages
    app.use flash()
    
    # use passport session
    app.use passport.initialize()
    app.use passport.session()
    app.use express.favicon()
    
    # routes should be at the last
    app.use app.router
    
    # assume "not found" in the error msgs
    # is a 404. this is somewhat silly, but
    # valid, you can do whatever you like, set
    # properties, use instanceof etc.
    app.use (err, req, res, next) ->
      
      # treat as 404
      return next()  if ~err.message.indexOf("not found")
      
      # log it
      console.error err.stack
      
      # error page
      res.status(500).render "500",
        error: err.stack

    # assume 404 since no middleware responded
    app.use (req, res, next) ->
      res.status(404).render "404",
        url: req.originalUrl
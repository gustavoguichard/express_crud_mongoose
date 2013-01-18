# Main application entry file. Please note, the order of loading is important.
# Configuration loading and booting of controllers and custom error handlers
express = require 'express'
fs = require 'fs'
passport = require 'passport'

# Load configurations
env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]
auth = require './config/middlewares/authorization'
mongoose = require 'mongoose'

# Ensure safe writes
mongoOptions = { db: { safe: true }}

# Bootstrap db connection
mongoose.connect config.db, mongoOptions, (err, res)->
  if err
    console.log "ERROR connecting to: #{config.db}. #{err}"
mongoose.connection.on 'open', ->
  # Bootstrap models
  models_path = __dirname + '/app/models'
  fs.readdirSync(models_path).forEach (file)->
    require "#{models_path}/#{file}"

  # Bootstrap passport config
  require('./config/passport')(passport, config)

  app = express()
  # Express settings
  require('./config/express')(app, config, passport)

  # Bootstrap routes
  require('./config/routes')(app, passport, auth)

  # Start the app by listening on <port>
  port = process.env.PORT || 3000
  app.listen port
  console.log "Express app started on port #{port}"

mongoose.connection.on 'error', console.error.bind console, 'connection error:'
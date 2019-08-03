fs = require 'fs'
_ = require 'lodash'
log = require 'loga'
cors = require 'cors'
express = require 'express'
Promise = require 'bluebird'
bodyParser = require 'body-parser'
http = require 'http'

Joi = require 'joi'

config = require './config'
routes = require './routes'
CronService = require './services/cron'
KueRunnerService = require './services/kue_runner'

HEALTHCHECK_TIMEOUT = 1000

setup = ->
  CronService.start()
  KueRunnerService.listen()
  Promise.resolve null

app = express()

app.set 'x-powered-by', false

app.use cors()
app.use bodyParser.json()
# Avoid CORS preflight
app.use bodyParser.json({type: 'text/plain'})
app.use routes

app.get '/ping', (req, res) -> res.send 'pong'

module.exports = {app, setup}

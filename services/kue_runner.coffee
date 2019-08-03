_ = require 'lodash'
kue = require 'kue'

Card = require '../controllers/card'
KueService = require './kue'
KueCreateService = require './kue_create'
config = require '../config'

TYPES =
  "#{KueCreateService.JOB_TYPES.CARD_CREATE}":
    {fn: Card.processCreate, concurrency: 3}


class KueRunnerService
  listen: ->
    console.log 'listen'
    # if config.ENV isnt config.ENVS.DEV
    _.forEach TYPES, ({fn, concurrency}, type) ->
      KueService.process type, concurrency, (job, ctx, done) ->
        console.log 'process'
        # KueCreateService.setCtx type, ctx
        fn job.data
        .then ->
          done()
        .catch (err) ->
          done err

module.exports = new KueRunnerService()

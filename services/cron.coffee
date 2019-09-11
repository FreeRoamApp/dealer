CronJob = require('cron').CronJob
_ = require 'lodash'
Promise = require 'bluebird'

CacheService = require './cache'
CleanupService = require './cleanup'
config = require '../config'

THIRTY_SECONDS = 30

class CronService
  constructor: ->
    @crons = []

    # shares kue with back-roads, so we can clean there
    # @addCron 'tenMin', '0 */10 * * * *', ->
    #   CleanupService.cleanKue()

  addCron: (key, time, fn) =>
    @crons.push new CronJob {
      cronTime: time
      onTick: ->
        CacheService.runOnce(key, fn, {
          # if server times get offset by >= 30 seconds, crons get run twice...
          # so this is not guaranteed to run just once
          expireSeconds: THIRTY_SECONDS
        })
      start: false
      timeZone: 'America/Los_Angeles'
    }

  start: =>
    _.map @crons, (cron) ->
      cron.start()

module.exports = new CronService()

Promise = require 'bluebird'
_ = require 'lodash'

KueCreateService = require './kue_create'
config = require '../config'

MIN_KUE_STUCK_TIME_MS = 60 * 10 * 1000 # 10 minutes


class CleanupService
  cleanKue: ->
    KueCreateService.clean {
      types: ['failed'], minStuckTimeMs: MIN_KUE_STUCK_TIME_MS
      # types: ['active', 'failed'], minStuckTimeMs: MIN_KUE_STUCK_TIME_MS
    }

module.exports = new CleanupService()

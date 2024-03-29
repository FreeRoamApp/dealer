Redis = require 'ioredis'
_ = require 'lodash'

config = require '../config'
client = new Redis {
  port: config.REDIS.PORT
  host: config.REDIS.HOST
}

events = ['connect', 'ready', 'error', 'close', 'reconnecting', 'end']
_.map events, (event) ->
  client.on event, ->
    console.log "redislog #{event}"

module.exports = client

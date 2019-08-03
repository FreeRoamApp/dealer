_ = require 'lodash'
assertNoneMissing = require 'assert-none-missing'

env = process.env

REDIS_PORT = 6379

config =
  VERBOSE: if env.VERBOSE then env.VERBOSE is '1' else true
  PORT: env.DEALER_PORT or 50000
  ENV: env.NODE_ENV
  IS_STAGING: env.IS_STAGING
  DEALER_SECRET: env.DEALER_SECRET
  REDIS:
    PREFIX: 'dealer'
    PORT: REDIS_PORT
    HOST: env.REDIS_HOST
    HOST_KUE: env.REDIS_KUE_HOST
  ENVS:
    DEV: 'development'
    PROD: 'production'
    TEST: 'test'

assertNoneMissing config

module.exports = config

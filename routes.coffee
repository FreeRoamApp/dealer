router = require 'promise-router'

CardCtrl = require './controllers/card'

routePublic = router.route

###################
# Public Routes   #
###################
routePublic 'get', '/ping', -> Promise.resolve 'pong'

routePublic 'get', '/healthcheck', ->
  # TODO: check redis
  {healthy: true}

routePublic 'post', '/cards',
  CardCtrl.create


module.exports = router.getExpressRouter()

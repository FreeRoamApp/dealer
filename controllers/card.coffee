_ = require 'lodash'
router = require 'promise-router'
urlMetadata = require 'url-metadata'
request = require 'request-promise'

CacheService = require '../services/cache'
KueCreateService = require '../services/kue_create'
config = require '../config'

TIMEOUT_MS = 5000
ONE_DAY_SECONDS = 3600 * 24

class Card
  create: ({body}) =>
    {url, callbackUrl} = body

    console.log 'create', url

    CacheService.get "url:#{url}"
    .then (data) =>
      if data
        card = @getCardFromData data
        request callbackUrl, {
          method: 'POST'
          body: {card, secret: config.DEALER_SECRET}
          json: true
        }
        {card}
      else
        KueCreateService.createJob {
          job: {url, callbackUrl}
          delayMs: 0
          type: KueCreateService.JOB_TYPES.CARD_CREATE
        }
        {isPending: true}

  getCardFromData: (data) ->
    {
      title: data['og:title'] or data.title
      image: data['og:image'] or data.image
      description: data['og:description'] or data.description
      url: data.url
    }

  processCreate: ({url, callbackUrl}) =>
    CacheService.preferCache "url:#{url}", =>
      console.log 'process', url
      urlMetadata(url, {timeout: TIMEOUT_MS})
      .then (data) =>
        card = @getCardFromData data
        request callbackUrl, {
          method: 'POST'
          body: {card, secret: config.DEALER_SECRET}
          json: true
        }
        data
      .catch (err) ->
        console.log err, url, callbackUrl
        throw err
    , {expireSeconds: ONE_DAY_SECONDS}

module.exports = new Card()

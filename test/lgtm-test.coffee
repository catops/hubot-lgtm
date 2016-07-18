Helper = require 'hubot-test-helper'
sinon = require 'sinon'
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper '../src/lgtm.coffee'
fixtures = require './fixtures.js'

# issuesMocks = [
#   nock('https://api.github.com').get('/issues').query(true).reply(200, fixtures.issues),
#   nock('https://api.github.com').get('/issues').query(true).reply(200, fixtures.issues)
# ]
#
# commentsMocks = [
#   nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.comments),
#   nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.commentsShipIt)
# ]

describe 'lgtm', ->

  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'lists pull requests', ()->
    @room.user.say('alice', '@hubot show pending pull requests').then =>
      setTimeout(=>
        expect(@room.messages).to.eql [
          ['alice', '@hubot show pull requests']
          ['hubot', 'fake-user/fake-repo/101 doesn\'t need to be merged.']
          ['hubot', 'I need to merge fake-user2/fake-repo2/666.']
        ]
      , 100)

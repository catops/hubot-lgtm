Helper = require 'hubot-test-helper'
sinon = require 'sinon'
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper '../src/lgtm.coffee'
fixtures = require './fixtures.js'

issuesMocks = [
  nock('https://api.github.com').get('/issues').query(true).reply(200, fixtures.issues)
  nock('https://api.github.com').get('/issues').query(true).reply(200, fixtures.issues)
  nock('https://api.github.com').get('/issues').query(true).reply(200, fixtures.noIssues)
]

commentsMocks = [
  nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.comments)
  nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.commentsShipIt)
  nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.longComments)
  nock('https://api.github.com').get(/\/repos\/(.*)/).query(true).reply(200, fixtures.commentsShipIt)
]

mergeMocks = [
  nock('https://api.github.com').put(/\/repos\/(.*)\/pulls\/(.*)\/merge/).query(true).reply(200, fixtures.mergeSuccess)
  nock('https://api.github.com').put(/\/repos\/(.*)\/pulls\/(.*)\/merge/).query(true).reply(200, fixtures.mergeFailure)
]

describe 'lgtm', ->

  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'lists pull requests', (done)->
    @room.user.say('alice', '@hubot list your pull requests').then =>
      setTimeout(=>
        expect(@room.messages).to.eql [
          ['alice', '@hubot list your pull requests']
          ['hubot', "I'm monitoring these pull requests:\n- https://github.com/fake-user/fake-repo/pull/101\n- https://github.com/fake-user2/fake-repo2/pull/666\n- https://github.com/fake-user3/fake-repo3/pull/1234"]
        ]
        do done
      , 100)

  it 'processes pull requests', (done)->
    @room.user.say('alice', '@hubot check your pull requests').then =>
      setTimeout(=>
        expect(@room.messages).to.eql [
          ['alice', '@hubot check your pull requests']
          ['hubot', 'I merged https://github.com/fake-user2/fake-repo2/pull/666. Thanks for the review fake-user6 and fake-user7! ✌︎']
        ]
        do done
      , 100)

  it 'reports that it\'s not monitoring any pull requests', (done)->
    @room.user.say('alice', '@hubot list your pull requests').then =>
      setTimeout(=>
        expect(@room.messages).to.eql [
          ['alice', '@hubot list your pull requests']
          ['hubot', 'No pull requests have been assigned to me.']
        ]
        do done
      , 100)

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

reviewsMocks = [
  nock('https://api.github.com').get(/\/repos\/(.*)\/pulls\/(.*)\/reviews/).query(true).reply(200, fixtures.reviewsFail)
  nock('https://api.github.com').get(/\/repos\/(.*)\/pulls\/(.*)\/reviews/).query(true).reply(200, fixtures.reviewsPass)
  nock('https://api.github.com').get(/\/repos\/(.*)\/pulls\/(.*)\/reviews/).query(true).reply(200, fixtures.reviewsPass)
]

mergeMocks = [
  nock('https://api.github.com').put(/\/repos\/(.*)\/pulls\/(.*)\/merge/).query(true).reply(200, fixtures.mergeSuccess)
  nock('https://api.github.com').put(/\/repos\/(.*)\/pulls\/(.*)\/merge/).query(true).reply(200, fixtures.mergeFailure)
]

process.env.HUBOT_LGTM_GITHUB_TOKEN = "ABC123"

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
          [
            'alice',
            '@hubot check your pull requests'
          ]
          [
            'hubot',
            'I merged [fake-repo2#666](https://github.com/fake-user2/fake-repo2/pull/666). Thanks for the [review](https://github.com/catops/hubot-lgtm#usage) fake-user6 and fake-user7! ✌︎'
          ]
          [
            'hubot',
            'I tried to merge https://github.com/fake-user3/fake-repo3/pull/1234 but failed. It might have a conflict or failed a status check. 😦 I\'ll try again later.'
          ]
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

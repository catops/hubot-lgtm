# Description
#   Automatically merge pull requests after contributors have given the thumbs up.
#
# Configuration:
#   HUBOT_LGTM_GITHUB_TOKEN - GitHub API key.
#   HUBOT_LGTM_NOTIFICATION_ROOM - [optional] Slack/Mattermost room to notify of merges.
#   HUBOT_LGTM_IGNORE_FAILURES - [optional] Set to `true` if you don't want to be notified about failed merge attempts.
#   HUBOT_LGTM_INTERVAL - [optional] # of seconds to check GitHub for approved PRs. Defaults to 60.
#   HUBOT_LGTM_DISABLE_MD - [optional] Set to `true` to disable the use of markdown in messages.
#
# Commands:
#   hubot list your pull requests - returns list of pull requests hubot is monitoring
#   hubot check your pull requests - checks pull requests assigned to bot and merges approved ones
#
# Author:
#   contolini

github = require 'github'
regexEscape = require 'regex-escape'

token = process.env.HUBOT_LGTM_GITHUB_TOKEN
room = process.env.HUBOT_LGTM_NOTIFICATION_ROOM
ignoreFailures = process.env.HUBOT_LGTM_IGNORE_FAILURES
interval = process.env.HUBOT_LGTM_INTERVAL || 60
threshold = process.env.HUBOT_LGTM_THRESHOLD || 1

# Initialize GH API.
github = new github version: "3.0.0", debug: false, headers: Accept: "application/vnd.github.moondragon+json"

# Keep track of pull requests with conflicts so that the bot doesn't keep trying to merge them.
ignoreList = []

# List all pull requests assigned to the bot.
listPullRequests = (robot, res) ->
  github.issues.getAll {}, (err, resp) ->
    issues = resp.data
    return notify robot, res, "No pull requests have been assigned to me." if not issues.length
    pullRequests = issues.map (issue) ->
      if issue.pull_request and issue.state is "open"
        return "https://github.com/#{issue.repository.owner.login}/#{issue.repository.name}/pull/#{issue.number}"
    pullRequests = pullRequests.filter (pr) -> pr
    notify robot, res, "I'm monitoring these pull requests:\n- #{pullRequests.join('\n- ')}"

# Iterate assigned pull requests and merge approved ones.
mergePullRequests = (robot, res) ->
  github.issues.getAll {}, (err, resp) ->
    issues = resp.data
    return notify robot, res, "No pull requests have been assigned to me." if not issues.length
    issues.forEach (issue) ->
      # Abort if it's closed or not a pull request.
      return if not issue.pull_request or issue.state != "open"
      issue =
        user: issue.repository.owner.login
        repo: issue.repository.name
        number: issue.number
      slug = "#{issue.user}#{issue.repo}#{issue.number}"
      checkReviews robot, issue, res

checkReviews = (robot, issue, res) ->
  url = "https://github.com/#{issue.user}/#{issue.repo}/pull/#{issue.number}"
  slug = "#{issue.user}#{issue.repo}#{issue.number}"
  approvers = {}
  github.pullRequests.getReviews { owner: issue.user, repo: issue.repo, number: issue.number }, (err, resp) ->
    reviews = resp.data
    reviews.forEach (review) ->
      if review.state == 'APPROVED'
        approvers[review.user.login] = true
    if Object.keys(approvers).length >= threshold
      github.pullRequests.merge { owner: issue.user, repo: issue.repo, number: issue.number }, (err, resp) ->
        if err or not resp.data.merged
          # Don't display a failure message if they've turned it off.
          return if ignoreFailures
          # Don't display a message if it *still* can't be merged. We don't want to spam the channel.
          return if ignoreList.indexOf(slug) > -1
          notify robot, res, "I tried to merge #{url} but failed. It might have a conflict or failed a status check. 😦 I'll try again later."
          ignoreList.push slug
        else
          if process.env.HUBOT_LGTM_DISABLE_MD
            notify robot, res, "I merged #{url}. Thanks for the review #{Object.keys(approvers).join(' and ')}! ✌︎"
          else
            notify robot, res, "I merged [#{issue.repo}##{issue.number}](#{url}). Thanks for the [review](https://github.com/catops/hubot-lgtm#usage) #{Object.keys(approvers).join(' and ')}! ✌︎"

notify = (robot, res, msg) ->
  if res and /Response/.test res.constructor.name
    return res.send msg
  if room
    return robot.messageRoom room, msg

module.exports = (robot) ->

  return robot.logger.error "HUBOT_LGTM_GITHUB_TOKEN is not defined." if not token
  github.authenticate type: "oauth", token: token

  robot.respond /check (your )?(pull requests|prs?)/i, (res) ->
    mergePullRequests robot, res

  robot.respond /(show|list|what are) (your )?(pull requests|prs?)/i, (res) ->
    listPullRequests robot, res

  # HUBOT_LGTM_INTERVAL is set to false, don't poll GH.
  return if not interval

  setInterval(=>
    mergePullRequests robot
  , interval * 1000)

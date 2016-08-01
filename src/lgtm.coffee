# Description
#   Automatically merge pull requests after maintainers have given the thumbs up
#
# Configuration:
#   HUBOT_LGTM_GITHUB_TOKEN - GitHub API key.
#   HUBOT_LGTM_GITHUB_ROOM - Optional Slack/Mattermost room to notify of merges.
#   HUBOT_LGTM_INTERVAL - Optional # of seconds to check GitHub for approved PRs. Defaults to 60.
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
room = process.env.HUBOT_LGTM_GITHUB_ROOM
approvals = process.env.HUBOT_LGTM_APPROVAL_MSGS || ":shipit:,:+1:,👍,LGTM"
interval = process.env.HUBOT_LGTM_THRESHOLD || 60
threshold = process.env.HUBOT_LGTM_THRESHOLD || 2

# Regexify the acceptable approval messages.
approvals = new RegExp regexEscape(approvals).replace(/,/g,'|')

# Initialize GH API.
github = new github version: "3.0.0", debug: false, headers: Accept: "application/vnd.github.moondragon+json"

# Keep track of pull requests with conflicts so that the bot doesn't keep trying to merge them.
ignoreList = []

# List all pull requests assigned to the bot.
listPullRequests = (res) ->
  github.issues.getAll {}, (err, issues) ->
    return notify res, "No pull requests have been assigned to me." if not issues.length
    pullRequests = issues.map (issue) ->
      if issue.pull_request and issue.state is "open"
        return "https://github.com/#{issue.repository.owner.login}/#{issue.repository.name}/pull/#{issue.number}"
    pullRequests = pullRequests.filter (pr) -> pr
    notify res, "I'm monitoring these pull requests:\n- #{pullRequests.join('\n- ')}"

# Iterate assigned pull requests and merge those with 2 or more comment approvals.
mergePullRequests = (res) ->
  github.issues.getAll {}, (err, issues) ->
    return notify res, "No pull requests have been assigned to me." if not issues.length
    issues.forEach (issue) ->
      # Abort if it's closed or not a pull request.
      return if not issue.pull_request or issue.state != "open"
      issue =
        user: issue.repository.owner.login
        repo: issue.repository.name
        number: issue.number
      slug = "#{issue.user}#{issue.repo}#{issue.number}"
      # Abort if it's in the ignore list (meaning it has a conflict).
      return if ignoreList.indexOf(slug) > -1
      checkComments issue, res

checkComments = (issue, res) ->
  url = "https://github.com/#{issue.user}/#{issue.repo}/pull/#{issue.number}"
  slug = "#{issue.user}#{issue.repo}#{issue.number}"
  approvers = {}
  github.issues.getComments issue, (err, comments) ->
    comments.forEach (comment) ->
      body = comment.body.trim()
      if approvals.test(body) && body.length < 20
        approvers[comment.user.login] = true
    if Object.keys(approvers).length >= threshold
      github.pullRequests.merge issue, (err, response) ->
        if err or not response.merged
          ignoreList.push slug
          notify res, "I tried to merge #{url} but failed. It might have a conflict. 😦"
        else
          notify res, "I merged #{url}. Thanks for the review #{Object.keys(approvers).join(' and ')}! ✌︎"

notify = (res, msg) ->
  if res and /Response/.test res.constructor.name
    return res.send msg
  if room
    return robot.messageRoom room, msg

module.exports = (robot) ->

  return robot.logger.error "HUBOT_LGTM_GITHUB_TOKEN is not defined." if not token
  github.authenticate type: "oauth", token: token

  robot.respond /check (your )?(pull requests|prs?)/i, (res) ->
    mergePullRequests res

  robot.respond /(show|list|what are) (your )?(pull requests|prs?)/i, (res) ->
    listPullRequests res

  # HUBOT_LGTM_INTERVAL is set to false, don't poll GH.
  return if not interval

  setInterval(=>
    do mergePullRequests
  , interval * 1000)

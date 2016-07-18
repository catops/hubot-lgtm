# Description
#   Automatically merge pull requests after maintainers have given the thumbs up
#
# Configuration:
#   HUBOT_LGTM_GITHUB_ORG - GitHub organization to monitor
#   HUBOT_LGTM_GITHUB_TOKEN - GitHub API key
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Chris Contolini

github = require 'github'
github = new github version: "3.0.0", debug: false, headers: Accept: "application/vnd.github.moondragon+json"

organization = process.env.HUBOT_LGTM_GITHUB_ORG
token = process.env.HUBOT_LGTM_GITHUB_TOKEN

github.authenticate type: "oauth", token: token

module.exports = (robot) ->

  robot.respond /show pending pull requests/, (res) ->
    github.issues.getAll {}, (err, issues) ->
      console.log issues.length
      issues.forEach (issue) ->
        issue =
          user: issue.repository.owner.login
          repo: issue.repository.name
          number: issue.number
        github.issues.getComments issue, (err, comments) ->
          approvers = []
          comments.forEach (comment) ->
            if /shipit/.test comment.body
              approvers.push comment.user.login
          if approvers.length >= 2
            res.send "I need to merge #{issue.user}/#{issue.repo}/#{issue.number}."
          else
            res.send "#{issue.user}/#{issue.repo}/#{issue.number} doesn't need to be merged."

module.exports = {
  issues: [
    {
      number: 101,
      repository: {
        name: 'fake-repo',
        owner: {
          login: 'fake-user'
        }
      },
      state: "open",
      pull_request: {
        url: 'foo'
      }
    },
    {
      number: 666,
      repository: {
        name: 'fake-repo2',
        owner: {
          login: 'fake-user2'
        }
      },
      state: "open",
      pull_request: {
        url: 'foo'
      }
    },
    {
      number: 1234,
      repository: {
        name: 'fake-repo3',
        owner: {
          login: 'fake-user3'
        }
      },
      state: "open",
      pull_request: {
        url: 'foo'
      }
    }
  ],
  noIssues: [],
  comments: [
    {
      user: {
        login: "fake-user3"
      },
      body: "I like food."
    },
    {
      user: {
        login: "fake-user4"
      },
      body: ":shipit:"
    }
  ],
  commentsShipIt: [
    {
      user: {
        login: "fake-user5"
      },
      body: "I like metal."
    },
    {
      user: {
        login: "fake-user6"
      },
      body: ":shipit:"
    },
    {
      user: {
        login: "fake-user7"
      },
      body: ":shipit:"
    }
  ],
  longComments: [
    {
      user: {
        login: "fake-user8"
      },
      body: "The snozzberries taste like snozzberries! :shipit:"
    },
    {
      user: {
        login: "fake-user9"
      },
      body: "Please review my comments in chat."
    },
    {
      user: {
        login: "fake-user10"
      },
      body: ":shipit:"
    }
  ],
  mergeSuccess: {
    sha: "xxxxxxxxxxxxxxxxxxx",
    merged: true,
    message: "Pull Request successfully merged"
  },
  mergeFailure: {
    message: "Pull Request is not mergeable",
    documentation_url: "https://developer.github.com/v3/pulls/#merge-a-pull-request-merge-button"
  }
}

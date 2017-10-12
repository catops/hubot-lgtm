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
  reviewsFail: [
    {
      user: {
        login: "fake-user3"
      },
      state: "NOT APPROVED"
    },
    {
      user: {
        login: "fake-user4"
      },
      state: "NOT APPROVED"
    }
  ],
  reviewsPass: [
    {
      user: {
        login: "fake-user5"
      },
      state: "NOT APPROVED"
    },
    {
      user: {
        login: "fake-user6"
      },
      state: "APPROVED"
    },
    {
      user: {
        login: "fake-user7"
      },
      state: "APPROVED"
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

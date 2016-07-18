module.exports = {
  issues: [
    {
      number: 101,
      repository: {
        name: 'fake-repo',
        owner: {
          login: 'fake-user'
        }
      }
    },
    {
      number: 666,
      repository: {
        name: 'fake-repo2',
        owner: {
          login: 'fake-user2'
        }
      }
    }
  ],
  comments: [
    {
      user: {
        login: "fake-user"
      },
      body: "I like food."
    },
    {
      user: {
        login: "fake-user"
      },
      body: ":shipit:"
    }
  ],
  commentsShipIt: [
    {
      user: {
        login: "fake-user"
      },
      body: "I like metal."
    },
    {
      user: {
        login: "fake-user"
      },
      body: ":shipit:"
    },
    {
      user: {
        login: "fake-user"
      },
      body: ":shipit:"
    }
  ]
}

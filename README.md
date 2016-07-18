# hubot-lgtm [![Build Status](https://img.shields.io/travis/catops/hubot-lgtm.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/catops/hubot-lgtm) [![npm](https://img.shields.io/npm/v/hubot-lgtm.svg?maxAge=2592000&style=flat-square)](https://www.npmjs.com/package/hubot-lgtm)

:cat: Automatically merge pull requests after maintainers have given the thumbs up

See [`src/lgtm.coffee`](src/lgtm.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-lgtm --save`

Then add **hubot-lgtm** to your `external-scripts.json`:

```json
["hubot-lgtm"]
```

## Sample Interaction

```
user1>> hubot hello
hubot>> hello!
```

```
user1>> hubot orly
hubot>> yarly
```

## Contributing

Please read our general [contributing guidelines](CONTRIBUTING.md).

## Open source licensing info
1. [TERMS](TERMS.md)
2. [LICENSE](LICENSE)
3. [CFPB Source Code Policy](https://github.com/cfpb/source-code-policy/)

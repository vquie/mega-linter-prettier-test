## Disclaimer

This repo holds just some random data to allow debugging [#2574](https://github.com/oxsecurity/megalinter/discussions/2574). The content doesn't make any sense in a different context.
A set of debug logs is already pushed.

## How to

run `make lint-all-files-fix` to generate the changes.

```
❯ make help
lint-ci                                          Lint only changed files with the lighter `ci_light` flavor.
lint-ci-fix                                      Lint and fix only changed files with the lighter `ci_light` flavor.
lint-all-files                                   Lint all files with all available file linters
lint-all-files-fix                               Lint and fix all files with all available file linters
help                                             Print this help message
```
_FILES = $$(git diff --name-only HEAD)

# Misc
.DEFAULT_GOAL = help	# if you type 'make' without arguments, this is the default: show the help
.PHONY        : # Not needed here, but you can put your all your targets to be sure
                # there is no name conflict between your files and your targets.

_check-for-all:
	@echo "================================== Warning! ==================================" && \
	echo "== Linting the whole codebase can take" && \
	echo "== a very long time" && \
	echo "==============================================================================="
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

_check-for-changed-files:
	@if [ -z $(_FILES) ]; then \
		echo "No files to lint";\
		exit 1;\
	fi

## Lint only changed files with the lighter `ci_light` flavor.
.PHONY: lint-ci
.ONESHELL:
lint-ci: _check-for-changed-files
	mega-linter-runner -f ci_light --remove-container -e "MEGALINTER_CONFIG=.mega-linter.yml" --filesonly $(_FILES)

## Lint and fix only changed files with the lighter `ci_light` flavor.
.PHONY: lint-ci-fix
.ONESHELL:
lint-ci-fix: _check-for-changed-files
	mega-linter-runner -f ci_light --fix --remove-container -e "MEGALINTER_CONFIG=.mega-linter.yml" --filesonly $(_FILES)

## Lint all files with all available file linters
.PHONY: lint-all-files
.ONESHELL:
lint-all-files: _check-for-all
	mega-linter-runner --remove-container -e "MEGALINTER_CONFIG=.mega-linter.yml" --filesonly 

## Lint and fix all files with all available file linters
.PHONY: lint-all-files-fix
.ONESHELL:
lint-all-files-fix: _check-for-all
	mega-linter-runner --fix --remove-container -e "MEGALINTER_CONFIG=.mega-linter.yml" --filesonly 


## Print this help message
.PHONY: help
help:
	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_\.0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-40s\033[0m \t%s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-40s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                                                  "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					printf "\n\033[33m%-80s\033[0m\n", \
          	helpMessage; \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)

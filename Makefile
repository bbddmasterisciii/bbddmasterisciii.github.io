## ========================================
## Commands for both workshop and lesson websites.

# Settings
MAKEFILES=Makefile $(wildcard *.mk)
PRJDIR=$(dir $(realpath $(firstword $(MAKEFILES))))
# Giving a self-detection chance
ifeq (,${INDOCKER})
  INDOCKER := $(shell grep 'docker\|podman' /proc/1/cgroup)
else
  INDOCKER := ${INDOCKER}
endif
HOSTTIMEZONE := $(shell cat /etc/timezone || true)
ifeq (,$(HOSTTIMEZONE))
  HOSTTIMEZONE := Europe/Madrid
endif
ifeq (,$(INDOCKER))
  JEKYLL := bundle config --local set path .vendor/bundle && bundle install && bundle update && bundle exec jekyll
else
  JEKYLL := jekyll
endif
JEKYLL_DOCKER_IMG=jekyll/jekyll
#JEKYLL_DOCKER_IMG=jekyll/builder
JEKYLL_VERSION=4.2.0
PARSER=bin/markdown_ast.rb
DST=_site

# Check Python 3 is installed and determine if it's called via python3 or python
# (https://stackoverflow.com/a/4933395)
PYTHON3_EXE := $(shell which python3 2>/dev/null)
ifneq (, $(PYTHON3_EXE))
  ifeq (,$(findstring Microsoft/WindowsApps/python3,$(subst \,/,$(PYTHON3_EXE))))
    PYTHON := python3
  endif
endif

ifeq (,$(PYTHON))
  PYTHON_EXE := $(shell which python 2>/dev/null)
  ifneq (, $(PYTHON_EXE))
    PYTHON_VERSION_FULL := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
    PYTHON_VERSION_MAJOR := $(word 1,${PYTHON_VERSION_FULL})
    ifneq (3, ${PYTHON_VERSION_MAJOR})
      $(error "Your system does not appear to have Python 3 installed.")
    endif
    PYTHON := python
  else
      $(error "Your system does not appear to have any Python installed.")
  endif
endif

# Controls
.PHONY : commands clean files
.NOTPARALLEL:

# Default target
.DEFAULT_GOAL := commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILES} | sed -e 's/## //g'

## docker-serve     : use docker to build the site
docker-serve :
	-docker run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=${HOSTTIMEZONE} -p 127.0.0.1:4000:4000 ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} make serve
	docker run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=${HOSTTIMEZONE} ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} chown -R $(shell id -u):$(shell id -g) /srv/jekyll


## docker-serve     : use docker to build the site
docker-site :
	-docker run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=${HOSTTIMEZONE} ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} make site
	docker run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=${HOSTTIMEZONE} ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} chown -R $(shell id -u):$(shell id -g) /srv/jekyll


## podman-serve     : use podman to build the site
podman-serve :
	-podman run --rm -it -v ${PRJDIR}:/srv/jekyll -v ${PRJDIR}/.bundle:/usr/local/bundle -e TZ=${HOSTTIMEZONE} -e INDOCKER=yes -p 127.0.0.1:4000:4000 ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} /bin/bash -c 'chgrp -R jekyll . ; chmod -R g+w . ; make serve ; chgrp root . ; find . -user jekyll -exec chown -R root: {} \; ; chmod -R g-w . ; chgrp -R root .'
	#podman run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=Europe/Madrid ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} chown -R $(shell id -u):$(shell id -g) /srv/jekyll

## docker-serve     : use podman to build the site
podman-site :
	-podman run --rm -it -v ${PRJDIR}:/srv/jekyll -v ${PRJDIR}/.bundle:/usr/local/bundle -e TZ=${HOSTTIMEZONE} -e INDOCKER=yes ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} /bin/bash -c 'chgrp -R jekyll . ; chmod -R g+w . ; make site ; find . -user jekyll -exec chown -R root: {} \; ; chmod -R g-w . ; chgrp -R root .'
	#podman run --rm -it -v ${PRJDIR}:/srv/jekyll -e TZ=Europe/Madrid ${JEKYLL_DOCKER_IMG}:${JEKYLL_VERSION} chown -R $(shell id -u):$(shell id -g) /srv/jekyll

## serve            : run a local server.
serve : lesson-md
	mkdir -p _site .jekyll-cache
	${JEKYLL} serve

## site             : build files but do not run a server.
site : lesson-md
	mkdir -p _site .jekyll-cache
	${JEKYLL} build

# repo-check        : check repository settings.
repo-check :
	@${PYTHON} bin/repo_check.py -s .

## clean            : clean up junk files.
clean :
	@rm -rf ${DST}
	@rm -rf .sass-cache
	@rm -rf bin/__pycache__
	@find . -name .DS_Store -exec rm {} \;
	@find . -name '*~' -exec rm {} \;
	@find . -name '*.pyc' -exec rm {} \;

## clean-rmd        : clean intermediate R files (that need to be committed to the repo).
clear-rmd :
	@rm -rf ${RMD_DST}
	@rm -rf fig/rmd-*

## ----------------------------------------
## Commands specific to workshop websites.

.PHONY : workshop-check

## workshop-check   : check workshop homepage.
workshop-check :
	@${PYTHON} bin/workshop_check.py .

## ----------------------------------------
## Commands specific to lesson websites.

.PHONY : lesson-check lesson-md lesson-files lesson-fixme install-rmd-deps

# RMarkdown files
RMD_SRC = $(wildcard _episodes_rmd/??-*.Rmd)
RMD_DST = $(patsubst _episodes_rmd/%.Rmd,_episodes/%.md,$(RMD_SRC))

# Lesson source files in the order they appear in the navigation menu.
MARKDOWN_SRC = \
  index.md \
  CODE_OF_CONDUCT.md \
  setup.md \
  $(sort $(wildcard _episodes/*.md)) \
  reference.md \
  $(sort $(wildcard _extras/*.md)) \
  LICENSE.md

# Generated lesson files in the order they appear in the navigation menu.
HTML_DST = \
  ${DST}/index.html \
  ${DST}/conduct/index.html \
  ${DST}/setup/index.html \
  $(patsubst _episodes/%.md,${DST}/%/index.html,$(sort $(wildcard _episodes/*.md))) \
  ${DST}/reference/index.html \
  $(patsubst _extras/%.md,${DST}/%/index.html,$(sort $(wildcard _extras/*.md))) \
  ${DST}/license/index.html

## * install-rmd-deps : Install R packages dependencies to build the RMarkdown lesson
install-rmd-deps:
	@${SHELL} bin/install_r_deps.sh

## lesson-md        : convert Rmarkdown files to markdown
lesson-md : ${RMD_DST}

# Use of .NOTPARALLEL makes rule execute only once
${RMD_DST} : ${RMD_SRC} install-rmd-deps
	@mkdir -p _episodes
	@${SHELL} bin/knit_lessons.sh ${RMD_SRC}

## lesson-check     : validate lesson Markdown.
lesson-check : lesson-fixme
	@${PYTHON} bin/lesson_check.py -s . -p ${PARSER} -r _includes/links.md

## lesson-check-all : validate lesson Markdown, checking line lengths and trailing whitespace.
lesson-check-all :
	@${PYTHON} bin/lesson_check.py -s . -p ${PARSER} -r _includes/links.md -l -w --permissive

## unittest         : run unit tests on checking tools.
unittest :
	@${PYTHON} bin/test_lesson_check.py

## lesson-files     : show expected names of generated files for debugging.
lesson-files :
	@echo 'RMD_SRC:' ${RMD_SRC}
	@echo 'RMD_DST:' ${RMD_DST}
	@echo 'MARKDOWN_SRC:' ${MARKDOWN_SRC}
	@echo 'HTML_DST:' ${HTML_DST}

## lesson-fixme     : show FIXME markers embedded in source files.
lesson-fixme :
	@fgrep -i -n FIXME ${MARKDOWN_SRC} || true

#-------------------------------------------------------------------------------
# Include extra commands if available.
#-------------------------------------------------------------------------------

-include commands.mk

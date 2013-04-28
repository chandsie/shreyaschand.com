#!/bin/bash

jekyll --no-auto
rsync -crz --delete _site/ chandsie_chandsie@ssh.phx.nearlyfreespeech.net:/home/public

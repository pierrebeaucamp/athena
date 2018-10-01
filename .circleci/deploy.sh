#!/usr/bin/env sh

npm install netlify-cli
node node_modules/netlify-cli/bin/cli.js deploy -t $NETLIFY_TOKEN

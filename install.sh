#!/usr/bin/env bash
# Wrapper around the master install.sh script located inside plugins/sdlc
exec bash "$(dirname "$0")/plugins/sdlc/install.sh" "$@"

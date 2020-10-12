#!/usr/bin/env bash

if [[ -f deps ]]; then
  echo "A"
elif [[ -d deps ]]; then
  echo "B"
else
  echo "C"
fi

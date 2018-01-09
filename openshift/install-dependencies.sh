#!/bin/bash
echo "Would you like to check that brew and oc installed (This check only works for a mac by the way) y/n?"
echo "-> If you choose to skip this step just make sure you have oc installed. If you're unsure how to install it, don't worry"
echo "just go here https://github.com/openshift/origin/releases!"

read continue;

if [ "$continue" == "y" ]; then
    brew -v  >/dev/null 2>&1 || { echo >&2 "I require brew but it's not installed so I'll install it...";  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";}
    oc help  >/dev/null 2>&1 || { echo >&2 "I require oc but it's not installed so I'll install it..."; brew install openshift-cli; }

    echo "Ok, let's continue as brew & oc both appear to be working"
fi
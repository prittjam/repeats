#!/bin/bash
REF=${1-master} # branch or tag; defaults to 'master' if parameter 1 not present
REMOTE=vgtk # just a name to identify the remote
REPO=git@github.com:prittjam/vgtk.git # replace this with your repository URL
FOLDER=vgtk # where to mount the subtree

git pull
git remote add $REMOTE --no-tags $REPO
if [[ -d "$FOLDER" ]]; then # update the existing subtree
    git subtree pull $REMOTE $REF --prefix=$FOLDER --squash -m "Merging '$REF' into '$FOLDER'"
else # add the subtree
    git subtree add  $REMOTE $REF --prefix=$FOLDER --squash -m "Merging '$REF' into '$FOLDER'"
fi
git remote remove $REMOTE

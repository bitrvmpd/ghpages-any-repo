#!/bin/sh

set -e

echo "#################################################"
echo "Changing directory to 'BUILD_DIR' $BUILD_DIR ..."
cd $BUILD_DIR

echo "#################################################"
echo "Now deploying to GitHub Pages..."
if [[ -z "$GH_USER_REPO" ]]; then
  GH_USER_REPO="$GITHUB_REPOSITORY"
fi && \
REMOTE_REPO="https://${GH_PAT}@github.com/${GH_USER_REPO}.git" && \
REPONAME="$(echo $GH_USER_REPO| cut -d'/' -f 2)" && \
OWNER="$(echo $GH_USER_REPO| cut -d'/' -f 1)" && \
GHIO="${OWNER}.github.io" && \
if [[ "$REPONAME" == "$GHIO" ]]; then
  REMOTE_BRANCH="master"
else
  REMOTE_BRANCH="gh-pages"
fi && \
git init && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
if [ -z "$(git status --porcelain)" ]; then
    echo "Nothing to commit" && \
    exit 0
fi && \
git add . && \
git commit -m 'Deploy to GitHub Pages' && \
git push --force $REMOTE_REPO master:$REMOTE_BRANCH && \
rm -fr .git && \
cd $GITHUB_WORKSPACE && \
echo "Content of $BUILD_DIR has been deployed to GitHub Pages."

# Run this script in your repo dir.

# Set your configs
$REPO_HTTPS_URL='https://github.com/your_username/your_repo.git'
$OLD_EMAIL='your_old@email.com'
$CORRECT_NAME='your author name'
$CORRECT_EMAIL='your_new@email.com'

# Just in case of transferred repo
git remote set-url origin $REPO_HTTPS_URL

$bareDir=$REPO_HTTPS_URL.split('/')[-1]
git clone --bare $REPO_HTTPS_URL
cd $bareDir

$envFilter='
  if [ "$GIT_COMMITTER_EMAIL" = "'+$OLD_EMAIL+'" ]
  then
    export GIT_COMMITTER_NAME="'+$CORRECT_NAME+'"
    export GIT_COMMITTER_EMAIL="'+$CORRECT_EMAIL+'"
  fi
  if [ "$GIT_AUTHOR_EMAIL" = "'+$OLD_EMAIL+'" ]
  then
    export GIT_AUTHOR_NAME="'+$CORRECT_NAME+'"
    export GIT_AUTHOR_EMAIL="'+$CORRECT_EMAIL+'"
  fi
'
git filter-branch --env-filter $envFilter --tag-name-filter cat -- --branches --tags

git push --force --tags origin 'refs/heads/*'

cd ..
Remove-Item -Recurse -Force $bareDir

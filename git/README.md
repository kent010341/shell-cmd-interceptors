# Git Commit Interceptor

## Description
This script is used for prompt user while trying to use invalid git command.  
E.g., while trying to commit on master branch, or the commit message isn't valid.

## Usage
1. Add an alias for `git`
   ```
   alias git="$INTERCEPTOR_PATH/docker-compose/git-interceptor.sh"
   ```

2. Confirm the setting of `.env` file.

3. Done!

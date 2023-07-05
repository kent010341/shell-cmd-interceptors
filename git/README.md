# Git Interceptor

> I don't know there's Git hook for this kind of use case when I'm writing this script.  
> You can adjust this script for the `pre-commit` hook.

## Description
This script is used for prompt user while trying to use invalid git command.  
E.g., while trying to commit on master branch, or the commit message isn't valid.

## Usage
1. Add an alias for `git`
   ```
   alias git="$INTERCEPTOR_PATH/docker-compose/git-interceptor.sh"
   ```

2. Confirm the environment variables configuration file `.env`.
   > :warning: **Attention:** Certain special characters commonly used in other regular expression engines have different interpretations in Bash.
   > The following special characters **do not** have their usual meanings in Bash regular expressions:
   > - `\w`: Matches word characters.
   > - `\d`: Matches digits (0-9), use `[0-9]` instead.
   > - `\s`: Matches space, use `\ ` instead.
   > - other special characters.  

   * `MASTER_BRANCH_NAME`  
     Master branch name, usually is 'main' or 'master'.

   * `BRANCH_PATTERN`
     Regular expression pattern of branch name, used for validating commit message.

   * `MESSAGE_PATTERN`  
     Regular expression pattern of commit message, used for validating commit message.

   * `VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP` (integer, >= 0; skip validation while is empty)  
     When this variable isn't empty, this script will validate if the group 1 of commit message (depends on `MESSAGE_PATTERN`) equals to the specified group of current branch name (depends on `BRANCH_PATTERN`).  
       
     Take `BRANCH_PATTERN="([A-Z]+-[0-9]+)-.+"`, `MESSAGE_PATTERN="([A-Z]+-[0-9]+)\ .+"` and `VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP=1` for example, if current branch name is `FOO-1111-Branch` and the commit message is `"BAR-1234 hello world!"`, the validation will fail due to the mismatch of `FOO-1111` and `BAR-1234`.  

3. Done! Enjoy the safer Git!

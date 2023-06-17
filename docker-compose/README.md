# Docker Compose Down Interceptor

## Description
This script is used for making `docker-compose` command able to "just down one container".  
Also, if your Docker environment doesn't support `docker-compose` file, it will make it supported.

## Usage
1. Clone this repository to anywhere you want.
2. In your Shell startup file which could be `~/.zshrc`, `~/.bashrc`, `~/.bash_profile`, etc., add an variable for the path of the folder cloned in step 1. e.g.,  
   ```
   export INTERCEPTOR_PATH="$HOME/code/shell-cmd-interceptors"
   ```
3. Add an alias for `docker-compose`
   ```
   alias docker-compose="$INTERCEPTOR_PATH/docker-compose/docker-compose-down-interceptor.sh"
   ```

4. Done! Now you can use command like  
   ```
   docker-compose down mysql
   ```
   to stop and remove a container!

# Docker Compose Down Interceptor

## Description
This script is used for making `docker-compose` command able to "just down one container".  
Also, if your Docker environment doesn't support `docker-compose` file, it will make it supported.

## Usage
1. Add an alias for `docker-compose`
   ```
   alias docker-compose="$INTERCEPTOR_PATH/docker-compose/docker-compose-down-interceptor.sh"
   ```

2. Done! Now you can use command like  
   ```
   docker-compose down mysql
   ```
   to stop and remove a container!

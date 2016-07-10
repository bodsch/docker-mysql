docker-mysql
============

Docker container with an running MySQL Database.

The Container stores there Data at the Hostsystem in the Directory ```${HOME}/docker-data/mysql```

# Status
not yet supported

# Build

Your can use the included Makefile.

To build the Container:
```make build```

Starts the Container:
```make run```

Starts the Container with Login Shell:
```make shell```

Entering the Container:
```make exec```

Stop (but **not kill**):
```make stop```

# Docker Hub

You can find the Container also at  [DockerHub](https://hub.docker.com/r/bodsch/docker-mysql/)
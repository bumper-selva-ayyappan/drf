FROM python:3.9-alpine3.13
# Add the name and tag to the Docker image
# LABEL image.name="drf" image.tag="latest"
LABEL maintainer="selva"

# ENV PYTHONBUFFERED 1 sets an environment variable called PYTHONBUFFERED to 1.
# In Python, the PYTHONBUFFERED environment variable controls the buffering of the standard output and standard error streams. When PYTHONBUFFERED is set to a non-zero value, it enables buffering, which means that the output will be stored in memory before being written to the console or redirected to a file.
# Setting PYTHONBUFFERED to 1 ensures that the output from your Python application is immediately flushed and displayed in real-time, rather than being buffered and displayed all at once after the program finishes running. This can be useful for debugging and monitoring the progress of your application.
# In the context of a Dockerfile, setting PYTHONBUFFERED to 1 is a common practice to ensure that the output from Python applications running inside a Docker container is immediately visible in the container logs or when running the container interactively.
# this line ensures that the output from your Python application is not buffered and is immediately available for viewing.
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# setting this arguement to decide which requirements to install
# this is over-written on docker-compose file
ARG DEV=false

# It is good practice to use virtual environment
# run the application using a specific user with limited access, not the root user
# remove any tmp files and directories you create to keep the image clean
# running command in ago avoid creating multiple layers in your docker image, this will reduce the size of the image
# you can run in multiple run command lines but this will add layering
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # adding required dependencies for psycopg2
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        # below are the dependency packages needed for psycopg2
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    # dependency packages are needed only for the install, so removing it
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
# ENV PATH="/py/bin:$PATH" prepends /py/bin to the existing PATH. This means that when the system is looking for executables, it will first look in /py/bin, then in the directories already listed in PATH
# If you change it to ENV PATH="/py/bin", you're replacing the entire PATH with just /py/bin. This means the system will only look in /py/bin for executables and nowhere else. Any executables located in the directories previously included in PATH will not be found unless their full paths are specified.

USER django-user

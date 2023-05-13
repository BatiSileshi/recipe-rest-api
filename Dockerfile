#using apline docker image
FROM python:3.9-alpine3.13

#it tells python that I don't want to buffer the uotput
# we see outputs directly on the console
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

COPY ./recipe-app /recipe-app
WORKDIR /recipe-app
EXPOSE 8000

#ovveridin from docker-compose.yml
ARG DEV=false
RUN python3 -m venv /py
RUN /py/bin/pip install --upgrade pip 
RUN /py/bin/pip install -r /tmp/requirements.txt \
   && if [ $DEV = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt ; fi 
RUN rm -rf /tmp
RUN adduser --disabled-password --no-create-home django-user

# when we run a command it will run from our virtual env't 
ENV PATH="/py/bin:$PATH"

#
USER django-user

FROM python:3.9-alpine3.13
LABEL maintainer="yasmine@bahrideveloper.com"

ENV PYTHONUNBUFFERED=1 \
    PATH="/py/bin:$PATH"

# Create virtualenv, system deps, and a minimal runtime user
RUN python -m venv /py \
 && /py/bin/pip install --upgrade pip \
 && apk add --no-cache postgresql-client gcc musl-dev linux-headers postgresql-dev \
 && adduser -D -H -s /sbin/nologin djangouser

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

ARG DEV=false
RUN /py/bin/pip install -r /tmp/requirements.txt \
 && if [ "$DEV" = "true" ] ; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi \
 && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 8000
USER djangouser

FROM python:3-alpine
MAINTAINER Karushin Aleksandr <karushin@adv.ru>

ARG BUILD_DATE
ARG VCS_REF

ENV VCS_URL "https://github.com/kapb14/docker-python3-flask"
ENV APP_DEBUG False

# Set labels (see https://microbadger.com/labels)
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL

RUN apk add --no-cache bash curl

WORKDIR /app

RUN pip install --no-cache-dir flask gunicorn

EXPOSE 55000

COPY opt/ /opt/

ENTRYPOINT ["/opt/run.sh"]

FROM ubuntu:xenial-20180123
ENV DEBIAN_FRONTEND="noninteractive"

# Configure locales to avoid coding errors
RUN apt-get update && apt-get install locales \
   && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
   && locale-gen en_US.UTF-8 \
   && dpkg-reconfigure locales \
   && update-locale LANG=en_US.UTF-8

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" PYTHONIOENCODING="UTF-8" 

COPY files/pip_requirements.txt files/apk_requirements.txt /tmp/

RUN apt-get update \
  && apt-get install -y wget sudo \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
  && apt-get update \
  && apt-get install -y postgresql-10
RUN apt-get install -y $(grep -vE "^\s*#" /tmp/apk_requirements.txt | tr "\n" " ")
RUN pip install -U pip \
  && python2.7 -m pip install -Ur /tmp/pip_requirements.txt

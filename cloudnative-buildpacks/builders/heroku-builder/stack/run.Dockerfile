ARG IMAGE=tencentos/tencentos3-minimal
ARG TAG=latest

FROM ${IMAGE}:${TAG}

ARG STACK_ID="heroku-24"
ARG sources
ARG packages
#ARG package_args='--allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends'


# Set required CNB information
LABEL io.buildpacks.stack.id=${STACK_ID}
ENV CNB_USER_ID=2000 CNB_GROUP_ID=2000 CNB_STACK_ID=${STACK_ID} STACK=${STACK_ID}

# Use root to create cnb user
USER root

RUN groupadd --gid ${CNB_GROUP_ID} cnb && \
  useradd --uid ${CNB_USER_ID} --gid ${CNB_GROUP_ID} -m -s /bin/bash --home-dir /app cnb && \
  chown cnb:cnb /app /tmp -R

# Install common packages
ARG TIME_ZONE=Asia/Shanghai
ENV TZ=${TIME_ZONE}
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

RUN yum clean all && \
    yum update -y && \
    yum install -y \
        glibc-langpack-en \
        tzdata \
        ${packages} && \
    yum clean all && \
    rm -rf /var/cache/yum

# RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && \
#     echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
#     export LANG=en_US.UTF-8 && \
#     export LC_ALL=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

ENV HOME /app
WORKDIR /app

FROM alpine:3.7

RUN apk upgrade --update-cache --available \
    && apk add --update --nocache \
        nginx=1.12.2-r3 

RUN archive=dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
    commit=1c2a8d81f8b0793fab2d1dd80420f0c382a5fe1f \
    && wget https://raw.github.com/kbase/dockerize/$commit/$archive \
    && tar -C /usr/local/bin -xzvf $archive \
    && rm $archive

# These ARGs values are passed in via the docker build command and fed
# straight into the image tags.
ARG BUILD_DATE
ARG VCS_REF
ARG BRANCH=develop
ARG TAG

RUN mkdir -p /kb/module/htdocs

COPY . /kb/module/htdocs

LABEL org.label-schema.schema-version="1.0.0-rc1" \  
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/kbase/kbase-ui.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    us.kbase.vcs-branch=$BRANCH  \
    us.kbase.vcs-tag=$TAG \
    maintainer="Erik Pearson eapearson@lbl.gov"

ENTRYPOINT ["/usr/local/bin/dockerize"]
CMD ["-template", "/kb/module/templates/nginx.conf.tmpl:/etc/nginx/nginx.conf", \
    "bash", "/kb/module/scripts/start-server.bash" ]
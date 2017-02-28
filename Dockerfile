FROM nginx:1.11-alpine

ENV ECS_GEN_RELEASE 0.3.1

RUN apk add --update bash ca-certificates openssl && \
    rm -rf /var/cache/apk/*

RUN wget -q https://github.com/codesuki/ecs-gen/releases/download/$ECS_GEN_RELEASE/ecs-gen-linux-amd64.zip && \
    unzip ecs-gen-linux-amd64.zip && \
    cp ecs-gen-linux-amd64 /usr/local/bin/ecs-gen && \
    rm -rf ecs-gen-linux-amd64*

COPY nginx.tmpl nginx.tmpl

CMD nginx && ecs-gen --signal="nginx -s reload" --template=nginx.tmpl --output=/etc/nginx/conf.d/default.conf

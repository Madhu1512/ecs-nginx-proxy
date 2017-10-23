FROM nginx:1.13-alpine

ARG ECS_GEN_RELEASE=0.4.0-custom

RUN apk add --update bash ca-certificates openssl && \
    rm -rf /var/cache/apk/* && \
    wget -q https://github.com/madhu1512/ecs-gen/releases/download/$ECS_GEN_RELEASE/ecs-gen-linux-amd64.zip && \
    unzip ecs-gen-linux-amd64.zip && \
    cp ecs-gen-linux-amd64 /usr/local/bin/ecs-gen && \
    rm -rf ecs-gen-linux-amd64* && \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.tmpl nginx.tmpl
COPY nginx.conf /etc/nginx/nginx.conf

CMD nginx && ecs-gen --signal="nginx -s reload" --template=nginx.tmpl --output=/etc/nginx/conf.d/default.conf

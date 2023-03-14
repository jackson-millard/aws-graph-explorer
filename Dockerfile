# syntax=docker/dockerfile:1
FROM amazonlinux:2
WORKDIR /
COPY . /graph-explorer/
WORKDIR /graph-explorer
RUN yum install -y curl && curl -sL https://rpm.nodesource.com/setup_16.x | bash - && yum install -y nodejs openssl && npm install -g pnpm && pnpm install
WORKDIR /graph-explorer/packages/graph-explorer-proxy-server/cert-info/
### BEGIN CERT CREATION (The below portion is used to create the self-signed cert so that the workbench and proxy can communicate over https.)
RUN yum remove -y openssl
WORKDIR /graph-explorer/
ENV HOME=/graph-explorer
RUN pnpm build
EXPOSE 80
EXPOSE 443
RUN chmod a+x ./docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]

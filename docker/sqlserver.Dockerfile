FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=Admin@1234

USER root

RUN mkdir -p /var/backups
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER mssql

ENTRYPOINT ["/entrypoint.sh"]
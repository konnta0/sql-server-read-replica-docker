FROM mcr.microsoft.com/mssql/server:2022-latest

RUN /opt/mssql/bin/mssql-conf set hadr.hadrenabled  1
RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true

EXPOSE 1433

ENTRYPOINT /opt/mssql/bin/sqlservr
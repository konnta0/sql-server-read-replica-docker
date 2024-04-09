CREATE AVAILABILITY GROUP [AG1]
      WITH (CLUSTER_TYPE = NONE)
      FOR REPLICA ON
      N'sqlNode1'
            WITH (
            ENDPOINT_URL = N'tcp://sqlNode1:5022',
            AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
               SEEDING_MODE = AUTOMATIC,
               FAILOVER_MODE = MANUAL,
            SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
               ),
      N'sqlNode2'
            WITH (
            ENDPOINT_URL = N'tcp://sqlNode2:5022',
            AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
               SEEDING_MODE = AUTOMATIC,
               FAILOVER_MODE = MANUAL,
            SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
               ),
      N'sqlNode3'
            WITH (
            ENDPOINT_URL = N'tcp://sqlNode3:5022',
            AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT,
               SEEDING_MODE = AUTOMATIC,
               FAILOVER_MODE = MANUAL,
            SECONDARY_ROLE (ALLOW_CONNECTIONS = ALL)
               );
GO

ALTER AVAILABILITY GROUP [AG1] GRANT CREATE ANY DATABASE;
GO
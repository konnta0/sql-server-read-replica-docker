ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode1' WITH
   (SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));

ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode1' WITH
   (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'tcp://172.16.238.21:1433'));


ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode2' WITH
   (SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));

ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode2' WITH
   (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'tcp://172.16.238.22:1433'));


ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode3' WITH
      (SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));

ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode3' WITH
      (SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'tcp://172.16.238.23:1433'));


ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode1' WITH
   (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=(('sqlNode3','sqlNode2'),'sqlnode1')));

ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode2' WITH
   (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=(('sqlNode1','sqlNode3'),'sqlnode2')));

ALTER AVAILABILITY GROUP [AG1]
MODIFY REPLICA ON
N'sqlNode3' WITH
      (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=(('sqlNode1','sqlNode2'),'sqlnode3')));

GO
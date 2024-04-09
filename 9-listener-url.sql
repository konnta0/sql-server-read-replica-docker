IF EXISTS (SELECT * FROM sys.availability_group_listeners l JOIN sys.availability_groups g ON l.group_id = g.group_id WHERE l.dns_name = 'AGListener' AND g.name = 'AG1')
BEGIN
    ALTER AVAILABILITY GROUP [AG1] REMOVE LISTENER 'AGListener';
END
GO

ALTER AVAILABILITY GROUP [AG1]
      ADD LISTENER 'AGListener' ( WITH IP ( (N'172.16.238.21', N'255.255.255.0') ) , PORT = 1434 );
GO
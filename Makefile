.PHONY: help # Show help
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 ... \2/' | expand -t20

.PHONY: build # Build image
build:
	docker build -t sqlag:ha . --no-cache

.PHONY: up # Start container
up:
	docker compose up -d --remove-orphans

.PHONY: down # Stop container
down:
	docker compose down

.PHONY: logs # Log container
logs:
	docker compose logs -f

PRIMAY_SERVER=172.16.238.1,1501
.PHONY: db-primary # sqlcmd to primary
db-primary:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1"

SECONDARY_SERVER1=172.16.238.1,1502
.PHONY: db2 # sqlcmd to db2
db2:
	sqlcmd -S $(SECONDARY_SERVER1) -U SA -P "Password1"

SECONDARY_SERVER2=172.16.238.1,1503
.PHONY: db3 # sqlcmd to db3
db3:
	sqlcmd -S $(SECONDARY_SERVER2) -U SA -P "Password1"

LISTENER=172.16.238.21,1434
.PHONY: db-listener # sqlcmd 
db-listener:
	sqlcmd -S $(LISTENER) -U SA -P "Password1" -d agtestdb

.PHONY: db-listener-ro # sqlcmd 
db-listener-ro:
	sqlcmd -S $(LISTENER) -U SA -P "Password1" -d agtestdb -K ReadOnly

.PHONY: setup # Setup. If you want to set up a readOnly replica, run the [setup-routing-list setup-listener-url] command additionally
setup: setup-certificate setup-always-on setup-always-on-availability-group create-test-db 

.PHONY: setup-certificate # Setup certificate
setup-certificate:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 1-primary-setup-certificate.sql
	docker cp sqlNode1:/tmp/dbm_certificate.cer ./certificates
	docker cp sqlNode1:/tmp/dbm_certificate.pvk ./certificates
	sqlcmd -S $(SECONDARY_SERVER1) -U SA -P "Password1" -i 2-secondary-setup-certificate.sql
	sqlcmd -S $(SECONDARY_SERVER2) -U SA -P "Password1" -i 2-secondary-setup-certificate.sql

.PHONY: setup-always-on # Setup AlwaysOn
setup-always-on:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 3-always-on.sql
	sqlcmd -S $(SECONDARY_SERVER1) -U SA -P "Password1" -i 3-always-on.sql
	sqlcmd -S $(SECONDARY_SERVER2) -U SA -P "Password1" -i 3-always-on.sql
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 4-always-on-health.sql
	sqlcmd -S $(SECONDARY_SERVER1) -U SA -P "Password1" -i 4-always-on-health.sql
	sqlcmd -S $(SECONDARY_SERVER2) -U SA -P "Password1" -i 4-always-on-health.sql

.PHONY: setup-always-on-availability-group # Setup AlwaysOn Availability Group
setup-always-on-availability-group:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 5-primary-always-on-availability-group.sql
	sqlcmd -S $(SECONDARY_SERVER1) -U SA -P "Password1" -i 6-secondary-always-on-availability-group.sql
	sqlcmd -S $(SECONDARY_SERVER2) -U SA -P "Password1" -i 6-secondary-always-on-availability-group.sql

.PHONY: create-test-db # Create test database
create-test-db:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 7-create-test-database.sql

.PHONY: setup-routing-list # Setup routing list
setup-routing-list:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 8-routing-list.sql

.PHONY: setup-listener-url # Setup listener url
setup-listener-url:
	sqlcmd -S $(PRIMAY_SERVER) -U SA -P "Password1" -i 9-listener-url.sql

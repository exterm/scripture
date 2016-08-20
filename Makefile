.PHONY: plt hard_deploy production_backup

plt:
	mix dialyzer.plt
	dialyzer --add_to_plt --plt scripture.plt --output_plt scripture.plt _build/dev/lib/plug/ebin _build/dev/lib/ecto/ebin

hard_deploy:
	mix edeliver build release --branch=scripture-new \
	&& mix edeliver deploy release to production \
	&& mix edeliver restart production

BACKUP_LOCATION=~/Dropbox/scripture_backups
SSH_HOST=scripture@hullubullu.de
BACKUP_FILE=$(shell echo /tmp/scripture/backup_`date +%Y-%m-%d-%H:%M`.sql.gz)
DB_NAME=scripture_prod

production_backup:
	mkdir -p $(BACKUP_LOCATION)
	ssh $(SSH_HOST) "pg_dump $(DB_NAME) | gzip > $(BACKUP_FILE)"
	scp $(SSH_HOST):"$(BACKUP_FILE)" $(BACKUP_LOCATION)/

RESTORE_LOCATION=/tmp/scripture/restore
RESTORE_FILENAME=$(shell ls -1 $(BACKUP_LOCATION) | sort | tail -n1)

production_restore:
	ssh $(SSH_HOST) mkdir -p $(RESTORE_LOCATION)
	ssh $(SSH_HOST) rm -f $(RESTORE_LOCATION)/*
	scp $(BACKUP_LOCATION)/$(RESTORE_FILENAME) $(SSH_HOST):$(RESTORE_LOCATION)/
	mix edeliver stop production
	ssh $(SSH_HOST) dropdb --if-exists $(DB_NAME)
	ssh $(SSH_HOST) createdb $(DB_NAME)
	ssh $(SSH_HOST) "gunzip -c $(RESTORE_LOCATION)/$(RESTORE_FILENAME) | psql $(DB_NAME)"
	mix edeliver start production

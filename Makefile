include .env
export

up:
	@docker-compose up -d
	@echo "Custom php-fpm + nginx Up"
stop:
	@docker-compose stop
	@echo "Custom php-fpm + nginx Stop"

snd:
	@docker-compose down
	@echo "Custom php-fpm + nginx Stop and Down (stop and remove all container data - becareful)"

backup:
	@echo "Backup database"
	@docker exec $(container_mysql_name) /usr/bin/mysqldump -u root --password=root $(database_name) > backup.sql

restore:
	@echo "Restore database"
	@cat backup.sql | docker exec -i $(container_mysql_name) /usr/bin/mysql -u root --password=root $(database_name)

go_run:
	docker exec -it $(container_web_name) /bin/bash

chmod:
	@echo "Update permission"
	@sudo chmod -R 777 ./ #find . -type f -exec chmod -c 644 {} \; && sudo find . -type d -exec chmod -c 755 {} \;
	@#sudo chmod -R 755 ./ && sudo chmod -R 777 ./magento/var ./magento/pub ./magento/app/etc ./magento/generated

upg:
	@echo "Setup Upgrade"
	#php bin/magento setup:upgrade
	docker exec $(container_web_name) /var/www/public/bin/magento setup:upgrade

dp: cf
	@echo "Deploy"
	#php bin/magento setup:static-content:deploy -f
	docker exec $(container_web_name) rm -rf /var/www/public/pub/static/_requirejs/*
	docker exec $(container_web_name) rm -rf /var/www/public/pub/static/frontend/*
	docker exec $(container_web_name) rm -rf /var/www/public/pub/static/adminhtml/*
	docker exec $(container_web_name) rm -rf /var/www/public/var/view_preprocessed/*
	docker exec $(container_web_name) rm -rf /var/www/public/var/page_cache/*
	docker exec $(container_web_name) /var/www/public/bin/magento setup:static-content:deploy -f

ri:
	@echo "Reindex"
	#php bin/magento indexer:reindex
	docker exec $(container_web_name) /var/www/public/bin/magento indexer:reindex

cf:
	@echo "Flush cache"
	#php bin/magento cache:flush
	docker exec $(container_web_name) /var/www/public/bin/magento c:f

di:
	@echo "Compile"
	#php bin/magento setup:di:compile
	docker exec $(container_web_name) /var/www/public/bin/magento setup:di:compile

composer:
	php composer.phar $(cm)
	
m_all: upg dp ri cf chmod
	@echo "-----------------------"; echo "Done !!!";

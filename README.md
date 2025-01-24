# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs


### **Задание 2. Шардирование**

1. Запускаем mongodb и приложение

```shell
docker compose up -d
```

В результате в терминале увидим следующий вывод:

```shell
✔ Network mongo-sharding_app-network            Created 0.1s
✔ Network mongo-sharding_default                Created 0.1s
✔ Volume "mongo-sharding_mongodb1-shard1-data"  Created 0.0s
✔ Volume "mongo-sharding_mongodb1-shard2-data"  Created 0.0s
✔ Volume "mongo-sharding_config-data"           Created 0.0s
✔ Container mongodb1-shard2                     Started 0.7s
✔ Container configSrv                           Started 0.6s
✔ Container mongodb1                            Started 0.5s
✔ Container mongodb1-shard1                     Started 0.6s
✔ Container pymongo_api                         Started 0.8s
```

2. Запускаем скрипт scripts/mongo-init.sh

```shell
cd scripts
sh mongo-init.sh
```

Скрипт выполнит инициализацию БД, а также заполнит её данными (1000 документов)

3. Запускаем скрипт mongo-get-docs-count.sh Скрипт отобразит количество документов в шардах 1 и 2

```shell
sh mongo-get-docs-count.sh
```

В результате увидим следующее распределение документов по шардам:

```shell
mongodb1-shard1
mongodb1-shard1 [direct: primary] test> switched to db somedb
mongodb1-shard1 [direct: primary] somedb> 492
mongodb1-shard1 [direct: primary] somedb> mongodb1-shard2
mongodb1-shard2 [direct: primary] test> switched to db somedb
mongodb1-shard2 [direct: primary] somedb> 508
```

4. Останавливаем контейнеры

```shell
docker compose down
```

### **Задание 3. Репликация**

```shell
 
```

Проверяем запуск приложения

curl -X 'GET' \
'http://localhost:8080' \
-H 'accept: application/json'


{"mongo_topology_type":"Sharded","mongo_replicaset_name":null,"mongo_db":"somedb","read_preference":"Primary()","mongo_nodes":[["t3-mongodb1",27020]],"mongo_primary_host":null,"mongo_secondary_hosts":[],"mongo_address":["t3-mongodb1",27020],"mongo_is_primary":true,"mongo_is_mongos":true,"collections":{"helloDoc":{"documents_count":1000}},"shards":{"t3-mongodb1-shard1-rs":"t3-mongodb1-shard1-rs/t3-mongodb1-shard1:27018,t3-mongodb1-shard1-repl1:27025,t3-mongodb1-shard1-repl2:27026","t3-mongodb1-shard2-rs":"t3-mongodb1-shard2-rs/t3-mongodb1-shard2:27019,t3-mongodb1-shard2-repl1:27027,t3-mongodb1-shard2-repl2:27028"},"cache_enabled":false,"status":"OK"}

curl -X 'GET' \
'http://localhost:8080/helloDoc/count' \
-H 'accept: application/json'

{
"status": "OK",
"mongo_db": "somedb",
"items_count": 1000
}
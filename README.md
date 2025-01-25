### **Задание 2. Шардирование**

1. Запускаем mongodb и приложение

```shell
cd mongo-sharding
docker compose up -d
```

В результате в терминале увидим следующий вывод:

```shell
✔ Network t2-network                               Created                                                                                                                           0.1s 
 ✔ Network mongo-sharding_default                   Created                                                                                                                           0.1s 
 ✔ Volume "mongo-sharding_t2-config-data"           Created                                                                                                                           0.0s 
 ✔ Volume "mongo-sharding_t2-mongodb1-shard1-data"  Created                                                                                                                           0.0s 
 ✔ Volume "mongo-sharding_t2-mongodb1-shard2-data"  Created                                                                                                                           0.0s 
 ✔ Container t2-configSrv                           Started                                                                                                                           1.8s 
 ✔ Container t2-mongodb1-shard2                     Started                                                                                                                           1.8s 
 ✔ Container t2-mongodb1-shard1                     Started                                                                                                                           1.7s 
 ✔ Container t2-mongodb1                            Started                                                                                                                           2.2s 
 ✔ Container t2-pymongo_api                         Started 
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
t2-mongodb1-shard1 [direct: primary] test> switched to db somedb
t2-mongodb1-shard1 [direct: primary] somedb> 492
t2-mongodb1-shard1 [direct: primary] somedb> mongodb1-shard2
t2-mongodb1-shard2 [direct: primary] test> switched to db somedb
t2-mongodb1-shard2 [direct: primary] somedb> 508
t2-mongodb1-shard2 [direct: primary] somedb> %   
```

4. Проверяем запуск приложения

```shell
curl -X 'GET' \
'http://localhost:8080' \
-H 'accept: application/json'
```

```json
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "t2-mongodb1",
      27020]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "t2-mongodb1",
    27020],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "t2-mongodb1-shard1": "t2-mongodb1-shard1/t2-mongodb1-shard1:27018",
    "t2-mongodb1-shard2": "t2-mongodb1-shard2/t2-mongodb1-shard2:27019"
  },
  "cache_enabled": false,
  "status": "OK"
}
```

5. Останавливаем контейнеры

```shell
docker compose down
```

### **Задание 3. Репликация**

1. Запускаем mongodb и приложение

```shell
cd mongo-sharding-repl
docker compose up -d
```

В результате в терминале увидим следующий вывод:

```shell
[+] Running 17/17
✔ Network t3-network                                          Created                                                                                                                0.1s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard2-repl1-data"  Created                                                                                                                0.0s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard2-data"        Created                                                                                                                0.0s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard1-repl2-data"  Created                                                                                                                0.1s
✔ Volume "mongo-sharding-repl_t3-mongodb1-shard1-data"        Created                                                                                                                0.0s
✔ Volume "mongo-sharding-repl_t3-config-data"                 Created                                                                                                                0.0s
✔ Container t3-mongodb1-shard1-repl1                          Started                                                                                                                2.6s
✔ Container t3-mongodb1-shard2-repl1                          Started                                                                                                                2.5s
✔ Container t3-mongodb1                                       Started                                                                                                                2.3s
✔ Container t3-configSrv                                      Started                                                                                                                2.3s
✔ Container t3-mongodb1-shard1-repl2                          Started                                                                                                                2.5s
✔ Container t3-mongodb1-shard2                                Started                                                                                                                2.6s
✔ Container t3-mongodb1-shard2-repl2                          Started                                                                                                                2.1s
✔ Container t3-mongodb1-shard1                                Started                                                                                                                2.4s
✔ Container t3-pymongo_api                                    Started                                                                                                                2.8s
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
t3-mongodb1-shard1-rs [direct: primary] test> switched to db somedb
t3-mongodb1-shard1-rs [direct: primary] somedb> 492
t3-mongodb1-shard1-rs [direct: primary] somedb> mongodb1-shard2
t3-mongodb1-shard2-rs [direct: primary] test> switched to db somedb
t3-mongodb1-shard2-rs [direct: primary] somedb> 508
t3-mongodb1-shard2-rs [direct: primary] somedb> %  
```

4. Проверяем запуск приложения

```shell
curl -X 'GET' \
'http://localhost:8080' \
-H 'accept: application/json'
```

```json
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "t3-mongodb1",
      27020
    ]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "t3-mongodb1",
    27020
  ],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "t3-mongodb1-shard1-rs": "t3-mongodb1-shard1-rs/t3-mongodb1-shard1:27018,t3-mongodb1-shard1-repl1:27025,t3-mongodb1-shard1-repl2:27026",
    "t3-mongodb1-shard2-rs": "t3-mongodb1-shard2-rs/t3-mongodb1-shard2:27019,t3-mongodb1-shard2-repl1:27027,t3-mongodb1-shard2-repl2:27028"
  },
  "cache_enabled": false,
  "status": "OK"
}
```

```shell
curl -X 'GET' \
'http://localhost:8080/helloDoc/count' \
-H 'accept: application/json'
```

```json
{
"status": "OK",
"mongo_db": "somedb",
"items_count": 1000
}
```

5. Останавливаем контейнеры

```shell
docker compose down
```

### **Задание 4. Кэширование**

1. Запускаем mongodb и приложение

```shell
cd sharding-repl-cache
docker compose up -d
```

```shell
[+] Running 14/7
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 14/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 14/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 14/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 16/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 19/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
[+] Running 28/28ng-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 15/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 16/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 17/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 17/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 17/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 17/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 18/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 18/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 18/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 21/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 22/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 22/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 23/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 24/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 25/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 26/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 27/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 28/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
[+] Running 29/29ng-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Network t4-network                                          Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-data"        Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_1_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl1-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_3_data"                   Created                                                                                                                0.1s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard1-repl2-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-config-data"                 Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_5_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_4_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_t4-mongodb1-shard2-repl1-data"  Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_2_data"                   Created                                                                                                                0.0s 
 ✔ Volume "sharding-repl-cache_redis_6_data"                   Created                                                                                                                0.0s 
 ✔ Container t4-mongodb1                                       Started                                                                                                                3.0s 
 ✔ Container t4-mongodb1-shard2                                Started                                                                                                                2.2s 
 ✔ Container t4-mongodb1-shard1-repl2                          Started                                                                                                                3.3s 
 ✔ Container redis_4                                           Started                                                                                                                2.7s 
 ✔ Container t4-configSrv                                      Started                                                                                                                3.1s 
 ✔ Container redis_5                                           Started                                                                                                                3.6s 
 ✔ Container redis_1                                           Started                                                                                                                3.7s 
 ✔ Container redis_2                                           Started                                                                                                                3.9s 
 ✔ Container redis_6                                           Started                                                                                                                3.6s 
 ✔ Container t4-mongodb1-shard2-repl1                          Started                                                                                                                3.0s 
 ✔ Container t4-mongodb1-shard2-repl2                          Started                                                                                                                3.0s 
 ✔ Container t4-mongodb1-shard1                                Started                                                                                                                3.4s 
 ✔ Container redis_3                                           Started                                                                                                                2.4s 
 ✔ Container t4-mongodb1-shard1-repl1                          Started                                                                                                                3.1s 
 ✔ Container t4-pymongo_api                                    Started                                                                                                                3.8s
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

В результате увидим следующее распределение документов по репликам:

```shell
t4-mongodb1-shard1-rs [direct: primary] test> switched to db somedb
t4-mongodb1-shard1-rs [direct: primary] somedb> 492
t4-mongodb1-shard1-rs [direct: primary] somedb> mongodb1-shard2
t4-mongodb1-shard2-rs [direct: primary] test> switched to db somedb
t4-mongodb1-shard2-rs [direct: primary] somedb> 508
t4-mongodb1-shard2-rs [direct: primary] somedb> %   
```

4. Проверяем запуск приложения

```shell
curl -X 'GET' \
'http://localhost:8080' \
-H 'accept: application/json'
```

```json
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "t4-mongodb1",
      27020]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "t4-mongodb1",
    27020],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "t4-mongodb1-shard1-rs": "t4-mongodb1-shard1-rs/t4-mongodb1-shard1:27018,t4-mongodb1-shard1-repl1:27025,t4-mongodb1-shard1-repl2:27026",
    "t4-mongodb1-shard2-rs": "t4-mongodb1-shard2-rs/t4-mongodb1-shard2:27019,t4-mongodb1-shard2-repl1:27027,t4-mongodb1-shard2-repl2:27028"
  },
  "cache_enabled": true,
  "status": "OK"
}
```

5. Проверка кэширования 

```shell
date +%s
curl -X 'GET' 'http://localhost:8080/helloDoc/users' -H 'accept: application/json' > users.json
date +%s
```

1737773355
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
Dload  Upload   Total   Spent    Left  Speed
100 58791  100 58791    0     0  49485      0  0:00:01  0:00:01 --:--:-- 49445
1737773356
vspitchenko@Users-MBP scripts % date +%s
curl -X 'GET' 'http://localhost:8080/helloDoc/users' -H 'accept: application/json' > users.json
date +%s
1737773373
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
Dload  Upload   Total   Spent    Left  Speed
100 58791  100 58791    0     0  2453k      0 --:--:-- --:--:-- --:--:-- 2496k
1737773373

Первый запрос отработал за 1 секунду, повторый менее 1 секунды

### **Задание 5. Service Discovery и балансировка с API Gateway**



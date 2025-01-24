#!/bin/bash
docker compose exec -T t3-configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "t3-configSrv:27017" }
    ]
  }
);
exit();
EOF

# создаём набор реплик mongodb1-shard1-rs
docker compose exec -T t3-mongodb1-shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
{
  _id: "t3-mongodb1-shard1-rs", members: [
    {_id: 0, host: "t3-mongodb1-shard1:27018"},
    {_id: 1, host: "t3-mongodb1-shard1-repl1:27025"},
    {_id: 2, host: "t3-mongodb1-shard1-repl2:27026"}
  ]
})
exit();
EOF

# создаём набор реплик mongodb1-shard2-rs
docker compose exec -T t3-mongodb1-shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
{
  _id: "t3-mongodb1-shard2-rs", members: [
    {_id: 0, host: "t3-mongodb1-shard2:27019"},
    {_id: 1, host: "t3-mongodb1-shard2-repl1:27027"},
    {_id: 2, host: "t3-mongodb1-shard2-repl2:27028"}
  ]
})
exit();
EOF

docker compose exec -T t3-mongodb1 mongosh --port 27020 --quiet <<EOF
sh.addShard( "t3-mongodb1-shard1-rs/t3-mongodb1-shard1:27018");
sh.addShard( "t3-mongodb1-shard2-rs/t3-mongodb1-shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
exit();
EOF

#распечатаем конфигурацию
docker compose exec -T t3-mongodb1-shard1 mongosh --port 27018 --quiet <<EOF
rs.conf();
exit();
EOF

docker compose exec -T t3-mongodb1 mongosh --port 27020 --quiet <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit();
EOF

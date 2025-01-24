#!/bin/bash
docker compose exec -T configSrv mongosh --port 27020 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27020" }
    ]
  }
);
exit();
EOF

docker compose exec -T mongodb1-shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
  {
    _id : "mongodb1-shard1",
    members: [
      { _id : 0, host : "mongodb1-shard1:27018" }
    ]
  }
);
exit();
EOF

docker compose exec -T mongodb1-shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "mongodb1-shard2",
    members: [
      { _id : 1, host : "mongodb1-shard2:27019" }
    ]
  }
);
exit();
EOF

docker compose exec -T mongodb1 mongosh --port 27017 --quiet <<EOF
sh.addShard( "mongodb1-shard1/mongodb1-shard1:27018");
sh.addShard( "mongodb1-shard2/mongodb1-shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit();
EOF
echo 'mongodb1-shard1'
docker compose exec -T t3-mongodb1-shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
echo 'mongodb1-shard2'
docker compose exec -T t3-mongodb1-shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


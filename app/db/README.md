# Data backend

## MongoDB deployment

### Create a new Mongo StatefulSet name `mongo`

```shell
cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongo
spec:
  selector:
      matchLabels:
        role: db
        env: dev
        replicaset: rs0.main
  serviceName: mongo
  replicas: 3
  template:
    metadata:
      labels:
        role: db
        env: dev
        replicaset: rs0.main
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: replicaset
                  operator: In
                  values:
                  - rs0.main
              topologyKey: kubernetes.io/hostname
      containers:
        - name: mongo
          image: xxx
          command:
           	- mongod
            - "--replSet"
            - rs0
            - "--bind_ip"
            - "0.0.0.0"
          ports:
            - containerPort: 27017
          volumeMounts:
            - name: mongodb-persistent-storage-claim
              mountPath: /data/db
  volumeClaimTemplates:
    - metadata:
        name: mongodb-persistent-storage-claim
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 0.5Gi
EOF
```

Examine the Mongo Pods launch in an ordered sequence

```shell
kubectl get pods --watch
kubectl get pods
kubectl get pods --show-labels
kubectl get pods -l role=db
```

>  **Ctrl-C** to exit the watch

### Create a new Headless Service for Mongo named `mongo`

```shell
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  name: mongo
	...
EOF
```

```shell
kubeclt get svc
```

### Initialise the Mongo database replica set

```shell
cat > db.init.js << EOF
rs.initiate({
  _id : "rs0",
  members: [
    { _id: 0, host: "mongo-0.mongo:27017" },
    { _id: 1, host: "mongo-1.mongo:27017" },
    { _id: 2, host: "mongo-2.mongo:27017" }
  ]
});
EOF
```

```shell
kubectl exec mongo-0 mongo < db.init.js
kubectl exec mongo-0 mongo --eval "rs.status()"
```

###   Load the initial voting app data into the Mongo database

```shell
cat > db.load.js << EOF
use platformsdb;
db.platforms.insert({
"name" : "openshift", 
"codedetail" : { 
	"usecase" : "Container platform", 
  "rank" : 12, 
  "homepage" : "https://openshift.com", 
  "download" : "https://developers.redhat.com/products/codeready-containers/overview",
  "votes" : 0}});
db.platforms.insert({
"name" : "kubernetes", 
"codedetail" : { 
	"usecase" : "Container orchestration platform ", 
	"rank" : 38, 
	"homepage" : "https://kubernetes.com", 
	"download" : "https://kubernetes.io/docs/tasks/tools/install-minikube/", 
	"votes" : 0}});
db.platforms.insert(
{"name" : "rancher", 
 "codedetail" : { 
 		"usecase" : "Container platform management ", 
 		"rank" : 50, 
 		"homepage" : "https://rancher.com/", 
 		"download" : "https://github.com/rancher/rancher", 
 		"votes" : 0}});
db.platforms.find().pretty();
EOF
```

```shell
kubectl exec mongo-0 mongo < db.load.js
kubectl exec mongo-0 mongo platformsdb --eval "db.platforms.find().pretty()"
```




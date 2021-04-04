# Dockerfile - Version de confluent cli

Il faut installer confluent cli en fonction de la version du playbook

Version courante:
```
git --git-dir ~/main/cp-ansible/.git branch
```

Cf https://docs.confluent.io/platform/current/installation/versions-interoperability.html#confluent-cli


# Démarrage container "cloud-tooling-kafka"

```
make run
```

# Volumes

* zookeeper

  ```
  dataDir=/var/lib/zookeeper
  kafka.logs.dir=/var/log/kafka
  ```
* kafka

  ```
  log.dirs=/var/lib/kafka/data
  kafka.logs.dir=/var/log/kafka
  ```

* schema_registry

  ```
  schema-registry.log.dir=/var/log/confluent/schema-registry
  ```

# Provisionning VMs AWS

```
cd ~/main/terraform
./plan.sh
./apply.sh
```

# Génération ssh_config / inventory.yml

* Sans bastion
  ```
  cd ~/main
  create-ssh-config.sh
  inventory-template.sh
  ```

* Avec bastion
  ```
  cd ~/main
  create-ssh-config.sh
  inventory-template-with-bastion.sh
  ```

* Check ssh
  ```
  $ ssh -F ssh_config node_c_1
  Failed to add the host to the list of known hosts (/home/devops/.ssh/known_hosts).
  [centos@ip-10-0-3-154 ~]$
  ```
  ==> La connexion ssh sur la VM node_c est OK

* Check ansible
  ```
  $ ansible all -m ping
  ```
  ==> Toutes les VMs doivent répondre au ping

# Cheatsheet Centos

## Install netcat

```
sudo yum install nc
```

## Install dig

```
sudo yum install bind-utils
```


# Prérequis pour install

## DNS: les VMs doivent pouvoir s'atteindre via les hostnames dans ansible

Le nom des hosts doit se résoudre via les IPs internes

## AWS

```
ansible-playbook pre-cp-ansible/all.yml
```

> ** _NOTE_ ** Si utilisation avec bastion voir PREPARE_VM.md

# Exécuter le playbook

```
ansible-playbook cp-ansible/all.yml
```

# Test

```
export BOOTSTRAP_SERVER=node_a:9092,node_b:9092,node_c:9092
```

## Create topic

```
kafka-topics \
  --bootstrap-server ${BOOTSTRAP_SERVER} \
  --create \
  --if-not-exists \
  --topic coincoincoin \
  --partitions 6 \
  --replication-factor 3 \
  --config min.insync.replicas=2
```

## List topic

```
kafka-topics --bootstrap-server ${BOOTSTRAP_SERVER} --list
```

## Describe topic

```
kafka-topics --bootstrap-server ${BOOTSTRAP_SERVER} --describe --topic coincoincoin
```

## Write in topic

```
kafka-console-producer \
  --bootstrap-server ${BOOTSTRAP_SERVER} \
  --request-required-acks all \
  --topic coincoincoin
```

## Read from topic

```
kafka-console-consumer \
  --from-beginning \
  --bootstrap-server ${BOOTSTRAP_SERVER} \
  --topic coincoincoin
```

## Write perf test

```
kafka-producer-perf-test \
  --producer-props bootstrap.servers=${BOOTSTRAP_SERVER} acks=all \
  --topic coincoincoin \
  --throughput -1 \
  --num-records 1000000 \
  --record-size 1024
```

* Exemple sur zookeeper=t3.large, kafka=t3.xlarge, schema_registry=t3.xlarge
  ```
  111661 records sent, 22323.3 records/sec (21.80 MB/sec), 1094.6 ms avg latency, 2011.0 ms max latency.
  167490 records sent, 33498.0 records/sec (32.71 MB/sec), 920.5 ms avg latency, 2225.0 ms max latency.
  223140 records sent, 44628.0 records/sec (43.58 MB/sec), 698.8 ms avg latency, 1503.0 ms max latency.
  228660 records sent, 45732.0 records/sec (44.66 MB/sec), 669.4 ms avg latency, 1481.0 ms max latency.
  233040 records sent, 46608.0 records/sec (45.52 MB/sec), 650.4 ms avg latency, 1534.0 ms max latency.
  1000000 records sent, 37831.498506 records/sec (36.94 MB/sec), 772.71 ms avg latency, 2225.00 ms max latency, 609 ms 50th, 1526 ms 95th, 2055 ms 99th, 2182 ms 99.9th.
  ```

* Exemple sur zookeeper, kafka et schema_registry collocalisés sur 3x t3.large
  ```
  47401 records sent, 9478.3 records/sec (9.26 MB/sec), 2148.3 ms avg latency, 3304.0 ms max latency.
  68070 records sent, 13614.0 records/sec (13.29 MB/sec), 2037.5 ms avg latency, 2655.0 ms max latency.
  89490 records sent, 17898.0 records/sec (17.48 MB/sec), 1974.9 ms avg latency, 3060.0 ms max latency.
  136620 records sent, 27324.0 records/sec (26.68 MB/sec), 1179.1 ms avg latency, 1668.0 ms max latency.
  167070 records sent, 33414.0 records/sec (32.63 MB/sec), 900.8 ms avg latency, 1513.0 ms max latency.
  164862 records sent, 32972.4 records/sec (32.20 MB/sec), 871.5 ms avg latency, 2149.0 ms max latency.
  168893 records sent, 33778.6 records/sec (32.99 MB/sec), 950.9 ms avg latency, 2451.0 ms max latency.
  1000000 records sent, 25399.405654 records/sec (24.80 MB/sec), 1161.43 ms avg latency, 3304.00 ms max latency, 1175 ms 50th, 2404 ms 95th, 2859 ms 99th, 3193 ms 99.9th.
  ```

## Read perf test

```
kafka-consumer-perf-test \
  --bootstrap-server ${BOOTSTRAP_SERVER} \
  --messages 1000000 \
  --topic coincoincoin
```

* Exemple sur zookeeper=t3.large, kafka=t3.xlarge, schema_registry=t3.xlarge
  ```
  start.time, end.time, data.consumed.in.MB, MB.sec, data.consumed.in.nMsg, nMsg.sec, rebalance.time.ms, fetch.time.ms, fetch.MB.sec, fetch.nMsg.sec
  2021-03-09 13:46:17:288, 2021-03-09 13:46:24:858, 976.5625, 129.0043, 1000000, 132100.3963, 1615297580688, -1615297573118, -0.0000, -0.0006
  ```

* Exemple sur zookeeper, kafka et schema_registry collocalisés sur 3x t3.large
  ```
  start.time, end.time, data.consumed.in.MB, MB.sec, data.consumed.in.nMsg, nMsg.sec, rebalance.time.ms, fetch.time.ms, fetch.MB.sec, fetch.nMsg.sec
  2021-03-09 14:07:50:466, 2021-03-09 14:07:59:251, 976.5625, 111.1625, 1000000, 113830.3927, 1615298873969, -1615298865184, -0.0000, -0.0006
  ```

## ActiveControllerCount

```
kafka-run-class kafka.tools.JmxTool \
      --one-time true \
      --object-name kafka.controller:type=KafkaController,name=ActiveControllerCount \
      --jmx-url service:jmx:rmi:///jndi/rmi://localhost:9999/jmxrmi \
      --report-format properties
```

## Arrêt shema-registry/kafka/zookeeper

```
ansible schema_registry --become -m shell -a "systemctl stop confluent-schema-registry.service"
ansible kafka_broker --become -m shell -a "systemctl stop confluent-kafka.service"
ansible zookeeper --become -m shell -a "systemctl stop confluent-zookeeper.service"
```

# Ouvertures

packages.confluent.io (port 443)
search.maven.org (port 80)
repo1.maven.org (port 443)

Tasks install:
* confluent.common : Install Java
* confluent.common : Install OpenSSL and Unzip

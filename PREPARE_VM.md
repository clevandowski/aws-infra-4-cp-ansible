# Connexion bastion

```
ssh ubuntu@<bastion ip public>
```

# Inventory: hosts.yml

* Mettre les IP (private) dans les paramètres hosts:

Editer 'hosts.yml': ```vi hosts.yml```

```
vars:
  ...
  hosts:
    node_a_X:
      # Put private ip here
      ansible_host: 10.0.1.233
    node_b_X:
      # Put private ip here
      ansible_host: 10.0.2.227
    node_c_X:
      # Put private ip here
      ansible_host: 10.0.3.116
```

* Vérifier l'inventaire

```
ansible all -m ping
```

# Cloner le repo git Confluent pour Ansible

```
git clone https://github.com/confluentinc/cp-ansible
```

# Configurer les paramètres de base

* Zookeeper

  Reprendre les paramètres 'zookeeper_id' dans 'hosts.yml'

  ```
  zookeeper:
    hosts:
      node_a_X:
        zookeeper_id: 1
      node_b_X:
        zookeeper_id: 2
      node_c_X:
        zookeeper_id: 3
  ```

* Kafka

  Reprendre les paramètres 'broker_id' dans 'hosts.yml'

  ```
  kafka_broker:
    hosts:
      node_a_X:
        broker_id: 1
      node_b_X:
        broker_id: 2
      node_c_X:
        broker_id: 3
  ```

* schema_registry:

  ```
  hosts:
    node_a_X:
    node_b_X:
  ```

# Executer le playbook

```
ansible-playbook cp-ansible/all.yml
```

# Vérifier que ça fonctionne

Sourcer les variables d'environnement
```
. ~/.env.sh
```

## List topic

```
kafka-topics --bootstrap-server ${BOOTSTRAP_SERVER} --list
```

## Describe topic

```
kafka-topics --bootstrap-server ${BOOTSTRAP_SERVER} --describe --topic __consumer_offsets
```

# Eteindre tous les services

```
ansible schema_registry --become -m shell -a "systemctl stop confluent-schema-registry.service"
ansible kafka_broker --become -m shell -a "systemctl stop confluent-kafka.service"
ansible zookeeper --become -m shell -a "systemctl stop confluent-zookeeper.service"
```
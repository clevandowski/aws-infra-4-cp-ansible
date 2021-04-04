FROM ubuntu:18.04

# ENV TERRAFORM_VERSION 0.13.2
# A utiliser pour le moment si on veut modifier la VM read (plans/machine_learning)
# Le temps que je monte son backend pour la 0.13.2
ENV TERRAFORM_VERSION 0.14.7
# ENV TERRAFORM_VERSION 0.12.30

# Cf https://docs.confluent.io/platform/current/installation/versions-interoperability.html#confluent-cli
# Actuellement la version de confluent est 6.1.* ==> 1.22.0 and later

RUN apt-get update \
    && apt-get install -y software-properties-common curl wget unzip python3 python3-pip openssh-client bash-completion jq iproute2 net-tools netcat-openbsd groff xxd iputils-ping dnsutils vim git openjdk-11-jre \
    && apt-get clean all \
    && apt-get autoclean all \
# TERRAFORM
# https://learn.hashicorp.com/terraform/getting-started/install.html
# Décommenter la ligne suivante si on veut utiliser la dernière version
    # && TERRAFORM_VERSION=$(curl -s https://releases.hashicorp.com/terraform/ | grep -o "terraform_[0-9]\+\.[0-9]\+\.[0-9]\+" | head -n 1 | sed -e "s|.*_\([0-9]\+\.[0-9]\+\.[0-9]\+$\)|\1|") \
    && curl -LOs https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && chmod +x terraform \
    && mv terraform /usr/local/bin \
    && terraform -install-autocomplete \
# Kafka Tools
    && wget -qO - https://packages.confluent.io/deb/6.1/archive.key | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/6.1 stable main" \
    && apt-get update \ 
    && apt-get install -y confluent-community-2.13


ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ARG GROUP_NAME

# Add group if not present
# Add user if not present
RUN if getent group ${GROUP_ID} >/dev/null; then \
      echo "Group ${GROUP_ID} already exists"; \
    else \
      echo "Creating group ${GROUP_ID}"; \
      groupadd -g ${GROUP_ID} ${GROUP_NAME}; \
    fi \
    && if getent passwd ${USER_ID} >/dev/null; then \
      echo "User ${USER_ID} already exists"; \
    else \
      echo "Creating user ${USER_ID}"; \
      useradd -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME} --create-home; \
    fi

WORKDIR /home/${USER_NAME}
USER ${USER_ID}

RUN python3 -m pip install -U pip \
    && pip3 install awscli==1.19.* --upgrade --user \
    && pip3 install ansible==2.9.* --upgrade --user \
    && PATH=${PATH}:/home/${USER_NAME}/.local/bin \
    && ls -l /home/${USER_NAME}/.local/bin \
    && ansible-galaxy collection install community.crypto

RUN mkdir -p /home/${USER_NAME}/.terraform.d/plugin-cache

ENV PATH ${PATH}:/home/${USER_NAME}/.local/bin:/home/${USER_NAME}/main/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV TF_PLUGIN_CACHE_DIR /home/${USER_NAME}/.terraform.d/plugin-cache

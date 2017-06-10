# MatterMost Compose

A compose of following Docker containers:

* Mattermost

This Repository is subset of [devops-compose](https://github.com/int128/devops-compose).

If you want to know more detail, please see [devops-compose](https://github.com/int128/devops-compose).

## Provisioning

Run containers on Docker Compose.
This may take a few minutes.

```sh
# Wildcard DNS
echo 'REVERSE_PROXY_DOMAIN_NAME=192.168.1.2.xip.io' > .env

# Custom domain
echo 'REVERSE_PROXY_DOMAIN_NAME=example.com' > .env

docker-compose build
docker-compose up -d
```


### CoreOS

Enough swap space and Docker Compose are required.

```sh
#!/bin/bash -xe
cat > /etc/systemd/system/swap.service <<EOF
[Service]
Type=oneshot
ExecStartPre=-/usr/bin/rm -f /swapfile
ExecStartPre=/usr/bin/touch /swapfile
ExecStartPre=/usr/bin/fallocate -l 4G /swapfile
ExecStartPre=/usr/bin/chmod 600 /swapfile
ExecStartPre=/usr/sbin/mkswap /swapfile
ExecStartPre=/usr/sbin/sysctl vm.swappiness=10
ExecStart=/sbin/swapon /swapfile
ExecStop=/sbin/swapoff /swapfile
ExecStopPost=-/usr/bin/rm -f /swapfile
RemainAfterExit=true
[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now /etc/systemd/system/swap.service
mkdir -p /opt/bin
curl -L -o /opt/bin/docker-compose https://github.com/docker/compose/releases/download/1.12.0/docker-compose-Linux-x86_64
chmod +x /opt/bin/docker-compose
```


### Custom domain

Create a wildcard record on the DNS service.

```
A *.example.com. 192.168.1.2.
```


## Setup

Open http://devops.example.com (concatenate `devops` and domain name).


### Setup Mattermost

Mattermost (Community Edition) does not support LDAP authentication.
Configure a mail service such as AWS SES and use the email sign up.

### Register init script

We provide the init script for LSB.
Register as follows:

```sh
sudo ln -s /opt/devops-compose/init-lsb.sh /etc/init.d/devops-compose
sudo chkconfig --add devops-compose
```

## Backup and Restore

It may be best to backup and restore volumes under `/var/lib/docker/volumes`.

## Contribution

This is an open source software licensed under Apache-2.0.
Feel free to open issues or pull requests.

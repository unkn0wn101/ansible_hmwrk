# ansible_hmwrk
Consider next setup:

Server0: where ansible is configured (Linux server)

Server1: server dedicated for monitoring, server0 is able to connect via SSH (user/pass or cert) to it on port 22. (Linux server)

Server2: target server that runs openresty (nginx with LuaJit), server0 is able to connect SSH (user/pass or cert) to it on port 22. (Linux server)

=>

Create an ansible playbook or role that implements next requirements:

1.       Install on server1 (monitoring) Prometheus and Grafana and do the necessary configurations for them.

2.       Install on server2 (target) a metrics exporter. Target server is a Linux server and your intention is to monitor it (CPU/RAM/Disk Usage). You can use a preconfigured dashboard

3.       Adjust with ansible the necessary firewall rules for communication between monitoring and targeting

4.       Create a user dedicated to run applications, name it OPSUSR, on Server2

5.       Install openresty and postgresql using ansible on server2 and run it under OPSUSR

6.       Configure a default user (Test) with a random secure password on postgresql

7.       Open firewall for all incoming HTTP, SQL traffic on Server2

*If no ansible module is available for a specific task, feel free to use Shell Scripts called from ansible.

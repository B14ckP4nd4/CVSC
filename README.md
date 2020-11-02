# CVSC server configurator

!!! this is full prv8 repo and need secret file for run !!!

```
[root@VPS ~]# docker system purne --force --all
[root@VPS ~]# rm -rf /etc/cwn /etc/cvsc /usr/local/bin/* /etc/systemd/system/cvsc.service
[root@VPS ~]# wget https://raw.githubusercontent.com/B14ckP4nd4/CVSC/main/first.sh -O first.sh && chmod +x first.sh && . first.sh /root/secret
```
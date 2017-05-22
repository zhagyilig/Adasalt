zabbix:
  group.present:
    - name: zabbix

  user.present:
    - fullname: zabbix
    - home: /home/zabbix
    - shell: /sbin/nologin
    - groups:
      - zabbix
    - require:
      - group: zabbix

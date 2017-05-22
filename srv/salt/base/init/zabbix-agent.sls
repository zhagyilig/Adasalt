zabbix-agent-install:
  file.managed:
    - name: /usr/local/src/zabbix-3.0.4.tar.gz 
    - source: salt://init/files/zabbix-3.0.4.tar.gz
    - user: root 
    - group: root
    - mode: 755

  cmd.run: 
    - name: cd /usr/local/src && tar xf zabbix-3.0.4.tar.gz && cd zabbix-3.0.4 && ./configure --enable-agent  --with-net-snmp --with-libcurl && make && make install
    - unless: test -f /usr/local/etc/zabbix_agentd.conf
    - require:
      - file: zabbix-agent-install

service-config:
  file.managed:
    - name: /usr/local/etc/zabbix_agentd.conf
    - source: salt://init/files/zabbix_agentd.conf
    - template: jinja
    - defaults:
    - SERVER: {{ pillar['zabbix-agent']['Zabbix-Server'] }}
    - require:
      - cmd: zabbix-agent-install

service-init:
  file.managed:
    - name: /etc/init.d/zabbix_agentd
    - source: salt://init/files/zabbix_agentd
    - user: root
    - group: root
    - mode: 755
  
  cmd.run:
    - name: chkconfig --add zabbix_agentd
    - unless: chkonfig --list|grep "zabbix_agentd"
    - require:
      - file: service-config
      - file: service-init
    
service-running:
  service.running:
    - name: zabbix_agentd
    - enable: True
    - watch:
      - file: service-config


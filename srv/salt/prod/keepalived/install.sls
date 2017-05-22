include:
  - pkg.pkg-init

keepalived-install:
  file.managed:
    - name: /usr/local/src/keepalived-1.1.19.tar.gz
    - source: salt://keepalived/files/keepalived-1.1.19.tar.gz
    - user: root
    - group: root
    - mode: 755

  cmd.run:
    - name: mkdir -p /var/log/keepalived && mkdir /etc/keepalived && cd /usr/local/src && tar xf keepalived-1.1.19.tar.gz && cd keepalived-1.1.19 && ./configure --prefix=/usr/local/keepalived --disable-fwmark && make && make install
    - unless: test -d /var/log/keepalived
    - require:
      - pkg: pkg-init
      - file: keepalived-install

keepalived-sysconfig:
  file.managed:
    - name: /etc/sysconfig/keepalived
    - source: salt://keepalived/files/keepalived.sysconfig
    - user: root
    - group: root
    - mode: 755
  
keepalived-rsyslogs:
  file.append:
    - name: /etc/rsyslog.conf
    - text:
      - local0.*   /var/log/keepalived/keepalived.log
 
  cmd.run:
    - name: /etc/init.d/rsyslog restart

keepalived-init:
  file.managed:
    - name: /etc/init.d/keepalived
    - source: salt://keepalived/files/keepalived.init
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add keepalived
    - unless: chkconfig --list|grep keepalived
    - require:
      - file: keepalived-init


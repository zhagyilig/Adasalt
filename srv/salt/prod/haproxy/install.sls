include:
  - pkg.pkg-init
  - pkg.useradd-haproxy

haproxy-install:
  file.managed:
    - name: /usr/local/src/haproxy-1.4.24.tar.gz
    - source: salt://haproxy/files/haproxy-1.4.24.tar.gz
    - user: root
    - group: root
    - mode: 644

  cmd.run:
    - name: cd /usr/local/src && tar xf haproxy-1.4.24.tar.gz && cd haproxy-1.4.24 && make TARGET=linux26 PREFIX=/usr/local/haproxy && make install PREFIX=/usr/local/haproxy
    - unless: test -d /usr/local/haproxy
    - require:
      - pkg: pkg-init
      - file: haproxy-install

/etc/init.d/haproxy:
  file.managed:
    - source: salt://haproxy/files/haproxy.init
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: haproxy-install

net.ipv4.ip_nonlocal_bind:
  sysctl.present:
    - value: 1

haproxy-config-dir:
  file.directory:
    - name: /etc/haproxy
    - user: root
    - group: root
    - mode: 755

haproxy-init:
  cmd.run:
    - name: chkconfig --add haproxy
    - require:
      - file: /etc/init.d/haproxy


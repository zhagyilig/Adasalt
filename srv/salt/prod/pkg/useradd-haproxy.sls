useradd-haproxy:
  group.present:
    - name: haproxy

  user.present:
    - fullname: haproxy
    - shell: /sbin/nologin
    - home: /home/hapoxy
    - groups:
      - haproxy
    - require:
      - group: useradd-haproxy


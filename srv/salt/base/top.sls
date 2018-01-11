#base:
#  '*':   
#    - init.env_init
#  'roles:mysql-server':
#    - match: grains
#    - apache
#prod:
#  '*':
#    - cluster.haproxy-outside
#    - cluster.haproxy-outside-keepalived
#    - redis.install
#
##################################

base:
  '*':
    - init.env_init

#prod:
#  'linux-node1.mysql.com':
#    - cluster.haproxy-outside
#    - cluster.haproxy-outside-keepalived
#  'jenkins.saltstack.me':
#    - cluster.haproxy-outside
#    - cluster.haproxy-outside-keepalived


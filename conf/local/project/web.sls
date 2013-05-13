include:
  - nginx
  - ufw

http_firewall:
  ufw.allow:
    - names:
      - '80'
      - '443'
    - enabled: true

nginx_conf:
  file.managed:
    - name: /etc/nginx/sites-enabled/{{ pillar['project_name'] }}.conf
    - source: salt://project/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        public_root: "/var/www/{{ pillar['project_name']}}/public"
        log_dir: "/var/www/{{ pillar['project_name']}}/log"
    - require:
      - pkg: nginx
      - file: log_dir

extend:
  nginx:
    service:
      - running
      - watch:
        - file: nginx_conf
{% from "diamond/map.jinja" import diamond with context %}

diamond_group:
  group.present:
    - name: diamond

diamond_user:
  user.present:
    - name: diamond
    - shell: /bin/bash
    - groups:
      - diamond
    - require:
      - group: diamond_group

diamond_directories:
  file.directory:
    - user: diamond
    - group: diamond
    - mode: 755
    - names:
      - /var/log/diamond
      - /var/run/diamond
      - /etc/diamond
    - require:
      - user: diamond_user

diamond_deps:
  pkg.installed:
    - pkgs:
      - python-psutil
      - python-configobj

install_diamond:
  pip.installed:
    - name: diamond

/etc/diamond/diamond.conf:
  file.managed:
    - source: salt://diamond/files/diamond_config.jinja
    - user: root
    - group: root
    - template: jinja
    - context:
      settings: {{ diamond.config }}
    - require:
      - file: diamond_directories

include:
  - diamond.collectors
  - diamond.handlers

/etc/init/diamond.conf:
  file.managed:
    - source: salt://diamond/files/diamond.upstart
    - user: root
    - group: root
    - mode: 644

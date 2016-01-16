{% from "diamond/map.jinja" import diamond with context %}

{% set collectors_config_path = diamond.config.server.collectors_config_path %}
{% set collectors_path = diamond.config.server.collectors_path %}

{{ collectors_config_path }}:
  file.directory:
    - makedirs: True
    - user: diamond
    - group: diamond
    - recurse:
      - user
      - group
    - require:
      - file: diamond_directories

{{ collectors_path }}:
  file.directory:
    - makedirs: True
    - user: diamond
    - group: diamond
    - recurse:
      - user
      - group
    - require:
      - file: diamond_directories

{% for collector, collector_data in diamond.collectors.items() %}
{{ collectors_config_path }}{{ collector }}.conf:
  file.managed:
    - source: salt://diamond/files/collector.jinja
    - user: diamond
    - group: diamond
    - mode: 644
    - template: jinja
    - context:
      settings: {{ collector_data }}
    - require:
      - file: diamond_directories
{% endfor %}
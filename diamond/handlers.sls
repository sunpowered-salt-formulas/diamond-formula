{% from "diamond/map.jinja" import diamond with context %}

{% set handlers_config_path = diamond.config.server.handlers_config_path %}
{% set handlers_path = diamond.config.server.handlers_path %}

{{ handlers_config_path }}:
  file.directory:
    - makedirs: True
    - user: diamond
    - group: diamond
    - recurse:
      - user
      - group
    - require:
      - file: diamond_directories

{{ handlers_path }}:
  file.directory:
    - makedirs: True
    - user: diamond
    - group: diamond
    - recurse:
      - user
      - group
    - require:
      - file: diamond_directories

{% for handler, handler_data in diamond.handlers.items() %}
{{ handlers_config_path }}{{ handler }}.conf:
  file.managed:
    - source: salt://diamond/files/collector.jinja
    - user: diamond
    - group: diamond
    - mode: 644
    - template: jinja
    - context:
      settings: {{ handler_data }}
    - require:
      - file: diamond_directories
{% endfor %}
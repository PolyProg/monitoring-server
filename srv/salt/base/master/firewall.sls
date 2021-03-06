Firewall:
  pkg.installed:
    - name: firewalld
    
  file.recurse:
    - name: /etc/firewalld/services
    - source: salt://master/files/etc/firewalld/services
    - clean: True

    - user: root
    - group: root
    - dir_mode: 500
    - file_mode: 400

    - watch_in:
      - service: Firewall
   
    - require:
      - pkg: Firewall
    
  firewalld.present:
    - name: external
    - default: True
    - services: 

      {% for service in pillar.get("services", []) %}
      - {{ service }}
      {% endfor %}

    - require:
      - pkg: Firewall
      
    - watch_in:
      - service: Firewall


  service.running:
    - name: firewalld
    - enable: True

    - require:
      - pkg: Firewall
      - file: Firewall

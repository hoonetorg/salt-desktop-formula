# vim: sts=2 ts=2 sw=2 et ai
{% from "desktop/map.jinja" import desktop with context %}

{% for packagegroup in desktop.packagegroups|default([]) %}
#desktop__pkggroup_desktop_{{packagegroup}}:
#  cmd.run:
#    - name: yum -y group install {{packagegroup}}
desktop__pkggroup_desktop_{{packagegroup}}:
  pkg.group_installed:
    - name: {{packagegroup}}
    {% if desktop['packagegroupdetails'][packagegroup] is defined and desktop['packagegroupdetails'][packagegroup] %}
      {% if desktop['packagegroupdetails'][packagegroup]['skip'] is defined and desktop['packagegroupdetails'][packagegroup]['skip'] %}
    - skip: {{desktop['packagegroupdetails'][packagegroup]['skip']|yaml}}
      {% endif %}
      {% if desktop['packagegroupdetails'][packagegroup]['include'] is defined and desktop['packagegroupdetails'][packagegroup]['include'] %}
    - include: {{desktop['packagegroupdetails'][packagegroup]['include']|yaml}}
      {% endif %}
    {% endif %}
{% endfor %}

desktop__pkg_desktop:
  pkg.installed:
    - name: desktop
    - pkgs: {{desktop.packages}}



desktop__pkggroup_graphical_target:
  cmd.run:
    - name: systemctl set-default graphical.target && systemctl isolate graphical.target
    - unless: test  "graphical.target" == "`systemctl get-default`" 

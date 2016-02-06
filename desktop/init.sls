# vim: sts=2 ts=2 sw=2 et ai
{% from "desktop/map.jinja" import desktop with context %}


{% for packagegroup,packagegroup_data in desktop.packagegroups.items()|default({}) %}
#desktop__pkggroup_desktop_{{packagegroup}}:
#  cmd.run:
#    - name: yum -y group install {{packagegroup}}
desktop__pkggroup_desktop_{{packagegroup}}:
  pkg.group_installed:
    - name: {{packagegroup}}
    {% if packagegroup_data.skip is defined and packagegroup_data.skip %}
    - skip: {{packagegroup_data.skip|yaml_encode}}
    {% endif %}
    {% if packagegroup_data.include is defined and packagegroup_data.include %}
    - include: {{packagegroup_data.skip|yaml_encode}}
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

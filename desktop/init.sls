# vim: sts=2 ts=2 sw=2 et ai
{% from "desktop/map.jinja" import desktop with context %}


{% for packagegroup in desktop.packagegroups %}
#desktop__pkggroup_desktop_{{packagegroup}}:
#  module.run:
#    - name: pkg.group_install
#    - m_name: {{packagegroup}}
#    - ignore_retcode: True
desktop__pkggroup_desktop_{{packagegroup}}:
  cmd.run:
    - name: yum -y group install {{packagegroup}}
{% endfor %}

desktop__pkg_desktop:
  pkg.installed:
    - name: desktop
    - pkgs: {{desktop.packages}}



desktop__pkggroup_graphical_target:
  cmd.run:
    - name: systemctl set-default graphical.target && systemctl isolate graphical.target
    - unless: test  "graphical.target" == "`systemctl get-default`" 

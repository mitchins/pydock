{{HEADER}}
global
    daemon
    maxconn 4096

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    {% for container in containers %}
    acl is_{{container.Id}} hdr_end(host) -i {{virtualhost(container)}}
    {% endfor %}

    {% for container in containers %}
    use_backend site_{{virtualhost(container)}} if is_{{container.Id}}
    {% endfor %}

{% for container in containers %}
backend site_{{virtualhost(container)}}
    balance roundrobin
    option httpclose
    option forwardfor
    server s{{container.Id}} 127.0.0.1:{{container.NetworkSettings.Ports['80/tcp'][0].HostPort}} maxconn 32
{% endfor %}

listen admin
    bind 127.0.0.1:8080
    stats enable


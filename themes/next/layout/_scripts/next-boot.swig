{%
  set boot_scripts = [
    'next_boot'
  ]
%}

{% for bs in boot_scripts %}
  <script src="{{ url_for(theme.vendors[bs])}}"></script>
{% endfor %}

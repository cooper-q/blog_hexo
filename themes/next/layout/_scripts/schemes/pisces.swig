{%
  set scripts = [
    'affix',
    'pisces'
  ]
%}

{% for script in scripts %}
  <script src="{{ url_for(theme.vendors[script]) }}"></script>
{% endfor %}

{%
  set js_commons = [
    'utils',
    'motion'
  ]
%}

{% for common in js_commons %}
  <script src="{{ url_for(theme.vendors[common]) }}"></script>
{% endfor %}

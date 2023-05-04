{% if theme.google_analytics.tracking_id %}
  <script async src="//www.googletagmanager.com/gtag/js?id={{ theme.google_analytics.tracking_id }}"></script>
  <script>
    var host = window.location.hostname;
    // 忽略本地统计
    if ({{theme.google_analytics.localhost_ignored}}&&(host ==="127.0.0.1" || host ==="localhost")) {
        console.log("本地调试，关闭google_analytics功能")
    }else{
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', '{{ theme.google_analytics.tracking_id }}');
    }
  </script>
{% endif %}

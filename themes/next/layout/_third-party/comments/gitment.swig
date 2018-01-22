{% if theme.gitment.enable and theme.gitment.client_id and theme.gitment.client_secret %}
  {% if is_home() %}
  {% else %}
    <link rel="stylesheet" href="/lib/gitment/style/default.css">
    <script src="/lib/gitment/gitmint.browser.js"></script>
    <script>
      var gitment = new Gitmint({
        id: location.origin + location.pathname,
        owner: '{{theme.gitment.owner}}',
        repo: '{{theme.gitment.repo}}',
      {% if theme.gitment.admin %}
        admin: [
        {% for username in theme.gitment.admin %}
          '{{username}}',
        {% endfor %}
        ],
      {% endif %}
        oauth: {
        {% if theme.gitment.http %}
          redirect_protocol: 'http',
        {% endif %}
          client_id: '{{theme.gitment.client_id}}',
          client_secret: '{{theme.gitment.client_secret}}',
        }
      })
      gitment.render('gitment')
    </script>
  {% endif %}
{% endif %}

{% if theme.gitment.enable and theme.gitment.client_id and theme.gitment.client_secret %}
  {% if is_home() %}
  {% else %}
    <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
    <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
    <script>
      var gitment = new Gitment({
        id: location.href ,
        owner: '{{theme.gitment.owner}}',
        repo: '{{theme.gitment.repo}}',
        oauth: {
          client_id: '{{theme.gitment.client_id}}',
          client_secret: '{{theme.gitment.client_secret}}',
        }
      })
      gitment.render('gitment')
    </script>
  {% endif %}
{% endif %}

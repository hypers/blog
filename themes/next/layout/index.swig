{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ config.title }}{% if theme.index_with_subtitle and config.subtitle %} - {{config.subtitle }}{% endif %}{% endblock %}


{% block page_class %}
  {% if is_home() %} page-home {% endif %}
{% endblock %}

{% block content %}
  <div class="hypers-loop-warpper">
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 124.51 53.99" id="hypers_loop_svg">
      <defs>
        <style>
          .hypers-loop-warpper{
            position: absolute;
            top: 50px;
            left: 50%;
            margin-left: -76px;
          }
          .cls-1 {
            fill: none;
            stroke-linecap: round;
            stroke-miterlimit: 10;
            stroke-width: 4px;
            stroke: url(#New_Gradient_Swatch_7);
          }
          #hypers_loop_svg{
            width: 152px;
          }

          #loop_svg path {
            animation: dash 20s infinite linear;
            stroke-dasharray: 32,10;
          }

          @keyframes dash {
            to {
              stroke-dashoffset: 800;
            }
          }

        </style>
        <linearGradient id="New_Gradient_Swatch_7" y1="26.99" x2="124.51" y2="26.99" gradientUnits="userSpaceOnUse">
          <stop offset="0" stop-color="#51e8ff" />
          <stop offset="1" stop-color="#1361aa" />
        </linearGradient>
      </defs>
      <title>loop</title>
      <g id="loop" data-name="图层 2">
        <g id="loop_svg" data-name="Layer 2">
          <path class="cls-1" d="M62.2,27L44.7,44.7c-9.8,9.8-25.6,9.8-35.4,0s-9.8-25.6,0-35.4s25.6-9.8,35.4,0l0,0l35.2,35.4
        c9.8,9.8,25.6,9.8,35.4,0s9.8-25.6,0-35.4s-25.6-9.8-35.4,0L62.2,27z"/>
        </g>
      </g>
    </svg>
  </div>

  <div class="starry-warpper">
    <div class='stars'></div>
    <div class='stars2'></div>
    <div class='stars3'></div>
  </div>
  <section id="posts" class="posts-expand">
    {% for post in page.posts %}
      {{ post_template.render(post, true) }}
    {% endfor %}
  </section>

  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}

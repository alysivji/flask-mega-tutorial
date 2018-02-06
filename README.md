# [Flask Mega-Tutorial](https://blog.miguelgrinberg.com/) Notes

```console
$ export FLASK_APP=microblog.py
$ export FLASK_DEBUG=1
$ flask run
 * Serving Flask app "microblog"
 * Forcing debug mode on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 148-568-946
```

## [Chapter 1: Hello World](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world)

> The `__name__` variable passed to the Flask class is a Python predefined variable, which is set to the name of the module in which it is used. Flask uses the location of the module passed here as a starting point when it needs to load associated resources such as template files

Import at bottom of `__init__.py` is to prevent circular imports

### `routes` module

> The routes are the different URLs that the application implements. In Flask, handlers for the application routes are written as Python functions, called view functions. View functions are mapped to one or more route URLs so that Flask knows what logic to execute when a client requests a given URL.

## [Chapter 2: Templates](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-ii-templates)

> Templates help achieve this separation between presentation and business logic.

### [Jinja2](http://jinja.pocoo.org/) Placeholders

> placeholders for the dynamic content, enclosed in {{ ... }} sections. These placeholders represent the parts of the page that are variable and will only be known at runtime.

#### Conditional Statements

```python
{% if title %}
<title>{{ title }} - Microblog</title>
{% else %}
<title>Welcome to Microblog!</title>
{% endif %}
```

#### Loops

```python
{% for post in posts %}
<div><p>{{ post.author.username }} says: <b>{{ post.body }}</b></p></div>
{% endfor %}
```

#### Template Inheritance

> In essence, what you can do is move the parts of the page layout that are common to all templates to a base template, from which all other templates are derived.

Define a `base.html` template that includes all your navigation and header information

Use named `block` control statement to define place where templates can be inserted

Insert as follows:

```python
{% extends "base.html" %}

{% block content %}
    Template specific content
{% endblock %}
```

#### Links

We can link to pages, but we should really link to functions.

TODO

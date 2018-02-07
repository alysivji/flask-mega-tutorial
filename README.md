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

We can link to pages, but we should really link to functions using `url_for()` which generates URLs using the internal mapping of URLs to view functions

## [Chapter 3: Web Forms](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-iii-web-forms)

> Extensions are a very important part of the Flask ecosystem, as they provide solutions to problems that Flask is intentionally not opinionated about

> Flask (and possibly also the Flask extensions that you use) offer some amount of freedom in how to do things, and you need to make some decisions, which you pass to the framework as a list of configuration variables.

For forms, we will be using [Flask-WTF](http://packages.python.org/Flask-WTF)

### Flask Configuration

**Best Practice**: Keep configuration in a separate class

```python
import os

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
```

> The configuration settings are defined as class variables inside the Config class. As the application needs more configuration items, they can be added to this class, and later if I find that I need to have more than one configuration set, I can create subclasses of it. But don't worry about this just yet.

Apply it

```python
from flask import Flask
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

from app import routes
```

### Flask-WTF

> The Flask-WTF extension uses Python classes to represent web forms. A form class simply defines the fields of the form as class variables.

> The optional validators argument that you see in some of the fields is used to attach validation behaviors to fields. The DataRequired validator simply checks that the field is not submitted empty. There are many more validators available, some of which will be used in other forms.

* Will need to create a form that inherits `FlaskForm` and uses field objects as building blocks for the form
    * can attach validators which generate descriptive error messages (stored under `form.<field_name>.errors`)

* Create a `POST` handler in our view function

## [Chapter 4: Databases](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-iv-database)

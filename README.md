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

Account Info: sivpack / 123456

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

#### Sub Templates

If we are reusing parts of the layout over and over again in the same page, it might be worth loooking into sub-templates which can be inserted into each template using `{% include '_page.html' %}

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

Uses [SQLAlchemy](http://www.sqlalchemy.org/), well [Flask-SQLAlchemy](http://flask-sqlalchemy.pocoo.org/2.3/), for ORM. Can plug in any number of relational databases

> I have also added two methods to this class called `validate_username()` and `validate_email()`. When you add any methods that match the pattern `validate_<field_name>`, WTForms takes those as custom validators and invokes them in addition to the stock validators.

> a validation error is triggered by raising `ValidationError`. The message included as the argument in the exception will be the message that will be displayed next to the field for the user to see.

### Database Models

> The data that will be stored in the database will be represented by a collection of classes, usually called database models. The ORM layer within SQLAlchemy will do the translations required to map objects created from these classes into rows in the proper database tables.

> The id field is usually in all models, and is used as the primary key. Each user in the database will be assigned a unique id value, stored in this field.

### Migrations

[Flask-Migrate](https://github.com/miguelgrinberg/flask-migrate) for migrations, based on [Alembic](https://pypi.python.org/pypi/alembic) which is the migration tool for SQLAlchemy. Migrations are used when we need to change how data is stored.

* Adds `flask db` subcommand to flask CLI
* `flask db init` creates new migration repository
* `flask db migrate -m "message"` generates migration script
* `flask db upgrade` runs migrations
* `flask db downgrade` rolls back migrations

> Without migrations you would need to figure out how to change the schema of your database, both in your development machine and then again in your server, and this could be a lot of work.

* `db.relationship` - not an actual database field, but a high-level view of the relationship between users and posts, and for that reason it isn't in the database diagram

> Changes to a database are done in the context of a session, which can be accessed as `db.session`. Multiple changes can be accumulated in a session and once all the changes have been registered you can issue a single `db.session.commit()`, which writes all the changes atomically. If at any time while working on a session there is an error, a call to `db.session.rollback()` will abort the session and remove any changes stored in it. The important thing to remember is that changes are only written to the database when `db.session.commit()` is called. Sessions guarantee that the database will never be left in an inconsistent state.

* `.first_or_404()` returns a result or sends a 404 back to the client

### Flask Shell

We can use the `flask shell` command to get into the Python shell and have the application context be reloaded.

In our `FLASK_APP` script, we can add shell context processors that can load information as required:

```python
@app.shell_context_processor
def make_shell_context():
    return {
        'db': db,
        'User': User,
        'Post': Post,
    }
```

## [Chapter 5: User Logins](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-v-user-logins)

### Password Hashing

We take a password and put it thru a non-reversible cryptographical algorithm so that it's true value is obfuscated.

### Flask-Login

> This extension manages the user logged-in state, so that for example users can log in to the application and then navigate to different pages while the application "remembers" that the user is logged in. It also provides the "remember me" functionality that allows users to remain logged in even after closing the browser window.

Need to add the following to the `User` model:
    * `is_authenticated` a property that is True if the user has valid credentials or False otherwise.
    * `is_active` a property that is True if the user's account is active or False otherwise.
    * `is_anonymous` a property that is False for regular users, and True for a special, anonymous user.
    * `get_id()` a method that returns a unique identifier for the user as a string.

We can add these to our model via `flask_login.UserMixin`

> Flask-Login keeps track of the logged in user by storing its unique identifier in Flask's user session, a storage space assigned to each user who connects to the application. Each time the logged-in user navigates to a new page, Flask-Login retrieves the ID of the user from the session, and then loads that user into memory.

Need to create a method and register it with `@flask_login.login.user_loader` so we know which user we are dealing with

We can also rediret users based on next query parameters, but be careful that we only redirect relative URLs not full URLs

* `current_user` gets the user that is currently logged in from the db

## [Chapter 6: Profile Page and Avatars](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-vi-profile-page-and-avatars)

### Deferred Request Callbacks

[docs](http://flask.pocoo.org/docs/0.12/patterns/deferredcallbacks/)

`@app.before_request`
`@app.after_request`

## [Chapter 7: Error Handling](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-vii-error-handling)

### Debug Mode

Flask can show errors in the browser:
    * `export FLASK_DEBUG=1`

### Logging

When the application is in production, we need a way to keep track of errors so we can the problems that occur in order to fix them later.

Use standard library logger, it just makes more sense.

## [Chapter 8: Followers](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-viii-followers)

# [Flask Mega-Tutorial](https://blog.miguelgrinberg.com/) Notes

## Chapter 1: Hello World

> The `__name__` variable passed to the Flask class is a Python predefined variable, which is set to the name of the module in which it is used. Flask uses the location of the module passed here as a starting point when it needs to load associated resources such as template files

Import at bottom of `__init__.py` is to prevent circular imports

### `routes` module

> The routes are the different URLs that the application implements. In Flask, handlers for the application routes are written as Python functions, called view functions. View functions are mapped to one or more route URLs so that Flask knows what logic to execute when a client requests a given URL.

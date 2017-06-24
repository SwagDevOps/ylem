<!-- ( vim: set fenc=utf-8 spell spl=en: ) -->

# Ylem ``/ˈiːlɛm/`` the primordial matter of the universe

## Principles

During the [Linux startup process](https://en.wikipedia.org/wiki/Linux_startup_process),
``ylem`` is intended to sequentially execute arbitrary "user scripts"
(alphabetically sorted). Moreover ``ylem`` provides logging facility
which facilitates startup __debugging__.

Startup scripts executed through ``ylem`` SHOULD be aimed to:

* create required files and directories
* setup users and permissions
* prepare the system to run deamons

For example, ``ylem`` COULD start
[``supervisor``](https://github.com/Supervisor/supervisor),
to manage daemons, as soon as the system is sufficiently ready.

Create an ``/etc/ylem/scripts`` directory and put your bootstraping scripts.
Then scripts are executed alphabetically sorted.

## Sample of use

In a ``Dockerfile``:

```
ENTRYPOINT ["dumb-init", "-c", "--", "ylem", "start"]
```

## Configuration

The configuration uses a [YAML syntax](https://en.wikipedia.org/wiki/YAML)
and remains in ``/etc/#{progname}/config.yml``,
where ``progname`` is ``ylem``.
Furthermore configuration filepath can be set on the
<abbr title="Command Line Interface">CLI</abbr>.
The main configuration keys are:

* ``logger.file``<br />
    default value is: ``/var/log/#{progname}.log``
* ``scripts.path``<br />
    where bootstraping scripts are stored<br />
    default value is: ``/etc/#{progname}/scripts``
* ``environment.file``<br />
    default value is: ``/etc/environment``
    ([System-wide environment variables](https://help.ubuntu.com/community/EnvironmentVariables#System-wide_environment_variables))

## Resources

* [Yelp/dumb-init: A minimal init system for Linux containers](https://github.com/Yelp/dumb-init)
* [Supervisor process control system for UNIX](https://github.com/Supervisor/supervisor)

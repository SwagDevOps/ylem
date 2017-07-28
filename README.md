<!-- ( vim: set fenc=utf-8 spell spl=en: ) -->

# Ylem ``/ˈiːlɛm/`` the primordial matter of the universe

## Principles

During the [Linux startup process](https://en.wikipedia.org/wiki/Linux_startup_process),
``ylem`` is intended to sequentially execute arbitrary "user scripts"
(alphabetically sorted). Moreover ``ylem`` provides [logging](#logging)
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

Available configuration keys are:

* ``scripts.path``<br />
  where bootstraping scripts are stored<br />
  default value is: ``/etc/#{progname}/scripts``
* ``logger.file``<br />
  default value is: ``/var/log/#{progname}.log``
* ``logger.level``<br />
  default value is: ``INFO`` (see: [Logger::Severity](https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger/Severity.html))
* ``environment.file``<br />
  default value is: ``/etc/environment``
  ([System-wide environment variables](https://help.ubuntu.com/community/EnvironmentVariables#System-wide_environment_variables))

Missing configuration keys use default values.
Configuration file can be: complete, partial or empty.

<div id="logging" /><!-- ala github -->

## Logging

Ylem provides its own logging mechanism, based on
[``Logger``](https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html).
During its init process, each handled script is logged to ``logger.file``.
Depending on ``logger.level`` only the messages with a level greater or equal
will be published to the log file.

| Level         | Format          | Summary                             |
| ------------- | --------------- | ----------------------------------- |
| ``DEBUG``     | ``/"BEGIN"/``   | script started                      |
| ``INFO``      | ``/".*"/``      | script message echoed to ``STDOUT`` |
| ``WARN``      | ``/".*"/``      | script message echoed to ``STDERR`` |
| ``DEBUG``     | ``/"ENDED \[0\]/"``     | script ended (success)      |
| ``ERROR``     | ``/"ERROR \[[0-9]+\]"/``| script error                |

## Resources

* [Yelp/dumb-init: A minimal init system for Linux containers](https://github.com/Yelp/dumb-init)
* [Supervisor process control system for UNIX](https://github.com/Supervisor/supervisor)
* [``/sbin/my_init`` as seen in ``phusion/baseimage-docker``](https://github.com/SwagDevOps/baseimage-docker/blob/master/image/bin/my_init)
* [``runit`` - a UNIX init scheme with service supervision](http://smarden.org/runit/)

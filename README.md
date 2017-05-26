# Ylem ``/ˈiːlɛm/`` the primordial matter of the universe

Create an ``/etc/ylem/scripts`` directory and put your bootstraping scripts.
Then scripts are executed alphabetically sorted.
The config resides in ``/etc/ylem/config.yml``
(filepath to the config can be set on the CLI).

## Config

Config keys are:

* ``log_file``
          default value is ``/var/log/#{executable}.log``
          can be set to ``/dev/stdout``
* ``scripts_dir``
          where bootstraping scripts are stored
          default path is: ``/etc/ylem/scripts``
* ``command``
         default value is ``nil``
* ``env_file``
         default value is: ``/etc/environment``

## Principles

During the [Linux startup process](https://en.wikipedia.org/wiki/Linux_startup_process),
``ylem`` is intended to sequentially execute arbitrary "user scripts"
(alphabetically ordered).
Debugging is easyfied due to logging, assumed by ``ylem``.

These scripts can be aimed to:

* create required files and directories
* setup users and permissions
* prepare the system to run deamons

For example, ``ylem`` could start
[``supervisor``](https://github.com/Supervisor/supervisor),
to manage daemons, it been prepared the system.

## Sample of use

In a ``Dockerfile``:

```
ENTRYPOINT ["dumb-init", "-c", "--", "ylem", "start"]
```

## Resources

* [Yelp/dumb-init: A minimal init system for Linux containers](https://github.com/Yelp/dumb-init)
* [Supervisor process control system for UNIX](https://github.com/Supervisor/supervisor)

[modeline]: # ( vim: set fenc=utf-8 spell spl=en: )

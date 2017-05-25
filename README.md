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

## Sample of use

In a ``Dockerfile``:

```
ENTRYPOINT ["dumb-init", "-c", "--", "/usr/local/bin/ylem"]
```

[modeline]: # ( vim: set fenc=utf-8 spell spl=en: )

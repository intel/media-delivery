Tests
=====

This folder contains some tests used to verify Media Delivery Software Stack
samples consistency. To run these tests, additionally to Media Delivery
Software Stack requirements you need to have
`bats <https://github.com/bats-core/bats-core>`_ on your host system.

Before running these tests setup the following environment variable::

  export MDS_IMAGE=intel-media-delivery

and specify the docker image name you wish to validate (this will be passed to
`docker run` command).

To run all available tests execute::

  bats *.bats

You might also run desired art of the tests grouped in separate `.bats`
files. For example::

  bats demo.bats

Will execute only `demo` script related tests.

Environment Variables
---------------------

+---------------+--------------------------+------------------------------------------------+
| Variable      | Default                  | Notes                                          |
+===============+==========================+================================================+
| ``DEVICE``    | ``/dev/dri/renderD128``  | Sets GPU device to use                         |
+---------------+--------------------------+------------------------------------------------+
| ``MDS_IMAGE`` | <must be set explicitly> | Sets docker image to run                       |
+---------------+--------------------------+------------------------------------------------+

Links
-----
* `BATS (Bash Automated Testing System) <https://github.com/bats-core/bats-core>`_

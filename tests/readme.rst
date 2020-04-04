Media Delivery Solutions Tests
==============================

This folder contains some tests used to verify Media Delivery Solutions consistency.
To run these tests, additionally to Media Delivery Solutions requirements you need
to have `bats <https://github.com/bats-core/bats-core>`_ on your host system.

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

Links
-----
* `BATS (Bash Automated Testing System) <https://github.com/bats-core/bats-core>`_

Media Delivery Solutions Patches
================================

This folder contains patches for the software included in Media Delivery
Solutions. Folder is structured in the following way::

  <component-1>/series
  <component-1>/<patch-1>
  <component-1>/<patch-2>
  <component-2>/series
  <component-2>/<patch-1>
  <component-2>/<patch-2>

So, there is a folder for each component which can be patched. Each
folder contains a `series` file which lists all the patches which needs to
be applied, for example::

  # cat <component-1>/series
  <patch-2>

Mind that if patch is not listed in the `series` file (like `<patch-1>` is
not listed in the above example), then it will not be applied even if
presents in the components directory.

Each patch is applied with `patch` command like::

  patch -p1 < patches/<component>/<patch>

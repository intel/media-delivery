Patches
=======

This folder contains patches for the software included in Media Delivery
Software Stacks. Folder is structured in the following way::

  <component-1>/<patch-1>
  <component-1>/<patch-2>
  <component-2>/<patch-1>
  <component-2>/<patch-2>

So, there is a folder for each component which can be patched. Each
patch is applied with `patch` command like::

  patch -p1 < patches/<component>/<patch>

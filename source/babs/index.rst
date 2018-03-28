====
babs
====

.. contents::
   :backlinks: none

Introduction
============

``babs``, (an acronym for "**b**\ abs: **a** **b**\ uild **s**\ ystem") is a set of Makefiles meant to easily compile & link a set of interdependent
modules, containing C/C++ source code, binaries like object files, static or dynamic libraries, etc ...

Environment variables
=====================

In order to do its work, ``babs`` needs 3 environment variables:

* ``BABS_DIR`` : the directory where the ``babs`` build system is located.
* ``SOURCE_DIR`` : the directory where the source modules are located.
* ``BUILD_DIR`` : the directory where all target and intermediate files are saved during the build process.

These variables are currently set by sourcing a script before running ``make``. Ideally, they should be set while running``make``.

Files
=====

``babs`` build system
---------------------

Folder structure
................

::

    babs/
        module_common.mk
        make_common.mk
        platform/
            platform.mk
            windows/
                rules.mk
                definitions.mk
                libstdc++-6.dll
                libgcc_s_dw2-1.dll
            linux/
                rules.mk
                definitions.mk
    source/
        config.mk
        setenv



module_common.mk
,,,,,,,,,,,,,,,,



make_common.mk
,,,,,,,,,,,,,,


Using ``babs``
==============

A minimal example
-----------------



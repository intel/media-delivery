dnl BSD 3-Clause License
dnl
dnl Copyright (c) 2020, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
pushdef(`_n', divnum)divert(-1)

define(`ERROR',`errprint(__file__:__line__: error: $1
)m4exit(1)')

ifdef(`OS_NAME',,`ERROR(definition of OS_NAME is required)')
ifdef(`OS_VERSION',,`ERROR(definition of OS_VERSION is required)')

# Declares macro only if it was not already defined.
# Mind quoting rules::
#
#   DECLARE(`MY_MACRO',`...macro w/o args...')
#   DECLARE(`MY_MACRO',``...macro w/ args: $1 $2 ...'')
define(`DECLARE',`ifdef(`$1',,`define(`$1',$2)')')

DECLARE(`BUILD_HOME',/opt/build)
DECLARE(`BUILD_DESTDIR',/opt/dist)
DECLARE(`BUILD_PREFIX',/usr/local)
DECLARE(`BUILD_BINDIR',BUILD_PREFIX/bin)
DECLARE(`BUILD_LIBDIR',BUILD_PREFIX/ifelse(OS_NAME,centos,lib64,lib))

DECLARE(`CLEANUP_DEV',yes)
DECLARE(`CLEANUP_MAN',yes)

DECLARE(`PREAMBLE',dnl
``# This file is automatically generated from .m4 template.''
``# To update, modify the template and regenerate.'')

DECLARE(`COMPONENTS_LIST',`')

# Maps given package name in ``$1`` argument to the desired package name. Default macro
# implementation just echoes given package name. You need to redefine the macro to have
# package name remap. This can be used, for example, in the case when you need to set
# specific component(s) version::
#
#   define(`PKG',`ifelse($1,libdrm,libdrm=2.4.99,$1)')
DECLARE(`PKG',``$1'')

# Same as ``PKG'' but accepts any number of packages via ``$@'' arguments.
define(`PKGS',`ifelse($#,0,,$#,1,PKG($1),`PKG($1) PKGS(shift($@))')')

# Appends items stored in ``$2+`` arguments to the list specified in ``$1`` argument.
# List is understood as a sequence of elements separated by spaces. The following is
# an example of the list containing 3 elements: ``item1 item2 item3``. This macro
# does not modify the list in ``$1'' argument.
define(`APPEND',`ifelse($#,0,,$#,1,$1,`$1 APPEND(shift($@))')')

# Expands to regexp to search for the given argument.
define(`TO_REGEXP',`patsubst($1,`\+',`\\+')')

# Removes items specified in ``$2+`` arguments from the list specified in ``$1''
# argument.
define(`REMOVE',`ifelse($#,0,,$#,1,$1,`dnl
patsubst(patsubst(patsubst(patsubst(
ifelse($#,2,$1,`REMOVE($1,shift(shift($@)))'),^TO_REGEXP($2)$),^TO_REGEXP($2)` '),` 'TO_REGEXP($2)$),` 'TO_REGEXP($2)` ',` ')')')

# Removes duplicated items from the list specified in ``$1`` argument. Macro works
# in a way that 2nd+ encounters of the same item are being removed. I.e. given the
# list ``a b a c d`` macro will exapnd to ``a b c d``.
define(`REMOVE_DUPLICATES',`dnl
pushdef(`_head',patsubst($1,` .+',))dnl
pushdef(`_tail',patsubst($1,`^[^ ]* ',))dnl
ifelse($1,_head,$1,`_head REMOVE_DUPLICATES(REMOVE(_tail,_head))')`'dnl
popdef(`_tail')dnl
popdef(`_head')')

# Removes items denoted by ``$2`` list from the list specified in ``$1``. Given
# the call ``REMOVE_MATCHING(`a b c d', `a c')`` macro will expand to ``b d``.
define(`REMOVE_MATCHING',`REMOVE($1,ARGS($2))')

# Appends items stored in ``$2+`` arguments to the list specified in ``$1`` argument
# and modified the ``$1'' list definition accordingly.
define(`APPEND_TO_DEF',`dnl
pushdef(`_tmp',$1)
define(`_tmp',defn(`$1')))
undefine(`$1')
define(`$1',APPEND(_tmp,shift($@)))
popdef(`_tmp')')

# Expands into list of packages for the components specified in the ``$@`` arguments.
# For the component ``$n`` macro expects that packages will be available in a form
# of ``$n_BUILD_DEPS`` macro. If this macro is not available, then package list for
# this component expands to void and m4 error is generated.
define(`GET_BUILD_DEPS',`dnl
pushdef(`_tmp',`ifdef(`_build_provides',`_build_provides ',)')dnl
pushdef(`_build_provides',_tmp`'$1_BUILD_PROVIDES)dnl
pushdef(`_list',`ifdef(`$1_BUILD_DEPS',`$1_BUILD_DEPS',`')')dnl
ifelse($#,0,,$#,1,`REMOVE_MATCHING(`_list',_build_provides)',
  `REMOVE_MATCHING(`_list',_build_provides) GET_BUILD_DEPS(shift($@))')`'dnl
popdef(`_list')dnl
popdef(`_build_provides')dnl
popdef(`_tmp')')

# Expands into list of packages for the components specified in the ``$@`` arguments.
# For the component ``$n`` macro expects that packages will be available in a form
# of ``$n_INSTALL_DEPS`` macro. If this macro is not available, then package list for
# this component expands to void and m4 error is generated.
#
# Additionally macro pass 2 arguments to ``$n_INSTALL_DEPS`` macro invocations. These
# arguments are obtained as a result of the following 2 macro expansions:
#
# * ``_install_mode`` should expand to desired installation mode (runtime, devel, etc.)
#
# * ``__install_from`` should expand to docker layer from which component artifacts
#   should be copied
define(`GET_INSTALL_DEPS',`dnl
pushdef(`_tmp',`ifdef(`_build_provides',`_build_provides ',)')dnl
pushdef(`_build_provides',_tmp`'$1_BUILD_PROVIDES)dnl
pushdef(`_list',`ifdef(`$1_INSTALL_DEPS',`indir(`$1_INSTALL_DEPS',`_install_mode',`_install_from')',`')')dnl
ifelse($#,0,,$#,1,`REMOVE_MATCHING(`_list',_build_provides)',
  `REMOVE_MATCHING(`_list',_build_provides) GET_INSTALL_DEPS(shift($@))')`'dnl
popdef(`_list')dnl
popdef(`_build_provides')dnl
popdef(`_tmp')')

#
# Definition to apply a given patch in the host to a required component
# within the Dockerfile
# Usage:
# PATCH(<component_source_path>,<host_patch_path>)
#
define(`PATCH',`
COPY $2 $1
RUN cd $1 && { set -e; \
  for patch_file in $(find -iname "*.patch" | sort -n); do \
    echo "Applying: ${patch_file}"; \
    patch -p1 < ${patch_file}; \
  done; }
')

# Expands into list of rules for the components specified in the ``$@`` arguments.
# For the component ``$n`` rule should be previously defined as ``BUILD_$n`` macro.
# If ``BUILD_$n`` macro was not defined, then rules expansion for this component is
# void and m4 error is generated.
define(`BUILD_COMPONENTS',`dnl
ifelse($#,0,,`ifdef(`BUILD_$1',`dnl
ifdef(`$1_BUILD_DEPS',INSTALL_PKGS(ARGS(PKGS($1_BUILD_DEPS))))
indir(`BUILD_$1')')
ifelse($#,1,,`BUILD_COMPONENTS(shift($@))')')')

# Expands into list of rules for the components specified in the ``$@`` arguments.
# For the component ``$n`` rule should be previously defined as ``ENV_VARS_$n`` macro.
define(`SET_ENV_VARS_COMPONENTS',dnl
`ifelse($#,0,,$#,1,`ifdef(`ENV_VARS_$1',`indir(`ENV_VARS_$1')')',dnl
`ifdef(`ENV_VARS_$1',`indir(`ENV_VARS_$1')')'dnl
`SET_ENV_VARS_COMPONENTS(shift($@))')')

# Expands into list of rules for the components specified in the ``$@`` arguments.
# For the component ``$n`` rule should be previously defined as ``INSTALL_$n`` macro.
# If ``INSTALL_$n`` macro was not defined, then rules expansion for this component is
# void and m4 error is generated.
define(`INSTALL_COMPONENTS',`dnl
pushdef(`_install_comp',`ifdef(`INSTALL_$1',`indir(`INSTALL_$1',_install_mode,_install_from)',)')dnl
ifelse($#,0,,$#,1,`_install_comp',`dnl
_install_comp`'INSTALL_COMPONENTS(shift($@))')`'dnl
popdef(`_install_comp')')

# Considers ``$1`` argument as a list understood as a sequence of elements separated
# by spaces) and expands to a list of elements separated by ``,``. I.e. given the
# ``item1 item2 item3`` macro will expand to ``item1, item2, item3``
define(`ARGS',`patsubst($1,` +',`,')')

# Default separator for ``ECHO''.
DECLARE(`ECHO_SEP',`` '')

# Echoes given arguments separating them with ``ECHO_SEP`` (defaults to `` `` space).
define(`ECHO',`ifelse($#,0,,$#,1,$1,`$1`'ECHO_SEP`'ECHO(shift($@))')')

define(`APT_INSTALL',`apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ECHO($@) && \
  rm -rf /var/lib/apt/lists/*')
define(`YUM_INSTALL',`yum install -y ECHO($@)')

# Expands into distro packages install command(s) for the packages specified
# in arguments.
define(`INSTALL_PKGS',`ifelse(
OS_NAME,ubuntu,RUN APT_INSTALL($@),
OS_NAME,centos,RUN YUM_INSTALL($@),
`ERROR(unsupported OS: OS_NAME)')')

# Expands into list of rules for the components listed in ``COMPONENTS_LIST``.
# ``BUILD_ALL'' macro expects that each component from the list (``$n``) exposes
# the following 2 macros:
#
# * ``$n_BUILD_DEPS`` should expand into a list of component's distro package
#   dependencies.
#
# * ``BUILD_$n`` should expand into a list of component-specific rules
#
# This is not a mistake if component does not expose one or both of the above
# macros. In this case expansion of this component is void.
#
# ``BUILD_ALL'' macro works in a way that it instantiates distro package
# install commands (for all components) first and then it instantiates component
# specific rules.
define(`BUILD_ALL',`dnl
RUN mkdir -p BUILD_HOME && mkdir -p BUILD_DESTDIR

ENV PKG_CONFIG_PATH=BUILD_LIBDIR/pkgconfig

BUILD_COMPONENTS(ARGS(COMPONENTS_LIST))dnl
')

# List of distro packages to be installed within INSTALL_ALL expansion.
# Use this list to add those components which you want to get directly from
# the OS. Mind that alternative way is to directly call ``INSTALL_PKGS``
# macro. The problem however is that ``INSTALL_PKGS`` will generate new
# package install command line (like ``RUN apt-get update && apt-get install...``).
# ``INSTALL_PKGS_LIST`` from the other hand will just add packages to the
# list which gets expanded with ``INSTALL_ALL`` which will combine your list
# with the list of package coming from build dependencies, i.e. you will get
# less number of package install commands.
DECLARE(`INSTALL_PKGS_LIST',`')

# Expands into list of rules for the components listed in ``COMPONENTS_LIST''.
# ``INSTALL_ALL'' macro expects that each component (``$n``) from the list exposes
# the following 2 macros:
#
# * ``$n_INSTALL_DEPS`` should expand into a list of component's distro package
#   dependencies.
#
# * ``INSTALL_$n`` should expand into a list of component-specific rules
#
# This is not a mistake if component does not expose one or both of the above
# macros. In this case expansion of this component is void.
#
# ``INSTALL_ALL'' macro works in a way that it instantiates distro package
# install commands (for all components) first and then it instantiates component
# specific rules.
#
# ``INSTALL_ALL'' accepts the following arguments and passes them unchanged on
# components ``INSTALL_$n`` invokations:
#
#  * ``$1'' specifies installation mode (runtime, devel, etc.)
#  * ``$2'' specifies docker layer to copy component artifacts from
define(`INSTALL_ALL',`dnl
pushdef(`_deps',GET_INSTALL_DEPS(ARGS(COMPONENTS_LIST)))dnl
pushdef(`_pkgs',PKGS(REMOVE_DUPLICATES(`_deps INSTALL_PKGS_LIST')))dnl
INSTALL_PKGS(ARGS(_pkgs))
popdef(`_pkgs')dnl
popdef(`_deps')dnl

ifelse($2,`',,
COPY --from=$2 BUILD_DESTDIR /
RUN echo "BUILD_LIBDIR" >> /etc/ld.so.conf.d/all-libs.conf && ldconfig)

# Custom component installation rules, if any...
pushdef(`_install_mode',$1)dnl
pushdef(`_install_from',$2)dnl
INSTALL_COMPONENTS(ARGS(COMPONENTS_LIST))dnl
popdef(`_install_from')dnl
popdef(`_install_mode')dnl
# ... end of custom installation rules

# Custom component environment variables, if any...
SET_ENV_VARS_COMPONENTS(ARGS(COMPONENTS_LIST))dnl
# ... end of custom environment variables
')

# Registers component given in ``$1`` argument to be built and/or isntalled.
define(`REG',`dnl
pushdef(`_tmp',COMPONENTS_LIST)
undefine(`COMPONENTS_LIST')
define(`COMPONENTS_LIST',REMOVE_DUPLICATES(APPEND(_tmp,$1)))
popdef(`_tmp')')

# Performs generic cleanup of the built packages. If packages install
#
define(`CLEANUP',`dnl
RUN echo "Start cleanup" && \
ifelse(CLEANUP_DEV,yes,`dnl
    rm -rf BUILD_DESTDIR/BUILD_PREFIX/include && \
    rm -rf BUILD_DESTDIR/BUILD_PREFIX/share/doc && \
    rm -rf BUILD_DESTDIR/BUILD_PREFIX/share/gtk-doc && \
')dnl
ifelse(CLEANUP_MAN,yes,`dnl
    rm -rf BUILD_DESTDIR/BUILD_PREFIX/share/man && \
')dnl
ifelse(CLEANUP_DEV,yes,`dnl
    ( find BUILD_DESTDIR -name "*.a" -exec rm -f {} \; ) && \
')dnl
    echo "Cleanup done"
')

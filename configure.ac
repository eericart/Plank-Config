AC_INIT([PLANK COnFIG], 1.3)
AM_INIT_AUTOMAKE([1.10 no-define foreign dist-xz no-dist-gzip])
AC_PROG_CC
AM_PROG_VALAC([0.22])
PKG_CHECK_MODULES(gtk, gtk+-3.0)
#
# Check for libnotify
#

PKG_CHECK_MODULES(LIBNOTIFY, libnotify >= 0.7.3)

AC_SUBST(LIBNOTIFY_CFLAGS)
AC_SUBST(LIBNOTIFY_LIBS)
AC_CONFIG_FILES([plank-config.desktop Makefile ])

AC_OUTPUT
AC_INIT([PLANK COnFIG], 1.3)
AM_INIT_AUTOMAKE([1.10 no-define foreign dist-xz no-dist-gzip])
AC_PROG_CC
AC_CONFIG_MACRO_DIR([m4])
AM_PROG_VALAC([0.22])

PKG_CHECK_MODULES(gtk, gtk+-3.0)

#
# Check for libnotify
#
PKG_CHECK_MODULES(LIBNOTIFY, libnotify >= 0.7.3)

AC_SUBST(LIBNOTIFY_CFLAGS)
AC_SUBST(LIBNOTIFY_LIBS)

dnl ================================================================            
dnl  Language Support                                                           
dnl ================================================================            
GETTEXT_PACKAGE=plank-config 
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE, "$GETTEXT_PACKAGE", [Define the gettext package to be used])
AC_SUBST(GETTEXT_PACKAGE)                                                          
AM_GLIB_GNU_GETTEXT

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([plank-config.desktop Makefile po/Makefile.in])

AC_OUTPUT

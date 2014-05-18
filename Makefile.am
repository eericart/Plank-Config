# The actual runnable program is set to the SCRIPTS primitive.
# # Prefix bin_ tells where to copy this
bin_PROGRAMS = plank-config
plank_config_CFLAGS = $(gtk_CFLAGS)\
                      `pkg-config --cflags --libs libnotify`
plank_config_LDADD = $(gtk_LIBS)
plank_config_VALAFLAGS =\
                         --pkg=gtk+-3.0 \
                         --pkg=posix \
                         --pkg=libnotify
plank_config_SOURCES = plank-config.vala

desktopdir = $(datadir)/applications
desktop_DATA = plank-config.desktop


appicondir=$(datadir)/icons/hicolor/scalable/apps
appicon_DATA=plank-config.svg
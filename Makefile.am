# The actual runnable program is set to the SCRIPTS primitive.
# # Prefix bin_ tells where to copy this
bin_PROGRAMS = plank-config
plank_config_CFLAGS = $(gtk_CFLAGS)
plank_config_LDADD = $(gtk_LIBS)
plank_config_VALAFLAGS = --pkg gtk+-3.0
plank_config_SOURCES = plank-config.vala

desktopdir = $(datadir)/applications
desktop_DATA = plank-config.desktop
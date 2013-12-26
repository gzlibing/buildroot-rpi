#############################################################
#
# gobject-introspection
#
#############################################################

GOBJECT_INTROSPECTION_VERSION = 1.36.0
GOBJECT_INTROSPECTION_SITE = http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.36
GOBJECT_INTROSPECTION_SOURCE = gobject-introspection-$(GOBJECT_INTROSPECTION_VERSION).tar.xz
GOBJECT_INTROSPECTION_DEPENDENCIES = host-python

$(eval $(autotools-package))
$(eval $(host-autotools-package))

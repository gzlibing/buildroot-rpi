################################################################################
#
# xapp_fslsfonts -- list fonts served by X font server
#
################################################################################

XAPP_FSLSFONTS_VERSION = 1.0.1
XAPP_FSLSFONTS_SOURCE = fslsfonts-$(XAPP_FSLSFONTS_VERSION).tar.bz2
XAPP_FSLSFONTS_SITE = http://xorg.freedesktop.org/releases/individual/app
XAPP_FSLSFONTS_AUTORECONF = YES
XAPP_FSLSFONTS_DEPENDANCIES = xlib_libFS xlib_libX11

$(eval $(call AUTOTARGETS,xapp_fslsfonts))

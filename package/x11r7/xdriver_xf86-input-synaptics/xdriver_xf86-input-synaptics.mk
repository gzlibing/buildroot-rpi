################################################################################
#
# xdriver_xf86-input-synaptics -- X.Org driver for synaptics input devices
#
################################################################################

XDRIVER_XF86_INPUT_SYNAPTICS_VERSION = 1.6.2
XDRIVER_XF86_INPUT_SYNAPTICS_SOURCE = xf86-input-synaptics-$(XDRIVER_XF86_INPUT_SYNAPTICS_VERSION).tar.bz2
XDRIVER_XF86_INPUT_SYNAPTICS_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_SYNAPTICS_LICENSE = MIT
XDRIVER_XF86_INPUT_SYNAPTICS_LICENSE_FILES = COPYING
XDRIVER_XF86_INPUT_SYNAPTICS_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto mtdev

$(eval $(autotools-package))

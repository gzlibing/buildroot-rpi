#############################################################
#
# lirc
#
#############################################################

LIRC_VERSION = 0.9.0
LIRC_SOURCE = lirc-$(LIRC_VERSION).tar.bz2
LIRC_SITE = http://downloads.sourceforge.net/project/lirc/LIRC/$(LIRC_VERSION)/

LIRC_INSTALL_STAGING = YES
LIRC_INSTALL_TARGET = YES

LIRC_AUTORECONF=YES

LIRC_CONF_OPT = --without-x --enable-sandboxed --with-driver=userspace

LIRC_POST_INSTALL_TARGET_HOOKS += LIRC_INSTALL_TARGET_SCRIPTS
LIRC_POST_UNINSTALL_TARGET_HOOKS += LIRC_UNINSTALL_TARGET_SCRIPTS

define LIRC_INSTALL_TARGET_SCRIPTS
	mkdir -p $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 0755 package/lirc/src/S70lircd $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 package/lirc/src/hardware.conf $(TARGET_DIR)/etc/
	$(INSTALL) -m 0755 package/lirc/src/lircd.conf $(TARGET_DIR)/etc/
endef

define LIRC_UNINSTALL_TARGET_SCRIPTS
	rm -f $(TARGET_DIR)/etc/init.d/S70lircd
	rm -f $(TARGET_DIR)/etc/hardware.conf
	rm -f $(TARGET_DIR)/etc/lircd.conf
endef

$(eval $(autotools-package))

#############################################################
#
# examples
#
#############################################################

EXAMPLES_VERSION = 1
EXAMPLES_SITE_METHOD = local
EXAMPLES_SITE = $(TOPDIR)/package/qt5/examples/src
EXAMPLES_DEPENDENCIES = qt5base

define EXAMPLES_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			DEFINES+=_NOTHING_ \
			./examples.pro \
	)
endef

define EXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define EXAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/cube/cube $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/hellogl_es2/hellogl_es2 $(TARGET_DIR)/usr/bin
endef

define EXAMPLES_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/cube
	rm -f $(TARGET_DIR)/usr/bin/hellogl_es2
endef

$(eval $(generic-package))

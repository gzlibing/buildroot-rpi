#############################################################
#
# dawn-sdk
#
#############################################################

DAWN_SDK_VERSION = 187864
DAWN_SDK_SITE = ../dawn
DAWN_SDK_SITE_METHOD = local
DAWN_SDK_INSTALL_STAGING = YES
DAWN_SDK_LICENSE = PROPRIETARY
DAWN_SDK_LICENSE_FILES = boot/LICENCE.broadcom

define DAWN_SDK_INSTALL_STAGING_CMDS
	cp -Rf $(@D)/sdk/include/* $(STAGING_DIR)/usr/include/
	cp -Rf $(@D)/sdk/lib/* $(STAGING_DIR)/usr/lib/
	cp -Rf $(@D)/sdk/pkgconfig/* $(STAGING_DIR)/usr/lib/pkgconfig/
endef

define DAWN_SDK_INSTALL_TARGET_CMDS
	cp -Rf $(@D)/sdk/lib/* $(TARGET_DIR)/usr/lib/
	mkdir -p $(TARGET_DIR)/lib/modules/3.3.8-3.0/
	cp -Rf $(@D)/modules/pace $(TARGET_DIR)/lib/modules/3.3.8-3.0/
	cp -Rf $(@D)/modules/OSS $(TARGET_DIR)/lib/modules/
	mkdir -p $(TARGET_DIR)/usr/lib/modules/
	cp -Rf $(@D)/modules/nexus.ko $(TARGET_DIR)/usr/lib/modules/
	cp -Rf $(@D)/init/inittab $(TARGET_DIR)/etc
	rm -rf $(TARGET_DIR)/etc/init.d/
	cp -Rf $(@D)/init/init.d $(TARGET_DIR)/etc
endef

$(eval $(generic-package))

#############################################################
#
# dawn-sdk
#
#############################################################

DAWN_SDK_VERSION = 187864
DAWN_SDK_SITE = ../dawn/sdk
DAWN_SDK_SITE_METHOD = local
DAWN_SDK_INSTALL_STAGING = YES
DAWN_SDK_LICENSE = PROPRIETARY
DAWN_SDK_LICENSE_FILES = boot/LICENCE.broadcom

define DAWN_SDK_INSTALL_STAGING_CMDS
	cp -Rf $(@D)/include/* $(STAGING_DIR)/usr/include/
	cp -Rf $(@D)/lib/* $(STAGING_DIR)/usr/lib/
	cp -Rf $(@D)/pkgconfig/* $(STAGING_DIR)/usr/lib/pkgconfig/
endef

define DAWN_SDK_INSTALL_TARGET_CMDS
	cp -Rf $(@D)/lib/* $(STAGING_DIR)/usr/lib/
endef

$(eval $(generic-package))

#############################################################
#
# dxdrm
#
#############################################################
DXDRM_VERSION = 1.0.0
DXDRM_SITE = $(TOPDIR)/package/multimedia/dxdrm/libs
DXDRM_SITE_METHOD = local
DXDRM_LICENSE = PROPRIETARY
DXDRM_REDISTRIBUTE = NO

define DXDRM_INSTALL_TARGET_CMDS
	if [ ! -f $(@D)/dxdrm.bin ]; then \
		cat $(@D)/README; \
	else \
		mkdir -p $(TARGET_DIR)/usr/lib; \
		$(INSTALL) -m 755 $(@D)/dxdrm.bin $(TARGET_DIR)/usr/lib/libDxDrm.so; \
	fi; \
	if [ -f $(@D)/DxDrmConfig.txt ]; then \
		mkdir -p $(TARGET_DIR)/usr/local/DxDrm/Credentials; \
		$(INSTALL) -m 755 $(@D)/DxDrmConfig.txt $(TARGET_DIR)/usr/local/DxDrm/; \
		$(INSTALL) -m 755 $(@D)/Credentials/* $(TARGET_DIR)/usr/local/DxDrm/Credentials; \
	fi; \
	if [ -d $(@D)/include ]; then \
		mkdir -p $(STAGING_DIR)/usr/include/dxdrm; \
		$(INSTALL) -m 755 $(@D)/include/* $(STAGING_DIR)/usr/include/dxdrm; \
	fi
endef

$(eval $(generic-package))

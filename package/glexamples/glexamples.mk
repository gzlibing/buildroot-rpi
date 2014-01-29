#############################################################
#
# gl-examples
#
#############################################################

GLEXAMPLES_VERSION = 2e7d3224a7958b1863c6e5e880754c6941e6365a
GLEXAMPLES_SITE_METHOD = git
GLEXAMPLES_SITE = https://github.com/msieben/opengl.git
        
        
ifeq ($(BR2_PACKAGE_DAWN_SDK),y)
	GLEXAMPLES_DEPENDENCIES = dawn-sdk 

	GLEXAMPLES_CFLAGS = $(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/refsw
	GLEXAMPLES_LDFLAGS =  -L$(STAGING_DIR)/lib/ -L$(STAGING_DIR)/usr/lib/ -lv3ddriver -ldbpl -lnexus -lnxpl -ldirectfb  -lrt -lb_ipc

	GLEXAMPLES_CFLAGS += -DBSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE -D NEXUS_PLATFORM=PACE_DMC7000KLG_CADB
endif

define GLEXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) CC="$(TARGET_CC)" CFLAGS="$(GLEXAMPLES_CFLAGS)" LDFLAGS="$(GLEXAMPLES_LDFLAGS)" $(MAKE) -C $(@D)/src
endef

define GLEXAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/demo_1 $(TARGET_DIR)/usr/bin
endef

define GLEXAMPLES_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/demo_1
endef

$(eval $(generic-package))

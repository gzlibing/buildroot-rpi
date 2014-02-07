#############################################################
#
# gl-examples
#
#############################################################

GLEXAMPLES_VERSION = 1
GLEXAMPLES_SITE_METHOD = local
GLEXAMPLES_SITE = $(TOPDIR)/package/glexamples/src
#GLEXAMPLES_DEPENDENCIES = 

GLEXAMPLES_CFLAGS = \
	$(TARGET_CFLAGS) \
	-I$(STAGING_DIR)/usr/include \
	-I$(STAGING_DIR)/usr/include/refsw \
	-DBSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE \
	-DNEXUS_PLATFORM=PACE_DMC7000KLG_CADB \
	-DNEXUS_SERVER_SUPPORT=1
GLEXAMPLES_LDFLAGS = \
	-L$(STAGING_DIR)/lib/ \
	-L$(STAGING_DIR)/usr/lib/ \
	-lrt -lnexus -lnxpl -lv3ddriver -lm -lb_ipc

#define GLEXAMPLES_CONFIGURE_CMDS
#endef

define GLEXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) CC="$(TARGET_CC)" CFLAGS="$(GLEXAMPLES_CFLAGS)" LDFLAGS="$(GLEXAMPLES_LDFLAGS)" $(MAKE) -C $(@D)
endef

define GLEXAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/demo_1 $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/demo_2 $(TARGET_DIR)/usr/bin
endef

define GLEXAMPLES_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/demo_*
endef

$(eval $(generic-package))

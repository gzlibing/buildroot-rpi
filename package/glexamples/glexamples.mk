#############################################################
#
# gl-examples
#
#############################################################

GLEXAMPLES_VERSION = 1
GLEXAMPLES_SITE_METHOD = local
GLEXAMPLES_SITE = $(TOPDIR)/package/glexamples/src
#GLEXAMPLES_DEPENDENCIES = 

GLEXAMPLES_CFLAGS = $(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/refsw
#GLEXAMPLES_LDFLAGS =  -L$(STAGING_DIR)/lib/ -L$(STAGING_DIR)/usr/lib/ -lv3ddriver -ldbpl -lnexus -lnxpl -ldirectfb  -lrt
#GLEXAMPLES_LDFLAGS =  -L$(STAGING_DIR)/lib/ -L$(STAGING_DIR)/usr/lib/ -lv3ddriver -lnexus -lnxpl -ldirectfb -lrt -lb_ipc
GLEXAMPLES_LDFLAGS =  -L$(STAGING_DIR)/lib/ -L$(STAGING_DIR)/usr/lib/ -lnexus -lnxpl -ldirectfb -lrt -lb_ipc

GLEXAMPLES_CFLAGS += -DBSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE -D NEXUS_PLATFORM=PACE_DMC7000KLG_CADB

#DEFINES += BDBG_DEBUG_BUILD=1 NEXUS_SERVER_SUPPORT=1 _GNU_SOURCE=1 \
       LINUX _FILE_OFFSET_BITS=64 _LARGEFILE_SOURCE _LARGEFILE64_SOURCE \
       BSTD_CPU_ENDIAN=BSTD_ENDIAN_LITTLE \
       NEXUS_POWER_MANAGEMENT BHSM_AUTO_TEST NEXUS_CONFIG_IMAGE \
       NEXUS_MODE_proxy NEXUS_PLATFORM_DOCSIS_OOB_SUPPORT=1 PLATFORM=PACE_DMC7000KLG_CADB \
       NEXUS_PLATFORM=PACE_DMC7000KLG_CADB BCHP_CHIP=7429 BCHP_VER=BCHP_VER_B0 \
       BMEM_REENTRANT_CONFIG=BMEM_REENTRANT BINT_REENTRANT_CONFIG=BINT_REENTRANT \
       NEXUS_PROFILE_OS_linuxuser BBCP_SUPPORT NEXUS_FRONTEND_3255 \
       NEXUS_FRONTEND_ACCUMULATE_STATISTICS=1 NEXUS_HAS_MXT=1 NEXUS_SECURITY_CHIP_SIZE=40 \
       NEXUS_SECURITY_HAS_ASKM=1 NEXUS_SECURITY_SC_VALUE NEXUS_SECURITY_SC_VALUE \
       NEXUS_SECURITY_EXT_KEY_IV NEXUS_KEYLADDER=1 NEXUS_HAS_KEYLADDER_SUPPORT=1 \
       NEXUS_OTPMSP=1 NEXUS_USERCMD=1 NEXUS_SECURITY_RAWCMD=1 \
       BXPT_MESG_DONT_AUTO_ENABLE_PID_CHANNEL NEXUS_OTFPVR=1 \
       NEXUS_SYNC_CHANNEL_SARNOFF_LIPSYNC_OFFSET_SUPPORT=1 NEXUS_HAS_PLATFORM \
       NEXUS_HAS_CORE NEXUS_HAS_PWM NEXUS_HAS_I2C NEXUS_HAS_GPIO NEXUS_HAS_LED \
       NEXUS_HAS_IR_INPUT NEXUS_HAS_IR_BLASTER NEXUS_HAS_INPUT_CAPTURE \
       NEXUS_HAS_KEYPAD NEXUS_HAS_FRONTEND NEXUS_HAS_SPI NEXUS_HAS_SECURITY \
       NEXUS_HAS_DMA NEXUS_HAS_TRANSPORT NEXUS_HAS_VIDEO_DECODER NEXUS_HAS_AUDIO \
       NEXUS_HAS_SURFACE NEXUS_HAS_GRAPHICS2D NEXUS_HAS_DISPLAY NEXUS_HAS_ASTM \
       NEXUS_HAS_SYNC_CHANNEL NEXUS_HAS_HDMI_OUTPUT NEXUS_HAS_RFM NEXUS_HAS_PICTURE_DECODER \
       NEXUS_HAS_CEC NEXUS_HAS_SMARTCARD NEXUS_HAS_SURFACE_COMPOSITOR NEXUS_HAS_INPUT_ROUTER \
       NEXUS_HAS_SIMPLE_DECODER NEXUS_HAS_FILE NEXUS_HAS_PLAYBACK NEXUS_HAS_RECORD \
       NEXUS_HAS_GRAPHICS3D BCHP_PWR_SUPPORT


#define GLEXAMPLES_CONFIGURE_CMDS
#endef

define GLEXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) CC="$(TARGET_CC)" CFLAGS="$(GLEXAMPLES_CFLAGS)" LDFLAGS="$(GLEXAMPLES_LDFLAGS)" $(MAKE) -C $(@D)
endef

define GLEXAMPLES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/demo_1 $(TARGET_DIR)/usr/bin
endef

define GLEXAMPLES_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/demo_1
endef

$(eval $(generic-package))
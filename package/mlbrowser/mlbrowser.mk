#############################################################
#
# mlbrowser
#
#############################################################

MLBROWSER_VERSION = e7bba1439ff9b38dfd36c6222e4825c5d17e7677
MLBROWSER_SITE_METHOD = git
MLBROWSER_SITE = https://github.com/msieben/mlbrowser.git

ifeq ($(BR2_PACKAGE_QT5WEBKIT),y)
MLBROWSER_DEPENDENCIES = qt5webkit
endif

ifeq ($(BR2_PACKAGE_QT_WEBKIT),y)
MLBROWSER_DEPENDENCIES = qt gstreamer
endif

define MLBROWSER_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			DEFINES+=_BROWSER_ \
			DEFINES+=_MOUSE_ \
			DEFINES+=_PROPERTYCHANGER_ \
			./src/mlbrowser.pro \
	)
endef

define MLBROWSER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MLBROWSER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mlbrowser $(TARGET_DIR)/usr/bin
endef

define MLBROWSER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/mlbrowser
endef

$(eval $(generic-package))

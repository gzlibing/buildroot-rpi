#############################################################
#
# qt5webkit
#
#############################################################

#QT5WEBKIT_VERSION = 63a45cfef9ec3ab16d9ea1529e296da1148f9504
#QT5WEBKIT_SITE = http://github.com/WebKit/webkit/tarball/master
QT5WEBKIT_VERSION = $(QT5_VERSION)
QT5WEBKIT_SITE = $(QT5_SITE)
QT5WEBKIT_SOURCE = qtwebkit-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_DEPENDENCIES = qt5base sqlite host-ruby host-gperf host-bison host-flex
QT5WEBKIT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WEBKIT_LICENSE = LGPLv2.1 or GPLv3.0
else
QT5WEBKIT_LICENSE = Commercial license
QT5WEBKIT_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_DEPENDENCIES += qt5declarative
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
	DEBUG_CONFIG = "CONFIG+=debug"
else
	DEBUG_CONFIG = "CONFIG-=debug"
endif

ifeq ($(BR2_PACKAGE_MINIBROWSER),y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_MINIBROWSER
endif

ifeq ($(BR2_PACKAGE_TESTBROWSER),y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_TESTBROWSER
endif

ifeq ($(BR2_PACKAGE_DUMPRENDERTREE), y)
	QT5WEBKIT_POST_BUILD_HOOKS += QT5WEBKIT_BUILD_MINIBROWSER
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
define QT5WEBKIT_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebKit $(TARGET_DIR)/usr/qml/
endef
endif

define QT5WEBKIT_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake \
			WEBKIT_CONFIG-=svg \
			WEBKIT_CONFIG+=accelerated_2d_canvas \
			CONFIG+=release \
			CONFIG+=use_gstreamer010 \
			CONFIG+=system-sqlite \
			$(DEBUG_CONFIG) \
	)
endef

define QT5WEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBKIT_BUILD_MINIBROWSER
	(cd $(@D)/Tools/MiniBrowser/qt; \
	$(TARGET_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/qmake \
	)

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/MiniBrowser/qt
endef

define QT5WEBKIT_BUILD_TESTBROWSER
	(cd $(@D)/Tools/QtTestBrowser; \
	$(TARGET_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/qmake \
	)

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/QtTestBrowser
endef

define QT5WEBKIT_BUILD_DUMPRENDERTREE
	(cd $(@D)/Tools/DumpRenderTree/qt; \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake ./DumpRenderTree.pro \
	)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/Tools/DumpRenderTree/qt
endef

define QT5WEBKIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

define QT5WEBKIT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/root/.cache
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebKit*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
	$(QT5WEBKIT_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))

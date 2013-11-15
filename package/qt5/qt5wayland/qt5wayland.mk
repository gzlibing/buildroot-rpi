QT5WAYLAND_VERSION = 36516e30b5daa84878a2b139db11a7358b7113ea
QT5WAYLAND_SITE = git://gitorious.org/qt/qtwayland.git
QT5WAYLAND_SITE_METHOD = git

QT5WAYLAND_DEPENDENCIES = qt5base qt5declarative wayland

QT5WAYLAND_INSTALL_STAGING = YES

define QT5WAYLAND_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	touch $(@D)/.git
	(cd $(@D) && \
		$(TARGET_MAKE_ENV) \
		$(HOST_DIR)/usr/bin/qmake -r CONFIG+=wayland-compositor)
endef

define QT5WAYLAND_BUILD_CMDS
 	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
 	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/examples/qwindow-compositor
endef

define QT5WAYLAND_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
	$(MAKE) -C $(@D)/examples/qwindow-compositor install
endef

define QT5WAYLAND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Compositor*.so* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/qt/plugins/platforms/libqwayland-brcm-egl.so $(TARGET_DIR)/usr/lib/qt/plugins/platforms/
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/waylandcompositors $(TARGET_DIR)/usr/lib/qt/plugins/
	cp -dpf $(STAGING_DIR)/usr/examples/qtwayland/qwindow-compositor/qwindow-compositor $(TARGET_DIR)/usr/bin
endef

define QT5WAYLAND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Compositor*.so*
	-rm $(TARGET_DIR)/usr/lib/qt/plugins/platforms/libqwayland-brcm-egl.so
	-rm -r $(TARGET_DIR)/usr/lib/qt/plugins/waylandcompositors
	-rm $(TARGET_DIR)/usr/bin/qwindow-compositor
endef

$(eval $(generic-package))


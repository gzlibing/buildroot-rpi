#############################################################
#
# webkit
#
#############################################################

WEBKIT_VERSION = 2.3.5
WEBKIT_SOURCE = webkitgtk-$(WEBKIT_VERSION).tar.xz
WEBKIT_SITE = http://www.webkitgtk.org/releases
WEBKIT_INSTALL_STAGING = YES
WEBKIT_DEPENDENCIES = host-flex host-bison host-gperf icu libxml2 \
	libxslt libgtk3 sqlite enchant libsoup jpeg webp

WEBKIT_AUTORECONF = YES

# Give explicit path to icu-config.
WEBKIT_CONF_ENV = \
	ac_cv_path_icu_config=$(STAGING_DIR)/usr/bin/icu-config \
	AR_FLAGS="cru" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -D_GLIBCXX_USE_SCHED_YIELD -D_GLIBCXX_USE_NANOSLEEP"

WEBKIT_CONF_OPT = \
	--disable-credential-storage \
	--disable-geolocation \
	--disable-video \
	--disable-web-audio

ifeq ($(BR2_PACKAGE_XORG7),y)
	WEBKIT_CONF_OPT += --enable-x11-target
	WEBKIT_DEPENDENCIES += xlib_libXt
endif
ifeq ($(BR2_PACKAGE_WAYLAND),y)
	WEBKIT_CONF_OPT += --enable-wayland-target
	WEBKIT_DEPENDENCIES += wayland
endif

$(eval $(autotools-package))

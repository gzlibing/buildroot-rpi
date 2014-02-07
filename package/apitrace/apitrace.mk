#############################################################
#
# apitrace
#
#############################################################

APITRACE_VERSION = 788d9ce293a9b44f64536130cf4ad577e8101dbe
APITRACE_SITE = https://github.com/apitrace/apitrace.git
APITRACE_SITE_METHOD = git

APITRACE_CONF_OPT =
ifneq ($(BR2_PACKAGE_XLIB_LIBX11),y)
APITRACE_CONF_OPT += -DCMAKE_C_FLAGS:STRING="$(TARGET_CFLAGS) -DMESA_EGL_NO_X11_HEADERS"
APITRACE_CONF_OPT += -DCMAKE_CXX_FLAGS:STRING="$(TARGET_CFLAGS) -DMESA_EGL_NO_X11_HEADERS"
endif

APITRACE_DEPENDENCIES = popt binutils

$(eval $(cmake-package))

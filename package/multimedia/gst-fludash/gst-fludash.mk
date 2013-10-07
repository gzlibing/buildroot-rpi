#############################################################
#
# gst-fludash
#
#############################################################
GST_FLUDASH_VERSION = 1.0.0
GST_FLUDASH_SITE = $(TOPDIR)/package/multimedia/gst-fludash/libs
GST_FLUDASH_SITE_METHOD = local
GST_FLUDASH_LICENSE = PROPRIETARY
GST_FLUDASH_REDISTRIBUTE = NO

GST_FLUDASH_DEPENDENCIES += gst-flucodecpack

define GST_FLUDASH_INSTALL_TARGET_CMDS
	if [ ! -f $(@D)/gstfludash.bin ]; then \
		cat $(@D)/README; \
	else \
		mkdir -p $(TARGET_DIR)/usr/lib/gstreamer-0.10; \
		$(INSTALL) -m 755 $(@D)/gstfludash.bin $(TARGET_DIR)/usr/lib/gstreamer-0.10/libgstfludash.so; \
	fi
endef

$(eval $(generic-package))

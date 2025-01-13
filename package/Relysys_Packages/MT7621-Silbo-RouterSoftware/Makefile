include $(TOPDIR)/rules.mk

PKG_NAME:=MT7621-Silbo-RouterSoftware
PKG_RELEASE:=1.12

include $(INCLUDE_DIR)/package.mk

#LDFLAGS = -llibc -lconfig -lmosquitto -lssl -lresolv -lpthread  -lcrypto

define Package/MT7621-Silbo-RouterSoftware
    SECTION:=utils
    CATEGORY:=RelySys Packages
    DEPENDS:= +busybox +libconfig +libmosquitto +libopenssl
    TITLE:=InterfaceManager scripts
endef

define Package/MT7621-Silbo-RouterSoftware/description
InterfaceManager scripts for interface monitoring
endef

define Build/Compile
endef

define Package/MT7621-Silbo-RouterSoftware/install
$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,MT7621-Silbo-RouterSoftware,+libopenssl))

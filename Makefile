ACRCHS = armv7 arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cenamo

Cenamo_FILES = UIColor+colorFromHexCode.m Tweak.xm
Cenamo_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += cenamoprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

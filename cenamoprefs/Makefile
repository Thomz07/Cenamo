include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cenamoprefs

cenamoprefs_FILES = CENRootListController.m CENSubPageController.m 
cenamoprefs_INSTALL_PATH = /Library/PreferenceBundles
cenamoprefs_FRAMEWORKS = UIKit
cenamoprefs_PRIVATE_FRAMEWORKS = Preferences
cenamoprefs_CFLAGS = -fobjc-arc
cenamoprefs_LIBRARIES = appearancecell

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/cenamoprefs.plist$(ECHO_END)

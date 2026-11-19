ARCHS = armv7
TARGET = iphone:clang:latest:9.3
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSSpoof
iOSSpoof_FILES = Tweak.x
iOSSpoof_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
iOSSpoof_FRAMEWORKS = UIKit Foundation CoreLocation
iOSSpoof_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += iosspoofprefs
include $(THEOS_MAKE_PATH)/aggregate.mk


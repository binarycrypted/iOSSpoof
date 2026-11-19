ARCHS = armv7
TARGET = iphone:clang:latest:9.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = iOSSpoofPrefs
iOSSpoofPrefs_FILES = ISPRootListController.m
iOSSpoofPrefs_FRAMEWORKS = UIKit
iOSSpoofPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk


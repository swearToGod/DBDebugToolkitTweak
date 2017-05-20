
ARCHS = arm64
TARGET = iphone:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 08Instagram
08Instagram_FILES = Tweak.xm
08Instagram_FILES += DBDebug/DBDebug.m
# export ADDITIONAL_LDFLAGS  =  -force_load ./lib84-staticLibry.a

08Instagram_FRAMEWORKS = UIKit CoreGraphics MapKit CoreLocation
08Instagram_LDFLAGS += lib84-staticLibry.a
08Instagram_LDFLAGS += -std=gnu99
08Instagram_LDFLAGS += -all_load -licucore


include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

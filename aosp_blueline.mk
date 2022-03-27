#
# Copyright 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# All components inherited here go to system image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

# Enable mainline checking
# TODO(b/138706293): enable Enable mainline checking later
#PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

#
# All components inherited here go to vendor image
#
USE_ANDROID_INFO := 1
# TODO(b/136525499): move *_vendor.mk into the vendor makefile later
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)
$(call inherit-product, device/google/crosshatch/device-blueline.mk)
$(call inherit-product-if-exists, vendor/google_devices/crosshatch/proprietary/device-vendor.mk)

PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

# STOPSHIP deal with Qualcomm stuff later
# PRODUCT_RESTRICT_VENDOR_FILES := all

# b/189477034: Bypass build time check on uses_libs until vendor fixes all their apps
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# Keep the VNDK APEX in /system partition for REL branches as these branches are
# expected to have stable API/ABI surfaces.
ifneq (REL,$(PLATFORM_VERSION_CODENAME))
  PRODUCT_PACKAGES += com.android.vndk.current.on_vendor
endif

PRODUCT_MANUFACTURER := Google
PRODUCT_NAME := aosp_blueline
PRODUCT_DEVICE := blueline
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on blueline

PRODUCT_ADB_KEYS := vendor/user1/xdroid.adb_key.pub
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/user1/certs/releasekey

PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions = log \

GAPPS_VARIANT := pico
GAPPS_PRODUCT_PACKAGES += \
        ActionsServices \
        CarrierServices \
        GoogleDialer \
        LatinImeGoogle \
        PixelLauncherIcons \
        Velvet \
        Wallpapers

# GAPPS_PRODUCT_PACKAGES += \
#         PixelLauncher

GAPPS_BYPASS_PACKAGE_OVERRIDES := \
        GoogleDialer

# GAPPS_BYPASS_PACKAGE_OVERRIDES := \
#         PixelLauncher

$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)

PRODUCT_COPY_FILES += \
    device/google/crosshatch/permissions/privapp-permissions-google-2.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-google-2.xml

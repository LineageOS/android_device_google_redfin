# Boot animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/redfin/aosp_redfin.mk)

-include device/google/redfin/device-lineage.mk

## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_redfin
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 5
TARGET_MANUFACTURER := Google

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=redfin \
    PRIVATE_BUILD_DESC="redfin-user 11 RQ1A.210105.003 7005429 release-keys"

BUILD_FINGERPRINT := google/redfin/redfin:11/RQ1A.210105.003/7005429:user/release-keys

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/redfin/overlay-lineage

$(call inherit-product, device/google/redbull/device-lineage.mk)

$(call inherit-product-if-exists, vendor/google/redfin/redfin-vendor.mk)

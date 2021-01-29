$(call inherit-product, device/google/redbull/device-lineage.mk)

# Touch
PRODUCT_PACKAGES += \
    vendor.lineage.touch@1.0-service.redfin

$(call inherit-product-if-exists, vendor/google/redfin/redfin-vendor.mk)

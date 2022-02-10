#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Kernel
TARGET_KERNEL_SOURCE := kernel/google/redbull

# Add before redbull BoardConfigLineage.mk
BOOT_KERNEL_MODULES += sec_touch.ko

include device/google/redbull/BoardConfigLineage.mk

include vendor/google/redfin/BoardConfigVendor.mk

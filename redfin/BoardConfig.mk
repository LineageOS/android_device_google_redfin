#
# Copyright (C) 2018 The Android Open-Source Project
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

TARGET_BOOTLOADER_BOARD_NAME := redfin
TARGET_SCREEN_DENSITY := 440
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
USES_DEVICE_GOOGLE_REDFIN := true

include device/google/redbull/BoardConfig-common.mk
DEVICE_MANIFEST_FILE += device/google/redfin/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/google/redfin/device_framework_matrix.xml

# Testing related defines
#BOARD_PERFSETUP_SCRIPT := platform_testing/scripts/perf-setup/r3-setup.sh

-include vendor/google_devices/$(TARGET_BOOTLOADER_BOARD_NAME)/proprietary/BoardConfigVendor.mk

-include device/google/redfin/BoardConfigLineage.mk

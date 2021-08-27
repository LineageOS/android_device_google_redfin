#
# Copyright (C) 2021 The LineageOS Project
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

# Boardconfig for lineage_redfin

# Add before redbull BoardConfigLineage.mk
BOOT_KERNEL_MODULES += sec_touch.ko

-include device/google/redbull/BoardConfigLineage.mk

# Manifests
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/google/redfin/lineage_compatibility_matrix.xml

# SEPolicy
BOARD_SEPOLICY_DIRS += device/google/redfin/sepolicy-lineage/vendor

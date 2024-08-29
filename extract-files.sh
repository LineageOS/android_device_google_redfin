#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=redfin
VENDOR=google

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

# If XML files don't have comments before the XML header, use this flag
# Can still be used with broken XML files by using blob_fixup
export TARGET_DISABLE_XML_FIXING=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_FIRMWARE=
KANG=
SECTION=
CARRIER_SKIP_FILES=()
VENDOR_SKIP_FILES=()

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        product/etc/felica/common.cfg)
            [ "$2" = "" ] && return 0
            sed -i -e '$a00000018,1' -e '/^00000014/d' -e '/^00000015/d' "${2}"
            ;;
        # Fix typo in qcrilmsgtunnel whitelist
        product/etc/sysconfig/nexus.xml)
            sed -i 's/qulacomm/qualcomm/' "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

function prepare_firmware() {
    if [ "${SRC}" != "adb" ]; then
        bash "${ANDROID_ROOT}"/lineage/scripts/pixel/prepare-firmware.sh "${DEVICE}" "${SRC}"
    fi
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

if [ -z "${ONLY_FIRMWARE}" ]; then
    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

    generate_prop_list_from_image "product.img" "${MY_DIR}/proprietary-files-carriersettings.txt" CARRIER_SKIP_FILES carriersettings
    extract "${MY_DIR}/proprietary-files-carriersettings.txt" "${SRC}" "${KANG}" --section "${SECTION}"

    readarray -t VENDOR_SKIP_FILES < <(cat "${MY_DIR}/skip-files-vendor.txt" | sed -E "/^[[:blank:]]*(#|$)/d")
    VENDOR_TXT="${MY_DIR}/proprietary-files-vendor.txt"
    generate_prop_list_from_image "vendor.img" "${VENDOR_TXT}" VENDOR_SKIP_FILES

    set_presigned "vendor/app/adreno_graphics_driver/adreno_graphics_driver.apk" "${VENDOR_TXT}"

    set_required "vendor/app/CneApp/CneApp.apk" "CneApp.libvndfwk_detect_jni.qti_symlink" "${VENDOR_TXT}"

    set_symlink "vendor/lib/egl/libEGL_adreno.so" "vendor/lib/libEGL_adreno.so" "${VENDOR_TXT}"
    set_symlink "vendor/lib/egl/libGLESv2_adreno.so" "vendor/lib/libGLESv2_adreno.so" "${VENDOR_TXT}"
    set_symlink "vendor/lib/egl/libq3dtools_adreno.so" "vendor/lib/libq3dtools_adreno.so" "${VENDOR_TXT}"
    set_symlink "vendor/lib64/egl/libEGL_adreno.so" "vendor/lib64/libEGL_adreno.so" "${VENDOR_TXT}"
    set_symlink "vendor/lib64/egl/libGLESv2_adreno.so" "vendor/lib64/libGLESv2_adreno.so" "${VENDOR_TXT}"
    set_symlink "vendor/lib64/egl/libq3dtools_adreno.so" "vendor/lib64/libq3dtools_adreno.so" "${VENDOR_TXT}"

    set_as_module "vendor/lib/libadsprpc.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib/libfastcvopt.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib/libMpeg4SwEncoder.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib64/libadsprpc.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib64/libfastcvopt.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib64/libMpeg4SwEncoder.so" "${VENDOR_TXT}"
    set_as_module "vendor/lib64/libthermalclient.so" "${VENDOR_TXT}"

    extract "${MY_DIR}/proprietary-files-vendor.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${SECTION}" ]; then
    extract_firmware "${MY_DIR}/proprietary-firmware.txt" "${SRC}"
fi

"${MY_DIR}/setup-makefiles.sh"

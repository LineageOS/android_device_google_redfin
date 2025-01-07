#!/usr/bin/env -S PYTHONPATH=../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.extract import extract_fns_user_type
from extract_utils.extract_pixel import (
    extract_pixel_factory_image,
    extract_pixel_firmware,
    pixel_factory_image_regex,
    pixel_firmware_regex,
)
from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'hardware/google/interfaces',
    'hardware/google/pixel',
    'hardware/qcom/sm7250/display',
    'hardware/qcom/sm7250/gps',
    'hardware/qcom/wlan/legacy',
    'vendor/qcom/opensource/display',
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.qti.hardware.tui_comm@1.0',
        'vendor.qti.imsrtpservice@3.0',
    ): lib_fixup_vendor_suffix,
    'libwpa_client': lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    'product/etc/felica/common.cfg': blob_fixup()
        .patch_file('osaifu-keitai.patch'),
    'product/etc/sysconfig/nexus.xml': blob_fixup()
        .regex_replace('qulacomm', 'qualcomm'),
    'system_ext/priv-app/HbmSVManager/HbmSVManager.apk': blob_fixup()
        .apktool_patch('HbmSVManager.patch', '-r'),
    (
        'vendor/bin/hw/android.hardware.rebootescrow-service.citadel',
        'vendor/lib64/android.hardware.keymaster@4.1-impl.nos.so',
    ): blob_fixup()
        .add_needed('libcrypto_shim.so'),
    'vendor/lib/libmmcamera_faceproc.so': blob_fixup()
        .clear_symbol_version('__aeabi_memcpy')
        .clear_symbol_version('__aeabi_memset')
        .clear_symbol_version('__gnu_Unwind_Find_exidx'),
    'vendor/lib64/libgooglecamerahal.so': blob_fixup()
        .add_needed('libmeminfo_shim.so'),
}  # fmt: skip

extract_fns: extract_fns_user_type = {
    pixel_factory_image_regex: extract_pixel_factory_image,
    pixel_firmware_regex: extract_pixel_firmware,
}

module = ExtractUtilsModule(
    'redfin',
    'google',
    device_rel_path='device/google/redfin/redfin',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
    extract_fns=extract_fns,
)

module.add_proprietary_file('proprietary-files-carriersettings.txt')
module.add_proprietary_file('proprietary-files-vendor.txt')

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()

# Copyright (C) 2015 The SaberMod Project
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

ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)
  ifeq (1,$(words $(filter $(LOCAL_DISABLE_STRICT_ALIASING),$(LOCAL_MODULE))))
    LOCAL_CFLAGS += -fno-strict-aliasing
  endif
endif

ifneq (1,$(words $(filter $(LOCAL_DISABLE_STRICT_ALIASING), $(LOCAL_MODULE))))
ifdef  LOCAL_CONLYFLAGS
LOCAL_CONLYFLAGS += \
	-fstrict-aliasing \
	-Werror=strict-aliasing
else
LOCAL_CONLYFLAGS := \
	-fstrict-aliasing \
	-Werror=strict-aliasing
endif

ifdef LOCAL_CPPFLAGS
LOCAL_CPPFLAGS += \
	-fstrict-aliasing \
	-Werror=strict-aliasing
else
LOCAL_CPPFLAGS := \
	-fstrict-aliasing \
	-Werror=strict-aliasing
endif
ifndef LOCAL_CLANG
LOCAL_CONLYFLAGS += \
	-Wstrict-aliasing=3
LOCAL_CPPFLAGS += \
	-Wstrict-aliasing=3
else
LOCAL_CONLYFLAGS += \
	-Wstrict-aliasing=2
LOCAL_CPPFLAGS += \
	-Wstrict-aliasing=2
endif
endif

ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)
  LOCAL_BASE_DISABLE_STRICT_ALIASING := \
    libpdfiumcore \
    libpdfium \
    libc_bionic \
    libc_dns \
    libc_gdtoa \
    libc_openbsd \
    libfs_mgr \
    libcutils \
    liblog \
    libc \
    adbd \
    libunwind \
    libziparchive \
    libsync \
    libnetutils \
    libRS \
    libbcinfo \
    libbccCore \
    libbccSupport \
    libstagefright_foundation \
    libusbhost \
    bluetooth.default \
    libbt-brcm_bta \
    libnetd_client \
    libbt-brcm_stack \
    bcc \
    debuggerd \
    toolbox \
    clatd \
    ip \
    libnetlink \
    libc_nomalloc \
    linker \
    libstagefright_avc_common \
    logd \
    libstagefright_webm \
    libstagefright_httplive \
    libstagefright_rtsp \
    sdcard \
    netd \
    libdiskconfig \
    audio.a2dp.default \
    libjavacore \
    libstagefright_avcenc \
    libRSDriver \
    libc_malloc \
    libRSSupport \
    libstlport \
    libandroid_runtime \
    libcrypto \
    libwnndict \
    libmedia \
    dnsmasq \
    ping \
    ping6 \
    libaudioflinger \
    libmediaplayerservice \
    libstagefright \
    libvariablespeed \
    librtp_jni \
    libwilhelm \
    libdownmix \
    libldnhncr \
    libqcomvisualizer \
    libvisualizer \
    libandroidfw \
    libstlport_static \
    tcpdump \
    libc_bionic_ndk \
    libc_openbsd_ndk \
    libskia \
    libosi \
    gatt_testtool \
    dex2oat \
    mdnsd \
    libavmediaserviceextensions \
    libart-compiler \
    libart \
    libart-disassembler \
    oatdump \
    patchoat \
    libssh \
    wpa_supplicant \
    libfdlibm \
    libuclibcrpc \
    busybox \
    libOmxVenc \
    fio

  # Check if there's already something somewhere.
  ifndef LOCAL_DISABLE_STRICT_ALIASING
    LOCAL_DISABLE_STRICT_ALIASING := \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  else
    LOCAL_DISABLE_STRICT_ALIASING += \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  endif
endif

###

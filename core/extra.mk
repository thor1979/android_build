# Copyright (C) 2014-2015 The SaberMod Project
# Copyright (c) 2015 Benzo Rom
# Copyright (c) 2015 CMRemix Roms
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
# Written for SaberMod toolchains

# Bluetooth
  LOCAL_BLUETOOTH_BLUEDROID := \
    bluetooth.default \
    libbt-brcm_stack \
    audio.a2dp.default \
    libbt-brcm_gki \
    libbt-utils \
    libbt-qcom_sbc_decoder \
    libbt-brcm_bta \
    bdt \
    bdtest \
    libbt-hci \
    libosi \
    ositests \
    libbt-vendor \
    libbluetooth_jni

# ENABLE_ARM_MODE
ifeq ($(strip $(ENABLE_ARM_MODE)),true)

  LOCAL_ARM_COMPILERS_WHITELIST_BASE := \
    libmincrypt \
    libc++abi \
    libjni_latinime_common_static \
    libcompiler_rt \
    libnativebridge \
    libc++ \
    libRSSupport \
    netd \
    libscrypt_static \
    libRSCpuRef \
    libRSDriver \
    liblog \
    logcat \
    logd \
    $(LOCAL_BLUETOOTH_BLUEDROID)

 ifndef LOCAL_ARM_COMPILERS_WHITELIST
 LOCAL_ARM_COMPILERS_WHITELIST := \
   $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
 else
 LOCAL_ARM_COMPILERS_WHITELIST += \
   $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
 endif

 ifeq ($(strip $(TARGET_ARCH)),arm)
  ifeq ($(strip $(ENABLE_ARM_MODE)),true)
    ifneq ($(strip $(LOCAL_IS_HOST_MODULE)),true)
      ifneq (1,$(words $(filter libLLVM% $(LOCAL_ARM_COMPILERS_WHITELIST),$(LOCAL_MODULE))))
        ifneq ($(filter arm thumb,$(LOCAL_ARM_MODE)),)
          LOCAL_TMP_ARM_MODE := $(filter arm thumb,$(LOCAL_ARM_MODE))
          LOCAL_ARM_MODE := $(LOCAL_TMP_ARM_MODE)
          ifeq ($(strip $(LOCAL_ARM_MODE)),arm)
            ifdef LOCAL_CFLAGS
              LOCAL_CFLAGS += -marm
            else
              LOCAL_CFLAGS := -marm
            endif
            ifeq ($(strip $(LOCAL_CLANG)),true)
#              LOCAL_CLANG := false
            endif
          endif
          ifeq ($(strip $(LOCAL_ARM_MODE)),thumb)
            ifdef LOCAL_CFLAGS
              LOCAL_CFLAGS += -mthumb-interwork
            else
              LOCAL_CFLAGS := -mthumb-interwork
            endif
          endif
        else
          LOCAL_ARM_MODE := arm
          ifdef LOCAL_CFLAGS
           LOCAL_CFLAGS += -marm
          else
            LOCAL_CFLAGS := -marm
          endif
        endif
        ifeq ($(strip $(LOCAL_CLANG)),true)
#            LOCAL_CLANG := false
        endif
      else
        ifndef LOCAL_ARM_MODE
          LOCAL_ARM_MODE := thumb
        endif
        ifeq ($(strip $(LOCAL_ARM_MODE)),arm)
          ifdef LOCAL_CFLAGS
          LOCAL_CFLAGS += -marm
          else
           LOCAL_CFLAGS := -marm
          endif
        endif
        ifeq ($(strip $(LOCAL_ARM_MODE)),thumb)
          ifdef LOCAL_CFLAGS
           LOCAL_CFLAGS += -mthumb-interwork
          else
           LOCAL_CFLAGS := -mthumb-interwork
          endif
        endif
      endif
    endif
  endif
 endif
endif

# TARGET_USE_PIPE
ifeq ($(TARGET_USE_PIPE),true)

 LOCAL_DISABLE_PIPE := \
    libc_dns \
    libc_tzcode \
    bluetooth.default

 ifeq ($(filter $(LOCAL_DISABLE_PIPE), $(LOCAL_MODULE)),)
  ifdef LOCAL_CONLYFLAGS
  LOCAL_CONLYFLAGS += \
        -pipe
  else
  LOCAL_CONLYFLAGS := \
        -pipe
  endif
  ifdef LOCAL_CPPFLAGS
  LOCAL_CPPFLAGS += \
	-pipe
  else
  LOCAL_CPPFLAGS := \
	-pipe
  endif
 endif
endif

# ENABLE_PTHREAD
ifeq ($(ENABLE_PTHREAD),true)

  LOCAL_DISABLE_PTHREAD := \
       camera.msm8084 \
       libc_netbsd

 ifeq ($(filter $(LOCAL_DISABLE_PTHREAD), $(LOCAL_MODULE)),)
  ifdef LOCAL_CONLYFLAGS
  LOCAL_CONLYFLAGS += -pthread
  else
  LOCAL_CONLYFLAGS := -pthread
  endif
  ifdef LOCAL_CPPFLAGS
  LOCAL_CPPFLAGS += -pthread
  else
  LOCAL_CPPFLAGS := -pthread
  endif
 endif
endif

# ENABLE_SANITIZE
ifeq ($(ENABLE_SANITIZE),true)

 ifneq ($(filter arm arm64,$(TARGET_ARCH)),)
  ifneq ($(strip $(LOCAL_IS_HOST_MODULE)),true)
   ifneq ($(strip $(LOCAL_CLANG)),true)
    ifdef LOCAL_CONLYFLAGS
    LOCAL_CONLYFLAGS += -fsanitize=leak
    else
    LOCAL_CONLYFLAGS := -fsanitize=leak
    endif
    ifdef LOCAL_CPPFLAGS
    LOCAL_CPPFLAGS += -fsanitize=leak
    else
    LOCAL_CPPFLAGS := -fsanitize=leak
    endif
   endif
  endif
 endif
endif

# ENABLE_GOMP
ifeq ($(ENABLE_GOMP),true)

  LOCAL_DISABLE_GOMP := \
       camera.msm8084 \
       libc_netbsd

 ifneq ($(filter arm arm64,$(TARGET_ARCH)),)
  ifneq ($(strip $(LOCAL_IS_HOST_MODULE)),true)
   ifneq ($(strip $(LOCAL_CLANG)),true)
    ifeq ($(filter $(LOCAL_DISABLE_GOMP), $(LOCAL_MODULE)),)
     ifdef LOCAL_CONLYFLAGS
     LOCAL_CONLYFLAGS += -fopenmp
     else
     LOCAL_CONLYFLAGS := -fopenmp
     endif
     ifdef LOCAL_CPPFLAGS
     LOCAL_CPPFLAGS += -fopenmp
     else
     LOCAL_CPPFLAGS := -fopenmp
     endif
    endif
   endif
  endif
 endif
endif

# ENABLE_GCCONLY
ifeq ($(ENABLE_GCCONLY),true)
 ifndef LOCAL_IS_HOST_MODULE
  ifeq ($(LOCAL_CLANG),)

  LOCAL_DISABLE_GCCONLY := \
    $(LOCAL_BLUETOOTH_BLUEDROID) \
	libwebviewchromium \
	libwebviewchromium_loader \
	libwebviewchromium_plat_support \
	liblog \
	logcat \
	logd

  GCCONLY_FLAGS := \
    -fira-loop-pressure \
	-fforce-addr \
	-funsafe-loop-optimizations \
	-funroll-loops \
	-ftree-loop-distribution \
	-fsection-anchors \
	-ftree-loop-im \
	-ftree-loop-ivcanon \
	-ffunction-sections \
	-fgcse-las \
	-fgcse-sm \
	-fweb \
	-ffp-contract=fast \
	-mvectorize-with-neon-quad

    ifeq ($(filter $(LOCAL_DISABLE_GCCONLY), $(LOCAL_MODULE)),)
    ifdef LOCAL_CONLYFLAGS
    LOCAL_CONLYFLAGS += \
       $(GCCONLY_FLAGS)
    else
    LOCAL_CONLYFLAGS := \
       $(GCCONLY_FLAGS)
    endif
    ifdef LOCAL_CPPFLAGS
    LOCAL_CPPFLAGS += \
       $(GCCONLY_FLAGS)
    else
    LOCAL_CPPFLAGS := \
       $(GCCONLY_FLAGS)
    endif
   endif
  endif
 endif
endif
###

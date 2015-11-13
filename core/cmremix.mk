#     _             _     _ ____            _     _
#    / \   _ __ ___| |__ (_)  _ \ _ __ ___ (_) __| |
#   / _ \ | '__/ __| '_ \| | | | | '__/ _ \| |/ _` |
#  / ___ \| | | (__| | | | | |_| | | | (_) | | (_| |
# /_/   \_\_|  \___|_| |_|_|____/|_|  \___/|_|\__,_|
#
# Copyright 2015 Łukasz "JustArchi" Domeradzki
# Contact: JustArchi@JustArchi.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#######################
### GENERAL SECTION ###
#######################

# General optimization level of target ARM compiled with GCC. Default: -O2
CMREMIX_GCC_CFLAGS_ARM := -O3

# General optimization level of target THUMB compiled with GCC. Default: -Os
CMREMIX_GCC_CFLAGS_THUMB := -Os

# Additional flags passed to all C targets compiled with GCC
CMREMIX_GCC_CFLAGS := -O3 -fgcse-las -fgcse-sm -fipa-pta -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftracer -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -Wno-error=array-bounds -Wno-error=clobbered -Wno-error=maybe-uninitialized -Wno-error=strict-overflow

############################
### EXPERIMENTAL SECTION ###
############################

# Flags in this section are highly experimental
# Current setup is based on proposed androideabi toolchain
# Results with other toolchains may vary

# These flags work fine in suggested compiler, but may cause ICEs in other compilers, comment if needed
CMREMIX_GCC_CFLAGS += -fgraphite -fgraphite-identity

# The following flags (-floop) require that your GCC has been configured with --with-isl
# Additionally, applying any of them will most likely cause ICE in your compiler, so they're disabled
# CMREMIX_GCC_CFLAGS += -floop-block -floop-interchange -floop-nest-optimize -floop-parallelize-all -floop-strip-mine

# These flags have been disabled because of assembler errors
# CMREMIX_GCC_CFLAGS += -fmodulo-sched -fmodulo-sched-allow-regmoves

####################
### MISC SECTION ###
####################

# Flags passed to GCC preprocessor for C and C++
CMREMIX_GCC_CPPFLAGS := $(CMREMIX_GCC_CFLAGS)

# Flags passed to linker (ld) of all C and C++ targets compiled with GCC
CMREMIX_GCC_LDFLAGS := -Wl,--sort-common

#####################
### CLANG SECTION ###
#####################

# Flags passed to all C targets compiled with CLANG
CMREMIX_CLANG_CFLAGS := -O3 -Qunused-arguments -Wno-unknown-warning-option

# Flags passed to CLANG preprocessor for C and C++
CMREMIX_CLANG_CPPFLAGS := $(CMREMIX_CLANG_CFLAGS)

# Flags passed to linker (ld) of all C and C++ targets compiled with CLANG
CMREMIX_CLANG_LDFLAGS := -O3 -Wl,--sort-common

# Only use Polly on Linux
ifeq ($(BUILD_OS),linux)
  POLLYCC := -mllvm -polly \
             -mllvm -polly-allow-nonaffine=1\
             -mllvm -polly-ignore-aliasing=1 \
             -mllvm -polly-ast-detect-parallel \
             -mllvm -polly-disable-multiplicative-reductions 
else
  POLLYCC := 
endif


ifeq ($(LOCAL_CLANG),true)
  ifdef POLLYCC
    ifneq (1,$(words $(filter $(DISABLE_POLLY),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += $(POLLYCC)
      else
        LOCAL_CFLAGS := $(POLLYCC)
      endif
      ifdef LOCAL_CPPFLAGS
        LOCAL_CPPFLAGS += $(POLLYCC)
      else
        LOCAL_CPPFLAGS := $(POLLYCC)
      endif
    endif
  endif
endif

# Disable Polly flags for certain modules
DISABLE_POLLY := \
   v8_tools_gyp_v8_%_arm_host_gyp%vv

# Flags that are used by GCC, but are unknown to CLANG. If you get "argument unused during compilation" error, add the flag here
CMREMIX_CLANG_UNKNOWN_FLAGS := \
  -mvectorize-with-neon-double \
  -mvectorize-with-neon-quad \
  -fgcse-after-reload \
  -fgcse-las \
  -fgcse-sm \
  -fgraphite \
  -fgraphite-identity \
  -fipa-pta \
  -floop-block \
  -floop-interchange \
  -floop-nest-optimize \
  -floop-parallelize-all \
  -ftree-parallelize-loops=2 \
  -ftree-parallelize-loops=4 \
  -ftree-parallelize-loops=8 \
  -ftree-parallelize-loops=16 \
  -floop-strip-mine \
  -fmodulo-sched \
  -fmodulo-sched-allow-regmoves \
  -frerun-cse-after-loop \
  -frename-registers \
  -fsection-anchors \
  -ftree-loop-im \
  -ftree-loop-ivcanon \
  -funsafe-loop-optimizations \
  -fweb

#####################
### HACKS SECTION ###
#####################

# Most of the flags are increasing code size of the output binaries, especially O3 instead of Os for target THUMB
# This may become problematic for small blocks, especially for boot or recovery blocks (ramdisks)
# If you don't care about the size of recovery.img, e.g. you have no use of it, and you want to silence the
# error "image too large" for recovery.img, use this definition
#
# NOTICE: It's better to use device-based flag TARGET_NO_RECOVERY instead, but some devices may have
# boot + recovery combo (e.g. Sony Xperias), and we must build recovery for them, so we can't set TARGET_NO_RECOVERY globally
# Therefore, this seems like a safe approach (will only ignore check on recovery.img, without doing anything else)
# However, if you use compiled recovery.img for your device, please disable this flag (comment or set to false), and lower
# optimization levels instead
#CMREMIX_IGNORE_RECOVERY_SIZE := true

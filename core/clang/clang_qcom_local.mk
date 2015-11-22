# Convert for CLANG QCOM
my_cflags := $(call convert-to-clang-qcom-flags,$(my_cflags))
my_cppflags := $(call convert-to-clang-qcom-flags,$(my_cppflags))
my_ldflags := $(call convert-to-clang-qcom-ldflags,$(my_ldflags))
LOCAL_CONLYFLAGS := $(call convert-to-clang-qcom-flags,$(LOCAL_CONLYFLAGS))

# Substitute -O2 and -O3 with -Ofast -fno-fast-math
ifneq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_DONT_REPLACE_WITH_Ofast_MODULES)))
my_cflags := $(call subst-clang-qcom-opt,$(my_cflags))
my_cppflags := $(call subst-clang-qcom-opt,$(my_cppflags))
LOCAL_CONLYFLAGS := $(call subst-clang-qcom-opt,$(LOCAL_CONLYFLAGS))
endif

# Flags and linking
my_cflags += $(CLANG_QCOM_CONFIG_Ofast_FLAGS)
my_cppflags += $(CLANG_QCOM_CONFIG_Ofast_FLAGS)
my_ldflags += $(CLANG_QCOM_CONFIG_LDFLAGS)
LOCAL_CONLYFLAGS += $(CLANG_QCOM_CONFIG_Ofast_FLAGS)  


ifneq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_DONT_USE_PARALLEL_MODULES)))
my_cflags += $(CLANG_QCOM_CONFIG_PARALLEL_FLAGS)
my_cppflags += $(CLANG_QCOM_CONFIG_PARALLEL_FLAGS)
my_asflags += $(CLANG_QCOM_CONFIG_PARALLEL_FLAGS)
my_ldflags += $(CLANG_QCOM_CONFIG_PARALLEL_FLAGS)
LOCAL_CONLYFLAGS += $(CLANG_QCOM_CONFIG_PARALLEL_FLAGS)
endif

# Set language dialect to C++11
ifeq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_C++11_MODULES)))
my_cppflags += -std=c++11
endif

# Set language dialect to C++11
ifeq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_GNU++11_MODULES)))
my_cppflags += -std=gnu++11
endif

ifeq ($(CLANG_QCOM_SHOW_FLAGS_LOCAL),true)
$(info local MODULE       : $(LOCAL_MODULE))
$(info cflags             : $(my_cflags))
$(info cppflags           : $(my_cppflags))
$(info asflags            : $(my_asflags))
$(info ldflags            : $(my_ldflags))    
$(info conly              : $(LOCAL_CONLYFLAGS))
$(info )
endif

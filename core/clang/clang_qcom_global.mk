ifneq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_FORCE_COMPILE_ACLANG_MODULES)))
  # Flags and linking
  my_target_c_includes += $(CLANG_QCOM_CONFIG_EXTRA_TARGET_C_INCLUDES)
  my_target_global_cflags := $(CLANG_QCOM_TARGET_GLOBAL_CFLAGS)
  my_target_global_cppflags := $(CLANG_QCOM_TARGET_GLOBAL_CPPFLAGS)
  my_target_global_ldflags := $(CLANG_QCOM_TARGET_GLOBAL_LDFLAGS)

  # -fparallel documentation 3.6.4
  #ifeq ($(LOCAL_MODULE),$(filter $(LOCAL_MODULE),$(CLANG_QCOM_USE_PARALLEL_MODULES)))
    my_target_global_cflags += $(CLANG_QCOM_CONFIG_KRAIT_PARALLEL_FLAGS)
    my_target_global_cppflags += $(CLANG_QCOM_CONFIG_KRAIT_PARALLEL_FLAGS)
    my_target_global_ldflags += $(CLANG_QCOM_CONFIG_KRAIT_PARALLEL_FLAGS)
  #endif

  # Invoke -marm if necessary because QCOM CLANG defaults to -mthumb
  ifeq ($(strip $(LOCAL_ARM_MODE)),arm)
    my_target_global_cflags += -marm
    my_target_global_cppflags += -marm
    my_target_global_ldflags += -marm
  endif

  ifeq ($(CLANG_QCOM_SHOW_FLAGS),true)
    $(info global MODULE       : $(LOCAL_MODULE))
    $(info global cflags       : $(my_target_global_cflags))
    $(info global cppflags     : $(my_target_global_cppflags))
    $(info global ldflags      : $(my_target_global_ldflags))
    $(info )
  endif

  # Set path to CLANG binary
  my_cc := $(CLANG_QCOM) $(CLANG_QCOM_CONFIG_KRAIT_MEM_FLAGS) $(CLANG_QCOM_CONFIG_KRAIT_PARALLEL_FLAGS)
  my_cxx := $(CLANG_QCOM_CXX) $(CLANG_QCOM_CONFIG_KRAIT_MEM_FLAGS) $(CLANG_QCOM_CONFIG_KRAIT_PARALLEL_FLAGS)
endif

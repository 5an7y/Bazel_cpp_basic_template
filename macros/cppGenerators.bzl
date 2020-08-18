load("@rules_cc//cc:defs.bzl", "cc_test")

def cpp_library(name, source, header, dependencies=[]):
  if len(dependencies) > 0:
    native.cc_library(
      name = name,
      srcs = source,
      hdrs = header,
      deps = dependencies,
      visibility = ["//code:__pkg__"],
    )
  else:
    native.cc_library(
      name = name,
      srcs = source,
      hdrs = header,
      visibility = ["//visibility:public"],
    )

def cpp_binary(name, source, include_paths = [], dependencies=[]):
  if len(dependencies) > 0:    
    native.cc_binary(
      name = name,
      srcs = source,
      copts = include_paths + ["-Icode/libs"],
      deps = dependencies,
    )
  else:
    native.cc_binary(
      name = name,
      srcs = source,
      copts = include_paths + ["-Icode/libs"],
    )

def cpp_test(name, source, include_paths = [], dependencies=[]):    
  native.cc_test(
    name = name,
    srcs = source,
    copts = include_paths + ["-Icode/libs"],
    deps = dependencies + ["@googletest//:gtest_main"],
  )
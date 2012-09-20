##############################################################################
# @file  FindSVMTorch.cmake
# @brief Find SVMTorch II package.
#
# @par Input varibales:
# <table border="0">
#   <tr>
#     @tp @b SVMTorch_DIR @endtp
#     <td>The SVMTorch package files are searched primarily under the specified
#         root directory. This variable can be alternatively set as environment
#         variable.</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_FIND_COMPONENTS @endtp
#     <td>@c COMPONENTS of SVMTorch to look for: @c train, @c test, @c lib. (default: @c train, @c test)</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_FIND_OPTIONAL_COMPONENTS @endtp
#     <td>@c OPTIONAL_COMPONENTS of SVMTorch to look for: @c train, @c test, @c lib. (default: @c lib)</td>
#   </tr>
# </table>
#
# @par Output variables:
# <table border="0">
#   <tr>
#     @tp @b SVMTorch_FOUND @endtp
#     <td>Whether the package was found and the following CMake variables are valid.</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_INCLUDE_DIR @endtp
#     <td>The directory containing the include files.</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_LIBRARY @endtp
#     <td>Found object files (.o).</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_train_EXECUTABLE @endtp
#     <td>Absolute path of found @c SVMTorch executable.</td>
#   </tr>
#   <tr>
#     @tp @b SVMTorch_test_EXECUTABLE @endtp
#     <td>Absolute path of found @c SVMTest executable.</td>
#   </tr>
#   <tr>
#     @tp @b svmtorch.train @endtp
#     <td>Import target of @c SVMTorch executable.</td>
#   </tr>
#   <tr>
#     @tp @b svmtorch.test @endtp
#     <td>Import target of @c SVMTest executable.</td>
#   </tr>
# </table>
#
# Copyright (c) 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup CMakeFindModules
##############################################################################

# ----------------------------------------------------------------------------
# initialize search
if (NOT SVMTorch_DIR)
  set (SVMTorch_DIR "$ENV{SVMTorch_DIR}" CACHE PATH "Installation prefix of SVMTorch." FORCE)
endif ()

if (NOT SVMTorch_FIND_COMPONENTS AND NOT SVMTorch_FIND_OPTIONAL_COMPONENTS)
  set (SVMTorch_FIND_COMPONENTS          train test)
  set (SVMTorch_FIND_OPTIONAL_COMPONENTS lib)
endif ()

set (_SVMTorch_COMPONENTS ${SVMTorch_FIND_COMPONENTS} ${SVMTorch_FIND_OPTIONAL_COMPONENTS})

#--------------------------------------------------------------
# find executables
if (_SVMTorch_COMPONENTS MATCHES train)
  if (SVMTorch_DIR)
    find_program (
      SVMTorch_train_EXECUTABLE
        NAMES         SVMTorch
        HINTS         ${SVMTorch_DIR}
        DOC           "The SVMTorch executable."
        NO_DEFAULT_PATH
    )
  else ()
    find_program (
      SVMTorch_train_EXECUTABLE
        NAMES SVMTorch
        DOC   "The SVMTorch executable."
    )
  endif ()
  mark_as_advanced (SVMTorch_train_EXECUTABLE)
  if (SVMTorch_train_EXECUTABLE)
    add_executable (svmtorch.train IMPORTED)
    set_target_properties (svmtorch.train PROPERTIES IMPORTED_LOCATION "${SVMTorch_train_EXECUTABLE}")
  endif ()
endif ()

if (_SVMTorch_COMPONENTS MATCHES test)
  if (SVMTorch_DIR)
    find_program (
      SVMTorch_test_EXECUTABLE
        NAMES         SVMTest
        HINTS         ${SVMTorch_DIR}
        DOC           "The SVMTest executable."
        NO_DEFAULT_PATH
    )
  else ()
    find_program (
      SVMTorch_test_EXECUTABLE
        NAMES SVMTest
        DOC   "The SVMTest executable."
    )
  endif ()
  mark_as_advanced (SVMTorch_test_EXECUTABLE)
  if (SVMTorch_test_EXECUTABLE)
    add_executable (svmtorch.test IMPORTED)
    set_target_properties (svmtorch.test PROPERTIES IMPORTED_LOCATION "${SVMTorch_test_EXECUTABLE}")
  endif ()
endif ()

#--------------------------------------------------------------
# derive SVMTorch_DIR if not set yet
if (NOT SVMTorch_DIR)
  if (SVMTorch_train_EXECUTABLE)
    get_filename_component (SVMTorch_DIR "${SVMTorch_train_EXECUTABLE}" PATH)
  elseif (SVMTorch_test_EXECUTABLE)
    get_filename_component (SVMTorch_DIR "${SVMTorch_test_EXECUTABLE}" PATH)
  endif ()
  set (SVMTorch_DIR "${SVMTorch_DIR}" CACHE PATH "Installation prefix of SVMTorch." FORCE)
endif ()

#--------------------------------------------------------------
# find header files and built object files
if (_SVMTorch_COMPONENTS MATCHES lib)
  if (SVMTorch_DIR)
    find_path (
      SVMTorch_INCLUDE_DIR
      NAMES IOTorch.h
      HINTS "${SVMTorch_DIR}"
      DOC   "Directory containing the header files of SVMTorch (i.e., IOTorch.h)."
      NO_DEFAULT_PATH
    )
    file (GLOB SVMTorch_LIBRARY "${SVMTorch_DIR}/*.o")
    mark_as_advanced (SVMTorch_INCLUDE_DIR)
  else ()
    find_path (
      SVMTorch_INCLUDE_DIR
      NAMES IOTorch.h
      DOC   "Directory containing the header files of SVMTorch (i.e., IOTorch.h)."
    )
    mark_as_advanced (SVMTorch_INCLUDE_DIR)
    set (SVMTorch_LIBRARY)
  endif ()
endif ()

# ----------------------------------------------------------------------------
# handle the QUIETLY and REQUIRED arguments and set *_FOUND to TRUE
# if all listed variables are found or TRUE
include (FindPackageHandleStandardArgs)

set (SVMTorch_REQUIRED_VARS)
if (SVMTorch_FIND_COMPONENTS MATCHES train)
  list (APPEND SVMTorch_REQUIRED_VARS SVMTorch_train_EXECUTABLE)
endif ()
if (SVMTorch_FIND_COMPONENTS MATCHES test)
  list (APPEND SVMTorch_REQUIRED_VARS SVMTorch_test_EXECUTABLE)
endif ()
if (SVMTorch_FIND_COMPONENTS MATCHES obj)
  list (APPEND SVMTorch_REQUIRED_VARS SVMTorch_INCLUDE_DIR)
  list (APPEND SVMTorch_REQUIRED_VARS SVMTorch_LIBRARY)
endif ()

find_package_handle_standard_args (SVMTorch DEFAULT_MSG ${SVMTorch_REQUIRED_VARS})


unset (_SVMTorch_COMPONENTS)

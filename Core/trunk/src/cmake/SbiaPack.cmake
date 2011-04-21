##############################################################################
# \file  SbiaPack.cmake
# \brief CPack configuration. Include this module instead of CPack.
#
# Overwrite the package information set by this module either in a file
# Package.cmake or a file Package.cmake.in located in the directory
# specified by PROJECT_CONFIG_DIR. The latter is configured and copied to the
# binary tree before included by this module. Further, to enable a
# component-based installation, provide either a file Components.cmake or
# Components.cmake.in again in the directory specified by PROJECT_CONFIG_DIR.
# Also in this case, the latter is configured via CMake's configure_file ()
# before use. This file is referred to as components definition (file).
#
# Components can be added in the components definition using the SBIA command
# sbia_add_component (). Several components can be grouped together and a
# group description be added using the command sbia_add_component_group ().
# Different pre-configured install types which define a certain selection of
# components to install can be added using sbia_add_install_type (). Note that
# all these SBIA functions are wrappers around the corresponding CPack
# functions.
#
# \see CPack.cmake
# \see http://www.vtk.org/Wiki/CMake:Component_Install_With_CPack \
#      #Component-Based_Installers_with_CPack
#
# Copyright (c) 2011 Univeristy of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT SBIA_PACK_INCLUDED)
set (SBIA_PACK_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# system libraries
# ============================================================================

# install required runtime libraries
include (InstallRequiredSystemLibraries)

# ============================================================================
# package information
# ============================================================================

set (CPACK_PACKAGE_NAME                "${PROJECT_NAME}")
set (CPACK_PACKAGE_VERSION_MAJOR       "${PROJECT_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR       "${PROJECT_VERSION_MINOR}")
set (CPACK_PACKAGE_VERSION_PATCH       "${PROJECT_VERSION_PATCH}")
set (CPACK_PACKAGE_VERSION             "${PROJECT_VERSION}")
set (CPACK_PACKAGE_VENDOR              "${PROJECT_PACKAGE_VENDOR}")
set (CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set (CPACK_PACKAGE_DESCRIPTION_FILE    "${PROJECT_README_FILE}")
set (CPACK_RESOURCE_FILE_README        "${PROJECT_README_FILE}")
set (CPACK_RESOURCE_FILE_LICENSE       "${PROJECT_LICENSE_FILE}")

set (CPACK_GENERATOR                   "STGZ" "TGZ")
set (CPACK_SOURCE_GENERATOR            "TGZ")
set (CPACK_INCLUDE_TOPLEVEL_DIRECTORY  "1")

# ----------------------------------------------------------------------------
# \todo The proper values for the following options still need to be
#       figured. For the moment, just ignore these settings. NSIS might
#       anyways not be supported in the near future.
# ----------------------------------------------------------------------------

if (WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
#  set (CPACK_PACKAGE_ICON             "${CMake_SOURCE_DIR}/Utilities/Release\\\\InstallIcon.bmp")
#  set (CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\MyExecutable.exe")
#  set (CPACK_NSIS_DISPLAY_NAME        "${CPACK_PACKAGE_INSTALL_DIRECTORY} ${PROJECT_NAME}")
#  set (CPACK_NSIS_HELP_LINK           "http:\\\\\\\\www.my-project-home-page.org")
#  set (CPACK_NSIS_URL_INFO_ABOUT      "http:\\\\\\\\www.my-personal-home-page.com")
  set (CPACK_NSIS_CONTACT             "sbia-software@uphs.upenn.edu")
  set (CPACK_NSIS_MODIFY_PATH         "ON")
else ()
#  set (CPACK_STRIP_FILES        "bin/MyExecutable")
#  set (CPACK_SOURCE_STRIP_FILES "")
endif ()

# ============================================================================
# source package
# ============================================================================

set (
  CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES}"
	"/CVS/"
	"/.svn/"
	".swp$"
	".#"
	"/#"
	".*~"
	"cscope.*"
	"[b|B]uild"
)

# ============================================================================
# include project package information
# ============================================================================

if (EXISTS "${PROJECT_CONFIG_DIR}/Package.cmake.in")
  configure_file ("${PROJECT_CONFIG_DIR}/Package.cmake.in"
                  "${PROJECT_BINARY_DIR}/Package.cmake" @ONLY)
  include ("${PROJECT_BINARY_DIR}/Package.cmake")
elseif (EXISTS "${PROJECT_CONFIG_DIR}/Package.cmake")
  include ("${PROJECT_CONFIG_DIR}/Package.cmake")
endif ()

# ============================================================================
# build package
# ============================================================================

include (CPack)

# ============================================================================
# components
# ============================================================================

# ----------------------------------------------------------------------------
# utilities
# ----------------------------------------------------------------------------

# ****************************************************************************
# \brief Add component group.
#
# \attention This functionality is not yet entirely implemented.
# \todo Come up and implement components concept which fits into superproject concept.
#
# \see http://www.cmake.org/pipermail/cmake/2008-August/023336.html
# \see cpack_add_component_group ()
#
# \param [in] GRPNAME Name of the component group.
# \param [in] ARGN    Further arguments passed to cpack_add_component_group ().

function (sbia_add_component_group GRPNAME)
  set (OPTION_NAME)
  set (PARENT_GROUP)

  foreach (ARG ${ARGN})
    if (OPTION_NAME)
      set (${OPTION_NAME} "${ARG}")
      set (OPTION_NAME)
      break ()
    else ()
      if ("${ARG}" STREQUAL "PARENT_GROUP")
        set (OPTION_NAME "PARENT_GROUP")
      endif ()
    endif ()
  endforeach ()

  cpack_add_component_group (${GRPNAME} ${ARGN})

  add_custom_target (install_${GRPNAME})

  if (PARENT_GROUP)
    add_dependencies (install_${PARENT_GROUP} install_${GRPNAME})
  endif ()
endfunction ()

# ****************************************************************************
# \brief Add component.
#
# \attention This functionality is not yet entirely implemented.
# \todo Come up and implement components concept which fits into superproject concept.
#
# \see http://www.cmake.org/pipermail/cmake/2008-August/023336.html
# \see cpack_add_component ()
#
# \param [in] COMPNAME Name of the component.
# \param [in] ARGN     Further arguments passed to cpack_add_component ().

function (sbia_add_component COMPNAME)
  set (OPTION_NAME)
  set (GROUP)

  foreach (ARG ${ARGN})
    if (OPTION_NAME)
      set (${OPTION_NAME} "${ARG}")
      set (OPTION_NAME)
      break ()
    else ()
      if ("${ARG}" STREQUAL "GROUP")
        set (OPTION_NAME "GROUP")
      endif ()
    endif ()
  endforeach ()

  cpack_add_component (${COMPNAME} ${ARGN})

  add_custom_target (
    install_${COMPNAME}
    COMMAND "${CMAKE_COMMAND}" -DCOMPONENT=${COMPNAME}
            -P "${PROJECT_BINARY_DIR}/cmake_install.cmake"
  )

  if (GROUP)
    add_dependencies (install_${GROUP} install_${COMPNAME})
  endif ()
endfunction ()

# ****************************************************************************
# \brief Add pre-configured install type.

function (sbia_add_install_type)
  cpack_add_install_type (${ARGN})
endfunction ()

# ----------------------------------------------------------------------------
# include components definition
# ----------------------------------------------------------------------------

if (EXISTS "${PROJECT_CONFIG_DIR}/Components.cmake.in")
  configure_file ("${PROJECT_CONFIG_DIR}/Components.cmake.in"
                  "${PROJECT_BINARY_DIR}/Components.cmake" @ONLY)
  include ("${PROJECT_BINARY_DIR}/Components.cmake")
elseif (EXISTS "${PROJECT_CONFIG_DIR}/Components.cmake")
  include ("${PROJECT_CONFIG_DIR}/Components.cmake")
endif ()


endif (NOT SBIA_PACK_INCLUDED)


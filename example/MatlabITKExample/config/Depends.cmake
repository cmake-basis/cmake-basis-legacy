##############################################################################
# \file  Depends.cmake
# \brief Contains find_package () commands to resolve dependencies.
#
# This file is included by the macro basis_project_initialize () if found in
# the directory PROJECT_CONFIG_DIR. It is supposed to resolve dependencies
# to other packages using the find_package () or find_basis_package ()
# command of CMake.
#
# If no CMake find module (i.e., Find<project>.cmake) for an external package
# is available and the package does not provide a <project>Config.cmake or
# <project>-config.cmake file, write your own find module and store it in the
# PROJECT_CONFIG_DIR folder of the project or have someone else write one for
# you. Consider also to inform the maintainer of the BASIS package to
# integrate your module into the collection of BASIS CMake modules. If the
# external package might become popular also for use by other, it is even
# more likely that the BASIS developer will provide you with a CMake module.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See COPYING file in project root or 'doc' directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################


# ----------------------------------------------------------------------------
# Matlab
# ----------------------------------------------------------------------------

find_package (Matlab REQUIRED)

if (MATLAB_FOUND)
  if (MATLAB_INCLUDE_DIRS)
    include_directories (${MATLAB_INCLUDE_DIRS})
  elseif (MATLAB_INCLUDE_DIR)
    include_directories (${MATLAB_INCLUDE_DIR})
  endif ()
else ()
  # raise fatal error in case FindMatlab.cmake did not do it
  message (FATAL_ERROR "Package Matlab not found.")
endif ()

# ----------------------------------------------------------------------------
# ITK
# ----------------------------------------------------------------------------

find_package (ITK REQUIRED)

if (ITK_FOUND)
  include (${ITK_USE_FILE})
else ()
  # raise fatal error in case FindITK.cmake did not do it
  message (FATAL_ERROR "Package ITK not found.")
endif ()

# Copyright (c) 2020 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

file(GLOB_RECURSE srcs ${CMAKE_SOURCE_DIR}/templates/*.m4)

set(M4FLAGS ${M4FLAGS} -E
  -I ${CMAKE_SOURCE_DIR}/templates
  -I ${CMAKE_SOURCE_DIR}/templates/m4docker/system
  -I ${CMAKE_SOURCE_DIR}/templates/m4docker/components
  -D BUILD_PATCHES=patches)

add_custom_command(OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/native/Dockerfile
  DEPENDS ${srcs}
    ${CMAKE_CURRENT_SOURCE_DIR}/native/Dockerfile.m4
  COMMAND ${M4} ${M4FLAGS} -D OS_NAME=ubuntu -D OS_VERSION=20.04
    ${CMAKE_CURRENT_SOURCE_DIR}/native/Dockerfile.m4 > ${CMAKE_CURRENT_SOURCE_DIR}/native/Dockerfile
  VERBATIM
  )

add_custom_command(OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx/Dockerfile
  DEPENDS ${srcs}
    ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx/Dockerfile.m4
  COMMAND ${M4} ${M4FLAGS} -D OS_NAME=ubuntu -D OS_VERSION=20.04
    ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx/Dockerfile.m4 > ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx/Dockerfile
  VERBATIM
  )

add_custom_command(OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx-embargo/Dockerfile
  DEPENDS ${srcs}
    ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx-embargo/Dockerfile.m4
  COMMAND ${M4} ${M4FLAGS} -D OS_NAME=ubuntu -D OS_VERSION=20.04
    ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx-embargo/Dockerfile.m4 > ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx-embargo/Dockerfile
  VERBATIM
  )

add_custom_target(ubuntu20.04-dockerfiles ALL DEPENDS
  ${CMAKE_CURRENT_SOURCE_DIR}/native/Dockerfile
  ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx/Dockerfile
  ${CMAKE_CURRENT_SOURCE_DIR}/intel-gfx-embargo/Dockerfile)

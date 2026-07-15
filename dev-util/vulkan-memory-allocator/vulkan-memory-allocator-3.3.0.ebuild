# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="VulkanMemoryAllocator"

DESCRIPTION="Easy to integrate Vulkan memory allocation library (header-only)"
HOMEPAGE="https://gpuopen.com/vulkan-memory-allocator/"
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/vulkan-headers"

# Header-only: the cmake build just installs vk_mem_alloc.h plus the
# VulkanMemoryAllocator CMake config that consumers find_package().

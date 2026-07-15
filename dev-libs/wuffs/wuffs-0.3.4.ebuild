# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Wrangling Untrusted File Formats Safely - single-file C library"
HOMEPAGE="https://github.com/google/wuffs"
SRC_URI="https://github.com/google/wuffs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Single-file library, consumed by #including the .c file (e.g. by
# www-client/ladybird's LibGfx GIF decoder). Nothing to compile here.
src_install() {
	insinto /usr/include/wuffs
	doins release/c/wuffs-v${PV%.*}.c
}

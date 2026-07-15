# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic ninja-utils python-any-r1 toolchain-funcs

# Tip of the upstream chrome/m${PV} branch (2026-06-12). Ladybird pins the
# skia milestone via vcpkg.json overrides and its CMake checks skia=${PV}
# from skia.pc, so PV must stay in sync with the milestone number.
MY_COMMIT="46f2e16555cac1211f4087cf24728fd741ac6495"

DESCRIPTION="2D graphics library for drawing text, geometries and images"
HOMEPAGE="https://skia.org/"
SRC_URI="https://github.com/google/skia/archive/${MY_COMMIT}.tar.gz -> ${P}-${MY_COMMIT::10}.tar.gz"
S="${WORKDIR}/skia-${MY_COMMIT}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/expat
	dev-libs/icu:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libwebp:=
	media-libs/mesa
	sys-libs/zlib
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
	dev-util/vulkan-memory-allocator
"
BDEPEND="
	${PYTHON_DEPS}
	dev-build/gn
	dev-build/ninja
"

src_prepare() {
	default

	# Use system gn rather than the (absent) bundled //bin/gn.
	sed -i 's|rebase_path("//bin/gn")|"gn"|' BUILD.gn || die

	# System-zlib detection workaround (same hack as nixpkgs).
	sed -i 's|"//third_party/zlib",||' BUILD.gn || die

	# Ladybird relies on the deprecated SkPath edit methods that the vcpkg
	# skia port re-enables (ports/skia/skpath-enable-edit-methods.patch).
	sed -i '/"SK_HIDE_PATH_EDIT_METHODS",/d' BUILD.gn || die
	grep -q SK_HIDE_PATH_EDIT_METHODS BUILD.gn && die "SK_HIDE_PATH_EDIT_METHODS still set"
}

# Quote a list of flags as a gn string list: ["a", "b", ...]
gn_list() {
	local f out=""
	for f in "$@"; do
		out+="\"${f//\"/\\\"}\", "
	done
	echo "[${out%, }]"
}

src_configure() {
	# -flto and the -Werror= diagnostic promotions from make.conf are known
	# to break large C++ builds; skia is built with its own LTO decisions.
	filter-lto
	filter-flags -Werror=strict-aliasing -Werror=odr -Werror=lto-type-mismatch

	python_setup

	local extra_cflags=(
		"-I${ESYSROOT}/usr/include/harfbuzz"
		# Ladybird needs the skcms symbols exported from libskia.so
		'-DSKCMS_API=[[gnu::visibility("default")]]'
	)

	local myargs=(
		is_official_build=true
		is_component_build=true
		is_debug=false
		skia_use_dng_sdk=false
		skia_use_wuffs=false
		skia_use_vulkan=true
		skia_use_system_expat=true
		skia_use_system_freetype2=true
		skia_use_system_harfbuzz=true
		skia_use_system_icu=true
		skia_use_system_libjpeg_turbo=true
		skia_use_system_libpng=true
		skia_use_system_libwebp=true
		skia_use_system_zlib=true
		"cc=\"$(tc-getCC)\""
		"cxx=\"$(tc-getCXX)\""
		"ar=\"$(tc-getAR)\""
		'target_cpu="x64"'
		"extra_cflags=$(gn_list "${extra_cflags[@]}")"
		"extra_cflags_c=$(gn_list ${CFLAGS})"
		"extra_cflags_cc=$(gn_list ${CXXFLAGS})"
		"extra_ldflags=$(gn_list ${LDFLAGS})"
	)

	set -- gn gen out --args="${myargs[*]}"
	echo "$@"
	"$@" || die "gn gen failed"
}

src_compile() {
	eninja -C out
}

src_install() {
	dolib.so out/*.so

	# Header layout matches what Ladybird (and nixpkgs) expect: everything
	# under /usr/include/skia with the source tree's include/ flattened away.
	local f
	pushd include >/dev/null || die
	while IFS= read -r -d '' f; do
		insinto "/usr/include/skia/${f%/*}"
		doins "${f}"
	done < <(find . -name '*.h' -print0)
	popd >/dev/null || die

	pushd modules >/dev/null || die
	while IFS= read -r -d '' f; do
		insinto "/usr/include/skia/modules/${f%/*}"
		doins "${f}"
	done < <(find . -name '*.h' -print0)
	popd >/dev/null || die

	# Skia headers reference each other as "include/...", but the include/
	# level does not exist in the installed tree.
	find "${ED}/usr/include/skia" -name '*.h' \
		-exec sed -i 's|#include "include/|#include "|' {} + || die

	insinto "/usr/$(get_libdir)/pkgconfig"
	newins - skia.pc <<-EOF
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include/skia

		Name: skia
		Description: 2D graphic library for drawing text, geometries and images
		URL: https://skia.org/
		Version: ${PV}
		Libs: -L\${libdir} -lskia
		Cflags: -I\${includedir}
	EOF
}

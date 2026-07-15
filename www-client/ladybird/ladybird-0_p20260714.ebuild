# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adblock@0.12.5
	addr@0.15.6
	aho-corasick@1.1.4
	allocator-api2@0.2.21
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	arbitrary@1.4.2
	arrayvec@0.7.6
	autocfg@1.5.0
	base64@0.22.1
	bitflags@2.11.0
	bumpalo@3.20.2
	calendrical_calculations@0.2.4
	cbindgen@0.29.2
	cfg-if@1.0.4
	chardetng@1.0.0
	clap@4.6.0
	clap_builder@4.6.0
	clap_lex@1.1.0
	colorchoice@1.0.5
	core_maths@0.1.1
	cranelift-bforest@0.116.1
	cranelift-bitset@0.116.1
	cranelift-codegen-meta@0.116.1
	cranelift-codegen-shared@0.116.1
	cranelift-codegen@0.116.1
	cranelift-control@0.116.1
	cranelift-entity@0.116.1
	cranelift-frontend@0.116.1
	cranelift-isle@0.116.1
	cranelift-module@0.116.1
	cranelift-native@0.116.1
	displaydoc@0.2.5
	either@1.16.0
	encoding_rs@0.8.35
	equivalent@1.0.2
	errno@0.3.14
	fallible-iterator@0.3.0
	fastrand@2.4.0
	flatbuffers@25.12.19
	foldhash@0.1.5
	form_urlencoded@1.2.2
	getrandom@0.4.2
	gimli@0.31.1
	hashbrown@0.14.5
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	icu_calendar@2.2.1
	icu_calendar_data@2.2.0
	icu_collections@2.2.0
	icu_locale@2.2.0
	icu_locale_core@2.2.0
	icu_locale_data@2.2.0
	icu_normalizer@2.2.0
	icu_normalizer_data@2.2.0
	icu_properties@2.2.0
	icu_properties_data@2.2.0
	icu_provider@2.2.0
	id-arena@2.3.0
	idna@1.1.0
	idna_adapter@1.2.2
	indexmap@2.13.1
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itoa@1.0.18
	ixdtf@0.6.5
	leb128fmt@0.1.0
	libc@0.2.184
	libm@0.2.16
	linux-raw-sys@0.12.1
	litemap@0.8.2
	log@0.4.29
	memchr@2.8.0
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	percent-encoding@2.3.2
	potential_utf@0.1.5
	precomputed-hash@0.1.1
	prettyplease@0.2.37
	proc-macro2@1.0.106
	psl-types@2.0.11
	psl@2.1.210
	quote@1.0.45
	r-efi@6.0.0
	regalloc2@0.11.2
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustc-hash@1.1.0
	rustc-hash@2.1.2
	rustc_version@0.4.1
	rustix@1.1.4
	seahash@4.1.0
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_spanned@1.1.1
	smallvec@1.15.1
	stable_deref_trait@1.2.1
	strsim@0.11.1
	syn@2.0.117
	synstructure@0.13.2
	target-lexicon@0.13.5
	tempfile@3.27.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tinystr@0.8.3
	toml@0.9.12+spec-1.1.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	url@2.5.8
	utf8_iter@1.0.4
	utf8parse@0.2.2
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	windows-link@0.2.1
	windows-sys@0.61.2
	winnow@0.7.15
	winnow@1.0.1
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	writeable@0.6.3
	yoke-derive@0.8.2
	yoke@0.8.2
	yuv@0.8.13
	zerofrom-derive@0.1.7
	zerofrom@0.1.7
	zerotrie@0.2.4
	zerovec-derive@0.11.3
	zerovec@0.11.6
	zmij@1.0.21
"

PYTHON_COMPAT=( python3_{11..14} )
RUST_MIN_VER="1.96.1"

inherit cargo cmake flag-o-matic python-any-r1 toolchain-funcs xdg

# master snapshot; upstream has no releases yet
MY_COMMIT="05a99cc050636c8fe57ed9cccc2c372a5152434c"
# chromium/chromium main at the time of snapshotting, for the HSTS preload
# list normally downloaded at build time (Meta/CMake/hsts_preload.cmake)
HSTS_COMMIT="371970f8420950d531c2132e3a46afb23e614472"
HSTS_FILE="${P}-hsts-${HSTS_COMMIT::10}.json"
# tip of ANGLE's chromium/7258 branch (the vcpkg.json override pin); we only
# need its GLES2/gl2ext_angle.h - the entry points themselves come from
# files/angle-shim.c forwarding to Mesa's GLES3 core exports
ANGLE_COMMIT="d9fc4a372074b1079c193c422fc4a180e79b6636"
ANGLE_HDR="${P}-gl2ext_angle-${ANGLE_COMMIT::10}.h"

DESCRIPTION="Truly independent web browser using the LibWeb engine"
HOMEPAGE="https://ladybird.org https://github.com/LadybirdBrowser/ladybird"
SRC_URI="
	https://github.com/LadybirdBrowser/ladybird/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/chromium/chromium/${HSTS_COMMIT}/net/http/transport_security_state_static.json -> ${HSTS_FILE}
	https://raw.githubusercontent.com/google/angle/${ANGLE_COMMIT}/include/GLES2/gl2ext_angle.h -> ${ANGLE_HDR}
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="BSD-2"
# crates
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
# tests want network-fetched data (wasm spec suite) and a display
RESTRICT="test"

# ICU is find_package()d with EXACT version - keep in lockstep with upstream's
# vcpkg.json override. Same for the skia milestone.
DEPEND="
	app-arch/brotli
	dev-cpp/cpptrace:=
	dev-cpp/fast_float
	dev-cpp/simdutf:=
	dev-db/sqlite:3
	~dev-libs/icu-78.3:=
	dev-libs/libedit
	dev-libs/libfmt:=
	dev-libs/libtommath
	dev-libs/libxml2
	<dev-libs/mimalloc-3:=
	dev-libs/openssl:=
	dev-libs/simdjson:=
	dev-libs/wuffs
	dev-qt/qtbase:6[gui,widgets]
	media-libs/fontconfig
	media-libs/harfbuzz:=
	media-libs/libavif:=
	media-libs/libjpeg-turbo:=
	media-libs/libjxl:=
	media-libs/libpng:=
	media-libs/libpulse
	media-libs/libsdl3
	media-libs/libwebp:=
	media-libs/mesa
	=media-libs/skia-148*:=
	media-libs/vulkan-loader
	media-libs/woff2
	media-video/ffmpeg:=
	net-libs/libpsl
	net-misc/curl[websockets]
	sys-libs/zlib
	virtual/libcrypt:=
	x11-libs/libdrm
"
DEPEND+="
	dev-util/vulkan-headers
	dev-util/vulkan-memory-allocator
"
RDEPEND="
	${DEPEND}
	dev-qt/qtwayland:6
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.25
	dev-build/ninja
	dev-util/glslang
	virtual/pkgconfig
"

PATCHES=(
	# pthread_getschedparam needs sched_getparam too; without it the
	# Compositor dies in the sandbox on this kernel
	"${FILESDIR}/${P}-seccomp-sched_getparam.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	# keep the HSTS json and ANGLE header away from unpack(); they are
	# consumed straight from DISTDIR in src_prepare
	local myA="${A/${HSTS_FILE}/}"
	myA="${myA/${ANGLE_HDR}/}"
	A="${myA}" cargo_src_unpack
}

src_prepare() {
	cmake_src_prepare

	# Gentoo's toolchain already defines _FORTIFY_SOURCE; upstream's
	# unconditional redefinition trips their -Werror
	sed -i '/add_cxx_compile_definitions(_FORTIFY_SOURCE=3)/d' \
		Meta/CMake/compile_options.cmake || die
	# don't let warnings from a newer GCC than upstream CI kill the build
	sed -i 's/add_cxx_compile_options(-Werror)/add_cxx_compile_options(-Wno-error)/' \
		Meta/CMake/compile_options.cmake || die
	# GCC 16 leaves inline-virtual vtable references (e.g.
	# AK::FixedMemoryStream::read_some) dangling across the shared-lib
	# boundary under -fvisibility-inlines-hidden - the exact address-taken
	# hazard GCC's docs warn about. Drop the flag.
	sed -i '/add_cxx_compile_options(-fvisibility-inlines-hidden)/d' \
		Meta/CMake/compile_options.cmake || die

	mkdir -p "${WORKDIR}/caches/HSTSPreload" || die
	cp "${DISTDIR}/${HSTS_FILE}" \
		"${WORKDIR}/caches/HSTSPreload/transport_security_state_static.json" || die

	# Ladybird hard-links ANGLE for WebGL (34 ANGLE-only entry points plus
	# GLES2/gl2ext_angle.h). Instead of packaging ANGLE we bridge those
	# entry points onto Mesa's GLES3 core exports with a small static
	# archive, and hand the pinned ANGLE header to the compiler.
	# (-lGL: skia GL glue references desktop GL symbols, see upstream #371)
	mkdir -p "${T}/angle/include/GLES2" "${T}/pkgconfig" || die
	cp "${DISTDIR}/${ANGLE_HDR}" "${T}/angle/include/GLES2/gl2ext_angle.h" || die

	cat > "${T}/pkgconfig/angle.pc" <<-EOF || die
		Name: angle
		Description: ANGLE shim backed by Mesa EGL/GLESv2 (see files/angle-shim.c)
		Version: 7258
		Requires: egl glesv2 gl
		Libs: -L${T}/angle -langle_shim
		Cflags: -I${T}/angle/include
	EOF
}

src_configure() {
	# make.conf's -flto and -Werror= diagnostic promotions break this build
	# (and upstream disables its own LTO for packaging builds, too)
	filter-lto
	filter-flags -Werror=strict-aliasing -Werror=odr -Werror=lto-type-mismatch

	# CMAKE_BUILD_TYPE stays "Gentoo": user flags rule, cargo still builds
	# --release (rust_crate.cmake only special-cases Debug). No -DNDEBUG in
	# CPPFLAGS: it reaches CMake compile probes and breaks the
	# ASSERT_FAIL_HAS_INT glibc/musl detection (assert.h stops declaring
	# __assert_fail under NDEBUG, so the musl probe falsely passes).

	# the ANGLE->Mesa bridge, statically absorbed into LibWeb/Compositor
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -fPIC -I"${T}/angle/include" \
		-c "${FILESDIR}/angle-shim.c" -o "${T}/angle/angle-shim.o" \
		|| die "angle-shim compilation failed"
	$(tc-getAR) rcs "${T}/angle/libangle_shim.a" "${T}/angle/angle-shim.o" \
		|| die "angle-shim archiving failed"

	export PKG_CONFIG_PATH="${T}/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"

	local mycmakeargs=(
		-DENABLE_NETWORK_DOWNLOADS=OFF
		-DLADYBIRD_CACHE_DIR="${WORKDIR}/caches"
		-DENABLE_LTO_FOR_RELEASE=OFF
		-DENABLE_LAGOM_CCACHE=OFF
		-DENABLE_INSTALL_HEADERS=OFF
		-DBUILD_TESTING=OFF
	)
	cmake_src_configure
}

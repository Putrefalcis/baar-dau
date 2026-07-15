# baar-dau overlay

A personal Gentoo overlay for ebuilds that either don't exist in another
repository, or exist but aren't kept up to date. There's no single theme.
Packages land here whenever the main tree and the usual overlays don't
provide something, or don't provide it new enough.

Everything here is `~amd64`-oriented and offered as-is. It is a personal overlay,
not affiliated with or endorsed by Gentoo. File issues and pull requests here,
not on Gentoo Bugzilla.

## Packages

Grouped by the headline package that pulled each set in. With the overlay
enabled, emerging the headline package pulls in the rest of its group. The
notes cover only what's worth knowing beyond the version; being absent from or
behind the main tree is the premise of the overlay, so it isn't repeated per
row.

### Blender

| Package | Version | Notes |
| --- | --- | --- |
| `media-gfx/blender` | 5.1.2, 5.2.0 | |
| `media-libs/draco` | 1.5.7 | glTF mesh compression; unbundled from Blender since 5.2. |
| `media-libs/meshoptimizer` | 1.1 | glTF I/O; unbundled from Blender since 5.2. |
| `media-libs/opencolorio` | 2.5.2 | Blender 5.1+ requires `>=2.5.0`. |
| `sci-libs/ceres-solver` | 2.2.0-r2 | Adds an `eigen-5` build fix over the tree's `-r1`. |

### Ladybird

| Package | Version | Notes |
| --- | --- | --- |
| `www-client/ladybird` | 0_p20260714 | Pinned master snapshot (no upstream releases yet). Builds fully offline against system libraries; upstream builds only through vcpkg. |
| `media-libs/skia` | 148 | The exact skia milestone Ladybird requires (tip of the `chrome/m148` branch), exposed via `skia.pc`. |
| `dev-libs/wuffs` | 0.3.4 | Single-file safe-decoding library; used by Ladybird's GIF decoder. |
| `dev-util/vulkan-memory-allocator` | 3.3.0 | Header-only Vulkan allocator; used by the Vulkan paths in skia and Ladybird. |

### Ladybird notes

- Ladybird pins some dependencies hard: `dev-libs/icu` is matched to one exact
  version (currently 78.3, which the tree ships), `dev-lang/rust` needs
  `>=1.96.1`, and `dev-libs/mimalloc` must stay `<3` (the 3.x heap API is
  incompatible). Portage resolves all of this automatically; it's only worth
  knowing when a future sync bumps one of them.
- Upstream hard-wires ANGLE into its WebGL support. Packaging ANGLE is a
  chromium-scale build, so `www-client/ladybird` uses a small static shim
  (`files/angle-shim.c`) that maps the ANGLE-only GL entry points onto Mesa's
  GLES3 core. WebGL then works on any GLES3-capable Mesa driver.
- The build downloads nothing: the Rust crates, the HSTS preload list and the
  ANGLE header are all pinned in `SRC_URI`.

## Adding the overlay

With `app-eselect/eselect-repository` (recommended):

```sh
eselect repository add baar-dau git https://github.com/Putrefalcis/baar-dau.git
emerge --sync baar-dau
```

Or manually, by creating `/etc/portage/repos.conf/baar-dau.conf`:

```ini
[baar-dau]
location = /var/db/repos/baar-dau
sync-type = git
sync-uri = https://github.com/Putrefalcis/baar-dau.git
auto-sync = yes
```

then `emerge --sync baar-dau`.

## Keywords / unmasking

Everything in the overlay is keyworded `~amd64` (blender-5.1.2 also `~arm64`).
On a stable system, accept the testing keyword for the set you want, e.g. in
`/etc/portage/package.accept_keywords`:

```
media-gfx/blender ~amd64
media-libs/draco ~amd64
media-libs/meshoptimizer ~amd64
```

or

```
www-client/ladybird ~amd64
media-libs/skia ~amd64
dev-libs/wuffs ~amd64
dev-util/vulkan-memory-allocator ~amd64
```

## Provenance & license

Most of these ebuilds are version bumps or lightly modified derivatives of
ebuilds from the Gentoo tree and the GURU overlay; the Ladybird set was written
from scratch for this overlay. All carry `Gentoo Authors` copyright headers and
are distributed under the GNU General Public License v2, matching upstream
Gentoo. Packaged software keeps its own upstream license.

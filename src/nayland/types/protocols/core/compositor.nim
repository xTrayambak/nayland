## Wrapper around `wl_compositor`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak at disroot dot org)

#!fmt: off
import pkg/nayland/bindings/libwayland,
       pkg/nayland/bindings/protocols/core,
       pkg/nayland/types/protocols/core/[region, surface]
#!fmt: on

type
  CompositorObj = object
    handle*: ptr wl_compositor

  Compositor* = ref CompositorObj

proc `=destroy`*(comp: CompositorObj) =
  wl_compositor_destroy(comp.handle)

proc createSurface*(comp: Compositor): Surface {.sideEffect.} =
  newSurface(wl_compositor_create_surface(comp.handle))

proc createRegion*(comp: Compositor): Region {.sideEffect.} =
  newRegion(wl_compositor_create_region(comp.handle))

proc initCompositor*(obj: pointer): Compositor =
  Compositor(handle: cast[ptr wl_compositor](obj))

## Wrapper around `wl_region`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak at disroot dot org)

#!fmt: off
import pkg/nayland/bindings/libwayland,
       pkg/nayland/bindings/protocols/core,
       pkg/nayland/types/protocols/core/[surface]
#!fmt: on

type
  RegionObj* = object
    handle*: ptr wl_region

  Region* = ref RegionObj

proc `=destroy`*(region: RegionObj) =
  wl_region_destroy(region.handle)

func add*(region: Region, x, y, w, h: int32) {.inline.} =
  wl_region_add(region.handle, x, y, w, h)

func subtract*(region: Region, x, y, w, h: int32) {.inline.} =
  wl_region_subtract(region.handle, x, y, w, h)

proc newRegion*(handle: ptr wl_region): Region =
  Region(handle: handle)

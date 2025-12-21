## Wrapper around `xdg_surface`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
import
  pkg/nayland/bindings/libwayland,
  pkg/nayland/bindings/protocols/xdg_shell,
  pkg/nayland/types/protocols/xdg_shell/[xdg_toplevel]

# Private implementation structs
type
  XDGSurfaceObj = object
    handle*: ptr xdg_surface

    listener: xdg_surface_listener
    callbacks: XDGSurfaceCallbacksRef

  XDGSurfaceCallback* = proc(surface: XDGSurface, data: pointer, serial: uint32)

  XDGSurface* = ref XDGSurfaceObj

  XDGSurfaceCallbacksPayload = object
    surf: XDGSurface

    configure: XDGSurfaceCallback

  XDGSurfaceCallbacksRef = ref XDGSurfaceCallbacksPayload

proc getToplevel*(xdgSurf: XDGSurface): Option[XDGToplevel] =
  let handle = xdg_surface_get_toplevel(xdgSurf.handle)
  if handle == nil:
    return none(XDGToplevel)

  some(newXDGToplevel(handle))

proc ackConfigure*(xdgSurf: XDGSurface, serial: uint32) =
  xdg_surface_ack_configure(xdgSurf.handle, serial)

proc `onConfigure=`*(xdgSurf: XDGSurface, callback: XDGSurfaceCallback) =
  xdgSurf.listener.configure = proc(
      data: pointer, _: ptr xdg_surface, serial: uint32
  ) {.cdecl.} =
    let payload = cast[ptr XDGSurfaceCallbacksPayload](data)
    payload.configure(payload.surf, data, serial)

  xdgSurf.callbacks.configure = callback

proc attachCallbacks*(xdgSurf: XDGSurface) =
  xdgSurf.callbacks.surf = xdgSurf

  discard xdg_surface_add_listener(
    xdgSurf.handle,
    xdgSurf.listener.addr,
    cast[ptr XDGSurfaceCallbacksPayload](xdgSurf.callbacks),
  )

func newXDGSurface*(handle: ptr xdg_surface): XDGSurface =
  XDGSurface(handle: handle, callbacks: XDGSurfaceCallbacksRef())

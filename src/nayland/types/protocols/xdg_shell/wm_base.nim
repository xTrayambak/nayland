## Wrapper over `xdg_wm_base`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
import pkg/nayland/bindings/libwayland, pkg/nayland/bindings/protocols/xdg_shell
import
  pkg/nayland/types/protocols/core/surface,
  pkg/nayland/types/protocols/xdg_shell/[xdg_surface]

type
  WMBaseObj = object of RootObj
    handle*: ptr xdg_wm_base
    listener: xdg_wm_base_listener

  WMBasePingCallback* = proc(wmBase: WMBase, serial: uint32)

  WMBase* = ref WMBaseObj

proc `=destroy`*(wm: WMBaseObj) =
  xdg_wm_base_destroy(wm.handle)

proc getXDGSurface*(wmBase: WMBase, surface: Surface): Option[XDGSurface] =
  let handle = xdg_wm_base_get_xdg_surface(wmBase.handle, surface.handle)
  if handle == nil:
    return none(XDGSurface)

  some(newXDGSurface(handle))

proc attachCallbacks*(wmBase: WMBase) =
  wmBase.listener.ping = proc(
      data: pointer, wmBase: ptr xdg_wm_base, serial: uint32
  ) {.cdecl.} =
    # TODO: For some reason, we can't call the callback here successfully?
    # This function is invoked properly, though.
    xdg_wm_base_pong(wmBase, serial)

  discard xdg_wm_base_add_listener(wmBase.handle, wmBase.listener.addr, nil)

func initWMBase*(handle: pointer): WMBase =
  WMBase(handle: cast[ptr xdg_wm_base](handle))

## Wrapper over `xdg_toplevel`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import pkg/nayland/bindings/libwayland, pkg/nayland/bindings/protocols/xdg_shell
import
  pkg/nayland/types/protocols/core/surface,
  pkg/nayland/types/protocols/xdg_shell/[xdg_surface]

type
  XDGToplevelObj = object
    handle*: ptr xdg_toplevel

  XDGToplevel* = ref XDGToplevelObj

proc `title=`*(toplevel: XDGToplevel, title: string) =
  xdg_toplevel_set_title(toplevel.handle, title)

proc `appId=`*(toplevel: XDGToplevel, appId: string) =
  xdg_toplevel_set_app_id(toplevel.handle, appId)

#[ proc `fullscreen=`*(toplevel: XDGToplevel, state: bool) =
  if state:
    xdg_toplevel_set_fullscreen(toplevel.handle)
  else:
    xdg_toplevel_unset_fullscreen(toplevel.handle) ]#

proc minimize*(toplevel: XDGToplevel) =
  xdg_toplevel_set_minimized(toplevel.handle)

proc maximize*(toplevel: XDGToplevel) =
  xdg_toplevel_set_maximized(toplevel.handle)

func newXDGToplevel*(handle: ptr xdg_toplevel): XDGToplevel =
  XDGToplevel(handle: handle)

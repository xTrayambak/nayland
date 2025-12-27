## Wayland EGL backend bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import pkg/nayland/bindings/protocols/core

{.push header: "<wayland-egl-backend.h>".}

let WL_EGL_WINDOW_VERSION* {.importc.}: int32

type wl_egl_window* {.importc: "struct $1".} = object
  version*: int64

  width*, height*: int32
  dx*, dy*: int32

  attached_width*: int32
  attached_height*: int32

  driver_private*: pointer
  resize_callback*: proc(win: ptr wl_egl_window, v: pointer) {.cdecl.}
  destroy_window_callback*: proc(v: pointer) {.cdecl.}

  surface*: ptr wl_surface

{.pop.}

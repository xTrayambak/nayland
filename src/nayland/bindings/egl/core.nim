## Wayland EGL core bindings
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import pkg/nayland/bindings/egl/backend, pkg/nayland/bindings/protocols/core

{.push header: "<wayland-egl-core.h>", importc.}

proc wl_egl_window_create*(
  surface: ptr wl_surface, width, height: int32
): ptr wl_egl_window

proc wl_egl_window_destroy*(win: ptr wl_egl_window)
proc wl_egl_window_resize*(win: ptr wl_egl_window, width, height, dx, dy: int32)
proc wl_egl_window_get_attached_size*(win: ptr wl_egl_window, width, height: ptr int32)

{.pop.}

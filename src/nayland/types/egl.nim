## Wayland EGL wrapper
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import
  pkg/nayland/bindings/egl/[backend, core], pkg/nayland/types/protocols/core/surface

type
  EGLWindowObj = object
    handle*: ptr wl_egl_window

  EGLWindow* = ref EGLWindowObj

proc createEGLWindow*(
    surface: Surface, width, height: int32
): EGLWindow {.sideEffect.} =
  EGLWindow(handle: wl_egl_window_create(surface.handle, width, height))

proc destroy*(window: EGLWindow) =
  wl_egl_window_destroy(window.handle)

proc resize*(window: EGLWindow, width, height, dx, dy: int32): EGLWindow =
  wl_egl_window_resize(window.handle, width = width, height = height, dx = dx, dy = dy)

proc getAttachedSize*(window: EGLWindow): tuple[width, height: int32] =
  var dims: tuple[width, height: int32]
  wl_egl_window_get_attached_size(window.handle, dims.width.addr, dims.height.addr)

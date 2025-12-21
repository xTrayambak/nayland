## Wrapper around `wl_buffer`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
#!fmt: off
import pkg/nayland/bindings/libwayland,
       pkg/nayland/bindings/protocols/core
#!fmt: on

type
  BufferObj = object
    handle*: ptr wl_buffer

  Buffer* = ref BufferObj

proc `=destroy`*(buffer: BufferObj) =
  wl_buffer_destroy(buffer.handle)

func newBuffer*(handle: ptr wl_buffer): Buffer =
  Buffer(handle: handle)

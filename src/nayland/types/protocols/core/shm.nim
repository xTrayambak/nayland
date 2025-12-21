## Wrapper around `wl_shm`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
import
  pkg/nayland/bindings/libwayland,
  pkg/nayland/bindings/protocols/core,
  pkg/nayland/types/protocols/core/[shm_pool]

type
  ShmObj = object
    handle*: ptr wl_shm

  Shm* = ref ShmObj

proc `=destroy`*(shm: ShmObj) =
  wl_shm_destroy(shm.handle)

proc createPool*(shm: Shm, fd: int32, size: int32): Option[ShmPool] =
  let poolHandle = wl_shm_create_pool(shm.handle, fd, size)
  if poolHandle == nil:
    return none(ShmPool)

  some(newShmPool(poolHandle))

proc release*(shm: Shm) =
  wl_shm_release(shm.handle)

func initShm*(handle: pointer): Shm =
  Shm(handle: cast[ptr wl_shm](handle))

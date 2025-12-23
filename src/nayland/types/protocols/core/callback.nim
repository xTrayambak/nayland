## Wrapper over `wl_callback`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import pkg/nayland/bindings/libwayland, pkg/nayland/bindings/protocols/core

type
  CallbackObj = object
    handle: ptr wl_callback
    listener: ptr wl_callback_listener

  CallbackCallback* = proc(callback: Callback, obj: pointer, callbackData: uint32)
    ## The ultimate callback. Fear it.
    ##
    ## I should probably rename this to something less nonsensical.

  CallbackPayloadObj = object
    obj*: pointer
    cbObj*: ptr CallbackObj
    cb*: CallbackCallback

  CallbackPayload* = ref CallbackPayloadObj

  Callback* = ref CallbackObj

proc listen*(callback: Callback, obj: pointer, cb: CallbackCallback) =
  # what in the world is this....
  if callback.listener == nil:
    callback.listener =
      cast[ptr wl_callback_listener](alloc(sizeof(wl_callback_listener)))

  callback.listener.done = proc(
      data: pointer, cb: ptr wl_callback, cbdata: uint32
  ) {.cdecl.} =
    let payload = cast[ptr CallbackPayloadObj](data)
    payload.cb(cast[Callback](payload.cbObj), payload.obj, cbdata)

  let payload = cast[ptr CallbackPayloadObj](alloc(sizeof(CallbackPayloadObj)))

  payload.cb = cb
  payload.cbObj = cast[ptr CallbackObj](callback)
  payload.obj = obj

  discard wl_callback_add_listener(callback.handle, callback.listener, payload)

proc destroy*(callback: Callback) =
  wl_callback_destroy(callback.handle)

proc implantListener*(source: Callback, dest: Callback) =
  dest.listener = source.listener

func newCallback*(handle: ptr wl_callback): Callback =
  Callback(handle: handle)

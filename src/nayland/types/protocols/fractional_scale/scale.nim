## Wrapper around `wp_fractional_scale_v1`
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import
  pkg/nayland/bindings/libwayland, pkg/nayland/bindings/protocols/fractional_scale_v1

type
  FractionalScaleObj = object
    handle*: ptr wp_fractional_scale_v1
    payload: PreferredScaleCallbackPayload

  PreferredScaleCallback* = proc(scale: uint32)
  PreferredScaleCallbackPObj = object
    preferredScaleCb*: PreferredScaleCallback

  PreferredScaleCallbackPayload = ref PreferredScaleCallbackPObj

  FractionalScale* = ref FractionalScaleObj

let listener = wp_fractional_scale_v1_listener(
  preferred_scale: proc(
      data: pointer, scaleObj: ptr wp_fractional_scale_v1, scale: uint32
  ) {.cdecl.} =
    cast[PreferredScaleCallbackPayload](data).preferredScaleCb(scale)
)

proc `=destroy`*(scale: FractionalScaleObj) =
  wp_fractional_scale_v1_destroy(scale.handle)

proc `onPreferredScale=`*(scale: FractionalScale, cb: PreferredScaleCallback) =
  scale.payload.preferredScaleCb = cb

proc attachCallbacks*(scale: FractionalScale) =
  discard wp_fractional_scale_v1_add_listener(
    scale.handle, listener.addr, cast[ptr PreferredScaleCallbackPObj](scale.payload)
  )

func newFractionalScale*(handle: ptr wp_fractional_scale_v1): FractionalScale =
  FractionalScale(handle: handle, payload: PreferredScaleCallbackPayload())

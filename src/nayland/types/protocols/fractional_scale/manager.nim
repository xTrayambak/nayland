## Wrapper around `wp_fractional_scale_manager_v1`
##
## Copyright (C) 2026 Trayambak Rai (xtrayambak@disroot.org)
import
  pkg/nayland/bindings/libwayland,
  pkg/nayland/bindings/protocols/fractional_scale_v1,
  pkg/nayland/types/protocols/core/[surface],
  pkg/nayland/types/protocols/fractional_scale/scale

type
  FractionalScaleManagerObj = object
    handle*: ptr wp_fractional_scale_manager_v1

  FractionalScaleManager* = ref FractionalScaleManagerObj

proc `=destroy`*(manager: FractionalScaleManagerObj) =
  wp_fractional_scale_manager_v1_destroy(manager.handle)

proc getFractionalScale*(
    manager: FractionalScaleManager, surface: Surface
): FractionalScale =
  newFractionalScale(
    wp_fractional_scale_manager_v1_get_fractional_scale(manager.handle, surface.handle)
  )

func initFractionalScaleManager*(handle: pointer): FractionalScaleManager =
  FractionalScaleManager(handle: cast[ptr wp_fractional_scale_manager_v1](handle))

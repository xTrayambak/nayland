## Wrapper around `wl_shm_pool`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import std/options
#!fmt: off
import pkg/nayland/bindings/libwayland,
       pkg/nayland/bindings/protocols/core,
       pkg/nayland/types/protocols/core/[buffer]
#!fmt: on

type
  ShmPoolObj = object
    handle*: ptr wl_shm_pool

  ShmFormat* {.size: sizeof(uint32), pure.} = enum
    ARGB8888 = 0
    XRGB8888 = 1
    C8 = 0x20203843
    RGB332 = 0x38424752
    BGR233 = 0x38524742
    XRGB4444 = 0x32315258
    XBGR4444 = 0x32314258
    RGBX4444 = 0x32315852
    BGRX4444 = 0x32315842
    ARGB4444 = 0x32315241
    ABGR4444 = 0x32314241
    RGBA4444 = 0x32314152
    BGRA4444 = 0x32314142
    XRGB1555 = 0x35315258
    XBGR1555 = 0x35314258
    RGBX5551 = 0x35315852
    BGRX5551 = 0x35315842
    ARGB1555 = 0x35315241
    ABGR1555 = 0x35314241
    RGBA5551 = 0x35314152
    BGRA5551 = 0x35314142
    RGB565 = 0x36314752
    BGR565 = 0x36314742
    RGB888 = 0x34324752
    BGR888 = 0x34324742
    XBGR8888 = 0x34324258
    RGBX8888 = 0x34325852
    BGRX8888 = 0x34325842
    ABGR8888 = 0x34324241
    RGBA8888 = 0x34324152
    BGRA8888 = 0x34324142
    XRGB2101010 = 0x30335258
    XBGR2101010 = 0x30334258
    RGBX1010102 = 0x30335852
    BGRX1010102 = 0x30335842
    ARGB2101010 = 0x30335241
    ABGR2101010 = 0x30334241
    RGBA1010102 = 0x30334152
    BGRA1010102 = 0x30334142
    YUYV = 0x56595559
    YVYU = 0x55595659
    UYVY = 0x59565955
    VYUY = 0x59555956
    AYUV = 0x56555941
    NV12 = 0x3231564e
    NV21 = 0x3132564e
    NV16 = 0x3631564e
    NV61 = 0x3136564e
    YUV410 = 0x39565559
    YVU410 = 0x39555659
    YUV411 = 0x31315559
    YVU411 = 0x31315659
    YUV420 = 0x32315559
    YVU420 = 0x32315659
    YUV422 = 0x36315559
    YVU422 = 0x36315659
    YUV444 = 0x34325559
    YVU444 = 0x34325659
    R8 = 0x20203852
    R16 = 0x20363152
    RG88 = 0x38384752
    GR88 = 0x38385247
    RG1616 = 0x32334752
    GR1616 = 0x32335247
    XRGB16161616F = 0x48345258
    XBGR16161616F = 0x48344258
    ARGB16161616F = 0x48345241
    ABGR16161616F = 0x48344241
    XYUV8888 = 0x56555958
    VUY888 = 0x34325556
    VUY101010 = 0x30335556
    Y210 = 0x30313259
    Y212 = 0x32313259
    Y216 = 0x36313259
    Y410 = 0x30313459
    Y412 = 0x32313459
    Y416 = 0x36313459
    XVYU2101010 = 0x30335658
    XVYU12_16161616 = 0x36335658
    XVYU16161616 = 0x38345658
    Y0L0 = 0x304c3059
    X0L0 = 0x304c3058
    Y0L2 = 0x324c3059
    X0L2 = 0x324c3058
    YUV420_8BIT = 0x38305559
    YUV420_10BIT = 0x30315559
    XRGB8888_A8 = 0x38415258
    XBGR8888_A8 = 0x38414258
    RGBX8888_A8 = 0x38415852
    BGRX8888_A8 = 0x38415842
    RGB888_A8 = 0x38413852
    BGR888_A8 = 0x38413842
    RGB565_A8 = 0x38413552
    BGR565_A8 = 0x38413542
    NV24 = 0x3432564e
    NV42 = 0x3234564e
    P210 = 0x30313250
    P010 = 0x30313050
    P012 = 0x32313050
    P016 = 0x36313050
    AXBXGXRX106106106106 = 0x30314241
    NV15 = 0x3531564e
    Q410 = 0x30313451
    Q401 = 0x31303451
    XRGB16161616 = 0x38345258
    XBGR16161616 = 0x38344258
    ARGB16161616 = 0x38345241
    ABGR16161616 = 0x38344241
    C1 = 0x20203143
    C2 = 0x20203243
    C4 = 0x20203443
    D1 = 0x20203144
    D2 = 0x20203244
    D4 = 0x20203444
    D8 = 0x20203844
    R1 = 0x20203152
    R2 = 0x20203252
    R4 = 0x20203452
    R10 = 0x20303152
    R12 = 0x20323152
    AVUY8888 = 0x59555641
    XVUY8888 = 0x59555658
    P030 = 0x30333050

  ShmPool* = ref ShmPoolObj

proc `=destroy`*(pool: ShmPoolObj) =
  wl_shm_pool_destroy(pool.handle)

proc resize*(pool: ShmPool, size: int32) =
  wl_shm_pool_resize(pool.handle, size)

proc createBuffer*(
    pool: ShmPool, offset, width, height, stride: int32, format: ShmFormat
): Option[Buffer] =
  let buffHandle = wl_shm_pool_create_buffer(
    pool.handle, offset, width, height, stride, cast[uint32](format)
  )
  if buffHandle == nil:
    return none(Buffer)

  some(newBuffer(buffHandle))

func newShmPool*(handle: ptr wl_shm_pool): ShmPool =
  ShmPool(handle: handle)

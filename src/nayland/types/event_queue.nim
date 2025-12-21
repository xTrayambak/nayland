## Event queue type, wraps `wl_event_queue`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak at disroot dot org)
import pkg/nayland/bindings/libwayland

type
  EventQueueError* = object of IOError
  InvalidQueueHandle* = object of EventQueueError

  EventQueueObj = object
    handle*: ptr wl_event_queue

  EventQueue* = ref EventQueueObj

proc toEventQueue*(
    handle: ptr wl_event_queue
): EventQueue {.inline, raises: [InvalidQueueHandle].} =
  if handle == nil:
    raise newException(
      InvalidQueueHandle,
      "wl_event_queue handle is nil, cannot convert it to nayland.EventQueue",
    )

  EventQueue(handle: handle)

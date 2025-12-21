## Wrapper around `wl_registry`
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak at disroot dot org)
import std/[options, tables]

#!fmt: off
import pkg/nayland/bindings/libwayland,
       pkg/nayland/bindings/protocols/core,
       pkg/nayland/types/display
#!fmt: on

type
  RegistryError* = object of IOError
  CannotGetRegistry* = object of RegistryError

  Interface* = object
    name*: uint32
    version*: uint32

  RegistryObj* = object
    handle*: ptr wl_registry

    interfaces: Table[string, Interface]

  Registry* = ref RegistryObj

proc `=destroy`*(reg: RegistryObj) =
  wl_registry_destroy(reg.handle)

iterator pairs*(reg: Registry): tuple[id: string, iface: Interface] =
  for key, value in reg.interfaces:
    yield (id: key, iface: value)

iterator items*(reg: Registry): string =
  for value in reg.interfaces.keys:
    yield value

func contains*(reg: Registry, name: string): bool {.inline, raises: [].} =
  reg.interfaces.contains(name)

func `[]`*(reg: Registry, key: string): Interface {.inline, raises: [KeyError].} =
  reg.interfaces[key]

func get*(reg: Registry, key: string): Option[Interface] {.inline.} =
  if key in reg:
    return some(reg[key])

  none(Interface)

proc bindInterface*(
    reg: Registry, name: uint32, iface: ptr wl_interface, version: uint32
): pointer =
  wl_registry_bind(reg.handle, name, iface, version)

var listeners = wl_registry_listener(
  global: proc(
      data: pointer,
      reg: ptr wl_registry,
      name: uint32,
      iface: ConstCStr,
      version: uint32,
  ) {.cdecl.} =
    let reg = cast[ptr RegistryObj](data)
    reg[].interfaces[$iface] = Interface(name: name, version: version),
  global_remove: proc(data: pointer, reg: ptr wl_registry, name: uint32) {.cdecl.} =
    discard "No-op for now",
)

proc initRegistry*(display: Display): Registry {.raises: [CannotGetRegistry].} =
  let handle = wl_display_get_registry(display.handle)
  if handle == nil:
    raise newException(CannotGetRegistry, "wl_display_get_registry() returned nil")

  let reg = Registry(handle: handle)
  discard wl_registry_add_listener(handle, listeners.addr, cast[ptr RegistryObj](reg))

  reg

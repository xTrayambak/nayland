with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    pkg-config
    c2nim
    wayland
    wayland-scanner
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    wayland.dev
  ];
}

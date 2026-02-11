let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  crossPkgs = 
    import <nixpkgs> {
      # uses GCC and newlib
      crossSystem = { system = "riscv64-none-elf"; }; 
    };
  
  compileCmd = pkgs.writeShellScriptBin "compile" ''
    if [ "$#" -ne 1 ]; then
      echo "[*] syntax: compile <file.c>";
      exit;
    fi;

    riscv64-unknown-elf-gcc $1 -no-pie -Wl,-T,link.ld -o program;
    echo "[*] Compiled, file is \"program\"." 
  '';
in
# use crossPkgs' mkShell to use the correct stdenv, so that riscv64-unknown-elf-* becomes available.
crossPkgs.mkShell {
  packages = [
    compileCmd
  ];
}
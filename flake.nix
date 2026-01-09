{
  description = "zig dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };


  in {
    devShells.${system} = {
      # Default: include both stacks so it runs in either Plasma X11 or Plasma Wayland.
      default = with pkgs; []
    };
  };
}

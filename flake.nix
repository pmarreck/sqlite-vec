{
	description = "sqlite-vec Zig build support";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
		zig-overlay = {
			url = "github:mitchellh/zig-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, flake-utils, zig-overlay }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs { inherit system; };
				# Pin Zig 0.16.0 explicitly via zig-overlay so we don't drift with nixpkgs.
				zigPkg = zig-overlay.packages.${system}."0.16.0";
				sqlite-amalgamation = pkgs.fetchzip {
					url = "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip";
					sha256 = "sha256-F50oTmmcPIl0AZJbsWAR3tbNAPV3pQLf+CNITzhmXfI=";
					stripRoot = true;
				};
			in {
				packages.sqlite-amalgamation = sqlite-amalgamation;
				devShells.default = pkgs.mkShell {
					packages = [
						zigPkg
						pkgs.unzip
					];
					shellHook = ''
						export SQLITE_VEC_SQLITE_AMALGAMATION_DIR="${sqlite-amalgamation}"
						export ZIG_GLOBAL_CACHE_DIR="$HOME/.cache/zig"
						export ZIG_LOCAL_CACHE_DIR="$PWD/zig-cache"
					'';
				};
			}
		);
}

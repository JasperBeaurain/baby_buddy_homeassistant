{
  description = "development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python313
              uv
            ];

            shellHook = ''
              export PS1="[bbha] $ "

              # Auto-sync dependencies if needed
              if [ ! -d ".venv" ]; then
                echo "First time setup - running uv sync..."
                uv sync
              fi

              echo "development environment loaded"
              echo "Python: $(python --version)"
              echo "UV: $(uv --version)"
              echo ""
              echo "To update dependencies:"
              echo "  uv sync"
              echo ""
            '';
          };
        }
    );
}

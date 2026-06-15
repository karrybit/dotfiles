# Linux test environment for private_minipc profile (x86_64-linux)
# Usage (on x86_64 Linux host or CI):
#   docker build -t dotfiles-test .
#   docker run --rm dotfiles-test
FROM nixpkgs/nix:latest

WORKDIR /dotfiles

COPY nix/ ./nix/

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Verify the flake evaluates cleanly on Linux
RUN nix flake check ./nix --print-build-logs

# Build (but do not activate) the home-manager configuration
RUN nix build ./nix#homeConfigurations.private_minipc.activationPackage \
    --no-link \
    --print-build-logs

# Define the default recipe to list available commands
default:
    @just --choose

update:
	nix flake update

check:
	nix flake check .

run:
	nix run .

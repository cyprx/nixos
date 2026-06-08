{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "global-dotnet-env";
  
  buildInputs = with pkgs; [
    dotnet-sdk_10
    csharpier
  ];

  shellHook = ''
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    echo "🚀 Shared .NET Development Environment Loaded!"
  '';
}


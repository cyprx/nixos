final: prev: {
  claude-code = prev.writeShellScriptBin "claude-code" ''
    exec ${prev.nodejs_22}/bin/npx @anthropic-ai/claude-code "$@"
  '';
}

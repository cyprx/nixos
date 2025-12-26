final: prev: {
  slack = prev.symlinkJoin {
    name = "slack";
    paths = [ prev.slack ];
    buildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/slack \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations"
    '';
 };
}

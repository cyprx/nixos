{ pkgs }:

pkgs.buildNpmPackage rec {
  pname = "claude-code";
  version = "2.0.76";

  src = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-code";
    rev = "v${version}";
    hash = "";
  };

  npmDepsHash = "";

  meta = with pkgs.lib; {
    description = "Command line tool for agentic coding with Claude";
    homepage = "https://docs.claude.com";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}

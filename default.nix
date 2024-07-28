{ pkgs ? import <nixpkgs> { } }:

let
  tools = [
    "acquire"
    "afflib"
    "autopsy"
    "binwalk"
    "bulk_extractor"
    "chainsaw"
    "chipsec"
    "dc3dd"
    "dmg2img"
    "exiftool"
    "fatcat"
    "flare-floss"
    "file"
    "firefox_decrypt"
    "foremost"
    "hstsparser"
    "libewf"
    "mac-robber"
    "maltego"
    "ntfs3g"
    "networkminer"
    "oletools"
    "osquery"
    "pdf-parser"
    "prowler"
    "recoverjpeg"
    "regripper"
    "scalpel"
    "sleuthkit"
    "snort"
    "tracee"
    "trivy"
    "unfurl"
    "unhide"
    "usbrip"
    "volatility3"
    "wireshark"
    "yarGen"
    "yara-x"
  ];

  forensics = pkgs.symlinkJoin {
    name = "nix-forensics";
    paths = map (pkg: pkgs.${pkg}) tools;
  };

  createLinks = pkgs.lib.concatMapStringsSep "\n"
    (pkg: ''
      mkdir -p $out/bin/${pkg}
      for binary in ${pkgs.${pkg}}/bin/*; do
        ln -s $binary $out/bin/${pkg}/$(basename $binary)
      done
    '')
    tools;

in
pkgs.stdenv.mkDerivation {
  name = "nix-forensics";
  src = null;

  buildInputs = [ forensics ];

  unpackPhase = "true";

  installPhase = ''
    ${createLinks}
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/MikeHorn-git/nix-forensics";
    description = "Forensics Lab powered by Nix";
    license = licenses.mit;
    maintainers = with maintainers; [ MikeHorn-git ];
  };
}

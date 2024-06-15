{ pkgs ? import <nixpkgs> { } }:

let
  forensics = pkgs.symlinkJoin {
    name = "nix-forensics";
    paths = with pkgs; [
      autopsy
      binwalk
      bulk_extractor
      chainsaw
      dc3dd
      dmg2img
      exiftool
      flare-floss
      file
      firefox_decrypt
      foremost
      libewf
      mac-robber
      ntfs3g
      networkminer
      oletools
      pdf-parser
      recoverjpeg
      regripper
      scalpel
      sleuthkit
      snort
      unfurl
      usbrip
      volatility3
      wireshark
      yara-x
    ];
  };

  createLinks = pkgs.lib.concatMapStringsSep "\n"
    (pkg: ''
      mkdir -p $out/bin/${pkg}
      for binary in ${pkgs."${pkg}"}/bin/*; do
        ln -s $binary $out/bin/${pkg}/$(basename $binary)
      done
    '')
    (with pkgs; [
      "autopsy"
      "binwalk"
      "bulk_extractor"
      "chainsaw"
      "dc3dd"
      "dmg2img"
      "exiftool"
      "flare-floss"
      "file"
      "firefox_decrypt"
      "foremost"
      "libewf"
      "mac-robber"
      "ntfs3g"
      "networkminer"
      "oletools"
      "pdf-parser"
      "recoverjpeg"
      "regripper"
      "scalpel"
      "sleuthkit"
      "snort"
      "unfurl"
      "usbrip"
      "volatility3"
      "wireshark"
      "yara-x"
    ]);

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

{ lib
, python3Packages
, python3
, pkgs
, fetchFromGitHub
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "nix-kernel";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "GTrunSec";
    repo = "nix-kernel";
    rev = "7f27018ac738b38d0e910172b2c6948919928398";
    sha256 = "sha256-vDXBHqiihdkAdzv32l1BE+Rnx1LftPv4rcEZrbk6eU4=";
  };
  doCheck = false;
  preBuild = ''
    export HOME=$(pwd)
  '';
  propagatedBuildInputs = with python3Packages; [ pexpect notebook ];
}

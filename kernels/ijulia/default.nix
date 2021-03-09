{ pkgs
, stdenv
, name ? "nixpkgs"
, extraEnv ? { }
, packages ? (_: [ ])
, extraPackages ? (_: [ ])
, writeScriptBin
, directory
, julia_wrapped
, activateDir ? ""
}:
let
  startupFile = pkgs.writeText "startup.jl" ''
    import Pkg
    Pkg.activate("${activateDir}")
  '';
  kernelFile = {
    display_name = "Julia - ${name}";
    language = "julia";
    argv = [
      "${julia_wrapped}/bin/julia"
      "-L"
      "${startupFile}"
      "-i"
      "--startup-file=yes"
      "--color=yes"
      "${directory}/packages/IJulia/e8kqU/src/kernel.jl"
      "{connection_file}"
    ];

    logo64 = "logo-64x64.png";

    env = {
      JULIA_DEPOT_PATH = "${directory}";
      JULIA_PKGDIR = "${directory}";
    } // extraEnv;
  };

  JuliaKernel = stdenv.mkDerivation {
    name = "Julia-${name}";
    src = ./julia.png;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/julia_${name}
      cp $src $out/kernels/julia_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/julia_${name}/kernel.json
    '';
  };

in
{
  spec = JuliaKernel;
  runtimePackages = [
    julia_wrapped
  ];
}

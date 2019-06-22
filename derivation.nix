{ stdenvNoCC, makeWrapper, bash, jq, coreutils, lib, writeText, cargo, pkgs
, fetchcargo ? pkgs.callPackage "${pkgs.path}/pkgs/build-support/rust/fetchcargo.nix" {
    inherit cargo;
  }
}: with lib; let
  example-test-shell = ''
    if [[ $CARGO_PANIC_EXAMPLE_COMMAND = test ]]; then
      cargo $CARGO_PANIC_EXAMPLE_PRECOMMAND test --no-run $CARGO_PANIC_EXAMPLE_FLAGS
    else
      cargo $CARGO_PANIC_EXAMPLE_PRECOMMAND build $CARGO_PANIC_EXAMPLE_FLAGS
    fi

    CARGO_RES=0
    PANIC_DATA=$(mktemp)
    cargo $CARGO_PANIC_EXAMPLE_PRECOMMAND $CARGO_PANIC_EXAMPLE_COMMAND $CARGO_PANIC_EXAMPLE_FLAGS > $PANIC_DATA || CARGO_RES=$?
    cat $PANIC_DATA
    if [[ $CARGO_PANIC_EXAMPLE_COMMAND = run ]] && [[ $CARGO_RES != 101 ]]; then
      echo Expected panic, got $CARGO_RES >&2
      exit 1
    fi
    if [[ $RUST_BACKTRACE = debug_test ]] && ! grep -q __CARGO_PANIC_TEST__ $PANIC_DATA; then
      echo Expected output not found >&2
      exit 1
    fi
    rm -f $PANIC_DATA
  '';
  drv = stdenvNoCC.mkDerivation {
    pname = "cargo-panic";
    version = "";
    panicPath = makeBinPath [ jq coreutils ];
    unpackPhase = "true";
    installPhase = ''
      panicDir=$out/lib/$pname
      install -d $panicDir
      # ugh need a better way of doing this...
      cp -a ${./hook} $panicDir/hook
      cp -a ${./depend} $panicDir/depend
      cp -a ${./bin} $panicDir/bin
      cp -a ${./Cargo.toml} $panicDir/Cargo.toml
      cp -a ${./Cargo.lock} $panicDir/Cargo.lock
      install -Dm0775 ${./cargo-panic} $out/bin/$pname

      wrapProgram $out/bin/$pname \
        --prefix PATH : $panicPath \
        --set CARGO_PANIC_DIR $panicDir
    '';
    nativeBuildInputs = [ makeWrapper ];

    setupHook = writeText "cargo-panic.setuphook" ''
      function cargo-panic-test {
        ${example-test-shell}
      }
    '';

    passthru = rec {
      exec = "${drv}/bin/${drv.pname}";
      panicDir = "${drv}/lib/${drv.pname}";
      cargoSha256 = "0narf09010lm30ds1xy0fpr64g9p259x14k9yv310b8yk8r9fpl2";
      cargoVendorDir = fetchcargo {
        inherit (drv) name;
        src = "${panicDir}";
        srcs = null;
        patches = null;
        sourceRoot = null;
        sha256 = cargoSha256;
      };
      example-test = {
        function = "cargo-panic-test";
        commands = example-test-shell;
        env = { cmd, backtrace }: {
          RUST_BACKTRACE = backtrace;
          CARGO_PANIC_EXAMPLE_COMMAND = cmd;
          CARGO_PANIC_EXAMPLE_PRECOMMAND = optionalString (backtrace != "") "panic";
          CARGO_PANIC_EXAMPLE_FLAGS = [ "--frozen" "--verbose" "--target ${stdenvNoCC.hostPlatform.config}" ] ++ optional (cmd == "test") "-- --nocapture";
        };
      };
    };
  };
in drv

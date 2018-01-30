# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 2.7 -r requirements.txt
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python27Full;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python27Full-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python2
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "Flask" = python.mkDerivation {
      name = "Flask-0.10.1";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/db/9c/149ba60c47d107f85fe52564133348458f093dd5e6b57a5b60ab9ac517bb/Flask-0.10.1.tar.gz"; sha256 = "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."Werkzeug"
      self."itsdangerous"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/flask/";
        license = licenses.bsdOriginal;
        description = "A microframework based on Werkzeug, Jinja2 and good intentions";
      };
    };



    "Flask-FlatPages" = python.mkDerivation {
      name = "Flask-FlatPages-0.6";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3a/0e/91ffbd2c911f142f4a138e109162d1bfee252e00b303eddd86152b84a7c3/Flask-FlatPages-0.6.tar.gz"; sha256 = "b52d502579a0903c8660816a77c17f61f5cb526b5091fbe910a2ee17d2063bf2"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."Markdown"
      self."PyYAML"
      self."Pygments"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/SimonSapin/Flask-FlatPages";
        license = licenses.bsdOriginal;
        description = "Provides flat static pages to a Flask application";
      };
    };



    "Frozen-Flask" = python.mkDerivation {
      name = "Frozen-Flask-0.12";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f6/d2/74acc7e25f53bd0ca1c488005c3f3b1cb3b87ccac141c647b1de2e168d48/Frozen-Flask-0.12.tar.gz"; sha256 = "8e4f638a1476427ea359f6d90691d96bda71b74e7b00faab48532442079ca736"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/SimonSapin/Frozen-Flask";
        license = licenses.bsdOriginal;
        description = "Freezes a Flask application into a set of static files.";
      };
    };



    "Jinja2" = python.mkDerivation {
      name = "Jinja2-2.8";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"; sha256 = "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://jinja.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A small but fast and easy to use stand-alone template engine written in pure python.";
      };
    };



    "Markdown" = python.mkDerivation {
      name = "Markdown-2.6.5";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/e0/e6/e373d058113efc3fcede632de0c76ded309892c405f960c45acd0250060f/Markdown-2.6.5.tar.gz"; sha256 = "8d94cf6273606f76753fcb1324623792b3738c7612c2b180c85cc5e88642e560"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pythonhosted.org/Markdown/";
        license = licenses.bsdOriginal;
        description = "Python implementation of Markdown.";
      };
    };



    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-0.23";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"; sha256 = "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/markupsafe";
        license = licenses.bsdOriginal;
        description = "Implements a XML/HTML/XHTML Markup safe string for Python";
      };
    };



    "PyYAML" = python.mkDerivation {
      name = "PyYAML-3.11";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"; sha256 = "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pyyaml.org/wiki/PyYAML";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };



    "Pygments" = python.mkDerivation {
      name = "Pygments-2.1.3";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"; sha256 = "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };



    "Werkzeug" = python.mkDerivation {
      name = "Werkzeug-0.11.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/77/88/93b65347187fe101f2848982e2f84871e7aea76bb75aa05467b2c1eac6ea/Werkzeug-0.11.4.tar.gz"; sha256 = "e48fb7e3f2bb5a740dd9a666624699a4d83e2e028555f9c46bcc8ecfc2cd8c32"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://werkzeug.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "The Swiss Army knife of Python web development";
      };
    };



    "itsdangerous" = python.mkDerivation {
      name = "itsdangerous-0.24";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"; sha256 = "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/itsdangerous";
        license = licenses.bsdOriginal;
        description = "Various helpers to pass trusted data to untrusted environments and back.";
      };
    };



    "pypandoc" = python.mkDerivation {
      name = "pypandoc-1.4";
      src = pkgs.fetchurl { url = "https://pypi.python.org/packages/71/81/00184643e5a10a456b4118fc12c96780823adb8ed974eb2289f29703b29b/pypandoc-1.4.tar.gz"; sha256 = "e914e6d5f84a76764887e4d909b09d63308725f0cbb5293872c2c92f07c11a5b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/bebraw/pypandoc";
        license = licenses.mit;
        description = "Thin wrapper for pandoc.";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
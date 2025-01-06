# Attribute set
{
  foo = null;
  "foo.bar" = null;

  fooz.bar = null;
  # syntactic sugar for:
  # foo = {
  #   bar = null;
  # };

  int = 10 + 2 / 3 - 10;

  floats = 10.0 + 2.0 / 3 - 10.0;

  variables =
    let someVariable = 10;
    in someVariable + 1;

  interpolation = 
    let someName = "Silvan";
    in "Hello, ${ someName + " Mosberger" }";

  interpolation' = 
    let someName = "Silvan";
    in "Hello, ${ someName } Mosberger";

  interpolation'' =
    let 
      a = 10;
      b = 20;
    in "Hello, ${ toString (a + b) }";

  toStringExample = toString false;
  toStringExample' = toString true;


  attributeSelectors = 
    let
      foo = {
        bar.baz = 10;
        bar.qux = 20;
      };
    in foo.bar.baz;


  attributeSelectors' = 
    let
      foo = {
        bar.baz = 10;
        bar.qux = 20;
      };
    in foo.bar.hello or 30;

  booleanOps = (true && ! false) || (true -> false);

  someFun =
    let f = x: x + 1;
    in f 1;

  someFun' =
    let f = x: y: x + y;
    in f 1 2;

  someFunAttrs =
    let
      f = { x, y }: x + y;
    in f {
      x = 2;
      y = 3;
    };

  someFunAttrs' =
    let
      f = { x ? 1, y, ... }: x + y;
    in f {
      y = 3;
      ignored = 4;
    };

  someFunAttrs'' =
    let
      f = { x ? 1, y, ... }: x + y;
      g = attrs: attrs.x or 1 + attrs.y;
      fg = attrs@{ x ? 1, y, ... }: x + y + attrs.notIgnored;
      gf = { x ? 1, y, ... }@attrs: x + y;
    in f {
      y = 3;
      ignored = 4;
    };

  ifExpr = if 1 + 1 == 2 then "Yes" else 10;
  
  checkForAttributes =
    let foo.bar.baz = 10;
    in foo ? bar.baz;

  
  functionMaybeArgument =
    let 
      f = { x, y, ... }@attrs:
        x + y + (if attrs ? notIgnored then attrs.notIgnored else 0);
      f' = { x, y, ... }@attrs:
        x + y + attrs.notIgnored or 0;
    in f { x = 1; y = 2; notIgnored = 3; };


  functionDefaultsQuirk = 
    let f = { x ? 10 }@attrs: attrs ? x;
    in f {};
}

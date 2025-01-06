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

  someFun = x: x + 1;

  someFun' = 
}

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
}

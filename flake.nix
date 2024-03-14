{
  description = "Useful helper functions";

  # a better recursiveUpdate, taking lists into account
  # much abliged https://stackoverflow.com/questions/54504685/nix-function-to-merge-attributes-records-recursively-and-concatenate-arrays
  outputs = { self, nixpkgs }:
    {
      recursiveMerge = attrList:
        with nixpkgs.lib;
        let
          f = attrPath:
            lib.zipAttrsWith (key: values:
              if tail values == [ ]
              then head values
              else if all isList values
              then unique (concatLists values)
              else if all isAttrs values
              then f (attrPath ++ [ key ]) values
              else last values
            );
        in
        f [ ] attrList;
    };
}

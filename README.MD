# Schema.org vocabulary to MyCoRe classification

This mini project attempts to finagle the official [Vocabulary Definition Files](https://schema.org/docs/developers.html#defs) for the latest Schema.org [vocabulary](https://schema.org/version/latest) into a usable MyCoRe classification. 

Running `build.sh` should be enough to perform the transformation.
Deleting the source files (`schemaorg-all-http.rdf`, `schemaorg-current-http.rdf`) should trigger downloading of the latest version of these files.
This assumes, that the Schema.org website isn't changed.

Some points:

- Schema.org provides two files.
  One file (`schemaorg-all-http.rdf`) contains all entries that at any point in time were part of the vocabulary.
  Another file (`schemaorg-current-http.rdf`) contains only the entries that are currently part of the vocabulary.
  For backwards compatibility, this script processes the first file. 
  It uses the second file to determine whether an entry is still considered part of the vocabulary.
  Sadly, it is not possible to determine this using the first file alone.
  Entries that are not current are marked with `<label xml:lang="x-disable" text="true"/>`
- A current version (release 15.0) of the source files and the corresponding output file (`schemaOrg.xml`) are included in this project.
  This allows to run the transformation, even if the Schema.org website is down.
  It also allows to determine the indented behaviour of this project, should the construction of the Schema.org vocabulary change in the future.  
- The Schema.org vocabulary is a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph).
  Some entries have two or more parents.
  MyCoRe classifications need to be a tree.
  Each entry may only have one parent.
  In order to create a MyCoRe classification, a preferred parent has been chosen for each Schema.org entry that has more than one parent.
  The preferred parents are listed in a configuration file (`parents.xml`).
  Each Schema.org entry that has more than one parent needs a corresponding entry in this configuration file.
  Otherwise, the transformation will fail.
  
Licensing

- The Schema.org source files are licensed under the [Attribution-ShareAlike 3.0](https://creativecommons.org/licenses/by-sa/3.0/) license (CC BY-SA 3.0). 
  The output file is, accordingly, licensed under the same license. The schema org [Terms of service](https://schema.org/docs/terms.html) may provide different licensing options in the future.
- The source code of this project is licensed under the [MIT](https://mit-license.org/) license.

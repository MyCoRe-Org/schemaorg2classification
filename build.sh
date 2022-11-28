#!/bin/bash

if [ ! -f schemaorg-all-http.rdf ]; then
   wget https://schema.org/version/latest/schemaorg-all-http.rdf
fi

if [ ! -f schemaorg-current-http.rdf ]; then
   wget https://schema.org/version/latest/schemaorg-current-http.rdf
fi

if [ -f schemaOrg.xml ]; then
  rm schemaOrg.xml
fi

echo "<any />" | xsltproc -o schemaOrg.xml schemaorg.xsl -

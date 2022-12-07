#!/bin/bash

if [ ! -f schemaorg-version.txt ]; then
   wget -O - -qnv https://schema.org/version/latest/ | grep "Schema.org Version" | cut -d">" -f2 | cut -d"<" -f1 > schemaorg-version.txt
fi

if [ ! -f schemaorg-all-http.rdf ]; then
   wget https://schema.org/version/latest/schemaorg-all-http.rdf
fi

if [ ! -f schemaorg-current-http.rdf ]; then
   wget https://schema.org/version/latest/schemaorg-current-http.rdf
fi

if [ -f schemaOrg.xml ]; then
  rm schemaOrg.xml
fi

echo "<any />" | xsltproc -o schemaOrg.xml --stringparam version "$(cat schemaorg-version.txt)" --stringparam date "$(date -I)" schemaorg.xsl -

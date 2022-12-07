#!/bin/bash

if [ ! -f schemaorg-version.txt ]; then
  rm schemaorg-version.txt
fi

if [ ! -f schemaorg-all-http.rdf ]; then
  rm schemaorg-all-http.rdf 
fi

if [ ! -f schemaorg-current-http.rdf ]; then
  rm schemaorg-current-http.rdf
fi

if [ -f schemaOrg.xml ]; then
  rm schemaOrg.xml
fi

<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                exclude-result-prefixes="rdf rdfs">

  <xsl:output method="xml" indent="yes" />

  <xsl:variable name="baseUri" select="'http://schema.org/'" />
  <xsl:variable name="completeClassification" select="document('./schemaorg-all-http.rdf')/rdf:RDF" />
  <xsl:variable name="currentClassification" select="document('./schemaorg-current-http.rdf')/rdf:RDF" />
  <xsl:variable name="preferredParents" select="document('./parents.xml')/parents" />

  <xsl:variable name="maxCommentLength" select="4096" />
  <xsl:variable name="verticalEllipsis" select="'&#8230;'" />

  <xsl:template match="/">
    <mycoreclass ID="schemaOrg"
                 xsi:noNamespaceSchemaLocation="MCRClassification.xsd"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <label xml:lang="de" text="schema.org" />
      <label xml:lang="en" text="schema.org" />
      <label xml:lang="x-build" text="{$version}, {$date}" />
      <label xml:lang="x-source" text="https://github.com/MyCoRe-Org/schemaorg2classification" />
      <label xml:lang="x-uri" text="{$baseUri}" />
      <categories>
        <xsl:apply-templates select="$completeClassification/rdfs:Class[@rdf:about=concat($baseUri, 'Thing')]" />
      </categories>
    </mycoreclass>
  </xsl:template>

  <xsl:template match="rdfs:Class">
    <xsl:variable name="uri" select="@rdf:about" />
    <xsl:variable name="id" select="substring-after($uri, $baseUri)" />
    <category ID="{$id}">
      <xsl:variable name="rawDescription" select="normalize-space(rdfs:comment)" />
      <xsl:variable name="description">
        <xsl:choose>
          <xsl:when test="string-length($rawDescription) &gt; 4096">
            <xsl:value-of select="concat(substring($rawDescription, $maxCommentLength - 1), $verticalEllipsis)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$rawDescription" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <label xml:lang="de" text="{rdfs:label}" />
      <label xml:lang="en" text="{rdfs:label}" description="{$description}" />
      <xsl:if test="not($currentClassification/rdfs:Class[@rdf:about=$uri])">
        <label xml:lang="x-disable" text="true" />
      </xsl:if>
      <label xml:lang="x-uri" text="{$uri}" />
      <xsl:variable name="children" select="../rdfs:Class[rdfs:subClassOf[@rdf:resource=$uri]]" />
      <xsl:for-each select="$children">
        <xsl:sort select="rdfs:label" />
        <xsl:variable name="childUri" select="@rdf:about" />
        <xsl:variable name="childId" select="substring-after($childUri, $baseUri)" />
        <xsl:variable name="parentUris" select="rdfs:subClassOf/@rdf:resource" />
        <xsl:choose>
          <xsl:when test="count($parentUris) != 1">
            <xsl:variable name="preferredParentUri" select="$preferredParents/parent[@of=$childUri]/@is" />
            <xsl:choose>
              <xsl:when test="$preferredParentUri">
                <xsl:if test="count($preferredParentUri)!=1">
                  <xsl:message terminate="yes">
                    <xsl:value-of select="$childUri" />
                    <xsl:text> has </xsl:text>
                    <xsl:value-of select="count($preferredParentUri)" />
                    <xsl:text> preferred parents: </xsl:text>
                    <xsl:for-each select="$preferredParentUri">
                      <xsl:if test="position()!=1">
                        <xsl:text> / </xsl:text>
                      </xsl:if>
                      <xsl:value-of select="." />
                    </xsl:for-each>
                  </xsl:message>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$uri=$preferredParentUri">
                    <xsl:apply-templates select="." />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:comment>
                      <xsl:text> The category with ID </xsl:text>
                      <xsl:value-of select="$childId" />
                      <xsl:text> could also be placed here. </xsl:text>
                    </xsl:comment>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="yes">
                  <xsl:value-of select="$childUri" />
                  <xsl:text> has </xsl:text>
                  <xsl:value-of select="count($parentUris)" />
                  <xsl:text> parents: </xsl:text>
                  <xsl:for-each select="$parentUris">
                    <xsl:if test="position()!=1">
                      <xsl:text> / </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="." />
                  </xsl:for-each>
                </xsl:message>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </category>
  </xsl:template>

</xsl:stylesheet>

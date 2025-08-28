<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>



  <!--
    Simple XSTL that just shows the errors and failures of junit XML result.
    @author Michiel Meeuwissen
    August 2025
    -->
  <xsl:param name="artifactIdPad" as="xs:double" select="20" />
  <xsl:param name="namePad" as="xs:double" select="25" />

  <xsl:variable name="spaces">
    <xsl:text>                                                                 </xsl:text>
  </xsl:variable>
  <xsl:variable name="projectArtifactId">
    <xsl:value-of select="/testsuite/properties/property[@name = 'projectArtifactId']/@value" />
  </xsl:variable>
  <xsl:variable name="paddedProjectArtifactId">
    <xsl:value-of select="$projectArtifactId" />
    <xsl:value-of select="substring($spaces, 1, $artifactIdPad - string-length($projectArtifactId))" />
  </xsl:variable>

  <xsl:template match="/testsuite">
    <xsl:for-each select="testcase/failure | testcase/error">

      <xsl:value-of select="$paddedProjectArtifactId" />
      <xsl:text> [</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:text>]</xsl:text>
      <xsl:value-of select="substring($spaces, 1, 8 - string-length(name()))" />
      <xsl:value-of select="../@name" />
      <xsl:value-of select="substring($spaces, 1, $namePad - string-length(../@name))" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="../@classname" />
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

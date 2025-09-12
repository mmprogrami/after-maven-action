<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

  <!--
    Simple XSLT that just shows the errors and failures of junit XML result.
    @author Michiel Meeuwissen
    August 2025
    -->
  <xsl:param name="artifactIdPad" as="xs:double" select="35" />
  <xsl:param name="namePad" as="xs:double" select="25" />
  <xsl:param name="fileSeparator" as="xs:string" select="/testsuite/properties/property[@name = 'file.separator']/@value" />

  <xsl:variable name="spaces">
    <xsl:text>                                                                 </xsl:text>
  </xsl:variable>

  <xsl:variable name="projectDir">
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="input" select="/testsuite/properties/property[@name = 'basedir']/@value"/>
      <xsl:with-param name="delimiter" select="$fileSeparator"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="paddedProjectDir">
    <xsl:value-of select="$projectDir" />
    <xsl:value-of select="substring($spaces, 1, $artifactIdPad - string-length($projectDir))" />
  </xsl:variable>

  <xsl:template match="/testsuite">
    <xsl:for-each select="testcase/failure | testcase/error">
      <xsl:value-of select="$paddedProjectDir" />
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

  <xsl:template name="substring-after-last">
    <xsl:param name="input" />
    <xsl:param name="delimiter" />
    <xsl:choose>
      <xsl:when test="contains($input,$delimiter) and string-length(substring-after($input, $delimiter)) &gt; 0">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input"
                          select="substring-after($input,$delimiter)" />
          <xsl:with-param name="delimiter" select="$delimiter" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/failsafe-summary">
    <xsl:text>Summary: completed: </xsl:text><xsl:value-of select="completed" />
    <xsl:text>, errors: </xsl:text><xsl:value-of select="errors" />
    <xsl:text>, failures: </xsl:text><xsl:value-of select="failures" />
    <xsl:text>, skipped: </xsl:text><xsl:value-of select="skipped" />
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>

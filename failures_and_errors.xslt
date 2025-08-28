<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>


  <!--
    Simple XSTL that just shows the errors and failures of junit XML result.
    @author Michiel Meeuwissen
    August 2025
    -->
  <xsl:template match="/testsuite">
    <xsl:for-each select="testcase/failure | testcase/error">
      <xsl:value-of select="/testsuite/properties/property[@name = 'projectArtifactId']/@value" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:text>: </xsl:text>
      <xsl:value-of select="../@name" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="../@classname" />
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

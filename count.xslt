<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <!--
    We used to just look at the .txt files, but surefire fails to count up all tests in that (e.g. jqwik tests are missed)
    This XSLT just collects the complete data from the XML element themselves (the attributes on the testsuite have the same issue)

    @author Michiel Meeuwissen
    april 2025
    -->

  <xsl:template match="/testsuite">
    <xsl:text>Tests run: </xsl:text>
    <xsl:value-of select="count(./testcase)" /> <!-- can be different from @tests ! -->
    <xsl:text>, Failures: </xsl:text>
    <xsl:value-of select="count(./testcase/failure)" /> <!-- can be different from @failures ! -->
    <xsl:text>, Errors: </xsl:text>
    <xsl:value-of select="count(./testcase/error)" /> <!-- can be different from @errors ! -->
    <xsl:text>, Skipped: </xsl:text>
    <xsl:value-of select="count(./testcase/skipped)" /> <!-- can be different from @skipped ! -->
    <xsl:text>, Time elapsed: </xsl:text>
    <xsl:value-of select="@time" />
    <xsl:text> s</xsl:text>
    <xsl:text>, Time spent: </xsl:text>
    <xsl:value-of select="sum(./testcase/@time)" />
    <xsl:text> s -- in </xsl:text>
    <xsl:value-of select="@name" />
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>

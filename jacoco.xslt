<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:param name="namePad" as="xs:double" select="50" />

  <xsl:variable name="spaces">
    <xsl:text>                                                                 </xsl:text>
  </xsl:variable>

  <xsl:template match="/report">
    <xsl:text>Coverage Summary&#xa;</xsl:text>
    <xsl:text>Package                                           Instr Branch Line Method Class&#xa;</xsl:text>
    <xsl:text>--------------------------------------------------------------------------------&#xa;</xsl:text>
    <xsl:for-each select="package">
      <xsl:variable name="name" select="@name"/>
      <xsl:variable name="instr" select="counter[@type='INSTRUCTION']"/>
      <xsl:variable name="branch" select="counter[@type='BRANCH']"/>
      <xsl:variable name="line" select="counter[@type='LINE']"/>
      <xsl:variable name="method" select="counter[@type='METHOD']"/>
      <xsl:variable name="class" select="counter[@type='CLASS']"/>
      <xsl:text>&#xa;</xsl:text>
      <xsl:value-of select="concat($name, substring($spaces,1,$namePad - string-length($name)))"/>
      <xsl:variable name="instr_cov"><xsl:value-of select="format-number($instr/@covered div ($instr/@covered + $instr/@missed) * 100, '0')"/>% </xsl:variable>
      <xsl:value-of select="concat(substring($spaces, 1,  6 - string-length($instr_cov)), $instr_cov)" />
      <xsl:variable name="branch_cov"><xsl:value-of select="format-number($branch/@covered div ($branch/@covered + $branch/@missed) * 100, '0')"/>% </xsl:variable>
      <xsl:value-of select="concat(substring($spaces, 1,  6 - string-length($branch_cov)), $branch_cov)" />
      <xsl:variable name="line_cov"><xsl:value-of select="format-number($line/@covered div ($line/@covered + $line/@missed) * 100, '0')"/>% </xsl:variable>
      <xsl:value-of select="concat(substring($spaces, 1,  6 - string-length($line_cov)), $line_cov)" />
      <xsl:variable name="method_cov"><xsl:value-of select="format-number($method/@covered div ($method/@covered + $method/@missed) * 100, '0')"/>% </xsl:variable>
      <xsl:value-of select="concat(substring($spaces, 1,  6 - string-length($method_cov)), $method_cov)" />
      <xsl:variable name="class_cov"><xsl:value-of select="format-number($class/@covered div ($class/@covered + $class/@missed) * 100, '0')"/>% </xsl:variable>
      <xsl:value-of select="concat(substring($spaces, 1,  6 - string-length($class_cov)), $class_cov)" />
    </xsl:for-each>
    <xsl:text>&#xa;------------------------------------------------------------------------------&#xa;</xsl:text>
    <!--
    <xsl:text>Overall Coverage:&#xa;</xsl:text>
    <xsl:variable name="instr" select="counter[@type='INSTRUCTION']"/>
    <xsl:variable name="branch" select="counter[@type='BRANCH']"/>
    <xsl:variable name="line" select="counter[@type='LINE']"/>
    <xsl:variable name="method" select="counter[@type='METHOD']"/>
    <xsl:variable name="class" select="counter[@type='CLASS']"/>
    <xsl:text>Instr Cov:        </xsl:text>
    <xsl:value-of select="format-number($instr/@covered div ($instr/@covered + $instr/@missed) * 100, '##0.0')"/>
    <xsl:text>%&#xa;Branch Cov: </xsl:text>
    <xsl:value-of select="format-number($branch/@covered div ($branch/@covered + $branch/@missed) * 100, '##0.0')"/>
    <xsl:text>%&#xa;Line Cov:    </xsl:text>
    <xsl:value-of select="format-number($line/@covered div ($line/@covered + $line/@missed) * 100, '##0.0')"/>
    <xsl:text>%&#xa;Method Cov:  </xsl:text>
    <xsl:value-of select="format-number($method/@covered div ($method/@covered + $method/@missed) * 100, '##0.0')"/>
    <xsl:text>%&#xa;Class Cov:   </xsl:text>
    <xsl:value-of select="format-number($class/@covered div ($class/@covered + $class/@missed) * 100, '##0.0')"/>
    <xsl:text>%&#xa;</xsl:text>
    -->
  </xsl:template>
</xsl:stylesheet>

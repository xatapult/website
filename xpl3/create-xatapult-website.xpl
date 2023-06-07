<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xtlwg="http://www.xtpxlib.nl/ns/xwebgen" xmlns:local="#local.ax1_hck_sxb" version="3.0" exclude-inline-prefixes="#all" name="this">

  <p:documentation>
    Main XProc 3.0 pipeline for creating the different versions of the Xatapult website.
  </p:documentation>

  <!-- ======================================================================= -->
  <!-- IMPORTS: -->

  <p:import href="../../xtpxlib-xwebgen/xpl3/create-site.xpl"/>

  <!-- ======================================================================= -->
  <!-- PORTS: -->

  <p:output port="result" primary="true" sequence="false" content-types="xml" serialization="map{'method': 'xml', 'indent': true()}">
    <p:documentation>A small XML report about the processing</p:documentation>
  </p:output>

  <!-- ======================================================================= -->
  <!-- OPTIONS: -->

  <p:option name="href-specification" as="xs:string" required="false" select="resolve-uri('../source/website-xatapult-specification.xml', static-base-uri())">
    <p:documentation>Reference to the xwebgen specification file</p:documentation>
  </p:option>

  <!-- ================================================================== -->
  <!-- MAIN: -->

  <!-- Create the sites: -->
  <xtlwg:create-site name="nl-TST">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'nl', 'system': 'TST'}"/>
  </xtlwg:create-site>

  <xtlwg:create-site name="en-TST">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'en', 'system': 'TST'}"/>
  </xtlwg:create-site>

  <xtlwg:create-site name="nl-PRD">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'nl', 'system': 'PRD'}"/>
  </xtlwg:create-site>

  <xtlwg:create-site name="en-PRD">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'en', 'system': 'PRD'}"/>
  </xtlwg:create-site>

  <!-- Create a report thingy: -->
  <p:identity>
    <p:with-input port="source">
      <xatapult-website-generation-results/>
    </p:with-input>
  </p:identity>
  <p:add-attribute attribute-name="timestamp" match="/*">
    <p:with-option name="attribute-value" select="string(current-dateTime())"/>
  </p:add-attribute>
  <p:add-attribute attribute-name="href-specification" match="/*">
    <p:with-option name="attribute-value" select="$href-specification"/>
  </p:add-attribute>
  <p:insert match="/*" position="last-child">
    <p:with-input port="insertion">
      <p:pipe port="result" step="nl-TST"/>
    </p:with-input>
  </p:insert>
  <p:insert match="/*" position="last-child">
    <p:with-input port="insertion">
      <p:pipe port="result" step="en-TST"/>
    </p:with-input>
  </p:insert>
  <p:insert match="/*" position="last-child">
    <p:with-input port="insertion">
      <p:pipe port="result" step="nl-PRD"/>
    </p:with-input>
  </p:insert>
  <p:insert match="/*" position="last-child">
    <p:with-input port="insertion">
      <p:pipe port="result" step="en-PRD"/>
    </p:with-input>
  </p:insert>

</p:declare-step>

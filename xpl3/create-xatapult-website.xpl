<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xtlc="http://www.xtpxlib.nl/ns/common"
  xmlns:xtlwg="http://www.xtpxlib.nl/ns/xwebgen" xmlns:local="#local.ax1_hck_sxb" version="3.0" exclude-inline-prefixes="#all" name="this">

  <p:documentation>
    Main XProc 3.0 pipeline for creating the different versions of the Xatapult website.
  </p:documentation>

  <!-- ======================================================================= -->
  <!-- IMPORTS: -->

  <p:import href="../../xtpxlib-common/xpl3mod/create-clear-directory/create-clear-directory.xpl"/>
  <p:import href="../../xtpxlib-xwebgen/xpl3/create-site.xpl"/>

  <!-- ======================================================================= -->
  <!-- PORTS: -->

  <p:output port="result" primary="true" sequence="false" content-types="xml" serialization="map{'method': 'xml', 'indent': true()}">
    <p:documentation>A small XML report about the processing</p:documentation>
  </p:output>

  <!-- ======================================================================= -->
  <!-- OPTIONS: -->

  <p:option name="href-specification" as="xs:string" required="false"
    select="resolve-uri('../source/website-xatapult-specification.xml', static-base-uri())">
    <p:documentation>Reference to the xwebgen specification file</p:documentation>
  </p:option>

  <p:option name="href-base-output-dir" as="xs:string" required="false" select="resolve-uri('../docs', static-base-uri())">
    <p:documentation>
      The base output directory.
      WARNING: This must be the same as the one mentioned in /*/@href-base-output-dir in ../source/website-xatapult-specification.xml
    </p:documentation>
  </p:option>

  <p:option name="cname" as="xs:string" required="false" select="'eriksiegel.nl'">
    <p:documentation>The CNAME entry for the website</p:documentation>
  </p:option>

  <!-- ================================================================== -->
  <!-- MAIN: -->

  <xtlc:create-clear-directory p:message="* Clearing output directory {$href-base-output-dir}">
    <p:with-option name="href-dir" select="$href-base-output-dir"/>
  </xtlc:create-clear-directory>

  <!-- Create the Dutch site: -->
  <xtlwg:create-site name="site-nl">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'nl', 'lang-dir-suffix': '', 'resource-link-prefix': ''}"/>
  </xtlwg:create-site>

  <!-- Create a CNAME document (for the GitHub pages): -->
  <p:variable name="base-output-dir" as="xs:string" select="/*/@base-output-dir"/>
  <p:if test="exists($cname)">
    <p:store serialization="map{'method': 'text'}" message="  * CNAME: {$cname}">
      <p:with-input>
        <p:inline xml:space="preserve" content-type="text/plain">{$cname}</p:inline>
      </p:with-input>
      <p:with-option name="href" select="string-join(($base-output-dir, 'CNAME'), '/')"/>
    </p:store>
  </p:if>

  <!-- Create the English site (in en/): -->
  <xtlwg:create-site name="site-en">
    <p:with-input href="{$href-specification}"/>
    <p:with-option name="filters" select="map{'lang': 'en', 'lang-dir-suffix': 'en', 'resource-link-prefix': '../'}"/>
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
      <p:pipe port="result" step="site-nl"/>
    </p:with-input>
  </p:insert>
  <p:insert match="/*" position="last-child">
    <p:with-input port="insertion">
      <p:pipe port="result" step="site-en"/>
    </p:with-input>
  </p:insert>

</p:declare-step>

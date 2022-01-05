<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
<html>
	<head>
		<title>Designer Reports</title>
		<style>
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
h1
	{mso-style-parent:"";
	mso-style-next:"Heading 2";
	margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:3.0pt;
	margin-left:.5in;
	text-indent:-.5in;
	mso-pagination:widow-orphan;
	page-break-after:avoid;
	mso-outline-level:1;
	mso-list:l0 level1 lfo1;
	tab-stops:list .5in;
	font-size:16.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:"Times New Roman";
	mso-font-kerning:14.0pt;
	mso-bidi-font-weight:normal;}
h2
	{mso-style-parent:"";
	mso-style-next:"Heading 3";
	margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:6.0pt;
	margin-left:.55in;
	text-indent:-.3in;
	mso-pagination:widow-orphan;
	page-break-after:avoid;
	mso-outline-level:2;
	mso-list:l0 level2 lfo1;
	tab-stops:list .55in;
	font-size:14.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:"Times New Roman";
	mso-bidi-font-weight:normal;}
h3
	{mso-style-update:auto;
	mso-style-next:"Heading 4";
	margin-top:6.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.75in;
	margin-bottom:.0001pt;
	text-indent:-.25in;
	mso-pagination:none;
	page-break-after:avoid;
	mso-outline-level:3;
	mso-list:l0 level3 lfo1;
	tab-stops:list .75in;
	font-size:12.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:"Times New Roman";
	layout-grid-mode:line;
	mso-bidi-font-weight:normal;}
h4
	{margin-top:6.0pt;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:1.0in;
	margin-bottom:.0001pt;
	text-indent:-.25in;
	mso-pagination:widow-orphan;
	mso-outline-level:4;
	mso-list:l0 level4 lfo1;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-bidi-font-weight:normal;}
h5
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:1.3in;
	margin-bottom:.0001pt;
	text-indent:-.3in;
	mso-pagination:widow-orphan;
	mso-outline-level:5;
	mso-list:l0 level5 lfo1;
	tab-stops:list 1.3in;
	font-size:10.0pt;
	font-family:"Times New Roman";
	font-weight:normal;}
h6
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:1.6in;
	margin-bottom:.0001pt;
	text-indent:-.3in;
	mso-pagination:widow-orphan;
	mso-outline-level:6;
	mso-list:l0 level6 lfo1;
	tab-stops:list 1.6in;
	font-size:9.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:"Times New Roman";
	font-weight:normal;}
p.MsoHeading7, li.MsoHeading7, div.MsoHeading7
	{mso-style-update:auto;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:2.0in;
	margin-bottom:.0001pt;
	text-indent:-.2in;
	mso-pagination:widow-orphan;
	mso-outline-level:7;
	mso-list:l0 level7 lfo1;
	tab-stops:list 2.55in;
	font-size:8.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
p.MsoHeading8, li.MsoHeading8, div.MsoHeading8
	{mso-style-next:Normal;
	margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:3.0pt;
	margin-left:3.5in;
	text-indent:0in;
	mso-pagination:widow-orphan;
	mso-outline-level:8;
	mso-list:l0 level8 lfo1;
	tab-stops:list 3.75in;
	font-size:10.0pt;
	font-family:Arial;
	mso-fareast-font-family:"Times New Roman";
	mso-bidi-font-family:"Times New Roman";
	font-style:italic;
	mso-bidi-font-style:normal;}
p.MsoHeading9, li.MsoHeading9, div.MsoHeading9
	{mso-style-next:Normal;
	margin-top:12.0pt;
	margin-right:0in;
	margin-bottom:3.0pt;
	margin-left:4.0in;
	text-indent:0in;
	mso-pagination:widow-orphan;
	mso-outline-level:9;
	mso-list:l0 level9 lfo1;
	tab-stops:list 4.25in;
	font-size:9.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:Arial;
	mso-fareast-font-family:"Times New Roman";
	mso-bidi-font-family:"Times New Roman";
	font-weight:bold;
	mso-bidi-font-weight:normal;
	font-style:italic;
	mso-bidi-font-style:normal;}
p.MsoIndex1, li.MsoIndex1, div.MsoIndex1
	{mso-style-update:auto;
	mso-style-next:Normal;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.25in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
p.MsoIndexHeading, li.MsoIndexHeading, div.MsoIndexHeading
	{mso-style-next:"Index 1";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
@list l0
	{mso-list-id:50276763;
	mso-list-template-ids:1179015458;}
@list l0:level1
	{mso-level-number-format:roman-upper;
	mso-level-style-link:"Heading 1";
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.5in;}
@list l0:level2
	{mso-level-number-format:alpha-upper;
	mso-level-style-link:"Heading 2";
	mso-level-tab-stop:.55in;
	mso-level-number-position:left;
	margin-left:.55in;
	text-indent:-.3in;}
@list l0:level3
	{mso-level-style-link:"Heading 3";
	mso-level-tab-stop:.75in;
	mso-level-number-position:left;
	margin-left:.75in;
	text-indent:-.25in;}
@list l0:level4
	{mso-level-number-format:alpha-lower;
	mso-level-style-link:"Heading 4";
	mso-level-text:"%4\)";
	mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	margin-left:1.0in;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-style-link:"Heading 5";
	mso-level-text:"\(%5\)";
	mso-level-tab-stop:1.3in;
	mso-level-number-position:left;
	margin-left:1.3in;
	text-indent:-.3in;}
@list l0:level6
	{mso-level-number-format:alpha-lower;
	mso-level-style-link:"Heading 6";
	mso-level-text:"\(%6\)";
	mso-level-tab-stop:1.6in;
	mso-level-number-position:left;
	margin-left:1.6in;
	text-indent:-.3in;}
@list l0:level7
	{mso-level-number-format:roman-lower;
	mso-level-style-link:"Heading 7";
	mso-level-text:"\(%7\)";
	mso-level-tab-stop:2.55in;
	mso-level-number-position:left;
	margin-left:2.0in;
	text-indent:-.2in;}
@list l0:level8
	{mso-level-number-format:alpha-lower;
	mso-level-style-link:"Heading 8";
	mso-level-text:"\(%8\)";
	mso-level-tab-stop:3.75in;
	mso-level-number-position:left;
	margin-left:3.5in;
	text-indent:0in;}
@list l0:level9
	{mso-level-number-format:roman-lower;
	mso-level-style-link:"Heading 9";
	mso-level-text:"\(%9\)";
	mso-level-tab-stop:4.25in;
	mso-level-number-position:left;
	margin-left:4.0in;
	text-indent:0in;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
td
	{font-size:8.0pt;}
		</style>
		<base href="I:\DBFORUM\Designer\HTMLReports\"/>
		<script language="javascript" src="Utility.js"/>
		<script language="javascript" src="ErrorManagement.js"/>
		<script language="javascript">
		//<![CDATA[
			function document.oncontextmenu()
			{
				event.returnValue = false;
			}
			function application_mouseover()
			{
				try
				{
					showToolTip('application_mouseover');
				}
				catch(e)
				{
					throw logError(e);
				}
			}
		//]]>
		</script>
	</head>
	<body>
	<h1>Workareas</h1>
	<xsl:for-each select="/workareas/workarea">
		<div class="Section1">
			<h3><a name="workarea_name" irid="@irid"><xsl:value-of select="@name"/></a></h3>
			<xsl:for-each select="application">
				<h4><a onmouseover="application_mouseover();" name="application_name" irid="@irid"><xsl:value-of select="@name"/></a></h4>
			</xsl:for-each>
		</div>
	</xsl:for-each>
	</body>
</html>
    </xsl:template>

</xsl:stylesheet>

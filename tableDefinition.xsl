<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
<html>
	<head>
		<title><xsl:value-of select="/table/@name"/></title>
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
	</head>
	<body>
	<xsl:for-each select="/tables/table">
		<div class="Section1">
			<h3><a name="table_name"><xsl:value-of select="@name"/></a></h3>
			
			<h4>Description</h4>
			<!-- Table Description Lines:BEGIN -->
			<xsl:for-each select="description/line">
				<h5><xsl:value-of select="position()"/>) <xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Table Description Lines:END -->
			
			<h4>Deployment</h4>
			<!-- Table Deployment Lines:BEGIN -->
			<xsl:for-each select="deployment/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Table Deployment Lines:END -->	
		
			<h4>Table Sizing</h4>
			<!-- Table Sizing Lines:BEGIN -->
				<h5>Initial Table Rows: <xsl:value-of select="initial_number_of_rows"/></h5>
				<h5>Table Rows Added Per Quarter: <xsl:value-of select="rows_per_quarter"/></h5>
				<h5>Initial Table Extent: <xsl:value-of select="initial_table_extent"/>K</h5>
				<h5>Next Table Extent: <xsl:value-of select="next_table_extent"/>K</h5>
				<br/>
			<!-- Table Sizing Lines:END -->

			<table border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr bgcolor="silver">
					<td valign="top">
						<p align="center" style="width:25%"><b>Column_Name</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:10%"><b>Type</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:10%"><b>Length</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:10"><b>Precision</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:5"><b>Key</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:5"><b>Unq?</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:5"><b>Null?</b></p>
					</td>
					<td valign="top">
						<p align="center" style="width:15"><b>Description</b></p>
					</td>
				</tr>
				<xsl:for-each select="columns/column">
				<tr>
					<td valign="top">
						<p align="center"><xsl:value-of select="name"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="dataType"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="dataLength"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="dataPrecision"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="key"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="unique"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="null"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="description"/></p>
					</td>
				</tr>
				</xsl:for-each>
			</table>
			<br/>
			<br/>
			<table cols="5" border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr bgcolor="silver">
					<td align="center" valign="top" width="10%">
						<p align="center" style="width:25%"><b>Constraint_Type</b></p>
					</td>
					<td align="center" valign="top" width="20%">
						<p align="center" style="width:10%"><b>Constraint_Name</b></p>
					</td>
					<td align="center" valign="top" width="10%">
						<p align="center" style="width:10%"><b>Check_Constraint_Type</b></p>
					</td>
					<td align="center" valign="top" width="20%">
						<p align="center" style="width:10%"><b>Constraint_Storage_Sizing</b></p>
					</td>
					<td align="center" valign="top" width="40%">
						<p align="center" style="width:10%"><b>Constraint_Columns</b></p>
					</td>
				</tr>
				<xsl:for-each select="constraints/constraint">
				<tr>
					<td valign="top">
						<p align="center"><xsl:value-of select="constraint_type"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="name"/></p>
					</td>
					<td valign="top">
						<p align="center"><xsl:value-of select="check_constraint_type"/></p>
					</td>
					<td>
						<xsl:variable name="cons_initial_extent" select="cons_initial_extent"/>
						<xsl:if test="string-length($cons_initial_extent) &gt; 0">
							<table border="1" cellspacking="0" cellpadding="0" width="100%">
								<!-- Constraint Storage Sizing Lines:BEGIN -->
								<tr>
										<td>Initial Constraint Storage Extent: <xsl:value-of select="cons_initial_extent"/>K</td>
								</tr>
								<tr>
										<td>Next Constraint Storage Extent: <xsl:value-of select="cons_next_extent"/>K</td>
								</tr>
								<!-- Constraint Storage Sizing Lines:END -->
							</table>
						</xsl:if>
					</td>

					<td valign="top">
						<xsl:variable name="consColumns" select="cons_columns/cons_column" />
						<xsl:if test="boolean($consColumns)">
						<table border="1" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td align="center" width="50%"><p align="center" style="width:10%"><b>ColumnName</b></p></td>
							</tr>
							<xsl:for-each select="$consColumns">
							<tr>
								<td>
									<p align="center"><xsl:value-of select="column_name"/></p>
								</td>
							</tr>
						</xsl:for-each>
						</table>
						</xsl:if>
					</td>
				</tr>
				</xsl:for-each>
			</table>
			<br/>
			<br/>
			<table cols="3" border="1" cellspacing="0" cellpadding="0" width="100%">
				<tr bgcolor="silver">
					<td align="center" valign="top" width="25%">
						<p align="center" style="width:10%"><b>Index_Name</b></p>
					</td>
					<td align="center" valign="top" width="25%">
						<p align="center" style="width:10%"><b>Index Storage Sizing</b></p>
					</td>
					<td align="center" valign="top" width="50%">
						<p align="center" style="width:10%"><b>Index_Columns</b></p>
					</td>
				</tr>
				<xsl:for-each select="indexes/index">
				<tr>
					<td valign="top">
						<p align="center"><xsl:value-of select="name"/></p>
					</td>
					<td>
						<xsl:variable name="ix_initial_extent" select="ix_initial_extent"/>
						<xsl:if test="string-length($ix_initial_extent) &gt; 0">
							<table border="1" cellspacking="0" cellpadding="0" width="100%">
								<!-- Index Storage Sizing Lines:BEGIN -->
								<tr>
										<td>Initial Index Storage Extent: <xsl:value-of select="ix_initial_extent"/>K</td>
								</tr>
								<tr>
										<td>Next Index Storage Extent: <xsl:value-of select="ix_next_extent"/>K</td>
								</tr>
								<!-- Index Storage Sizing Lines:END -->
							</table>
						</xsl:if>
					</td>
					<td valign="top">
						<xsl:variable name="indexColumns" select="index_columns/index_column" />
						<xsl:if test="boolean($indexColumns)">
						<table border="1" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td align="center" width="50%"><p align="center" style="width:10%"><b>IndexName</b></p></td>
							</tr>
							<xsl:for-each select="$indexColumns">
							<tr>
								<td>
									<p align="center"><xsl:value-of select="column_name"/></p>
								</td>
							</tr>
						</xsl:for-each>
						</table>
						</xsl:if>
					</td>
				</tr>
				</xsl:for-each>
			</table>							


			<p><i>Example Data</i></p> 
			<table border="1" cellspacing="0" cellpadding="0" width="576">
				<tr bgcolor="silver">
					<xsl:for-each select="columns/column">
					<td valign="top">
						<p><b><xsl:value-of select="name"/></b></p>
					</td>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="columns/column">
					<td valign="top">
						<p>column_value</p>
					</td>
					</xsl:for-each>
				</tr>
			</table>
			
			<h4>Deployment</h4>
			<!-- Deployment Lines:BEGIN -->
			<xsl:for-each select="notes/deployment/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Deployment Lines:END -->

			<h4>Population of Data</h4>
			<!-- Population of Data Lines:BEGIN -->
			<xsl:for-each select="notes/population_of_data/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Data Lines:END -->

			<h4>Maintenance Details</h4>
			<!-- Population of Maintenance Details Lines:BEGIN -->
			<xsl:for-each select="notes/maintenance_details/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Maintenance Details Lines:END -->

			<h4>Security</h4>
			<!-- Population of Security Lines:BEGIN -->
			<xsl:for-each select="notes/security/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Security Lines:END -->

			<h4>New or Changed Indexes or Constraints</h4>
			<!-- Population of Indexes or Constraints Lines:BEGIN -->
			<xsl:for-each select="notes/indexes_or_constraints/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Indexes or Constraints Lines:END -->

			<h4>Approval Required</h4>
			<!-- Population of Approval Lines:BEGIN -->
			<xsl:for-each select="notes/approval/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Approval Lines:END -->

			<h4>Associated Triggers</h4>
			<!-- Population of Triggers Lines:BEGIN -->
			<xsl:for-each select="notes/triggers/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Triggers Lines:END -->

			<h4>Issues</h4>
			<!-- Population of Issues Lines:BEGIN -->
			<xsl:for-each select="notes/issues/line">
				<h5><xsl:value-of select="."/></h5>
			</xsl:for-each>
			<!-- Population of Issues Lines:END -->

			<br/><br/>
		</div>
	</xsl:for-each>
	</body>
</html>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- This XSLT generates a comprehensive property analytics report -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://www.realestate-platform.com/schema">

    <xsl:output method="html" indent="yes"/>

    <!-- Helper template to find maximum value -->
    <xsl:template name="max">
        <xsl:param name="nodes" select="/.." />
        <xsl:choose>
            <xsl:when test="not($nodes)">0</xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$nodes">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Helper template to find minimum value -->
    <xsl:template name="min">
        <xsl:param name="nodes" select="/.." />
        <xsl:choose>
            <xsl:when test="not($nodes)">0</xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$nodes">
                    <xsl:sort select="." data-type="number" order="ascending"/>
                    <xsl:if test="position() = 1">
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Main template creates the analytics dashboard with various property metrics -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Property Analytics Report</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .analytics-container { max-width: 1200px; margin: 0 auto; }
                    .metrics-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 20px;
                        margin: 20px 0;
                    }
                    .metric-card {
                        background: #f7fafc;
                        padding: 20px;
                        border-radius: 5px;
                        text-align: center;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                    }
                    .metric-value {
                        font-size: 24px;
                        font-weight: bold;
                        color: #2c5282;
                    }
                    .chart {
                        background: #fff;
                        padding: 20px;
                        margin: 20px 0;
                        border-radius: 5px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
                    }
                    .property-type-distribution {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 10px;
                        margin: 20px 0;
                    }
                    .price-range {
                        background: #ebf8ff;
                        padding: 15px;
                        border-radius: 5px;
                        margin: 5px 0;
                    }
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin: 20px 0;
                    }
                    th, td {
                        padding: 10px;
                        border: 1px solid #e2e8f0;
                        text-align: left;
                    }
                    th { 
                        background: #f7fafc;
                        font-weight: bold;
                    }
                    .status-available {
                        color: #2f855a;
                        background: #c6f6d5;
                        padding: 2px 6px;
                        border-radius: 3px;
                    }
                    .status-under-contract {
                        color: #c05621;
                        background: #feebc8;
                        padding: 2px 6px;
                        border-radius: 3px;
                    }
                </style>
            </head>
            <body>
                <div class="analytics-container">
                    <h1>Property Analytics Report</h1>
                    
                    <!-- Overall Metrics -->
                    <div class="metrics-grid">
                        <div class="metric-card">
                            <h3>Total Properties</h3>
                            <div class="metric-value">
                                <xsl:value-of select="count(//property)"/>
                            </div>
                        </div>
                        <div class="metric-card">
                            <h3>Average Price</h3>
                            <div class="metric-value">
                                $<xsl:value-of select="format-number(sum(//property/pricing/listPrice) div count(//property), '#,##0')"/>
                            </div>
                        </div>
                        <div class="metric-card">
                            <h3>Available Properties</h3>
                            <div class="metric-value">
                                <xsl:value-of select="count(//property[@status='AVAILABLE'])"/>
                            </div>
                        </div>
                        <div class="metric-card">
                            <h3>Average Area</h3>
                            <div class="metric-value">
                                <xsl:value-of select="format-number(sum(//property/propertyDetails/totalArea) div count(//property), '#,##0')"/>
                                sq ft
                            </div>
                        </div>
                    </div>

                    <!-- Property Type Distribution -->
                    <div class="chart">
                        <h2>Property Type Distribution</h2>
                        <div class="property-type-distribution">
                            <xsl:for-each select="//property/propertyDetails/propertyType[not(. = preceding::propertyType)]">
                                <xsl:variable name="type" select="."/>
                                <div class="metric-card">
                                    <h4><xsl:value-of select="$type"/></h4>
                                    <div class="metric-value">
                                        <xsl:value-of select="count(//property[propertyDetails/propertyType = $type])"/>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>

                    <!-- Price Range Analysis -->
                    <div class="chart">
                        <h2>Price Range Analysis</h2>
                        <xsl:variable name="prices" select="//property/pricing/listPrice"/>
                        <xsl:variable name="maxPrice">
                            <xsl:call-template name="max">
                                <xsl:with-param name="nodes" select="$prices"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="minPrice">
                            <xsl:call-template name="min">
                                <xsl:with-param name="nodes" select="$prices"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <div class="price-range">
                            <p>Price Range: $<xsl:value-of select="format-number($minPrice, '#,##0')"/> - $<xsl:value-of select="format-number($maxPrice, '#,##0')"/></p>
                        </div>
                    </div>

                    <!-- Property Listing Performance -->
                    <div class="chart">
                        <h2>Property Listing Performance</h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>Property ID</th>
                                    <th>Days on Market</th>
                                    <th>Price Changes</th>
                                    <th>Current Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//property">
                                    <tr>
                                        <td><xsl:value-of select="propertyId"/></td>
                                        <td>
                                            <xsl:value-of select="count(history/event)"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(history/event[type='PRICE_REDUCTION'])"/>
                                        </td>
                                        <td>
                                            $<xsl:value-of select="format-number(pricing/listPrice, '#,##0')"/>
                                        </td>
                                        <td>
                                            <span>
                                                <xsl:attribute name="class">
                                                    <xsl:choose>
                                                        <xsl:when test="@status='AVAILABLE'">status-available</xsl:when>
                                                        <xsl:otherwise>status-under-contract</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:value-of select="@status"/>
                                            </span>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>

                    <!-- Location Analysis -->
                    <div class="chart">
                        <h2>Location Analysis</h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>City</th>
                                    <th>Number of Properties</th>
                                    <th>Average Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//property/address/city[not(. = preceding::city)]">
                                    <xsl:variable name="city" select="."/>
                                    <tr>
                                        <td><xsl:value-of select="$city"/></td>
                                        <td>
                                            <xsl:value-of select="count(//property[address/city = $city])"/>
                                        </td>
                                        <td>
                                            $<xsl:value-of select="format-number(sum(//property[address/city = $city]/pricing/listPrice) div count(//property[address/city = $city]), '#,##0')"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet> 
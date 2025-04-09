<?xml version="1.0" encoding="UTF-8"?>
<!-- This XSLT transforms real estate data into an agent dashboard HTML view -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:re="http://www.realestate-platform.com/schema">

    <xsl:output method="html" indent="yes"/>

    <!-- Main template creates the dashboard layout with agent info and listings -->
    <xsl:template match="/">
        <html xmlns:re="http://www.realestate-platform.com/schema">
            <head>
                <title>Agent Dashboard</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .dashboard { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; }
                    .agent-info { 
                        background: #f7fafc; 
                        padding: 20px; 
                        border-radius: 5px;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                    }
                    .listings { background: #fff; padding: 20px; }
                    .listing-card { 
                        border: 1px solid #e2e8f0; 
                        margin: 10px 0; 
                        padding: 15px; 
                        border-radius: 5px;
                        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
                    }
                    .status-badge {
                        display: inline-block;
                        padding: 3px 8px;
                        border-radius: 3px;
                        font-size: 0.8em;
                        font-weight: bold;
                    }
                    .status-available { background-color: #c6f6d5; color: #2f855a; }
                    .status-under-contract { background-color: #feebc8; color: #c05621; }
                    .metrics { 
                        display: grid; 
                        grid-template-columns: repeat(3, 1fr); 
                        gap: 10px; 
                        margin-top: 20px; 
                    }
                    .metric-card {
                        background: #fff;
                        padding: 15px;
                        border-radius: 5px;
                        text-align: center;
                        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                    }
                    .metric-value {
                        font-size: 1.5em;
                        font-weight: bold;
                        color: #2c5282;
                    }
                    .profile h3 {
                        color: #2d3748;
                        margin-bottom: 1em;
                    }
                    .profile p {
                        color: #4a5568;
                        margin: 0.5em 0;
                    }
                    .specializations {
                        margin: 1em 0;
                    }
                    .specializations li {
                        color: #4a5568;
                        margin: 0.3em 0;
                    }
                    .license-info {
                        background: #fff;
                        padding: 10px;
                        border-radius: 4px;
                        margin: 0.5em 0;
                    }
                </style>
            </head>
            <body>
                <div class="dashboard">
                    <div class="agent-info">
                        <xsl:apply-templates select="//agency/agents/agent[1]"/>
                    </div>
                    <div class="listings">
                        <h2>Active Listings</h2>
                        <xsl:apply-templates select="//properties/property[propertyId = //agency/agents/agent/activeListings]"/>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Template for displaying agent profile information -->
    <xsl:template match="agent">
        <h2>Agent Profile</h2>
        <div class="profile">
            <h3><xsl:value-of select="firstName"/> <xsl:value-of select="lastName"/></h3>
            <p>ID: <xsl:value-of select="userId"/></p>
            <p>Email: <xsl:value-of select="contactInfo/email"/></p>
            <p>Phone: <xsl:value-of select="contactInfo/phone"/></p>
            
            <h4>Specializations</h4>
            <ul class="specializations">
                <xsl:for-each select="specializations">
                    <li><xsl:value-of select="."/></li>
                </xsl:for-each>
            </ul>

            <h4>Licenses</h4>
            <xsl:for-each select="licenses/license">
                <div class="license-info">
                    <p>
                        <strong><xsl:value-of select="type"/></strong><br/>
                        License #: <xsl:value-of select="number"/><br/>
                        Expires: <xsl:value-of select="expiryDate"/>
                    </p>
                </div>
            </xsl:for-each>

            <div class="metrics">
                <div class="metric-card">
                    <h4>Active Listings</h4>
                    <div class="metric-value">
                        <xsl:value-of select="count(activeListings)"/>
                    </div>
                </div>
                <div class="metric-card">
                    <h4>Total Value</h4>
                    <div class="metric-value">
                        $<xsl:value-of select="format-number(sum(//properties/property[propertyId = current()/activeListings]/pricing/listPrice), '#,##0')"/>
                    </div>
                </div>
                <div class="metric-card">
                    <h4>Avg. Price</h4>
                    <div class="metric-value">
                        <xsl:choose>
                            <xsl:when test="count(activeListings) > 0">
                                $<xsl:value-of select="format-number(sum(//properties/property[propertyId = current()/activeListings]/pricing/listPrice) div count(activeListings), '#,##0')"/>
                            </xsl:when>
                            <xsl:otherwise>$0</xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- Template for displaying property listings -->
    <xsl:template match="property">
        <div class="listing-card">
            <span>
                <xsl:attribute name="class">
                    status-badge <xsl:choose>
                        <xsl:when test="@status='AVAILABLE'">status-available</xsl:when>
                        <xsl:otherwise>status-under-contract</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="@status"/>
            </span>
            <h3><xsl:value-of select="title"/></h3>
            <p><xsl:value-of select="description"/></p>
            <div class="listing-details">
                <p>
                    Price: $<xsl:value-of select="format-number(pricing/listPrice, '#,##0')"/><br/>
                    Type: <xsl:value-of select="propertyDetails/propertyType"/><br/>
                    Location: <xsl:value-of select="address/city"/>, <xsl:value-of select="address/state"/>
                </p>
            </div>
            <div class="listing-stats">
                <p>
                    Listed: <xsl:value-of select="history/event[type='LISTED']/date"/>
                </p>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet> 
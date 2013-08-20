<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#compress>
<#-- geojson.ftl

Outputs Funnelback response in GeoJSON format.

Date: June 2013
Author: Gordon Grace

See also:
http://www.geojson.org/geojson-spec.html
http://geojsonlint.com/
http://docs.funnelback.com/ui_modern_form_content_type_collection_cfg.html

Pre-requisites:
- Collection has geospatial component, encoded as lat/longs only
- collection.cfg has template response type correctly set to application/json (ui.modern.form.geojson.content_type=application/json)

ToDo:
- Handle best bets?
- Handle partial matches?
- Handle complex geometry output
- Allow definitions of indexed metadata at top of template

-->
<@fb.ViewModeBanner />
<@fb.ErrorMessage />
<@s.InitialFormOnly>
</@s.InitialFormOnly>  
<@s.AfterSearchOnly>
<#-- NO RESULTS -->
<#if response.resultPacket.resultsSummary.totalMatching == 0>
{
    "resp":{
        "code":400,
        "status":"ERROR",
        "errorMessage":"No matching results."
    }
}
<#else>
<#-- RESULTS -->
{"type": "FeatureCollection",
    "features": [
<@s.Results>
    <#if s.result.class.simpleName == "TierBar">
        <#if s.result.matched == s.result.outOf>
        <#else></#if>
        <#else>
        <#-- EACH RESULT -->
        {"type": "Feature",
            "geometry": {"type": "Point", "coordinates": [${s.result.metaData["x"]?replace(".*\\;","","r")},${s.result.metaData["x"]?replace("\\;.*","","r")}]},
            "properties": {
                "title": "${s.result.title}",
                "description": "${s.result.metaData["c"]}",
                "kmFromOrigin": "${s.result.kmFromOrigin}",
                "url": "${s.result.liveUrl?html}"
                <#-- MORE METADATA FIELDS... -->
            }
        }<#if s.result.rank &lt; response.resultPacket.resultsSummary.currEnd>,</#if>
        </#if>
</@s.Results>
    ]
}
</#if>
</@s.AfterSearchOnly>
</#compress>

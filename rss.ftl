<#ftl encoding="utf-8" strip_text=true/>
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<@s.AfterSearchOnly>
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
    <title>Search results for '<@s.QueryClean/>'</title>
    <description>Latest search results for '${question.inputParameterMap["query"]!?html}${question.inputParameterMap["query_prox"]!?html}' from <@s.cfg>service_name</@s.cfg></description>
    <link>${question.environmentVariables["REQUEST_URL"]!?html}</link>
    <atom:link href="${question.environmentVariables["REQUEST_URL"]!?html}" rel="self" type="application/rss+xml" />
    <generator>Funnelback</generator>
    <#-- Add the date if it is not a meta collection -->
    <#if (question.collection.type!) != "meta">
        <#assign rssUpdatedDate=((updatedDate(question.collection.id))!currentDate())?datetime?string("EEE, d MMM yyyy hh:mm:ss Z")>
    <lastBuildDate>${rssUpdatedDate}</lastBuildDate>
    <pubDate>${rssUpdatedDate}</pubDate></#if>
    <#if question.collection.configuration.value("rss.ttl")??><ttl>${question.collection.configuration.value("rss.ttl")!}</ttl></#if><#t>
    <#if question.collection.configuration.value("rss.copyright")??><copyright>${question.collection.configuration.value("rss.copyright")}</copyright></#if><#t>
    <@s.Results>
    <#if s.result.class.simpleName != "TierBar">
    <item>
        <title>${s.result.title?html}</title>
        <#-- DESCRIPTION -->
        <description><![CDATA[<@s.boldicize><#rt>
        <#if s.result.summary?exists>
            ${s.result.summary}<#t>
        <#elseif s.result.metaData["c"]?exists>
            ${s.result.metaData["c"]}<#t>
        </#if>
        </@s.boldicize>]]></description><#lt>
        <#-- LINK -->
        <link>${s.result.liveUrl!?html}</link>
        <#-- GUID -->
        <guid isPermaLink="true">${s.result.liveUrl!?html}</guid>
        <#-- PUBDATE -->
        <#if s.result.date?exists && s.result.date?date?string("d MMM yyyy") != "No Date">
        <pubDate>${s.result.date?date?string("EEE, d MMM yyyy hh:mm:ss Z")?html}</pubDate>
        </#if>
        <#-- AUTHOR --> 
        <#if s.result.metaData["a"]?exists>
        <author>${s.result.metaData["a"]?html}</author>
        </#if>
        <#-- CATEGORY -->
        <#if s.result.metaData["s"]?exists>
        <category>${s.result.metaData["s"]?html}</category>
        </#if>
    </item>
    </#if>
    </@s.Results>
</channel>
</rss>
</@s.AfterSearchOnly>

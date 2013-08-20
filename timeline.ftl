<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#import "bootstrap-search.ftl" as bs/>
<!DOCTYPE html>
<html lang="en">
<head>
    <title><@s.AfterSearchOnly>${question.inputParameterMap["query"]!?html}${question.inputParameterMap["query_prox"]!?html}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI></@s.AfterSearchOnly><@s.cfg>service_name</@s.cfg>, Funnelback Search</title>
    <@s.OpenSearch />
    <meta name="robots" content="nofollow">
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <@s.AfterSearchOnly><link rel="alternate" type="application/rss+xml" title="Search results for ${question.inputParameterMap["query"]!?html}${question.inputParameterMap["query_prox"]!?html}<@s.IfDefCGI name="query">,&nbsp;</@s.IfDefCGI><@s.cfg>service_name</@s.cfg>" href="http://training.funnelback.com/s/search.html?collection=<@s.cfg>collection</@s.cfg>&query=<@s.QueryClean />&form=rss&sort=date" /></@s.AfterSearchOnly>
    <@bs.Styles />    
    <!-- Timeline CSS -->
    <link media="all" rel="stylesheet" type="text/css" href="/s/resources/${question.inputParameterMap["collection"]!?html}/${question.inputParameterMap["profile"]!?html}/timeline.css" />
    
</head>
<body>    
    <@fb.ViewModeBanner />
    
    <@bs.NavBar />
        
    <div class="container">
    <@s.InitialFormOnly>
        <@bs.DemoShowcase />
        <#-- TODO: Output search query history -->
    </@s.InitialFormOnly>    
    <@s.AfterSearchOnly>
    <h1 class="hidden">Search</h1>

    <div class="row">    
        <div class="col-lg-2 col-md-push-10">
            <@bs.ViewSortModes />
        </div>
        <div class="col-lg-10 col-md-pull-2">
            <@bs.ResultSetSummary />           
        </div>    
    </div> <!-- /.row -->

    <#-- TODO: WRAP IN div.alert, change ErrorMessage macro to accept prefix and suffix parameters.  Correct macro spelling. -->
    <@fb.ErrorMessage />

    <#-- SEARCH RESULTS -->    
	<div class="row">
        
		<div class="col-lg-9 col-md-push-3">            
            <#-- SEARCH SCOPE -->
			<@s.IfDefCGI name="scope">
            <#if question.inputParameterMap["scope"]?length != 0>
				<p id="search-scope">
					Search scope: <@s.Truncate length=80>${question.inputParameterMap["scope"]!?html}</@s.Truncate>
					(<a href="?collection=${question.inputParameterMap["collection"]!?html}<#if question.inputParameterMap["form"]??>&amp;form=${question.inputParameterMap["form"]!?html}</#if>&amp;query=<@s.URLEncode><@s.QueryClean /></@s.URLEncode>">Broaden search scope</a>)
				</p>
            </#if>
			</@s.IfDefCGI>

			<#-- QUERY BLENDING -->					
			<#if response?? && response.resultPacket?? && response.resultPacket.QSups?? && response.resultPacket.QSups?size &gt; 0>
				<div class="alert alert-info">	
					<span class="glyphicon glyphicon-info-sign"></span> Showing results for <em><#list response.resultPacket.QSups as qsup> ${qsup.query}<#if qsup_has_next>, </#if></#list></em>.
					Search for <strong><a href="?${QueryString}&amp;qsup=off">${question.originalQuery}</a></strong> instead.
				</div>
			</#if>	
		
			<#-- TODO: STYLE DID YOU MEAN -->			
            <@s.CheckSpelling />
            
            <#-- NO RESULTS -->
    		<#if response.resultPacket.resultsSummary.totalMatching == 0>
            <div class="alert alert-block">
                <h4><span class="glyphicon glyphicon-warning-sign"></span> No results</h4>
				<p>Your search for <strong>${question.inputParameterMap["query"]!?html}</strong> did not return any results. Please ensure that you:</p>
					<ul>
						<li>are not using any advanced search operators like + - | " etc.</li> 
						<li>expect this document to exist within the <em><@s.cfg>service_name</@s.cfg></em><@s.IfDefCGI name="scope"><#if question.inputParameterMap["scope"]??> and within <em><@s.Truncate length=80>${question.inputParameterMap["scope"]!?html}</@s.Truncate></em></#if></@s.IfDefCGI></li>
						<li>have permission to see any documents that may match your query</li>
					</ul>
				</p>
            </div>
			</#if>
            
            <#-- TIMELINE -->
            <script type="text/javascript">
                var data = [];
                
                var timeline;
                
                var options = {
                  "width": "100%",
                  "height": "800px",
                  "style": "box",
                  "axisOnTop" : "true",
                  "box.align" : "left",
                  "selectable" : "false",
                  "scale" : "WEEK",
                  "cluster" : "true",
                  "locale" : "${question.locale?html}",
                  "step" : "6"                  
                };
            
            </script>            
            <div id="search-timeline"></div>

			<#-- RESULTS -->
            <h2 class="visible-print">Results</h2>
			<@s.Results>
            
                <#-- TIER BAR -->
				<#if s.result.class.simpleName == "TierBar">
					
					<#if s.result.matched != s.result.outOf>
						<h3 class="text-muted">Search results that match ${s.result.matched} of ${s.result.outOf} words</h3>
					</#if>
				<#else>
                    <#if s.result.date?exists>
                        <script type="text/javascript">
                            data.push({
                            <#if s.result.metaData["Z"]??>'class': '${s.result.metaData["Z"]?html}',</#if>
                            <#if s.result.metaData["A"]??>'group': '${s.result.metaData["A"]?html}',</#if>
                            'start': new Date(${s.result.date?date?string("yyyy")},${s.result.date?date?string("MM")?number - 1}, ${s.result.date?date?string("dd")}),
                            'content': '<p><a href="${s.result.clickTrackingUrl?html}" title="${s.result.liveUrl}">${s.result.title?replace("'","")}</a></p><p><small class="text-muted">${s.result.date?date?string("dd MMM yyyy")}</small></p>',
                            });
                        </script>
                    </#if>                    
				</#if>
			</@s.Results>			

			<@bs.ContextualNavigationPanel />
            
		</div> <!-- /.col -->
        
        <@bs.FacetedNavigation />
        
	</div> <!-- /.row -->
	</div> <!-- /.container -->
    </@s.AfterSearchOnly>
      
    <footer>
        <div class="container">            
            <@s.AfterSearchOnly>            
            <@bs.ResultSetTools />
            </@s.AfterSearchOnly>
            <p class="text-muted text-center"><small><@s.AfterSearchOnly>Collection last updated: ${response.resultPacket.details.collectionUpdated?datetime}.<br/></@s.AfterSearchOnly>
            Search powered by <a href="http://www.funnelback.com">Funnelback</a>.  Template uses <a href="http://getbootstrap.com/">Bootstrap</a> and <a href="http://glyphicons.getbootstrap.com/">Glyphicons</a>.</small></p>            
        </div>
    </footer>
    
    <#-- MODAL DIALOGS -->
    <div class="hidden-print" id="modal-dialogs">
        <h2 class="hidden">Tools</h2>
        <h3 class="hidden">Additional Forms</h3>
        
        <@bs.ModalUserDetailsForm />
        
        <@bs.ModalAdvancedSearchForm />
            
        <@s.AfterSearchOnly>
        
        <@bs.ModalResultTaggingForm/>    
        
        <@bs.ModalUserFeedbackForm/>        
        
        </@s.AfterSearchOnly>
    </div> <!-- /#modal-dialogs -->    

    <@bs.JavaScripts/>
    <@bs.GoogleAnalytics/>	
        
    <!-- TIMELINE SCRIPT SOURCED FROM http://almende.github.com/chap-links-library/js/timeline/doc/ -->
    <script type="text/javascript" src="/s/resources/${question.inputParameterMap["collection"]!?html}/${question.inputParameterMap["profile"]!?html}/timeline.js" ></script>
    <script type="text/javascript">
        timeline = new links.Timeline(document.getElementById('search-timeline'));
        timeline.draw(data, options);
    </script>
</body>
</html>

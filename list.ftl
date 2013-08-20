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
        
		<div class="col-lg-9 <@s.FacetedSearch>col-md-push-3</@s.FacetedSearch>">
            <#-- DEBUGGING: NOTIFICATION REGION -->
            <#--
            <div id="search-notifications">
                <div class="alert alert-success fade in">
                    <button data-dismiss="alert" class="close" type="button">×</button>
                    <strong>Result Title</strong> added to cart.
                </div>
            </div>
            -->
        
            <#-- SEARCH SCOPE -->
			<@s.IfDefCGI name="scope">
            <#if question.inputParameterMap["scope"]?length != 0>
			<p id="search-scope">
				Search scope: <@s.Truncate length=80>${question.inputParameterMap["scope"]!?html}</@s.Truncate>
				(<a href="?collection=${question.inputParameterMap["collection"]!?html}<#if question.inputParameterMap["form"]??>&amp;form=${question.inputParameterMap["form"]!?html}</#if>&amp;query=<@s.URLEncode><@s.QueryClean /></@s.URLEncode>">Broaden search scope</a>)
			</p>
            </#if>
			</@s.IfDefCGI>

            <@bs.QueryBlending />
		
			<#-- DID YOU MEAN -->			
            <@s.CheckSpelling prefix="<h3><span class=\"glyphicon glyphicon-question-sign text-muted\"></span> Did you mean <em>" suffix="</em>?</h3>" />
            
            <@bs.NamedEntities />		
            
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

            <#-- RESULTS -->            
            <h2 class="hidden">Results</h2>
            
            <div class="row">
                <div class="col-md-9">
            
    			<#-- BEST BETS -->
    			<@s.BestBets>
    			<div class="alert alert-success">
    				<#if s.bb.title??><h4><a href="${s.bb.clickTrackingUrl?html}"><@s.boldicize>${s.bb.title}</@s.boldicize></a></h3></#if>
    				<#if s.bb.title??><p><@s.boldicize><cite class="text-success">${s.bb.link}</cite></p></@s.boldicize></#if>
    				<#if ! s.bb.title??><p><strong>${s.bb.trigger}:</strong> <a href="${s.bb.link}">${s.bb.link}</a></#if>
    				<#if s.bb.description??><p><@s.boldicize>${s.bb.description}</@s.boldicize></p></#if>
    			</div>
    			</@s.BestBets>
                
    			<ol id="search-results" class="list-unstyled">
    				<@s.Results>                
                    <#-- TIER BAR -->
    				<#if s.result.class.simpleName == "TierBar">
    					<#if s.result.matched != s.result.outOf>
    						<h3 class="text-muted">Results that match ${s.result.matched} of ${s.result.outOf} words</h3>
                        <#else>
                            <h3 class="hidden">Fully-matching results</h3>
    					</#if>
    				<#else>
                        <#-- EACH RESULT -->
    					<li>
    						<h4>
    							<#if s.result.fileType == "pdf"><small class="text-muted">PDF (${filesize(s.result.fileSize)})</small></#if>
    							<#if s.result.fileType == "doc"><small class="text-muted">DOC (${filesize(s.result.fileSize)})</small></#if>
    							<#if s.result.fileType == "xls"><small class="text-muted">XLS (${filesize(s.result.fileSize)})</small></#if>
    							<#if s.result.fileType == "ppt"><small class="text-muted">PPT (${filesize(s.result.fileSize)})</small></#if>
    							<#if s.result.fileType == "rtf"><small class="text-muted">RTF (${filesize(s.result.fileSize)})</small></#if>
    							<a href="${s.result.clickTrackingUrl?html}" title="${s.result.liveUrl?html}">
    								<@s.boldicize><@s.Truncate length=70>${s.result.title}</@s.Truncate></@s.boldicize>
    							</a>
    						</h4>
    						
    						<#-- URL -->
    						<cite data-url="${s.result.displayUrl?html}" class="text-success"><@s.cut cut="http://"><@s.boldicize><@s.TruncateURL length=50>${s.result.displayUrl?html}</@s.TruncateURL></@s.boldicize></@s.cut></cite>
    					    
                            <@bs.ResultSecondaryActions />
                            
    						<#-- QUERY BIASED SUMMARY (WITH DATE)-->
    						<#if s.result.summary??>
    							<p><#if s.result.date?? && s.result.date?date?string("d MMM yyyy") != "No Date"><span class="text-muted">${s.result.date?date?string("d MMM yyyy")}:</span></#if>
    							<span class="search-summary"><@s.boldicize>${s.result.summary}</@s.boldicize></span></p>
    						</#if>
    
    						<#-- METADATA SUMMARIES -->
                            <@s.IfDefCGI name="SM">
                            <#if question.inputParameterMap["SM"] == "meta">
                                <dl>
    							    <#if s.result.metaData["c"]??>
                                    <dt>Description</dt>
                                    <dd>${s.result.metaData["c"]!}</dd>
                                    </#if>
                                    <#if s.result.metaData["a"]??>
                                    <dt>Author</dt>
                                    <dd>${s.result.metaData["a"]!}</dd>
                                    </#if>
    							    <#if s.result.metaData["s"]??>
                                    <dt>Keywords</dt>
                                    <dd>${s.result.metaData["s"]!}</dd>
                                    </#if>
    							    <#if s.result.metaData["p"]??>
                                    <dt>Publisher</dt>
                                    <dd>${s.result.metaData["p"]!}</dd>
                                    </#if>
                                </dl>
                            </#if>
                            </@s.IfDefCGI>
    
    						<#-- QUICK LINKS -->
    						<@s.Quicklinks>
    							<ul class="list-inline">
    								<@s.QuickRepeat><li><a href="${s.ql.url}" title="${s.ql.text}">${s.ql.text}</a></li></@s.QuickRepeat>
    							</ul>
    							<#if question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"]?? && question.collection.quickLinksConfiguration["quicklinks.domain_searchbox"] == "true">                                
                                    <#-- SCOPED SITE SEARCH -->
    								<#if s.result.quickLinks.domain?matches("^[^/]*/?[^/]*$", "r")>
    								<form action="${question.collection.configuration.value("ui.modern.search_link")}" method="get" class="form-inline search-scoped-domain">
                                        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!?html}">
    									<input type="hidden" name="meta_u_sand" value="${s.result.quickLinks.domain}">
    									<@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!?html}"></@s.IfDefCGI>
    									<@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!?html}"></@s.IfDefCGI>
    									<@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!?html}"></@s.IfDefCGI>
    									<@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!?html}"></@s.IfDefCGI>										
    									<input class="form-control" name="query" type="text" placeholder="Search ${s.result.quickLinks.domain}&hellip;">
                                        <button class="form-control btn btn-primary" type="submit"><i class="glyphicon glyphicon-search"></i> Search</button>                                        
    								</form>
    								</#if>
    							</#if>
    						</@s.Quicklinks>
    
    					</li>
    				</#if>
    			</@s.Results>
    			</ol>
                </div>
                <div class="col-md-3"></div>
            </div>
            
            <@bs.ContextualNavigationPanel />

            <@bs.Pagination />		
            
		</div> <!-- /.col -->
        
        <@bs.FacetedNavigation />
        
	</div> <!-- /.row -->
    </@s.AfterSearchOnly>
	</div> <!-- /.container -->    
      
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
    
</body>
</html>

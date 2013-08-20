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
    
    <@bs.Styles />    
    
    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.css" />
    <!--[if lte IE 8]>
    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.ie.css" />
    <![endif]-->
    
    <script src="http://cdn.leafletjs.com/leaflet-0.6.4/leaflet.js"></script>
    
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

    <div class="row hidden-xs">    
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
            
			<#-- BEST BETS -->
			<@s.BestBets>
			<div class="alert alert-success">
				<#if s.bb.title??><h4><a href="${s.bb.clickTrackingUrl?html}"><@s.boldicize>${s.bb.title}</@s.boldicize></a></h3></#if>
				<#if s.bb.title??><p><@s.boldicize><cite class="text-success">${s.bb.link}</cite></p></@s.boldicize></#if>
				<#if ! s.bb.title??><p><strong>${s.bb.trigger}:</strong> <a href="${s.bb.link}">${s.bb.link}</a></#if>
				<#if s.bb.description??><p><@s.boldicize>${s.bb.description}</@s.boldicize></p></#if>
			</div>
			</@s.BestBets>
			
            <#-- MAP-BASED OUTPUT -->
            <div id="map"></div>
            
            <script type="text/javascript">                                                                        
                <#-- INITIALISE MAP -->                
                <#if (question.inputParameterMap["origin"]??) && (question.inputParameterMap["origin"] != "") >
                var origin = new L.LatLng(${question.inputParameterMap["origin"]});
                <#else>
                origin = new L.LatLng(-35.308235,149.124224);  // Defaults to Canberra
                </#if>
                
                <#if (question.inputParameterMap["maxdist"]??) && (question.inputParameterMap["maxdist"] != "")>                
                <#-- TODO: var zoomLevel = 10 / ${question.inputParameterMap["maxdist"]?number}; -->                
                var radius = 1000 * ${question.inputParameterMap["maxdist"]?number};                
                <#else>
                var zoomLevel = 8;  // Defaults to city-level zoom
                var radius = 10000; // Defaults to 10km
                </#if>

                var map = L.map('map', {
                    center: origin,
                    zoom: zoomLevel
                });
                
                L.tileLayer('http://{s}.tile.cloudmade.com/{key}/22677/256/{z}/{x}/{y}.png', {
                    attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2012 CloudMade',
            		key: '<@s.cfg>cloudmade.api</@s.cfg>'
        		}).addTo(map);
            
                <#-- USER'S LOCATION AND RADIUS -->
                var marker_origin = L.marker(origin).addTo(map);                
                marker_origin.bindPopup("You.")                
                var circle = L.circle(origin, radius, {
                    color: 'red',
                    fillColor: '#f03',
                    fillOpacity: 0.1
                }).addTo(map);            
                
            <#-- RESULTS AS MARKERS -->
            <#-- TODO: IMPORT FROM GEOJSON TEMPLATE? -->
            <@s.Results>
				<#if s.result.class.simpleName == "TierBar">
    				<#if s.result.matched != s.result.outOf>                      
					</#if>
				<#else>
                    <#-- EACH RESULT -->
                                        
                    <#if s.result.metaData["x"]??>
                    var marker_${s.result.rank} = L.marker([${s.result.metaData["x"]}], {title: "${s.result.title!?html}"}).addTo(map);
                    <#else>
                    <#-- RANDOM MARKERS NEAR CANBERRA (-35.308235,149.124224) -->
                    var marker_${s.result.rank} = L.marker([(Math.random() - 35.308235), (Math.random() + 149.124224)], {title: "${s.result.title?html}"}).addTo(map);                    
                    </#if>
                    
                    marker_${s.result.rank}.bindPopup("<a href='${s.result.clickTrackingUrl?url}'>${s.result.title!?html}</a><p>${s.result.summary}</p>");
                    <#-- TODO: DISPLAY KM AWAY -->
				</#if>
			</@s.Results>			
            </script>

			<@bs.ContextualNavigationPanel />
			
			<@bs.Pagination />
            
		</div> <!-- /.col -->
        
        <#-- FACETED NAVIGATION -->
        <@s.FacetedSearch>
        <div class="col-lg-3 col-md-pull-9">            
			<@s.Facet>
            <div class="panel">
                <div class="panel-heading"><@s.FacetLabel/></div>
                <div class="panel-body">
    				<ul class="list-unstyled">
    				<@s.Category>
    				<li><@s.CategoryName />&nbsp;<span class="badge pull-right"><@s.CategoryCount /></span></li>
    				</@s.Category>
    				</ul>
                </div>
            </div>
			</@s.Facet>
        </div> <!-- /.col -->
        </@s.FacetedSearch>
        
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

	<@bs.JavaScripts />
        
    <@bs.GoogleAnalytics />
</body>
</html>

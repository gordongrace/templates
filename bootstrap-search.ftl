<#-- BOOTSTRAP SEARCH UI MACROS -->

<#macro Styles>    
    <#-- BOOTSTRAP CSS, WEBFONTS AND CUSTOM STYLES -->
    <#-- <link rel="stylesheet" type="text/css" href="/s/resources/<@s.cfg>collection</@s.cfg>/bootstrap.min.css" /> -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0-wip/css/bootstrap.min.css">    
    <link rel="stylesheet" type="text/css" href="/s/resources/<@s.cfg>collection</@s.cfg>/bootstrap-glyphicons.css" />    
    <link rel="stylesheet" type="text/css" href="/s/resources/<@s.cfg>collection</@s.cfg>/bootstrap-search.css" />    
</#macro>

<#macro NavBar>
    <nav class="navbar" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                </button>            
                <!-- <a class="navbar-brand" href="${question.collection.configuration.value("ui.modern.search_link")}?collection=${question.inputParameterMap["collection"]!?html}">Search</a> -->
            </div>
                
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <#-- QUERY FORM -->        
                <form class="navbar-form navbar-left" action="${question.collection.configuration.value("ui.modern.search_link")}" method="get" role="search">
                    <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!?html}">          
                    <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!?html}"></@s.IfDefCGI>
                    <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!?html}"></@s.IfDefCGI>
                    <@s.IfDefCGI name="scope"><#if question.inputParameterMap["scope"]??><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!?html}"></#if></@s.IfDefCGI>
                    <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!?html}"></@s.IfDefCGI>                    

                    <div class="form-group">
                        <input class="form-control" name="query" id="query" type="search" data-loading-text="Searching&hellip;" value="${question.inputParameterMap["query"]!?html}" placeholder="Search <@s.cfg>service_name</@s.cfg>&hellip;" autocomplete="off">
                        <button type="submit" class="btn btn-primary"><i class="glyphicon glyphicon-search"></i> Search</button>
                        <!--
                        <span class="input-group-btn">
                            <button type="submit" class="btn btn-primary" title="Search <@s.cfg>service_name</@s.cfg>&hellip;"><i class="glyphicon glyphicon-search"></i></button>
                        </span> -->
                    </div>                    
                </form>    
                <ul class="nav navbar-nav navbar-right">                    
                    <#-- ADVANCED SEARCH FORM MODAL TOGGLE -->
                    <li><a data-toggle="modal" href="#search-advanced" title="Advanced Search"><span class="glyphicon glyphicon-cog"></span> Advanced</a></li>
                    
                    <#-- CURRENT USER MODAL TOGGLE -->
                    <li><a data-toggle="modal" href="#search-user" title="My Details"><span class="glyphicon glyphicon-user"></span><#if question.searchUser??> ${question.searchUser}</#if> User</a></li>
                    
                    <#-- SEARCH HISTORY -->
                    <#-- TODO: <li><a href="#" title="My Search History"><span class="glyphicon glyphicon-time"></span></a></li> -->
                    
                    <#-- SEARCH CART -->
                    <#-- TODO: <li><a href="#" title="My Saved Results"><span class="glyphicon glyphicon-shopping-cart"></span></a></li> -->
                    
                    <#-- TAGS -->
                    <#-- TODO: <li><a href="#" title="My Tags"><span class="glyphicon glyphicon-tags"></span></a></li> -->
                    
                    <#-- RANKING -->
                    <#-- TODO: <li><a href="#" title="Ranking"><span class="glyphicon glyphicon-dashboard"></span></a></li> -->
                    
                    <#-- PERFORMANCE -->
                    <#-- TODO: <li><a href="#" title="Perfomance Statistics"><span class="glyphicon glyphicon-tasks"></span></a></li> -->                    
                </ul>
            </div> <!-- /.nav-collapse -->        
        </div>
    </nav>
</#macro>



<#macro FacetedNavigation>
    <@s.FacetedSearch>
    <div class="col-lg-3 col-md-pull-9">            
		<@s.Facet>
        <div class="panel">
            <div class="panel-heading"><@s.FacetLabel separator="" /></div>
            <#-- TODO: SUPPRESS .PANEL-BODY MARKUP IF NO CATEGORIES -->
            <div class="panel-body">
				<ul class="list-unstyled">
    				<@s.Category>
    				<li><@s.CategoryName/>&nbsp;<span class="badge pull-right"><@s.CategoryCount /></span></li>
    				</@s.Category>
				</ul>
            </div>            
        </div>
		</@s.Facet>
    </div> <!-- /.col -->
    </@s.FacetedSearch>
</#macro>



<#macro QueryBlending>
    <#if response?? && response.resultPacket?? && response.resultPacket.QSups?? && response.resultPacket.QSups?size &gt; 0>
	<div class="alert alert-info">	
		<span class="glyphicon glyphicon-info-sign"></span> Showing results for <em><#list response.resultPacket.QSups as qsup> ${qsup.query}<#if qsup_has_next>, </#if></#list></em>.
		Search for <strong><a href="?${QueryString}&amp;qsup=off">${question.originalQuery}</a></strong> instead.
	</div>
	</#if>
</#macro>



<#macro ModalUserFeedbackForm>
<#-- TODO: USER FEEDBACK FORM -->
        <div id="search-feedback" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="/search/feedback.tcgi" method="post">
                        <input type="hidden" name="query" value="<@s.QueryClean/>"/>
                        <input type="hidden" name="url" value="http://testurl.com" />
                        <input type="hidden" name="collection" value="<@s.cfg>collection</@s.cfg>" />
                        <#if question.searchUser??><input type="hidden" name="username" value="${question.searchUser}" /></#if>
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>Search Feedback</h4>
                    </div>
                    <div class="modal-body">                                                                
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="comment">What were you searching for?</label>
                                <textarea class="form-control" rows="4" id="comment" name="comment"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="correct_url">What's the URL of the result you were expecting?</label>
                                <input class="form-control" type="url" name="correct_url" id="correct_url" placeholder="e.g. http://example.com/correct/url" />
                            </div>
                            <span class="help-block">(Your <#if question.searchUser??>username, </#if>search query, IP address and the current date and time will be automatically sent)</span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-bullhorn"></span> Submit Feedback</button>                        
                    </div>
                    </form>                        
                </div>
            </div>
        </div> <!-- /#search-feedback -->
</#macro>



<#macro ModalResultTaggingForm>
<#-- TODO: RESULT TAGGING FORM -->
        <#-- REFER: http://docs.funnelback.com/tagging_classic_ui.html -->
        <div id="search-tagging" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="/search/tag.tcgi" method="post">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4>Tag Result</h4>
                        </div>
                        <div class="modal-body">                                       
                            <dl>
                                <dt>Result Title</dt>
                                <dd>RESULT TITLE</dd>
                                <dt>URL</dt>
                                <dd>RESULT URL</dd>
                            </dl>
                            <div class="form-group">
                                <label for="tags">Tags</label>
                                <textarea name="tags" id="tags" placeholder="tag1, tag2, etc" class="form-control"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                            <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-tags"></span> Add Tags</button>
                        </div>
                    </form>                        
                </div>
            </div>
        </div> <!-- /#search-tagging -->
</#macro>

<#macro ModalAdvancedSearchForm>
<#-- ADVANCED SEARCH FORM -->
        <div id="search-advanced" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" class="form-horizontal">        
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Advanced Search</h4>
                        </div>
                        <div class="modal-body">            
                			<input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!?html}">
                			<@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!?html}"></@s.IfDefCGI>
                			<@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!?html}"></@s.IfDefCGI>
                			<@s.IfDefCGI name="scope"><input type="hidden" name="scope" value="${question.inputParameterMap["scope"]!?html}"></@s.IfDefCGI>
                			<@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!?html}"></@s.IfDefCGI>                	
                			
                            <div class="form-group">
                                <label for="query-advanced" class="col-lg-4 control-label">Any of the words</label>
                                <div class="col-lg-8">
                    			    <input name="query" id="query-advanced" type="text" value="${question.inputParameterMap["query"]!?html}" class="form-control input-sm" placeholder="e.g. senate balcony plains" >
                                </div>
                            </div>
                                
                			<fieldset>
                				<legend>Contents</legend>	
                				<div class="form-group">
                					<label for="query_and" class="col-lg-4 control-label">All the words</label>
                                    <div class="col-lg-8">
                					    <input type="text" id="query_and" name="query_and" value="${question.inputParameterMap["query_and"]!?html}" class="form-control input-sm" placeholder="e.g. juliet where thou love">
                                    </div>
                				</div>                					
                				<div class="form-group">
                					<label for="query_phrase" class="col-lg-4 control-label">The phrase</label>					
                					<div class="col-lg-8">
                                        <input type="text" id="query_phrase" name="query_phrase" value="${question.inputParameterMap["query_phrase"]!?html}" class="form-control input-sm" placeholder="e.g. to be or not to be">
                                    </div>
                				</div>				                	
                				<div class="form-group">
                					<label for="query_not" class="col-lg-4 control-label">None of the words</label>
                					<div class="col-lg-8">
                						<input type="text" id="query_not" name="query_not" value="${question.inputParameterMap["query_not"]!?html}" class="form-control input-sm" placeholder="e.g. brutus othello">
                					</div>				
                				</div>		
                			</fieldset>
            						
                			<fieldset>
                				<legend>Metadata</legend>
                				<div class="form-group">
                					<label for="meta_t" class="col-lg-4 control-label">Title</label>
                					<div class="col-lg-8">
                						<input type="text" id="meta_t" name="meta_t" placeholder="e.g. A Midsummer Night's Dream" value="${question.inputParameterMap["meta_t"]!?html}" class="form-control input-sm">
                					</div>				
                				</div>                	
                				<div class="form-group">
                					<label for="meta_a" class="col-lg-4 control-label">Author</label>
                					<div class="col-lg-8">
                						<input type="text" id="meta_a" name="meta_a" placeholder="e.g. William Shakespeare" value="${question.inputParameterMap["meta_a"]!?html}" class="form-control input-sm">
                					</div>				
                				</div>				                	
                				<div class="form-group">
                					<label for="meta_s" class="col-lg-4 control-label">Subject</label>
                					<div class="col-lg-8">
                						<input type="text" id="meta_s" name="meta_s" placeholder="e.g. comedy" value="${question.inputParameterMap["meta_s"]!?html}" class="form-control input-sm">
                					</div>				
                				</div>					
                			</fieldset>
                            
                            <fieldset>
                                <legend>Located</legend>
                                <div class="form-group">
                                    <label class="control-label col-lg-4" for="maxdist">Distance</label>
                    				<div class="col-lg-4">
                                        <div class="input-group">
                    						<input type="number" id="maxdist" name="maxdist" placeholder="e.g. 10" value="${question.inputParameterMap["maxdist"]!?html}" class="form-control input-sm">
                                            <span class="input-group-addon">km</span>
                                        </div>
                					</div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-lg-4" for="origin">Origin</label>
                        			<div class="col-lg-5">
                                        <div class="input-group">
                    						<span class=" input-group-btn">
                                                <a class="btn btn-info detect-location btn-sm" title="Locate me!" ><span class="glyphicon glyphicon-map-marker"></span></a>
                                            </span>
                                            <input type="text" id="origin" name="origin" placeholder="Latitude, Longitude" value="${question.inputParameterMap["origin"]!?html}" class="form-control input-sm">
                                        </div>
                					</div>
                                </div>                                
                            </fieldset>
                        				
                			<fieldset>
                				<legend>Published</legend>                                
                				<div class="form-group">
                					<label class="control-label col-lg-4" for="meta_d1day">Published after</label>
                			    	<div class="col-lg-8">
                						<@s.Select name="meta_d1day" id="meta_d1day" options=["=Day"] range="1..31" class="input-sm" />
                						<@s.Select name="meta_d1month" options=["=Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] class="input-sm" />
                						<@s.Select name="meta_d1year" options=["=Year"] range="CURRENT_YEAR - 20..CURRENT_YEAR" class="input-sm" />
                					</div>
                				</div>
                			
                				<div class="form-group">
                					<label class="control-label col-lg-4" for="meta_d2day">Published before</label>					
                					<div class="col-lg-8">
                						<@s.Select name="meta_d2day" id="meta_d2day" options=["=Day"] range="1..31" class="input-sm" />
                						<@s.Select name="meta_d2month" options=["=Month", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"] class="input-sm" />
                						<@s.Select name="meta_d2year" options=["=Year"] range="CURRENT_YEAR - 20..CURRENT_YEAR + 1" class="input-sm" />
                					</div>
                				</div>
                			</fieldset>                                    

                            <div class="form-group">    			
            					<label class="control-label col-lg-4" for="scope">Within</label>
            					<div class="col-lg-8">
            						<input type="text" id="scope" name="scope" placeholder="e.g. example.com" value="${question.inputParameterMap["scope"]!?html}" class="form-control input-sm">
            					</div>
            				</div>
                        				
                			<div class="form-group">		
                			  <label class="control-label col-lg-4" for="meta_f_sand">File type</label>
                			  <div class="col-lg-8">
                				  <@s.Select name="meta_f_sand" id="meta_f_sand" options=["=Any ", "pdf=PDF  (.pdf) ", "xls=Excel (.xls) ", "ppt=Powerpoint (.ppt) ", "rtf=Rich Text (.rtf) ", "doc=Word (.doc) ", "docx=Word 2007+ (.docx) "] class="form-control input-sm"/>
                			  </div>
                			</div>
                        </div> <!-- /.modal-body -->
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                            <button class="btn btn-primary" type="submit"><span class="glyphicon glyphicon-cog"></span> Advanced Search</button>
                        </div>
                    </form>
                </div> <!-- /.modal-content -->
            </div> <!-- /.modal-dialog -->
        </div> <#-- #search-advanced -->
</#macro>



<#macro ModalUserDetailsForm>
    <div id="search-user" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4>User: <#if question.searchUser??>${question.searchUser}<#else>Anonymous</#if></h4>
                </div>
                <div class="modal-body">
                    <dl class="dl-horizontal">                        
                        <dt>IP Address</dt>
                        <dd><#if question.rawInputParameters["X_FORWARDED_FOR"]??>${question.rawInputParameters["X_FORWARDED_FOR"][0]}<#else>Unknown</#if></dd>
                        <dt>Locale</dt>
                        <dd>${question.locale?html}</dd>
                        <dt>Country</dt>
                        <dd><#if question.location.countryCode??>${question.location.countryName} (${question.location.countryCode})<#else>Unknown</#if></dd>
                        <dt>Latitude, Longitude</dt>
                        <dd>
                            <div class="input-group">
                                <span class="input-group-btn">
                                    <button class="btn btn-info detect-location" title="Locate me!"><span class="glyphicon glyphicon-map-marker"></span></button>
                                </span>
                                <input readonly type="text" id="location-detected" class="form-control input-small" value="<#if question.inputParameterMap["origin"]??>${question.inputParameterMap["origin"]}<#else><#if question.location.latitude??>${question.location.latitude},${question.location.longitude}<#else>Unknown</#if></#if>">
                            </div>
                        </dd>
                    </dl>                                            
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div> <!-- /#search-user -->
</#macro>



<#macro ResultSetTools>
    <ul class="list-inline text-center">
        <li><a rel="alternate" href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form","start_rank","sort"])?html}&amp;form=rss&amp;sort=date" title="Subscribe to this search as an RSS feed"><small><span class="glyphicon glyphicon-bookmark"></span> Subscribe</small></a></li>
        <li><a href="#search-feedback" data-toggle="modal"><small><span class="glyphicon glyphicon-thumbs-up"></span> Feedback</small></a></li>                
    </ul>
</#macro>


<#macro Pagination>			
	<ul class="pagination pagination-lg">
		<@fb.Prev><li><a href="${fb.prevUrl?html}" rel="prev"><small><i class="glyphicon glyphicon-chevron-left"></i></small> Prev</a></li></@fb.Prev>
		<@fb.Page><li <#if fb.pageCurrent> class="active"</#if>><a href="${fb.pageUrl?html}">${fb.pageNumber}</a></li></@fb.Page>
		<@fb.Next><li><a href="${fb.nextUrl?html}" rel="next">Next <small><i class="glyphicon glyphicon-chevron-right"></i></small></a></li></@fb.Next>
	</ul>
</#macro>



<#macro ContextualNavigationPanel>
	<@s.ContextualNavigation>				
		<@s.ClusterNavLayout />
		<@s.NoClustersFound />					
		<@s.ClusterLayout>
        <div class="well">
			<h3>Related searches for <strong><@s.QueryClean/></strong></h3>
            <div class="row">                        
                <div class="col-lg-6">
					<ul class="list-unstyled">
					<@s.Category name="topic">
						<@s.Clusters><li><a href="${s.cluster.href?html?replace(" ", "+")}"><@s.boldicize>${s.cluster.label?replace("...", " "+s.contextualNavigation.searchTerm+" ")}</@s.boldicize></a></li></@s.Clusters>
					</@s.Category>
					</ul>
                </div>
			    <div class="col-lg-6">
					<ul class="list-unstyled">
						<@s.Category name="type">		     
							<@s.Clusters><li><a href="${s.cluster.href?html?replace(" ", "+")}"><@s.boldicize>${s.cluster.label?replace("...", " "+s.contextualNavigation.searchTerm+" ")}</@s.boldicize></a></li></@s.Clusters>			    
						</@s.Category>
					</ul>
                </div>
            </div> <!-- /.row -->
        </div> <!-- /.well -->
		</@s.ClusterLayout>                    
	</@s.ContextualNavigation>
</#macro>



<#macro ResultSecondaryActions>
	<div class="btn-group">
		<a href="#" class="dropdown-toggle" data-toggle="dropdown" title="More actions&hellip;"><small><i class="glyphicon glyphicon-chevron-down text-success"></i></small></a>
		<ul class="dropdown-menu">
			
            <#-- CACHE LINK -->
            <#if s.result.cacheUrl??>
            <li><a href="${s.result.cacheUrl?html}" title="Cached version of ${s.result.title} (${s.result.rank})">Cached</a></li>
            </#if>
            
            <#-- EXPLORE LINK -->
			<li><@s.Explore /></li>
			
            <#-- ANCHORS LINK -->
            <li><a href="/s/anchors.html?collection=${question.inputParameterMap["collection"]!?html}&amp;docnum=${s.result.docNum?c}">Anchors</a></li>
            
            <#-- CONTENT OPTIMISER LINK -->
            <li><@fb.Optimise /></li>
            
            <#-- SESSION SAVE/REMOVE LINK -->
			<li><@fb.ResultCart /></li>
            
            <#-- DEBUGGING SAVE/REMOVE LINK -->
			<li><a href="#" class="search-result-save">Save</a></li>
            
            <#-- DEBUGGING TAGGING LINK -->
			<li><a href="#search-tagging" data-toggle="modal" title="Tag ${s.result.title}&hellip;">Tag</a></li>
            
		</ul>
	</div>
</#macro>



<#macro ViewSortModes>
    <ul class="list-inline pull-right">        
        <#-- SORT MODES -->
        <li>
            <div class="dropdown">
                <a class="dropdown-toggle text-muted" data-toggle="dropdown" href="#" id="dropdown-sortmode" title="Sort"><small><span class="glyphicon glyphicon-sort"></span></small></a>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdown-sortmode">
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span> Relevance</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&amp;sort=date"><span class="glyphicon glyphicon-sort-by-order-alt"></span> Recency</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&amp;sort=title"><span class="glyphicon glyphicon-sort-by-alphabet"></span> Title (A-Z)</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&amp;sort=dtitle"><span class="glyphicon glyphicon-sort-by-alphabet-alt"></span> Title (Z-A)</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&amp;sort=prox"><span class="glyphicon glyphicon-map-marker"></span> Distance</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["start_rank","sort"])?html}&amp;sort=shuffle"><span class="glyphicon glyphicon-random"></span> Shuffle</a></li>
                </ul>
            </div>
        </li>
        <#-- VIEW MODES -->
        <li>
            <div class="dropdown">
                <a class="dropdown-toggle text-muted" data-toggle="dropdown" href="#" id="dropdown-viewmode" title="View Mode"><small><span class="glyphicon glyphicon-list"></span></small></a>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdown-viewmode">
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form"])?html}&amp;form=list"><span class="glyphicon glyphicon-list"></span> List</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form"])?html}&amp;form=gallery"><span class="glyphicon glyphicon-th-large"></span> Gallery</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form"])?html}&amp;form=table"><span class="glyphicon glyphicon-list-alt"></span> Table</a></li>
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form"])?html}&amp;form=map"><span class="glyphicon glyphicon-map-marker"></span> Map</a></li>                    
                    <li role="menuitem"><a href="${question.collection.configuration.value("ui.modern.search_link")}?${removeParam(QueryString,["form"])?html}&amp;form=timeline"><span class="glyphicon glyphicon-calendar"></span> Timeline</a></li>
                </ul>
            </div>
        </li>
    </ul>
</#macro>



<#macro QueryBlending>
	<#if response?? && response.resultPacket?? && response.resultPacket.QSups?? && response.resultPacket.QSups?size &gt; 0>
	<div class="alert alert-info">	
		<span class="glyphicon glyphicon-info-sign"></span> Showing results for <em><#list response.resultPacket.QSups as qsup> ${qsup.query}<#if qsup_has_next>, </#if></#list></em>.
		Search for <strong><a href="?${QueryString}&amp;qsup=off">${question.originalQuery}</a></strong> instead.
	</div>
	</#if>
</#macro>



<#macro NamedEntities>
    <#if response.entityDefinition??>
    <blockquote>
        <h2 class="hidden">Definitions</h2>
        <h3><span class="glyphicon glyphicon-hand-right text-muted"></span> <@s.QueryClean/></h3>
        <@fb.TextMiner />
    </blockquote>
    </#if>
</#macro>



<#macro ResultSetSummary>    
    <h2 class="sr-only">Summary</h2>
    <h3 class="sr-only">Result Summary</h3>
    <h4>
    <#if response.resultPacket.resultsSummary.totalMatching == 0>
    	<strong>0</strong> results for <strong><@s.QueryClean /></strong>
    </#if>
    <#if response.resultPacket.resultsSummary.totalMatching != 0>
    	<strong>${response.resultPacket.resultsSummary.totalMatching?string.number}</strong>
    	search result<#if response.resultPacket.resultsSummary.totalMatching &gt; 1>s</#if> for <strong><@s.QueryClean /></strong>
    </#if>
    <#if response.resultPacket.resultsSummary.totalMatching != 0>
        <br/>
    	<small class="text-muted">Showing <strong>${response.resultPacket.resultsSummary.currStart}</strong> -	<strong>${response.resultPacket.resultsSummary.currEnd}</strong>
    	<#if response.resultPacket.resultsSummary.partiallyMatching != 0>
    		where <strong>${response.resultPacket.resultsSummary.fullyMatching?string.number}</strong> match all words and <strong>${response.resultPacket.resultsSummary.partiallyMatching?string.number}</strong> match some words.
    	</#if>			
    	</small>                    
    </#if>
    </h4>    
</#macro>



<#macro DemoShowcase>
<#-- DEMO SHOWCASE MARKUP -->
        <div class="jumbotron">
          <h1><span class="glyphicon glyphicon-search text-muted"></span> Funnelback</h1>
          <p>We're a search company, not an advertising company&hellip;</p>
          <!-- TODO: --><p><a class="btn btn-primary btn-large" href="#"><span class="glyphicon glyphicon-film"></span> 2min Video Tour</a> <a class="btn btn-primary btn-large" href="#"><span class="glyphicon glyphicon-film"></span> 10min Video Tour</a>
          <!-- <p><a class="btn btn-primary btn-large" href="${SearchPrefix}help/simple_search.html">Simple Help</a> <a class="btn btn-large btn-default" href="${SearchPrefix}help/query_language_help.html">Query Language</a></p> -->
        </div>
        
        <div class="row">
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Online Marketers</h3>
                    <p>Brief description of benefits and capabilities</p>
                    <p><a href="#" class="btn btn-primary">Let's measure!</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>End Users</h3>
                    <p>Familiar, powerful interfaces, flexibly delivered.</p>
                    <p><a href="#" class="btn btn-primary">Let's search!</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Developers</h3>
                    <p>No more search 'black box' - crack it open and make it dance.</p>
                    <p><a href="#" class="btn btn-primary">Let's develop!</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Content Managers</h3>
                    <p>You spent good money creating that content.  Make sure it gets found and used.</p>
                    <p><a href="#" class="btn btn-primary">Let's manage search!</a></p>
                  </div>
                </div>
            </div>
        </div>
        
        <div class="row">            
            <h2>Your Users</h2>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Simple UI, powerful filters</h3>
                    <p>Brief description of benefits and capabilities</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Go beyond Query Completion</h3>
                    <p>Anticipate your users' needs, and meet them instantly, in their own terms.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Dynamic ranking</h3>
                    <p>Learn from users' behaviours.  Take control of result relevance with dozens of custom influencers.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Proudly Made in Australia</h3>
                    <p>Used worlwide in the government, university, finance and banking sectors.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
        </div>
        
        <div class="row">            
            <h2>For Marketers</h2>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Powerful analytics</h3>
                    <p>Brief description of benefits and capabilities</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>We speak your users' language</h3>
                    <p>Localised interfaces, univeral query processing.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Expose context</h3>
                    <p>Brief description of benefits and capabilities</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Easy to administer.</h3>
                    <p>Brief description of benefits and capabilities</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <h2>For Developers</h2>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Open interfaces</h3>
                    <p>HTML, XML, JSON, RSS, GeoJSON and OpenSearch interfaces all available natively via REST calls.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Extensible</h3>
                    <p>Customise filters, workflows, query processing and outputs to your heart's content.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Deployment Options</h3>
                    <p>Hosted? Installed? Linux? Windows?  Centralised or distributed architecture? It's your choice.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Plays well with others</h3>
                    <p>Index web collections, filesystems, JDBC-compliant databases, TRIM, Matrix and LDAP.  Go further with Manifold CF.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
        </div> <!-- /.row -->

        <div class="row">
            <h2>For Administrators</h2>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Real Support. From Real People.</h3>
                    <p>You'll be able to get us on the phone.  24hrs a day, 7 days a week, if you need it.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Leverage legacy data</h3>
                    <p>Extract greater ROI from legacy systems and repositories without the cost and headaches of data migrations.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Deployment Options</h3>
                    <p>Hosted? Installed? Linux? Windows?  Your choice.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="thumbnail">
                  <img src="http://placehold.it/300x200" alt="">
                  <div class="caption">
                    <h3>Plays well with others</h3>
                    <p>Native support for web collections, filesystems, JDBC-compliant databases, TRIM, Matrix and LDAP.  Extend further with Manifold CF.</p>
                    <p><a href="#" class="btn btn-primary">Example</a> <a href="#" class="btn btn-default">Docs</a></p>
                  </div>
                </div>
            </div>
        </div> <!-- /.row -->
</#macro>

<#macro JavaScripts>
    <#-- JAVASCRIPTS -->
	<script src="http://code.jquery.com/jquery.js"></script>
    <#-- <script src="/s/resources/<@s.cfg>collection</@s.cfg>/bootstrap.min.js"></script> -->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0-wip/js/bootstrap.min.js"></script>
    <script type="text/javascript">
    /* Modernizr 2.6.2 (Custom Build) | MIT & BSD
    * Build: http://modernizr.com/download/#-geolocation-shiv-cssclasses-load
    */
    ;window.Modernizr=function(a,b,c){function u(a){j.cssText=a}function v(a,b){return u(prefixes.join(a+";")+(b||""))}function w(a,b){return typeof a===b}function x(a,b){return!!~(""+a).indexOf(b)}function y(a,b,d){for(var e in a){var f=b[a[e]];if(f!==c)return d===!1?a[e]:w(f,"function")?f.bind(d||b):f}return!1}var d="2.6.2",e={},f=!0,g=b.documentElement,h="modernizr",i=b.createElement(h),j=i.style,k,l={}.toString,m={},n={},o={},p=[],q=p.slice,r,s={}.hasOwnProperty,t;!w(s,"undefined")&&!w(s.call,"undefined")?t=function(a,b){return s.call(a,b)}:t=function(a,b){return b in a&&w(a.constructor.prototype[b],"undefined")},Function.prototype.bind||(Function.prototype.bind=function(b){var c=this;if(typeof c!="function")throw new TypeError;var d=q.call(arguments,1),e=function(){if(this instanceof e){var a=function(){};a.prototype=c.prototype;var f=new a,g=c.apply(f,d.concat(q.call(arguments)));return Object(g)===g?g:f}return c.apply(b,d.concat(q.call(arguments)))};return e}),m.geolocation=function(){return"geolocation"in navigator};for(var z in m)t(m,z)&&(r=z.toLowerCase(),e[r]=m[z](),p.push((e[r]?"":"no-")+r));return e.addTest=function(a,b){if(typeof a=="object")for(var d in a)t(a,d)&&e.addTest(d,a[d]);else{a=a.toLowerCase();if(e[a]!==c)return e;b=typeof b=="function"?b():b,typeof f!="undefined"&&f&&(g.className+=" "+(b?"":"no-")+a),e[a]=b}return e},u(""),i=k=null,function(a,b){function k(a,b){var c=a.createElement("p"),d=a.getElementsByTagName("head")[0]||a.documentElement;return c.innerHTML="x<style>"+b+"</style>",d.insertBefore(c.lastChild,d.firstChild)}function l(){var a=r.elements;return typeof a=="string"?a.split(" "):a}function m(a){var b=i[a[g]];return b||(b={},h++,a[g]=h,i[h]=b),b}function n(a,c,f){c||(c=b);if(j)return c.createElement(a);f||(f=m(c));var g;return f.cache[a]?g=f.cache[a].cloneNode():e.test(a)?g=(f.cache[a]=f.createElem(a)).cloneNode():g=f.createElem(a),g.canHaveChildren&&!d.test(a)?f.frag.appendChild(g):g}function o(a,c){a||(a=b);if(j)return a.createDocumentFragment();c=c||m(a);var d=c.frag.cloneNode(),e=0,f=l(),g=f.length;for(;e<g;e++)d.createElement(f[e]);return d}function p(a,b){b.cache||(b.cache={},b.createElem=a.createElement,b.createFrag=a.createDocumentFragment,b.frag=b.createFrag()),a.createElement=function(c){return r.shivMethods?n(c,a,b):b.createElem(c)},a.createDocumentFragment=Function("h,f","return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&("+l().join().replace(/\w+/g,function(a){return b.createElem(a),b.frag.createElement(a),'c("'+a+'")'})+");return n}")(r,b.frag)}function q(a){a||(a=b);var c=m(a);return r.shivCSS&&!f&&!c.hasCSS&&(c.hasCSS=!!k(a,"article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}")),j||p(a,c),a}var c=a.html5||{},d=/^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i,e=/^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i,f,g="_html5shiv",h=0,i={},j;(function(){try{var a=b.createElement("a");a.innerHTML="<xyz></xyz>",f="hidden"in a,j=a.childNodes.length==1||function(){b.createElement("a");var a=b.createDocumentFragment();return typeof a.cloneNode=="undefined"||typeof a.createDocumentFragment=="undefined"||typeof a.createElement=="undefined"}()}catch(c){f=!0,j=!0}})();var r={elements:c.elements||"abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup mark meter nav output progress section summary time video",shivCSS:c.shivCSS!==!1,supportsUnknownElements:j,shivMethods:c.shivMethods!==!1,type:"default",shivDocument:q,createElement:n,createDocumentFragment:o};a.html5=r,q(b)}(this,b),e._version=d,g.className=g.className.replace(/(^|\s)no-js(\s|$)/,"$1$2")+(f?" js "+p.join(" "):""),e}(this,this.document),function(a,b,c){function d(a){return"[object Function]"==o.call(a)}function e(a){return"string"==typeof a}function f(){}function g(a){return!a||"loaded"==a||"complete"==a||"uninitialized"==a}function h(){var a=p.shift();q=1,a?a.t?m(function(){("c"==a.t?B.injectCss:B.injectJs)(a.s,0,a.a,a.x,a.e,1)},0):(a(),h()):q=0}function i(a,c,d,e,f,i,j){function k(b){if(!o&&g(l.readyState)&&(u.r=o=1,!q&&h(),l.onload=l.onreadystatechange=null,b)){"img"!=a&&m(function(){t.removeChild(l)},50);for(var d in y[c])y[c].hasOwnProperty(d)&&y[c][d].onload()}}var j=j||B.errorTimeout,l=b.createElement(a),o=0,r=0,u={t:d,s:c,e:f,a:i,x:j};1===y[c]&&(r=1,y[c]=[]),"object"==a?l.data=c:(l.src=c,l.type=a),l.width=l.height="0",l.onerror=l.onload=l.onreadystatechange=function(){k.call(this,r)},p.splice(e,0,u),"img"!=a&&(r||2===y[c]?(t.insertBefore(l,s?null:n),m(k,j)):y[c].push(l))}function j(a,b,c,d,f){return q=0,b=b||"j",e(a)?i("c"==b?v:u,a,b,this.i++,c,d,f):(p.splice(this.i++,0,a),1==p.length&&h()),this}function k(){var a=B;return a.loader={load:j,i:0},a}var l=b.documentElement,m=a.setTimeout,n=b.getElementsByTagName("script")[0],o={}.toString,p=[],q=0,r="MozAppearance"in l.style,s=r&&!!b.createRange().compareNode,t=s?l:n.parentNode,l=a.opera&&"[object Opera]"==o.call(a.opera),l=!!b.attachEvent&&!l,u=r?"object":l?"script":"img",v=l?"script":u,w=Array.isArray||function(a){return"[object Array]"==o.call(a)},x=[],y={},z={timeout:function(a,b){return b.length&&(a.timeout=b[0]),a}},A,B;B=function(a){function b(a){var a=a.split("!"),b=x.length,c=a.pop(),d=a.length,c={url:c,origUrl:c,prefixes:a},e,f,g;for(f=0;f<d;f++)g=a[f].split("="),(e=z[g.shift()])&&(c=e(c,g));for(f=0;f<b;f++)c=x[f](c);return c}function g(a,e,f,g,h){var i=b(a),j=i.autoCallback;i.url.split(".").pop().split("?").shift(),i.bypass||(e&&(e=d(e)?e:e[a]||e[g]||e[a.split("/").pop().split("?")[0]]),i.instead?i.instead(a,e,f,g,h):(y[i.url]?i.noexec=!0:y[i.url]=1,f.load(i.url,i.forceCSS||!i.forceJS&&"css"==i.url.split(".").pop().split("?").shift()?"c":c,i.noexec,i.attrs,i.timeout),(d(e)||d(j))&&f.load(function(){k(),e&&e(i.origUrl,h,g),j&&j(i.origUrl,h,g),y[i.url]=2})))}function h(a,b){function c(a,c){if(a){if(e(a))c||(j=function(){var a=[].slice.call(arguments);k.apply(this,a),l()}),g(a,j,b,0,h);else if(Object(a)===a)for(n in m=function(){var b=0,c;for(c in a)a.hasOwnProperty(c)&&b++;return b}(),a)a.hasOwnProperty(n)&&(!c&&!--m&&(d(j)?j=function(){var a=[].slice.call(arguments);k.apply(this,a),l()}:j[n]=function(a){return function(){var b=[].slice.call(arguments);a&&a.apply(this,b),l()}}(k[n])),g(a[n],j,b,n,h))}else!c&&l()}var h=!!a.test,i=a.load||a.both,j=a.callback||f,k=j,l=a.complete||f,m,n;c(h?a.yep:a.nope,!!i),i&&c(i)}var i,j,l=this.yepnope.loader;if(e(a))g(a,0,l,0);else if(w(a))for(i=0;i<a.length;i++)j=a[i],e(j)?g(j,0,l,0):w(j)?B(j):Object(j)===j&&h(j,l);else Object(a)===a&&h(a,l)},B.addPrefix=function(a,b){z[a]=b},B.addFilter=function(a){x.push(a)},B.errorTimeout=1e4,null==b.readyState&&b.addEventListener&&(b.readyState="loading",b.addEventListener("DOMContentLoaded",A=function(){b.removeEventListener("DOMContentLoaded",A,0),b.readyState="complete"},0)),a.yepnope=k(),a.yepnope.executeStack=h,a.yepnope.injectJs=function(a,c,d,e,i,j){var k=b.createElement("script"),l,o,e=e||B.errorTimeout;k.src=a;for(o in d)k.setAttribute(o,d[o]);c=j?h:c||f,k.onreadystatechange=k.onload=function(){!l&&g(k.readyState)&&(l=1,c(),k.onload=k.onreadystatechange=null)},m(function(){l||(l=1,c(1))},e),i?k.onload():n.parentNode.insertBefore(k,n)},a.yepnope.injectCss=function(a,c,d,e,g,i){var e=b.createElement("link"),j,c=i?h:c||f;e.href=a,e.rel="stylesheet",e.type="text/css";for(j in d)e.setAttribute(j,d[j]);g||(n.parentNode.insertBefore(e,n),m(c,0))}}(this,document),Modernizr.load=function(){yepnope.apply(window,[].slice.call(arguments,0))};
    </script>
    <script src="/s/resources/<@s.cfg>collection</@s.cfg>/respond.js"></script>
    
    <script type="text/javascript">
        // GeoLocation check
        function get_location() {
            if (Modernizr.geolocation) {
            navigator.geolocation.getCurrentPosition(populate_origin, handle_geolocation_error, {enableHighAccuracy: true});
            } else {
            // no native support;
            }
        }
        function handle_geolocation_error(err) {
            if (err.code == 1) {
            // user said no!
            }
        }
        // Update origin in refinement form and main menu panel
        function populate_origin(position) {
            var latitude = position.coords.latitude;
            var longitude = position.coords.longitude;
            $("#origin").attr("value",(latitude + "," + longitude));
            $("#location-detected").attr("value",(latitude + "," + longitude));
        }

        // Expandable facet categories
        function expandable_facet_categories(defaultFacetCategories) {
            $(".facet .panel ul").each(function(){
                if ($(this).children(".category").size() > defaultFacetCategories) {
                    $(this).children(".category").each(function(){
                        if($(this).index() >= defaultFacetCategories)
                            $(this).hide();
                    });                    
                    $(this).after("<button type='button' class='btn btn-link btn-xs search-toggle-more-categories' title='Show more categories from this facet'><small><span class='glyphicon glyphicon-chevron-down'></span></small>&nbsp;More&hellip;</button>");
                }
            });
                
            // Show all categories
            $(".search-toggle-more-categories").click(function(){
                $(this).siblings("ul").children(".category").show("fast");
                $(this).hide();
            });
        }
                
        function style_selected_facets() {
            $(".panel-body ul").each(function() {
                if($(this).children(".category").size() == 0) {
                    // Suppress facet category panel if empty
                    $(this).parent().hide();
                    $(this).parent().parent().addClass("panel-primary");                    
                    // Hack!
                    $(".facetLabel a").addClass("btn btn-danger btn-xs pull-right").html("<span class='glyphicon glyphicon-remove'></span>").attr("title","Remove category");
                }
            });
        }
        
        $(document).ready(function() {
            // User-disclosed location
            $(".detect-location").click(function() {
                get_location();
            });
                        
            // Expand facet categories
            expandable_facet_categories(5);
            
            // Applicable for non-hierarchical facets only
            style_selected_facets();
            
        });
    </script>
</#macro>


<#--- 
Output Google Analytics tracking code for matching, non-matching, 
and partially-matching events.  Configure google.analytics.UA
setting in collection.cfg.
--->
<#macro GoogleAnalytics>
    <@s.AfterSearchOnly>
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '<@s.cfg>google.analytics.UA</@s.cfg>']);
     
    <#if response.resultPacket.resultsSummary.totalMatching == 0>
        <#-- TRACK QUERIES WITH ZERO RESULTS -->
        _gaq.push(['_setCustomVar', 1, 'No matching results', '<@s.QueryClean/>', 3]);        
    <#else>
        <#if response.resultPacket.resultsSummary.fullyMatching == 0>
        <#-- TRACK QUERIES WITH PARTIALLY-MATCHING RESULTS ONLY -->
        _gaq.push(['_setCustomVar', 1, 'Partially-matching results', '<@s.QueryClean/>', 3]);        
        <#else>
        _gaq.push(['_trackPageview']);
        </#if>
    </#if>
        (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
    </script>
    </@s.AfterSearchOnly>
</#macro>

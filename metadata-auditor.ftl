<#ftl encoding="utf-8" />
<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>
<#--

audit.ftl

Intended for general use metadata auditing, link checking, collection debugging,
etc. 

Uses jQuery and Twitter Bootstap for styling and behaviour.

INSTRUCTIONS:
- Ensure the bootstrap CSS and JS files are located in your collection's resources folder
- Update the <s.InitialFormOnly> <@fb.IncludeUrl url> value to be hard-coded. 
- Modify sort drop-down, <thead>, <tfoot> and <tbody> placeholders to align with metadata mapping 
- Using the 'Subjects' example, adapt the character used for separating multi-value metadata fields

POTENTIAL IMPROVEMENTS:
- Table column sorting?
- Fix broken CSS image references
- Add Funnelback branding
- Expand query syntax output
- Server-side thumbnail re-sizing
- Display description metadata on hover
- Large number of facets can result in 'jagged' layout
- Fix RSS subscription service
- Determine optimal maximum facet category output values (currently hard-coded to 100)
- Include query completion

-->

<!DOCTYPE html>
<html lang="en">
<head>
    <title>
        <@s.AfterSearchOnly>${question.inputParameterMap["query"]!?html}${question.inputParameterMap["query_prox"]!?html}<@s.IfDefCGI name="query">,</@s.IfDefCGI></@s.AfterSearchOnly>
            <@s.cfg>service_name</@s.cfg>, Funnelback Search
    </title>        
    
    <!-- BOOTSTRAP -->
    <link href="/s/resources/${question.inputParameterMap["collection"]!?html}/${question.inputParameterMap["profile"]!?html}/bootstrap.min.css" rel="stylesheet" media="screen">    
    
    <style type="text/css">
        .nowrap {
            white-space: nowrap;
        }
    </style>
    
</head>
<body>
    <@fb.ViewModeBanner />
    
    <h1><a href="/s/search.html?collection=${question.inputParameterMap["collection"]!?html}&amp;form=${question.inputParameterMap["form"]!?html}<#if question.inputParameterMap["profile"]??>&amp;profile=${question.inputParameterMap["profile"]!?html}</#if>">Content Auditor</a> <small><@s.cfg>service_name</@s.cfg></small></h1>

    <h2>Search</h2>
    <!-- QUERY FORM -->
    <form action="${question.collection.configuration.value("ui.modern.search_link")}" method="GET" class="form-inline">            
        <input name="query" id="query" type="search" placeholder="Search terms&hellip;" value="${question.inputParameterMap["query"]!?html}" class="input-xxlarge">
        
        <!-- <input name="meta_u_sand" type="text" <@s.IfDefCGI name="meta_u_sand">value="${question.inputParameterMap["meta_u_sand"]!?html}"</@s.IfDefCGI> placeholder="example.org" /> -->
        <input name="meta_v_sand" type="text" <@s.IfDefCGI name="meta_v_sand">value="${question.inputParameterMap["meta_v_sand"]!?html}"</@s.IfDefCGI> placeholder="/path/to/subsite" />
        
        <!-- ADD CUSTOM SORT MODES FOR ADDITIONAL METADATA FIELDS -->        
        <label for="sort">Sort:</label>
        <@s.Select name="sort" id="sort" options=["=Relevance", "date=Date (Newest First)", "adate=Date (Oldest First)", "url=URL", "title=Title (A-Z)", "dtitle=Title (Z-A)"] />
        <button type="submit" class="btn btn-primary">Search</button>        
        
        <#if response.facets?size &gt; 0>
        <div class="alert"><@s.FacetScope>Within selected categories only</@s.FacetScope></div>
        </#if>
        
        <input type="hidden" name="collection" value="${question.inputParameterMap["collection"]!?html}">
        <@s.IfDefCGI name="enc"><input type="hidden" name="enc" value="${question.inputParameterMap["enc"]!?html}"></@s.IfDefCGI>
        <@s.IfDefCGI name="form"><input type="hidden" name="form" value="${question.inputParameterMap["form"]!?html}"></@s.IfDefCGI>            
        <@s.IfDefCGI name="profile"><input type="hidden" name="profile" value="${question.inputParameterMap["profile"]!?html}"></@s.IfDefCGI>
        
        
        <!-- HARD-CODED -->
        <!-- <input type="hidden" name="explain" value="on" /> -->
        <input type="hidden" name="SM" value="meta" />
        <input type="hidden" name="SF" value="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" />
        <input type="hidden" name="fmo" value="on" />
        <input type="hidden" name="daat" value="0" />
        <input type="hidden" name="num_ranks" value="100" />
        <input type="hidden" name="show_qsyntax_tree" value="true" />
        <input type="hidden" name="showtimes" value="true" />
        
    </form>
    
    <@s.InitialFormOnly>    
        <h2>Browse Metadata</h2>
        <!-- SELF-REFERENTIAL NULL QUERY FOR POPULATING FACETS - CURRENTLY HARD-CODED PATH -->    
        <@fb.IncludeUrl url="http://localhost:8080/s/search.html?collection=COLLECTION&form=audit&query=!padrenullquery&daat=1000&num_ranks=20" start="<!--BEGINFACETS-->" end="<!--ENDFACETS-->" expiry=1 />

    </@s.InitialFormOnly>
    
    <@fb.ErrorMessage />

    <!-- SEARCH -->
    <@s.AfterSearchOnly>
    
        <!-- RESULTS SUMMARY -->
        <p>        

        <#if response.resultPacket.resultsSummary.totalMatching == 0>
            <strong class="fb-result-count" id="fb-total-matching">0</strong> search results for <strong><@s.QueryClean /></strong>
        </#if>
        <#if response.resultPacket.resultsSummary.totalMatching != 0>
            <strong class="fb-result-count" id="fb-page-start">${response.resultPacket.resultsSummary.currStart}</strong> -
            <strong class="fb-result-count" id="fb-page-end">${response.resultPacket.resultsSummary.currEnd}</strong> of
            <strong class="fb-result-count" id="fb-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</strong>
            search results for <strong><@s.QueryClean /></strong>
        </#if>
        <#if response.resultPacket.resultsSummary.partiallyMatching != 0>
            where
            <span class="fb-result-count" id="fb-fully-matching">
                ${response.resultPacket.resultsSummary.fullyMatching?string.number}
            </span>
            match all words and
            <span class="fb-result-count" id="fb-partially-matching">
                ${response.resultPacket.resultsSummary.partiallyMatching?string.number}
            </span>
            match some words.
        </#if>
    </p>
    
    <!-- TABBED NAVIGATION -->
    <div class="tabbable"> <!-- Only required for left/right tabs -->
      <ul class="nav nav-tabs">
        <li class="active"><a href="#refine" data-toggle="tab">Refine</a></li>
        <li><a href="#table" data-toggle="tab">Table</a></li>        
        <li><a href="#performanceMetrics" data-toggle="tab">Performance</a></li>
        <li><a href="#querySyntaxTree" data-toggle="tab">Query Syntax</a></li>        
        <li><a href="#metadataMapping" data-toggle="tab">Metadata Mapping</a></li>
      </ul>
      
      <div class="tab-content">
        
    
    <div class="tab-pane active" id="refine">
        
        <!--BEGINFACETS-->
        <@s.FacetedSearch>                        
            <div id="fb-facets" class="row-fluid">
                <@s.Facet>
                    <div class="span3">
                    <h4><@s.FacetLabel summary=false /><@s.FacetSummary /></h4>
                    <@s.Category max=100>
                        <@s.CategoryName />&nbsp;<span class="fb-facet-count">&nbsp;<span class="badge"><@s.CategoryCount /></span></span>
                    </@s.Category>
                    <@s.MoreOrLessCategories />
                    </div>
                </@s.Facet>
            </div>
        </@s.FacetedSearch>
        <!--ENDFACETS-->
      
    </div> <!-- /#refine -->
    
    
    <div class="tab-pane" id="table">
        <a class="btn" href="/s/search.html?${QueryString?replace("form=audit","form=csv_export")?replace("num_ranks=100","num_ranks=10000")}">Download as CSV (Maximum 10K Records)</a>    
        
        <!-- RSS.CGI BROKEN ON TRAINING VM -->
        <!--<a class="btn" href="/search/rss.cgi?${QueryString}">Subscribe</a> -->
        
        <!-- RESULTS -->
        <table class="table table-striped">
        <thead>
            <tr>
                <th scope="col">Actions</th> 
                <th scope="col">Title</th>
                <th scope="col">Site</th>            
                <th scope="col">Date</th>
                <th scope="col">Format</th>
                
                <!-- BEGIN CUSTOM METADATA FIELDS -->
                <th scope="col">Thumbnail</th>
                <!-- <th scope="col">Author</th> -->
                <th scope="col">Type</th>
                <th scope="col">Subjects</th>
                <th scope="col">Keywords</th>
                <th scope="col">Tags</th>
                <!-- END CUSTOM METADATA FIELDS -->
                
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th scope="col">Actions</th>    
                <th scope="col">Title</th>
                <th scope="col">Site</th>            
                <th scope="col">Date</th>
                <th scope="col">Format</th>
                
                <!-- BEGIN CUSTOM METADATA FIELDS -->
                <th scope="col">Thumbnail</th>
                <!-- <th scope="col">Author</th> -->
                <th scope="col">Type</th>
                <th scope="col">Subjects</th>
                <th scope="col">Keywords</th>
                <th scope="col">Tags</th>
                <!-- END CUSTOM METADATA FIELDS -->
                
                                                
            </tr>
        </tfoot>
        <tbody>
            <!-- EACH RESULT -->
            <@s.Results>
                <#if s.result.class.simpleName == "TierBar">
                    <#-- A tier bar -->
                    <#if s.result.matched != s.result.outOf>
                        <tr>
                            <td colspan="11">Search results that match ${s.result.matched} of ${s.result.outOf} words</td>
                        </tr>
                    </#if>
                <#else>
                <tr>
                    <!-- ACTIONS -->
                    <td>
                        <div class="btn-group">
                          <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                            <i class="icon-cog"></i>
                            <span class="caret"></span>
                          </a>
                          <ul class="dropdown-menu">
                            <li><a href="/s/anchors.html?collection=${question.inputParameterMap["collection"]!?html}&amp;docnum=${s.result.docNum?c}">Anchors</a></li>
                          </ul>
                        </div>
                        
                    </td>
                
                    <!-- TITLE -->
                    <td><a href="${s.result.liveUrl?html}" title="${s.result.title}"><@s.Truncate 150>${s.result.title}</@s.Truncate></a></td>
                    
                    <!-- SITE (Z) -->
                    <td>
                    <#if s.result.metaData["Z"]??>
                        ${s.result.metaData["Z"]}
                    <#else>                        
                        &nbsp;
                    </#if>
                    </td>
                    
                    <!-- DATE -->
                    <td class="nowrap">
                    <#if s.result.date??>
                        ${s.result.date?date?string("yyyy-MM-dd")}                    
                    <#else>
                        No Date
                    </#if>
                    </td>
                    
                    <!-- FORMAT -->
                    <td>
                    <#if s.result.filetype??>
                        ${s.result.filetype}
                    <#else>
                        &nbsp;
                    </#if>                        
                    </td>
                    
                    <!-- THUMBNAIL -->
                    <td>
                    <#if s.result.metaData["I"]??>
                        <img src="${s.result.metaData["I"]}" width="80px" height="80px" />
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
                                        
                    <!-- AUTHOR -->
                    <#--
                    <td>
                    <#if s.result.metaData["a"]??>
                        ul>
                        <#list s.result.metaData["a"]?split("|") as value>
                        <li>${value}</li>
                        </#list>  
                        </ul>
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
                    -->
                    
                    <!-- TYPE -->
                    <td>
                    <#if s.result.metaData["e"]??>
                        <ul>
                        <#list s.result.metaData["e"]?split("|") as value>
                            <li>${value}</li>
                        </#list>  
                        </ul>
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
                    
                    <!-- SUBJECT (s) -->
                    <td>
                    <#if s.result.metaData["s"]??>
                        <ul>
                        <#list s.result.metaData["s"]?split(";") as value>
                            <li>${value}</li>
                        </#list>  
                        </ul>
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
                    
                    <!-- KEYWORDS -->
                    <td>
                    <#if s.result.metaData["w"]??>
                        <ul>
                        <#list s.result.metaData["w"]?split(",") as value>
                            <li>${value}</li>
                        </#list>  
                        </ul>
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
                    
                    <!-- TAGS -->
                    <td>
                    <#if s.result.metaData["T"]??>
                        <ul>
                        <#list s.result.metaData["T"]?split(";") as value>
                            <li>${value}</li>
                        </#list>  
                        </ul>
                    <#else>
                        &nbsp;
                    </#if>
                    </td>
  
                </tr>
                </#if>
            </@s.Results>                
        </tbody>
    </table>

    <!-- NO RESULTS -->
    <#if response.resultPacket.resultsSummary.totalMatching == 0>
        <p id="fb-no-results">Your search for <strong>${question.inputParameterMap["query"]!?html}</strong> did not return any results. <span>Please ensure that you:</span>
            <ul>
                <li>are not using any advanced search operators like + - | " etc.</li> 
                <li>expect this document to exist within the <em><@s.cfg>service_name</@s.cfg></em><@s.IfDefCGI name="scope"> and within <em><@s.Truncate length=80>${question.inputParameterMap["scope"]!?html}</@s.Truncate></em></@s.IfDefCGI></li>
                <li>have permission to see any documents that may match your query</li>
            </ul>
        </p> 
    </#if>
    
    <!-- RESULTS SUMMARY -->
    <p class="<@s.FacetedSearch>fb-with-faceting</@s.FacetedSearch>">        

        <#if response.resultPacket.resultsSummary.totalMatching == 0>
            <strong class="fb-result-count" id="fb-total-matching">0</strong> search results for <strong><@s.QueryClean /></strong>
        </#if>
        <#if response.resultPacket.resultsSummary.totalMatching != 0>
            <strong class="fb-result-count" id="fb-page-start">${response.resultPacket.resultsSummary.currStart}</strong> -
            <strong class="fb-result-count" id="fb-page-end">${response.resultPacket.resultsSummary.currEnd}</strong> of
            <strong class="fb-result-count" id="fb-total-matching">${response.resultPacket.resultsSummary.totalMatching?string.number}</strong>
            search results for <strong><@s.QueryClean /></strong>
        </#if>
        <#if response.resultPacket.resultsSummary.partiallyMatching != 0>
            where
            <span class="fb-result-count" id="fb-fully-matching">
                ${response.resultPacket.resultsSummary.fullyMatching?string.number}
            </span>
            match all words and
            <span class="fb-result-count" id="fb-partially-matching">
                ${response.resultPacket.resultsSummary.partiallyMatching?string.number}
            </span>
            match some words.
        </#if>
    </p>


    <!-- PAGINATION -->
    <div class="pagination pagination-large">
      <ul>
        <@fb.Prev><li><a href="${fb.prevUrl?html}">Prev</a></li></@fb.Prev>
        <@fb.Page>
        <li <#if fb.pageCurrent> class="active"</#if>><a href="${fb.pageUrl?html}">${fb.pageNumber}</a></li>
        </@fb.Page>
        <@fb.Next><li><a href="${fb.nextUrl?html}">Next</a></li></@fb.Next>
      </ul>
    </div>
        
          
    </div> <!-- /#table -->
    
    
    
    <!-- QUERY DEBUGGING -->
    <div class="tab-pane" id="querySyntaxTree">
        <h2>Query Debugging</h2>
           <dl>
                <dt>Original Query</dt>
                <dd>${question.originalQuery}</dd>
                <dt>Query as Processed</dt>
                <dd>${response.resultPacket.queryAsProcessed}</dd>
                <dt>Cleaned Query</dt>
                <dd>${response.resultPacket.queryCleaned}</dd>
                <dt>Spelling Suggestions</dt>
                <dd><#if response.resultPacket.spell??>${response.resultPacket.spell["text"]}</#if></dd>
                <dt>Supplementary Query Terms</dt>
                <dd><#if response.resultPacket.qsups?exists>${response.resultPacket.qsups}</#if></dd>
                <dt>Expanded Query Terms</dt>
                <dd>SUPS</dd>
                <dt>Stopwords Removed</dt>
                <dd>TODO</dd>
            </dl>
        <#if response?? && response.resultPacket??
            && response.resultPacket.svgs??
            && response.resultPacket.svgs["syntaxtree"]??>
            <h2>Query Syntax Tree</h2>
                     
            
            ${response.resultPacket.svgs["syntaxtree"]}
        </#if>
    </div> <!-- /#queryTree -->
    
    <!-- PERFORMANCE METRICS -->
    <div class="tab-pane" id="performanceMetrics">
        <h2>Performance Metrics</h2>
        <@fb.PerformanceMetrics />
    </div> <!-- /#times -->
    
    <div class="tab-pane" id="metadataMapping">
        <h2>Metadata Mapping</h2>
     <table class="table">
            <thead>
                <tr>
                <th>Field Name</th>
                <th>Metadata Source(s)</th>
                </tr>
            </thead>
            <tfoot>
                <tr>
                <th>Field Name</th>
                <th>Metadata Source(s)</th>
                </tr>
            </tfoot>
            <tbody>
                <!-- TODO -->
            </tbody>
        </table>
        </div> <!-- /#metadataMapping -->
        
      </div> <!-- /.tab-content -->
    </div> <!-- /.tabbable -->

    </@s.AfterSearchOnly>

    <!-- SCRIPTS -->
    <script src="http://code.jquery.com/jquery.js"></script>
    <script src="/s/resources/${question.inputParameterMap["collection"]!?html}/${question.inputParameterMap["profile"]!?html}/bootstrap.min.js"></script>
    
</body>
</html>

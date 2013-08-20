templates
=========

Search templates for Funnelback's Modern UI templating system.

Authored for Funnelback v12.4.  Funnelback 11.x may require minor macro revisions.

Generic stand-alones:
- rss.ftl (Outputs results in RSS 2.0 specification.  Date metadata and date sort modes required.)
- geojson.ftl (Outputs results in GeoJSON specificatoin.  Geospatial metadata required.)

Bootstrap-powered suite:
- Pre-requisites: Bootstrap v3 (https://github.com/twbs/bootstrap) + Glyphicons (http://glyphicons.getbootstrap.com/) added to collections' web resources folder (http://docs.funnelback.com/12.4/web_resources_folder.html)
- bootstrap-search.ftl (contains Freemarker macros outputting Bootstrap-friendly markup - required for suite)
- list.ftl (list-based search result output based on Bootstrap markup patterns)
- map.ftl (map-based search result output based on Bootstrap markup patterns and Leaflet mapping library)
- gallery.ftl (gallery-based search result output based on Bootstrap markup patterns)
- timeline.ftl (timeline-based search result output based on the Almende GitHub Timeline project)
- table.ftl (table-based search result output)

Related Gists:
- https://gist.github.com/funnelback

Recommended reading:
- http://docs.funnelback.com/12.4/search_forms.html
- http://docs.funnelback.com/12.4/freemarker.html
- http://docs.funnelback.com/12.4/user_interface.html
- http://docs.funnelback.com/12.4/data_model.html
- http://freemarker.org/docs/

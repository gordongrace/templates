templates
=========

Search templates for Funnelback's Modern UI templating system.

Generic stand-alones:
- rss.ftl (Outputs results in RSS 2.0 specification.  Date metadata and date sort modes required.)
- geojson.ftl (Outputs results in GeoJSON specificatoin.  Geospatial metadata required.)

Bootstrap-powered suite:
- Pre-requisites: Bootstrap v3 + glyphicons added to collections' web resources folder
- bootstrap-search.ftl (contains Freemarker macros outputting Bootstrap-friendly markup - required for suite)
- list.ftl (list-based search result output based on Bootstrap markup patterns)
- map.ftl (map-based search result output based on Bootstrap markup patterns and Leaflet mapping library)
- gallery.ftl (gallery-based search result output based on Bootstrap markup patterns)
- timeline.ftl (timeline-based search result output based on the Almende GitHub Timeline project)
- table.ftl (table-based search result output)

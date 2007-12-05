
var map, layer_metacarta_base, layer_base, 
    layer_landslides, layer_arterials, layer_friends;
var mapfile = '/home/wcooley/public_html/webgis/test.map';
var mapserv_url = 'http://haus.nakedape.cc/cgi-bin/mapserv';
//var mapserv_url = 'http://scatha.oit.pdx.edu/cgi-bin/mapserv';
var tilecache_url = 'http://haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi';
var lon     = -122.671;
var lat     = 45.525;
var zoom    = 8;

function init(){
    map = new OpenLayers.Map( 'map', { controls: [] } );

    map.addControl( new OpenLayers.Control.PanZoomBar()     );
    map.addControl( new OpenLayers.Control.MouseToolbar()   );
    map.addControl( new OpenLayers.Control.MousePosition()  );
    map.addControl( new OpenLayers.Control.LayerSwitcher()  );
    map.addControl( new OpenLayers.Control.Permalink()      );
    map.addControl( new OpenLayers.Control.OverviewMap()    );
    map.addControl( new OpenLayers.Control.Scale()    );
    map.addControl( new OpenLayers.Control.KeyboardDefaults()  );
    map.addControl( new OpenLayers.Control.Navigation()    );

    layer_metacarta_base = new OpenLayers.Layer.WMS(
                "OpenLayers WMS", 
                "http://labs.metacarta.com/wms/vmap0",
                {
                    layers:         'basic'
                },
                {
                    isBaseLayer:    true,
                }
            );

    layer_base = new OpenLayers.Layer.MapServer(
                'Multnomah, Clackamas and Washington Counties', 
                mapserv_url,
                { 
                    map:            mapfile, 
                    layers:         'counties oregon',
                },
                {
                    isBaseLayer:    true,
                }
            );
/*
    layer_base = new OpenLayers.Layer.WMS(
                'Multnomah, Clackamas and Washington Counties', 
                tilecache_url,
                { 
                    map:            mapfile, 
                    layers:         'oregon-ms',
                    //layers:         'counties oregon',
                    format:         'image/png',
                },
                {
                    isBaseLayer:    true,
                    reproject:      false,
                }
            );
*/
    test = 433000;
    layer_landslides = new OpenLayers.Layer.MapServer(
                'Landslides', 
                mapserv_url,
                { 
                    map:            mapfile, 
                    layers:         'landslides', 
                },
                {
                    isBaseLayer:    false,
                    minScale:       test,
                }
            );

    layer_arterials = new OpenLayers.Layer.MapServer(
                'Arterial Roadways', 
                mapserv_url,
                { 
                    map:            mapfile, 
                    layers:         'arterials', 
                },
                {
                    isBaseLayer:    false,
                    visibility:     false,
                }
            );

    layer_friends = new OpenLayers.Layer.GML(
                "Friends' Homes", 
                "Friends.kml", 
                {
                    format: OpenLayers.Format.KML,
                    minScale:       test,
                }, {}
            );




    map.addLayers([ 
            layer_base,
            layer_landslides,
            layer_friends,
        ]);

    map.setCenter( new OpenLayers.LonLat(lon, lat), zoom );

}

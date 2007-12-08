var map;

function init(){

    var tilecache_url = [
        'http://a.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
        'http://c.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
        'http://d.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
    ];

    var mapfile = ( 'haus.nakedape.cc' == location.hostname )
        ? '/net/rheingold/home/wcooley/public_html/webgis/oregon.map'
        : '/home/wcooley/public_html/webgis/oregon.map'
        ;

    var mapserv_url         = location.protocol + '//' 
                            + location.hostname + '/' 
                            + 'cgi-bin/mapserv';
                            
    OpenLayers.Console.log(mapfile);

    var lon                 = -122.594;
    var lat                 =  45.494; 

    var defaultZoom         = 1;
    var friends_minScale    = 622010;

    var oregonwms_bounds    = new OpenLayers.Bounds(
                                -130,38,
                                -110,47
                            );

    var resolutions         = [
                                0.015800781250000007,
                                0.0039501953125000017,
                                0.0019750976562500008,
                                0.00049377441406250021,
                                0.00012344360351562505,
                                6.1721801757812526e-05,
                                1.5430450439453132e-05,
                                3.8576126098632829e-06,
                                1.9288063049316414e-06,
                                4.8220157623291036e-07,
                                1.2055039405822759e-07,
                                3.0137598514556897e-08
                            ];

    map = new OpenLayers.Map( 'map', 
        { 
            maxExtent: oregonwms_bounds,
            maxResolution: resolutions[0], 
            controls: [] 
        } 
    );
    map.addControl( new OpenLayers.Control.MouseToolbar()   );
    map.addControl( new OpenLayers.Control.PanZoomBar()     );
    map.addControl( new OpenLayers.Control.MousePosition()  );
    map.addControl( new OpenLayers.Control.LayerSwitcher()  );
    map.addControl( new OpenLayers.Control.Permalink()      );
    map.addControl( new OpenLayers.Control.Scale()    );
    map.addControl( new OpenLayers.Control.KeyboardDefaults()  );
    map.addControl( new OpenLayers.Control.Navigation()    );

    var layer_base = new OpenLayers.Layer.WMS(
                'Oregon and counties via TileCache and WMS', 
                tilecache_url,
                { 
                    layers:         'oregon-wms',
                    format:         'image/png',
                    transparent:    true,
                    srs:            'EPSG:4326',
                },
                {
                    isBaseLayer:    true,
                    reproject:      false,
                    opacity:        0.7,
                    maxExtent:      oregonwms_bounds,
                    resolutions:    resolutions,
                }
            );

    var layer_base_wms = new OpenLayers.Layer.WMS(
                'Oregon and counties via MapServer as WMS', 
                mapserv_url + '?' + mapfile,
                { 
                    layers:         'oregon,counties',
                    format:         'image/png',
                    transparent:    true,
                    srs:            'EPSG:4326',
                },
                {
                    isBaseLayer:    true,
                    reproject:      false,
                    opacity:        0.7,
                    maxExtent:      oregonwms_bounds,
                    resolutions:    resolutions,
                }
            );

    var layer_counties_ann = new OpenLayers.Layer.MapServer(
                'County Labels via MapServer (Untiled)', 
                mapserv_url,
                {
                    map:            mapfile,
                    layers:         'counties_ann',
                    format:         'image/png',
                    srs:            'EPSG:4326',
                    transparent:    true,
                },
                {
                    isBaseLayer:    false,
                    visibility:     true,
                    transparent:    true,
                    maxExtent:      oregonwms_bounds,
                    singleTile:     true,
                    displayInLayerSwitcher: false,
                }
            );

    var layer_oregon_ms = new OpenLayers.Layer.MapServer(
                'Oregon via MapServer w/o TileCache', 
                mapserv_url,
                {
                    map:            mapfile,
                    layers:         'oregon counties',
                    format:         'image/png',
                    srs:            'EPSG:4326',
                    transparent:    true,
                },
                {
                    resolutions:    resolutions,
                    isBaseLayer:    true,
                    visibility:     false,
                    maxExtent:      oregonwms_bounds,
                }
            );

    var layer_hillshade = new OpenLayers.Layer.WMS(
                'Oregon Hillshade',
                tilecache_url,
                {
                    layers:         'oregon-hillshade',
                    format:         'image/png',
                    srs:            'EPSG:4326',
                },
                {
                    isBaseLayer:    false,
                    visibility:     false,
                    reproject:      false,
                    opacity:        0.7,
                    maxExtent:      oregonwms_bounds,
                    resolutions:    resolutions.slice(0,4),
                }
            );



    var layer_friends = new OpenLayers.Layer.GML(
                "Friends' Homes", 
                "Friends.kml", 
                {
                    format: OpenLayers.Format.KML,
                    minScale:   friends_minScale,
                }
            );

    map.addLayers([ 
            layer_hillshade,
            layer_oregon_ms,
            layer_counties_ann,
            layer_base,
            layer_base_wms,
            layer_friends,
        ]);

    map.setCenter( new OpenLayers.LonLat(lon, lat), defaultZoom );

//    OpenLayers.Console.dir(map);
}


var map, layer_base, layer_friends; 
var tilecache_url = [
    'http://a.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
    'http://c.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
    'http://d.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi',
    ];
//var tilecache_url = 'http://a.haus.nakedape.cc/~wcooley/tilecache/bin/tilecache.cgi';
var mapfile = '/home/wcooley/public_html/webgis/oregon.map';
//var mapserv_url = 'http://b.haus.nakedape.cc/cgi-bin/mapserv';
var mapserv_url = 'http://scatha.oit.pdx.edu/cgi-bin/mapserv';
//var lon     = -120.5;
//var lat     = 44.0;
var lon     = -122.594;
var lat     =  45.494; 

var zoom    = 0;

var hillshade_bounds = new OpenLayers.Bounds( 
        -125.3955930, 41.4074868, -115.6037075, 46.5853105);

var oregonwms_bounds = new OpenLayers.Bounds(
        -130,38,-110,47);

var resolutions = [
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

var hs_resolutions = [
    0.015800781250000007,
    0.0039501953125000017,
    0.0019750976562500008,
    0.00049377441406250021
    ];

function init(){
    map = new OpenLayers.Map( 'map', 
        { 
            maxExtent: oregonwms_bounds,

            maxResolution: 0.015800781250000007, 
            controls: [] 
        } 
    );
    map.addControl( new OpenLayers.Control.MouseToolbar()   );
    map.addControl( new OpenLayers.Control.PanZoomBar()     );
    map.addControl( new OpenLayers.Control.MousePosition()  );
    map.addControl( new OpenLayers.Control.LayerSwitcher()  );
    map.addControl( new OpenLayers.Control.Permalink()      );
    //map.addControl( new OpenLayers.Control.OverviewMap()    );
    map.addControl( new OpenLayers.Control.Scale()    );
    map.addControl( new OpenLayers.Control.KeyboardDefaults()  );
    map.addControl( new OpenLayers.Control.Navigation()    );

    layer_base = new OpenLayers.Layer.WMS(
                'Oregon and MuWaCla counties via TileCache and WMS', 
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
                    opacity:        0.3,
                    maxExtent:      oregonwms_bounds,
                    //maxExtent:      hillshade_bounds,
                    resolutions:    resolutions,
                }
            );

    layer_oregon_ms = new OpenLayers.Layer.MapServer(
                'Oregon via MapServer w/o TileCache', 
                mapserv_url,
                {
                    map:            mapfile,
                    layers:         'oregon',
                    format:         'image/png',
                    srs:            'EPSG:4326',
                    transparent:    true,
                },
                {
                    isBaseLayer:    true,
                    visibility:     false,
                //    opacity:        0.3,
                    //maxExtent:      hillshade_bounds,
                    maxExtent:      oregonwms_bounds,
                }
            );

    layer_hillshade = new OpenLayers.Layer.WMS(
                'Oregon Hillshade',
                tilecache_url,
                {
                    layers:         'oregon-hillshade',
                    format:         'image/png',
                    srs:            'EPSG:4326',
                },
                {
                    isBaseLayer:    false,
                    visibility:     true,
                    reproject:      false,
                    opacity:        0.3,
                    //maxExtent:      hillshade_bounds,
                    maxExtent:      oregonwms_bounds,
                    resolutions:    hs_resolutions,
                    //maxResolution:  0.00049377441406250021,
                }
            );



    //test = 622000000;
    //test = 1;
    test = 622010;

    layer_friends = new OpenLayers.Layer.GML(
                "Friends' Homes", 
                "Friends.kml", 
                {
                    format: OpenLayers.Format.KML,
                    minScale:   test,
                },
                {
                    //isBaseLayer:    false,
                }
            );

    map.addLayers([ 
            layer_hillshade,
            layer_oregon_ms,
            layer_base,
            layer_friends,
        ]);

    map.setCenter( new OpenLayers.LonLat(lon, lat), zoom );

}

x
        var lon = 5;
        var lat = 40;
        var zoom = 5;
        var map, layer;

        // Returns
        function get_markers() {

        }

        function init(){
            map = new OpenLayers.Map('map');
            layer = new OpenLayers.Layer.WMS( "OpenLayers WMS", 
                    "http://labs.metacarta.com/wms/vmap0", {layers: 'basic'} );
            map.addLayer(layer);
            map.addLayer(new OpenLayers.Layer.GML("KML", 
                            "Friends.kml", 
                            {format: OpenLayers.Format.KML}));


           
            map.setCenter( new OpenLayers.LonLat(-122.671, 45.525), 9);
        }

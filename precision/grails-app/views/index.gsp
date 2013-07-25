<!DOCTYPE html>
<html>
<head>

    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
    html { height: 100% }
    body { height: 100%; margin: 0; padding: 0 }
    #map-canvas { height: 100% }
    </style>
    <script type="text/javascript"
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDZmLBMQ5X-bjpwxOKAMMip_FnhZkz6xeg&sensor=false">
    </script>
    <script type="text/javascript">


        /* I have included the contents of the TripMarkersActual.js and Trip MarkersPlan.js files below to make it easier to follow the code.
         In reality, the two files are changed each time we move to a new location */
        var TripMarkersActual = [
            ['Phoenix AZ', 33.604470, -112.078700, 0, 'stop', 'black', '<div class="infwdw"><div class="infwdwTitle">Our home base</div>Phoenix AZ 85029</div>', ''],
            ['Bullhead City AZ', 35.128250, -114.572300, 1, 'stop', 'red', '<div class="infwdw"><div class="infwdwTitle">River City RV Park</div>2225 Merrill Ave<br/>Bullhead City AZ 86442<br/>35.128250/-114.572300</div>', ''],
            ['Las Vegas NV', 36.110430, -115.060600, 2, 'stop', 'blue', '<div class="infwdw"><div class="infwdwTitle">Sams Town Crazy Cat House!!!! Boulder RV Park</div>5225 Boulder Highway<br/>Las Vegas NV 89122<br/>36.110430/-115.060600</div>', ''],
            ['Tonopah NV', 38.070300, -117.211100, 3, 'stop', 'green', '<div class="infwdw"><div class="infwdwTitle">Joy Land RV Park</div>1260 Ketten Rd<br/>Tonopah NV 89049<br/>38.070300/-117.211100</div>', ''],
            ['Silver Springs NV', 39.4161922, -119.224832, 3, 'via', '', '', ''],
            ['Carson City NV', 39.117300, -119.773540, 4, 'stop', 'brown', '<div class="infwdw"><div class="infwdwTitle">Comstock Country RV Resort</div>5400 S Carson St<br/>Carson City NV 89701<br/>39.117270/-119.773600</div>', ''],
            ['Klamath Falls OR', 42.215280, -121.746800, 5, 'stop', 'red', '<div class="infwdw"><div class="infwdwTitle">Klamath Falls KOA</div>3435 Shasta Way<br/>Klamath Falls OR 97603<br/>42.215280/-121.746800</div>', '']
        ];
        var TripMarkersPlan = [
            ['Klamath Falls OR', 42.215280, -121.746800, 5, 'stop', 'red', '<div class="infwdw"><div class="infwdwTitle">Klamath Falls KOA</div>3435 Shasta Way<br/>Klamath Falls OR 97603<br/>42.215280/-121.746800</div>', ''],
            ['Bend OR', 44.030080, -121.311400, 7, 'stop', 'green', '(to be determined)', ''],
            ['Salem OR', 44.910980, -122.935100, 8, 'stop', 'yellow', '(to be determined)', ''],
            ['Portland OR', 45.340200, -122.558600, 9, 'stop', 'pink', '(to be determined)', '']
        ];

        var map;

        // set up directions system
        var directionDisplayActual;

        var rendererOptionsActual = {
            suppressMarkers: true
        };

        var polylineOptionsActual = {
            strokeColor: '#FF0000',   //Red
            strokeOpacity: 0.5,
            strokeWeight: 3
        };

        var directionsServiceActual = new google.maps.DirectionsService();


        var directionDisplayPlan;

        var rendererOptionsPlan = {
            suppressMarkers: true
        };

        var polylineOptionsPlan = {
            strokeColor: '#00FF00',   //Green
            strokeOpacity: 0.5,
            strokeWeight: 3
        };








        function initialize() {
 //alert("initialize");
            var directionsServicePlan = new google.maps.DirectionsService();


            // create map definition
            var mapDiv = document.getElementById('map-canvas');

            map = new google.maps.Map(mapDiv, {
                center: new google.maps.LatLng(39.23, -98.74),
                zoom: 3,
                mapTypeId: google.maps.MapTypeId.TERRAIN
            });

            // Close infowindow when click on map
            google.maps.event.addListener(map, 'click', function() {
                infowindow.close();
            });

            //alert("setMarkers");

            // Draw the markers
            setMarkers(map, TripMarkersActual);
            setMarkers(map, TripMarkersPlan);

            //alert("after_setMarkers");

            // Draw the Plan path
            var spotPlace = TripMarkersPlan[0];
            var pathStart = new google.maps.LatLng(spotPlace[1], spotPlace[2]);

            var waypts = [];

            for (var i = 1; i < TripMarkersPlan.length-2; i++) {
                var spotPlace = TripMarkersPlan[i];
                var latLng = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
                waypts.push({
                    location: latLng,
                    stopover: true});
            } // for

            var spotPlace = TripMarkersPlan[TripMarkersPlan.length-1];
            var pathEnd = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
            var request = {
                origin: pathStart,
                destination: pathEnd,
                waypoints: waypts,
                optimizeWaypoints: false,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };



// alert("request plan:"+pathStart+","+pathEnd+","+waypts.length);



            directionsServicePlan.route(request, function(response, status) {

                if (status == google.maps.DirectionsStatus.OK) {
//            directionsDisplayPlan = new google.maps.DirectionsRenderer(rendererOptionsPlan);
// alert("directionsServicePlan callback:"+status);
                    directionsDisplayPlan = new google.maps.DirectionsRenderer({suppressMarkers: true, polylineOptions: polylineOptionsPlan});
                    directionsDisplayPlan.setMap(map);
                    directionsDisplayPlan.setDirections(response);
                } // if
            }); // directionsServicePlan







            // Draw the Actual path
            var spotPlace = TripMarkersActual[0];

            var pathStart = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
            var waypts = [];
            for (var i = 1; i < TripMarkersActual.length-2; i++) {
                var spotPlace = TripMarkersActual[i];
                var latLng = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
                waypts.push({
                    location: latLng,
                    stopover: true});
            } // for

            var spotPlace = TripMarkersActual[TripMarkersActual.length-1];
            var pathEnd = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
            var request = {
                origin: pathStart,
                destination: pathEnd,
                waypoints: waypts,
                optimizeWaypoints: false,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };
// alert("request actual:"+pathStart+","+pathEnd+","+waypts.length);
            directionsServiceActual.route(request, function(response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
// alert("directionsServiceActual callback:"+status);
                    directionsDisplayActual = new google.maps.DirectionsRenderer({suppressMarkers: true, polylineOptions: polylineOptionsActual});
//            directionsDisplayActual = new google.maps.DirectionsRenderer(rendererOptionsActual);
                    directionsDisplayActual.setMap(map);
                    directionsDisplayActual.setDirections(response);
                } // if
            }); // directionsServiceActual

        }




        function calcDrivingRoute() {
            var start = document.getElementById("start").value;
            var end = document.getElementById("end").value;
            var request = {
                origin: start,
                destination: end,
                travelMode: google.maps.TravelMode.DRIVING
            };

            directionsService.route(request, function(result, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(result);
                }
            });
        }

            function calcRailRoute() {
                var start = document.getElementById("start").value;
                var end = document.getElementById("end").value;
                var request = {
                    origin: start,
                    destination: end,
                    travelMode: google.maps.TravelMode.TRANSIT                //HEAVY_RAIL
                };

                directionsService.route(request, function(result, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(result);
                    }
                });
            }


                // initialize infowindow
        var infowindow = new google.maps.InfoWindow({
            maxWidth: 250
        });




        // function to setup markers
        function setMarkers(map, locations) {
            var shadow = new google.maps.MarkerImage('http://Violette.com/MapFiles/Icons/shadowpaddle.png',
                    new google.maps.Size(41, 27),
                    new google.maps.Point(0, 0),
                    new google.maps.Point(13, 27)
            );

// alert("processing "+locations.length+" locations");
            for (var i = 0; i < locations.length; i++) {
                var spotPlace = locations[i];
// alert("locations["+i+"]="+spotPlace);
                var isStop = spotPlace[4];
                if (isStop == 'stop') {
                    var latLng = new google.maps.LatLng(spotPlace[1], spotPlace[2]);
                    var markerNbr = spotPlace[3];
                    var markerColor = spotPlace[5];
                    var markerTitle = spotPlace[0];
                    var image = new google.maps.MarkerImage('http://Violette.com/MapFiles/Icons/' + markerColor + Right('00' + markerNbr, 2) + '.png',
                            new google.maps.Size(27, 27),
                            new google.maps.Point(0, 0),
                            new google.maps.Point(13, 27)
                    );
                    var infoContent = spotPlace[6];
                    createMarker(latLng, map, image, shadow, markerTitle, infoContent);
                };
            } // for
        } // setMarkers

        // function to create markers
        function createMarker(latLng, map, image, shadow, markerTitle, infoContent) {
            var marker = new google.maps.Marker({
                position: latLng,
                map: map,
                icon: image,
                shadow: shadow,
                title: markerTitle
            });
            google.maps.event.addListener(marker, 'click', function() {
                infowindow.setContent(infoContent);
                infowindow.open(map,marker);
            });
            // This Javascript is based on code provided by the Community Church Javascript Team http://www.bisphamchurch.org.uk/  http://econym.org.uk/gmap/
            // updated for V3 by Larry at: http://www.geocodezip.com/v3_MW_example_map1.html
        } // createMarker

        // function to trim chars from left
        function Right(str, n){
            if(n <= 0)
                return "";
            else if (n > String(str).length)
                return str;
            else {
                var iLen = String(str).length;
                return String(str).substring(iLen, iLen - n);
            }
        } // Right

        google.maps.event.addDomListener(window, 'load', initialize);

//
//        function loadScript() {
//            var script = document.createElement('script');
//            script.type = 'text/javascript';
//            script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&' +
//                    'callback=initialize';
//            document.body.appendChild(script);
//        }
//
//        window.onload = loadScript;

    </script>

</head>

<body>
<div id="map-canvas"/>
</body>

</html>

<?php
// set error reporting
ini_set("display_errors", 1);
ini_set("display_startup_errors", 1);
error_reporting (E_ALL);

if (!extension_loaded("MapScript")) 
    dl("php_mapscript.so");

$map_file="./hillshade.map";
$map1 = ms_newMapObj($map_file);
$image1=$map1->draw();
$image_url1=$image1->saveWebImage();
$image_path1 = $image1->imagepath;

?>
 <HTML>
 <HEAD>
 <TITLE>Mapfile tester</TITLE>
 </HEAD>
 <BODY>
 <?php
 echo "map: <br><img SRC=\"$image_url1\"><br>";
?>

 </BODY>
</html>

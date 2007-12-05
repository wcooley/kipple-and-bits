<?php
// set error reporting
ini_set("display_errors", 1);
ini_set("display_startup_errors", 1);
error_reporting (E_ALL);

if (!extension_loaded("MapScript")) dl("php_mapscript.so");

$map_file="./oregon.map";
$map1 = ms_newMapObj($map_file);
$image1=$map1->draw();
//$image2=$map1->drawreferencemap();
//$image3=$map1->drawlegend();

$image_url1=$image1->saveWebImage();
//$image_url2=$image2->saveWebImage();
//$image_url3=$image3->saveWebImage();

$image_path1 = $image1->imagepath;

//echo $image1."<br>";
//echo $image_url1."<br>";
//echo $image_path1."<br>";

//chmod($image_path1, 0644);

?>
 <HTML>
 <HEAD>
 <TITLE>Mapfile tester</TITLE>
 </HEAD>
 <BODY>
 <?php
 // specify height/width to make the page render a bit faste
 echo "map: <br><img SRC=\"$image_url1\"><br>";
// echo "refmap: <br><img SRC=\"$image_url2\"<br>";
// echo "legend: <br><img SRC=\"$image_url3\"<br>";
?>

 </BODY>
</html>

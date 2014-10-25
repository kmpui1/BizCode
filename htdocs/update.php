<?php

//Create connection
$con=mysqli_connect("localhost","admin","admin","namecarddb");

//Check connection
if(mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_errno();
}

$ID = $_POST['ID'];
$Position = $_POST['Position'];
$Title = $_POST['Title'];
$Name = $_POST['Name'];
$Phone = $_POST['Phone'];
$Company = $_POST['Company'];
$Address = $_POST['Address'];
$Postcode = $_POST['Postcode'];
$Website = $_POST['Website'];


if(empty($Position) || empty($Title) || empty($Name) || empty($Phone) || empty($Company) || empty($Address) || empty($Postcode))
{
	echo "Please do not leave * blank";
}
else
{
	if(empty($Website))
	{
		$sql = "UPDATE namecarddb SET Position = '$Position', Title = '$Title', Name = '$Name', Phone = '$Phone', Company = '$Company', Address = '$Address', Postcode = '$Postcode' WHERE ID = $ID";
	}
	else
	{
		$sql = "UPDATE namecarddb SET Position = '$Position', Title = '$Title', Name = '$Name', Phone = '$Phone', Company = '$Company', Address = '$Address', Postcode = '$Postcode', Website = '$Website' WHERE ID = $ID";
	}
	if(!mysqli_query($con, $sql))
	{
		die('Error: ' . mysqli_error($con));
	}
	
	echo "record updated";

	
}


mysqli_close($con);
?>
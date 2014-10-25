<?php

//Create connection
$con=mysqli_connect("localhost","admin","admin","namecarddb");

//Check connection
if(mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_errno();
}


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
		$sql = "INSERT INTO namecarddb(ID,Position, Title, Name, Phone, Company, Address, Postcode) VALUES (NULL,'$Position','$Title','$Name','$Phone','$Company','$Address','$Postcode')";
	}
	else
	{
		$sql = "INSERT INTO namecarddb(ID,Position, Title, Name, Phone, Company, Address, Postcode, Website) VALUES (NULL,'$Position','$Title','$Name','$Phone','$Company','$Address','$Postcode','$Website')";
	}
	if(!mysqli_query($con, $sql))
	{
		die('Error: ' . mysqli_error($con));
	}
	
	echo "1 record added";

	
}


mysqli_close($con);
?>
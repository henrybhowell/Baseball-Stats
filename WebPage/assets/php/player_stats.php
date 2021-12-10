<html>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Amatic+SC&family=Sen&family=Stoke&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/styles.css">
<body>



  <div class="container-fluid">



  <?php
  $servername = "127.0.0.1"; // Do not use "localhost"

  // In the Real World (TM), you should not connect using the root account.
  // Create a privileged account instead.
  $username = "root";

  // In the Real World (TM), this password would be cracked in miliseconds.
  $password = "123456";

  // Create connection
  $conn = new mysqli($servername, $username, $password);

  // Check connection
  if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
  }


  $dbname = "Baseball";

  mysqli_select_db($conn, $dbname) or die("Could not open the '$dbname'");

  $pName = $_POST['pName'];
  $sDate = $_POST['sDate'];
  $eDate = $_POST['eDate'];
  $stat = $_POST['stat'];

  $test_query = "CALL pitcherSeasonStats('$tname', '$oname', $home, $away, '$sdate', '$edate');";
  $result = mysqli_query($conn, $test_query);

  echo "<div class='col align-self-center tables'>";
  echo "<h1> Pitcher Statistics for " . $pName . "</h1>";

  echo "<br>";
  echo "<table border='1'>
          <tr>
          <th>Player_id</th>
          <th>Season</th>
          <th>G</th>
          <th>IP</th>
          <th>PA</th>
          <th>AB</th>
          <th>H</th>
          <th>1B</th>
          <th>2B</th>
          <th>3B</th>
          <th>HR</th>
          <th>K</th>
          <th>BB</th>
          <th>K_percent</th>
          <th>BB_percent</th>
          <th>BAA</th>
          <th>SLG</th>
          <th>OBP</th>
          <th>OPS</th>
          <th>ER</th>
          <th>R</th>
          <th>SV</th>
          <th>BS</th>
          <th>W</th>
          <th>L</th>
          <th>ERA</th>
          <th>xBA</th>
          <th>xSLG</th>
          <th>wOBA</th>
          <th>xwOBA</th>
          <th>xOBP</th>
          <th>xISO</th>
          <th>exit_velocity_avg</th>
          <th>launch_angle_avg</th>
          <th>sweet_spot_percent</th>
          <th>barrel_rate</th>
          <th>Pitches</th>
          <th>four_seam_percent</th>
          <th>four_seam_avg_mph</th>
          <th>four_seam_avg_spin</th>
          <th>slider_percent</th>
          <th>slider_avg_speed</th>
          <th>slider_avg_spin</th>
          <th>changeup_percent</th>
          <th>changeup_avg_speed</th>
          <th>changeup_avg_spin</th>
          <th>curveball_percent</th>
          <th>curveball_avg_speed</th>
          <th>curveball_avg_spin</th>
          <th>sinker_percent</th>
          <th>sinker_avg_speed</th>
          <th>sinker_avg_spin</th>
          <th>cutter_percent</th>
          <th>cutter_avg_speed</th>
          <th>cutter_avg_spin</th>
          <th>splitter_percent</th>
          <th>splitter_avg_speed</th>
          <th>splitter_avg_spin</th>
          <th>knuckle_percent</th>
          <th>knuckle_avg_speed</th>
          <th>knuckle_avg_spin</th>";

  $tuple_count = 0;
  while ($row = mysqli_fetch_array($result)) {

    foreach ($row as $value){
      echo "<tr>";
      for ($x = 0; $x <= ; $x++) {
        echo "The number is: $x <br>";
      }
        echo "<td>" . $row[0]. "</td>";
        echo "<td>" . $row[1]. "</td>";
        echo "<td>" . $row[2]. "</td>";
        echo "<td>" . $row[3]. "</td>";

      echo "</tr>";
    }
  }
      echo "</table>";
    echo "</div>";
  echo "</div>";

  ?>
</body>
</html>

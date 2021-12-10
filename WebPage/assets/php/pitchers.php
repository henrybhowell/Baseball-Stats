<html>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Amatic+SC&family=Sen&family=Stoke&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/styles.css">
<body>
  <div class="container-fluid">
  <?php
    $servername = "127.0.0.1";
    $username = "root";
    $password = "123456";
    $conn = new mysqli($servername, $username, $password);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    $dbname = "Baseball";
    mysqli_select_db($conn, $dbname) or die("Could not open the '$dbname'");
    $pName = $_POST['pName'];
    $arr = explode(" ",$pName);
    $firstname = $arr[0];
    $lastname = $arr[1];
    $sDate = $_POST['sDate'];
    $eDate = $_POST['eDate'];
    $oName = $_POST['oName'];
    $local = $_POST['location'];

    if ($local = 'home'){
        $home = 1;
        $away = 0;
    }
    else {
        $home = 0;
        $away = 1;
    }
    $test_query1 = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='Baseball' AND TABLE_NAME='PitcherPlaysIn';";
    $result1 = mysqli_query($conn, $test_query1);
    $test_query3 = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='Baseball' AND TABLE_NAME='Game'";
    $result3 = mysqli_query($conn, $test_query3);
    echo "<div class='col align-self-center tables'>";
    echo "<h1> Pitcher Game Statistics for " . $pName . "</h1>";
    echo "<br>";
    echo "<div style='overflow-x:auto'>";
    echo "<table border='1'>";
    while ($row = mysqli_fetch_array($result1)) {
            echo "<th>" . $row[0] . "</th>";
        }
    while ($row = mysqli_fetch_array($result3)) {
            echo "<th>" . $row[0] . "</th>";
        }
    $test_query = "CALL pitcherMatchUp('$firstname', '$lastname', '$oName', '$sDate', '$eDate', $home, $away);";
    $result = mysqli_query($conn, $test_query);
    $tuple_count = 0;
    while ($row = mysqli_fetch_array($result)) {
            echo "<tr>";
            for ($i=0; $i < 38; $i++) {
                echo "<td>" . $row[$i] . "</td>";
            }
            echo "</tr>";
    }
        echo "</table>";
        echo "</div>";
        echo "</div>";
    echo "</div>";
    ?>
    </body>
    </html>

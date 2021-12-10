<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Amatic+SC&family=Sen&family=Stoke&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/styles.css">


    <title>Baseball Stats</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>


</head>


  <body>

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

    ?>

<body>

    <div class="banner">
      <div class="content">
        <h1>Major League Baseball Statistics</h1>
        <div class="info">This site allows the user to make specific calls to players in order to
        access their game logs, statistics, or player info. </div>
        <h2>Game statistics for any game in a given year.</h2>
      </div>
    </div>


    <div class="container">
      <div class="row">
        <form action="assets/php/team.php" method="POST">
          <div class="d-flex justify-content-center">
              <label for="tName" class="top"><h2> Team</h2>
                <select name="tName" class="box">
                  <option>-- Select Team --</option>
                  <?php

                  $stmt4 = $conn->prepare("SELECT DISTINCT home_team FROM Game ORDER BY home_team ASC;");

                  $stmt4->execute();
                  $result4 = $stmt4->get_result();
                  $used = array("");

                      while ($row = mysqli_fetch_array($result4)){
                        foreach ($row as $value) {
                          if (!in_array($value, $used)){
                            echo "<option value='$value'>$value</option>";
                            $used[] = $value;
                          }
                        }
                      }
                   ?>
                </select>
              </label>
          </div>

          <div class="row">
            <div class="col-2"></div>

            <div class="col-2">
              <label for="location" class="elem">
                <span class="align-top"><select name='location' class="box">
                  <option>-- Home/Away --</option>
                  <option> Home </option>
                  <option> Away</option>

                </select>
                </span>
                  </label>


            </div>

            <div class="col-2">
              <label for="oName" class="elem"></label>
                <span class="align-top"><select name='oName' class="box">

                  <option>-- Select Opponent --</option>
                  <?php

                  $stmt4 = $conn->prepare("SELECT DISTINCT away_team FROM Game ORDER BY away_team ASC;");

                  $stmt4->execute();
                  $result4 = $stmt4->get_result();
                  $used = array("");

                      while ($row = mysqli_fetch_array($result4)){
                        foreach ($row as $value) {
                          if (!in_array($value, $used)){
                            echo "<option value='$value'>$value</option>";
                            $used[] = $value;
                          }
                        }
                      }
                   ?>
                </select></span>
            </div>

            <div class="col-2">
              <label for="sDate" class="elem">Start Date</label>
                <span class="align-top">
                <input type="date" id="start" name="sDate" value = "2015-04-05" min="2015-04-05" max="2021-10-03"></span>
            </div>

            <div class="col-2">
              <label for="eDate" class="elem">End Date</label>
                <span class="align-top">
                <input type="date" id="end" name="eDate" value = "2015-04-05" min="2015-04-05" max="2021-10-03"></span>
            </div>

            <div class="d-flex justify-content-center">
              <input type="submit" class="col-3 top" value="Submit">
            </div>
          </div>
        </form>



      <div class="d-flex justify-content-center">
          <label for="pName" class="top"><h2> Players</h2>
          </label>
      </div>
      <form action="assets/php/player_stats.php" method="POST">
        <div class="row">
          <div class="col-3">
            <h2>Individual Player Stats</h2>
          </div>

          <div class="col-2">
            <label for="pName" class="elem"></label>
              <select name='pName' class="box">
                <option>-- Select Player --</option>
                <?php

                $stmt4 = $conn->prepare("SELECT DISTINCT CONCAT(first_name, ' ', last_name) as name FROM Players ORDER BY name ASC;");

                $stmt4->execute();
                $result4 = $stmt4->get_result();
                $used = array("");

                    while ($row = mysqli_fetch_array($result4)){
                      foreach ($row as $value) {
                        if (!in_array($value, $used)){
                          echo "<option value='$value'>$value</option>";
                          $used[] = $value;
                        }
                      }
                    }
                 ?>
              </select>
          </div>

          <div class="col-2">
            <label for="sDate" class="elem"></label>
              <select name='sDate' class="box">
                <option>-- Start Season --</option>
                <option>2015</option>
                <option>2016</option>
                <option>2017</option>
                <option>2018</option>
                <option>2019</option>
                <option>2020</option>
                <option>2021</option>
              </select>
          </div>
          <div class="col-2">
            <label for="eDate" class="elem"></label>
              <select name='eDate' class="box">
                <option>-- Start Season --</option>
                <option>2015</option>
                <option>2016</option>
                <option>2017</option>
                <option>2018</option>
                <option>2019</option>
                <option>2020</option>
                <option>2021</option>
              </select>
          </div>
          <div class="col-2">
            <label for="stat" class="elem"></label>
              <select name='stat' class="box">
                <option>-- Select Statistics --</option>
                <option>G</option>
                <option>AB</option>
                <option>PA</option>
                <option>H</option>
                <option>1B</option>
                <option>2B</option>
                <option>3B</option>
                <option>HR</option>
                <option>K</option>
                <option>BB</option>
                <option>K_percent</option>
                <option>BB_percent</option>
                <option>Average</option>
                <option>SLG</option>
                <option>OBP</option>
                <option>OPS</option>
                <option>RBI</option>
                <option>SB</option>
                <option>HBP</option>
                <option>R</option>
                <option>SB_percent</option>
                <option>xBA</option>
                <option>xSLG</option>
                <option>wOBA</option>
                <option>xwOBA</option>
                <option>xOBP</option>
                <option>xISO</option>
                <option>exit_velocity_avg</option>
                <option>launch_angle_avg</option>
                <option>sweet_spot_percent</option>
                <option>barrel_rate</option>
                <option>groundballs_percent</option>
                <option>flyballs_percent</option>
                <option>linedrives_percent</option>
                <option>popups_percent</option>
                <option>sprint_speed</option>
              </select>
          </div>
          <div class="col-3"></div>
        </div>
        <div class="d-flex justify-content-center">
          <input type="submit" class="col-3 top" value="Submit">
        </div>
      </form>



      <form action="assets/php/leaderboard.php" method="POST">
        <div class="row">
          <div class="col-3">
            <h2>Player Leaderboard Stats</h2>
          </div>

          <div class="col-3">
            <label for="sYear" class="elem"></label>
              <select name='sYear' class="box">
                <option>--  Season Start Year --</option>
              </select>
          </div>

          <div class="col-3">
            <label for="eYear" class="elem"></label>
              <select name='eYear' class="box">
                <option>-- Season End Year --</option>
              </select>
          </div>
          <div class="col-3">
            <label for="agg"><h2> Aggregate <input type="checkbox" class="aggregate" name="aggregate" value="Aggregate"></h2></label>
          </div>
          <div class="col-3"></div>
        </div>


        <div class="d-flex justify-content-center">
          <input type="submit" class="col-3 top" value="Submit">
        </div>

      </form>

      <div class="d-flex justify-content-center">
          <label for="stats" class="top"><h2> Game Level Statistics</h2>
          </label>
      </div>

      <form action="assets/php/batters.php" method="POST">

        <div class="row">
          <div class="col-3">
            <h2>Batters</h2>
          </div>

          <div class="col-3">
            <label for="sDate" class="elem"></label>
              <select name='sDate' class="box">
                <option>--  Season Start Date --</option>
              </select>
          </div>

          <div class="col-3">
            <label for="eDate" class="elem"></label>
              <select name='eDate' class="box">
                <option>-- Season End Date --</option>
              </select>
          </div>
        </div>

        <div class="d-flex justify-content-center">
          <input type="submit" class="col-3 top" value="Submit">
        </div>

      </form>



      <form action="assets/php/ptichers.php" method="POST">
        <div class="row">
          <div class="col-3">
            <h2>Pitchers</h2>
          </div>

          <div class="col-3">
            <label for="sDate" class="elem"></label>
              <select name='sDate' class="box">
                <option>--  Season Start Date --</option>
              </select>
          </div>

          <div class="col-3">
            <label for="eDate" class="elem"></label>
              <select name='eDate' class="box">
                <option>-- Season End Date --</option>
              </select>
          </div>
        </div>

        <div class="d-flex justify-content-center">
          <input type="submit" class="col-3 top" value="Submit">
        </div>
      </form>

      <form action="assets/php/match_ups.php" method="POST">
        <div class="row">
          <div class="col-3">
            <h2>Match Ups</h2>
          </div>

          <div class="col-2">
            <label for="pName" class="elem"></label>
              <select name='pName' class="box">
                <option>-- Select Player --</option>
              </select>

          </div>

          <div class="col-2">
            <label for="oName" class="elem"></label>
              <span class="align-top"><select name='oName' class="box">
                <option>-- Select Opponent --</option>
              </select></span>
          </div>

          <div class="col-2">
            <label for="sDate" class="elem"></label>
              <select name='sDate' class="box">
                <option>--  Select Start Date --</option>
              </select>
          </div>

          <div class="col-2">
            <label for="eDate" class="elem"></label>
              <select name='eDate' class="box">
                <option>-- Select End Date --</option>
              </select>
          </div>
        </div>

        <div class="d-flex justify-content-center">
          <input type="submit" class="col-3 top" value="Submit">
        </div>
      </form>

      <div class="footer">

      </div>

    </div>


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>


</body>
</html>

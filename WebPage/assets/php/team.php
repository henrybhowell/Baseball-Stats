<html>
<body>

Welcome <?php echo $_POST["tName"]; ?>!

<?php
// Make sure to check the PHP forms validation, especially the part about injection attacks.
//
// if ($_SERVER["REQUEST_METHOD"] == "POST") {
//     $lname = $_POST["fname"];
//
//     if (empty($lname)) {
//         echo "You did not provide a last name.";
//     } else {
//         echo "Your provided last name was [" . $lname . "].";
//     }
// }
// ?>

Your provided telephone was <?php echo $_POST["home"]; ?>.

</body>
</html>

<?php
$input = array("This", "is", "an", "array");
$max = 4;
for ($x=0; $x<=$max; $x++) {
    echo sprintf("Index: %d // Value: %s\n", $x, $input[$x]);
}
echo "Goodbye, I'm PHP!\n";


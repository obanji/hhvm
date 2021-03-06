<?hh
<<__EntryPoint>> function main(): void {
$array = varray['a', 'b', 'c'];
$arrayIterator = new ArrayIterator($array);

try {
  $limitIterator = new LimitIterator($arrayIterator, 0);
  foreach ($limitIterator as $item) {
    echo $item . "\n";
  }
} catch (OutOfRangeException $e){
  print $e->getMessage() . "\n";
}

try {
  $limitIterator = new LimitIterator($arrayIterator, -1);
  foreach ($limitIterator as $item) {
    echo $item . "\n";
  }
} catch (OutOfRangeException $e){
  print $e->getMessage() . "\n";
}

echo "===DONE===\n";
}

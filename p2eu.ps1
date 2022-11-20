# Bottleneck function but it works
Function Get-Fib ($n) {
	$current = $previous = 1;
	while ($current -lt $n) {
		$current;
		$current,$previous = ($current + $previous), $current
	}
}

[System.Collections.ArrayList]$fibgen = Get-Fib 4000000
$fibgen.Insert(0,1)
$csum = 0

# Use the fact that fib(n) is even if 3 divides n
for ($i=3; $i -le $fibgen.count; $i += 3) {
	$csum += $fibgen[$i - 1]
}
	
Write-Host $csum
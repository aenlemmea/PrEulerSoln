# The problem has virtually nothing to do with triangular numbers
<# Using the triangular number closed form  expression of (n * (n+1)/2)
	and bruteforcing is clumsy.
	Sticking to the iterative definition is easy and the tau function computes
	the number of divisors.
	
	Knowing more is harmful here!
#>

Function Tau ($n) {
	$ans = 0
	$i = 1
	$j = 1
	
	while (($i*$i) -le $n) {
		if (0 -eq ($n % $i)) {
			$ans += 1
			$j = [int] $n / $i
			if ($j -ne $i) {
				$ans += 1
			}
		}
		$i += 1
	}
	return $ans
}

$temp = 1
$d = 1

while ((Tau $d) -le 500) {
	$temp++
	$d += $temp
}

Write-Host $d
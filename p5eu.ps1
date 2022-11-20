# https://rosettacode.org/wiki/Sieve_of_Eratosthenes#Another_implementation

Function Prime-Gen ($n) {
    if($n -ge 1){
        $prime = @(1..($n+1) | foreach{$true})
        $prime[1] = $false
        $m = [Math]::Floor([Math]::Sqrt($n))
        for($i = 2; $i -le $m; $i++) {
            if($prime[$i]) {
                for($j = $i*$i; $j -le $n; $j += $i) {
                    $prime[$j] = $false
                }
            }
        }
        1..$n | where{$prime[$_]}
    } else {
        Write-Warning "$n is less than 1"
    }
}

Function LCM-Till ($number) {
	$total = 1
	foreach ($i in (Prime-Gen $number)) {
		$x = 1
		while (($x * $i) -le $number) {
			$x = ($x * $i)
		}
		$total = ($total * $x)
	}
	return $total
}

Write-Host (LCM-Till 20)

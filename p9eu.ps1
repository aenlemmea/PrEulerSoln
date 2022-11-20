for ($m=0; $m -lt 1000; $m++) {
	for ($n=1; $n -lt 1000; $n++) {
		$a = (([Math]::Pow($m, 2)) - ([Math]::Pow($n, 2)))
		$b = (2 * $m * $n)
		$c = (([Math]::Pow($m, 2)) + ([Math]::Pow($n, 2)))
		if ($a + $b + $c -eq 1000) {
			Write-Host ($a * $b * $c)
		}
	}
}
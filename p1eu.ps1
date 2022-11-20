$csum = 0
for ($i=1; $i -lt 1000; $i++) {
	if ($i % 3 -eq 0 -and $i % 5 -eq 0) {
		$csum += $i
	} 
	elseif ($i % 3 -eq 0) {
		$csum += $i
	}
	elseif ($i % 5 -eq 0) {
		$csum += $i
	}
}

Write-Host $csum
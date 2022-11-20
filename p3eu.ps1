# Odd number, 12 digits, 600 millers
# 600851475143 Sqrt: 775146

$temp = 600851475143
for ($i=2; $i -lt 775146; $i++) {
	if ($i -ge $temp) {
		break
	}
	if ($temp % $i -eq 0) {
		$temp = $temp / $i
	}
}

Write-Host $temp
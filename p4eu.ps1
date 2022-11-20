# String based isPalindrome check to avoid integer division
# in a integer based check

Function Is-Palindrome($number) {
	$num = [string]$number
	$revnum = [string]$number
	$revnum = $revnum.ToCharArray()
	$revnum = $revnum -join ([array]::Reverse($revnum))
	if ("$num" -eq "$revnum") {
		$true
	}
	else {
		$false
	}
}

$max = -1

for ($i = 999; $i -ge 100; $i--) {
	if ($max -ge ($i * 999)) {
		break
	}
	for ($j = 999; $j -ge $i; $j--) {
		$temp = ($i * $j)
		if ($max -lt $temp -and (Is-Palindrome $temp)) {
			$max = $temp
		}
	}
}
Write-Host $max
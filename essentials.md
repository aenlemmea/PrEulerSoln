### Sieve Of Erastothenes Implementation
- https://rosettacode.org/wiki/Sieve_of_Eratosthenes#Another_implementation

```pwsh
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
```

-----

### Tau Function
- https://rosettacode.org/wiki/Tau_function#Python

```pwsh
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
```

-----

### Powershell Sum and Product of Array
- Sum

```pwsh
Function Get-Sum ($a) {
    return ($a | Measure-Object -Sum).Sum
}
````

- Product

```pwsh
Function Get-Product ($a) {
    if ($a.Length -eq 0) {
        return 0
    } else {
        $p = 1
        foreach ($x in $a) {
            $p *= $x
        }
        return $p
    }
}
```

-----
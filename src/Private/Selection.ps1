function ConvertTo-Selection {
    param([string] $Text, [int] $Count)
    $indices = [System.Collections.Generic.SortedSet[int]]::new()
    foreach ($part in ($Text -split ',')) {
        if ($part.Trim() -notmatch '^(\d+)(?:\s*-\s*(\d+))?$') { throw 'Enter numbers or ranges, such as 1,3-5.' }
        $first = 0
        $last = 0
        if (-not [int]::TryParse($Matches[1], [ref] $first)) { throw 'Number is too large.' }
        $last = $first
        if ($Matches.ContainsKey(2) -and -not [int]::TryParse($Matches[2], [ref] $last)) { throw 'Number is too large.' }
        if ($first -lt 1 -or $last -gt $Count -or $last -lt $first) { throw "Choose numbers between 1 and $Count, in ascending ranges." }
        for ($i = $first; $i -le $last; $i++) { [void] $indices.Add($i - 1) }
    }
    return @($indices)
}

function Read-TeamSelection {
    param([object[]] $Teams, [ValidateRange(1, 100)][int] $PageSize = 12)
    $filtered = @($Teams)
    $page = 0
    :menu while ($true) {
        $pages = [Math]::Max(1, [int][Math]::Ceiling($filtered.Count / [double]$PageSize))
        Write-Host "`nTeams - page $($page + 1)/$pages ($($filtered.Count) matches)"
        $start = $page * $PageSize
        $end = [Math]::Min($start + $PageSize, $filtered.Count)
        for ($i = $start; $i -lt $end; $i++) {
            Write-Host ('{0,4}. {1} [{2}]' -f ($i + 1), (ConvertTo-SafeLabel $filtered[$i].DisplayName), $filtered[$i].GroupId)
        }
        Write-Host 'Numbers/ranges: 1,3-5 | n: next | p: previous | /text: search | /: reset | q: cancel'
        $answer = Read-Host 'Select teams to leave'
        if ($null -eq $answer) { return }
        $answer = $answer.Trim()
        switch ($answer.ToLowerInvariant()) {
            'q' { return }
            'n' { $page = [Math]::Min($page + 1, $pages - 1); continue menu }
            'p' { $page = [Math]::Max(0, $page - 1); continue menu }
            '' { continue menu }
        }
        if ($answer.StartsWith('/')) {
            $query = $answer.Substring(1)
            $filtered = @($Teams | Where-Object { $_.DisplayName.IndexOf($query, [StringComparison]::OrdinalIgnoreCase) -ge 0 })
            $page = 0
            continue
        }
        try { $indices = @(ConvertTo-Selection -Text $answer -Count $filtered.Count) }
        catch { Write-Host $_.Exception.Message; continue }
        foreach ($index in $indices) { $filtered[$index] }
        return
    }
}

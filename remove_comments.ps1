Get-ChildItem -Path "lib\lib_admin" -Recurse -Filter "*.dart" | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Remove single-line comments (// and ///) but preserve strings
    $lines = $content -split "`n"
    $newLines = @()
    $inMultiline = $false
    
    foreach ($line in $lines) {
        if ($inMultiline) {
            if ($line -match '\*/') {
                $line = $line -replace '^.*?\*/', ''
                $inMultiline = $false
            } else {
                $line = ''
            }
        }
        
        if (-not $inMultiline) {
            # Remove single-line comments (// and ///)
            $line = $line -replace '//.*$', ''
            # Remove /* */ style comments on same line
            while ($line -match '/\*') {
                if ($line -match '/\*.*?\*/') {
                    $line = $line -replace '/\*.*?\*/', ''
                } else {
                    $line = $line -replace '/\*.*$', ''
                    $inMultiline = $true
                }
            }
        }
        
        # Keep the line (even if empty) to maintain structure
        $newLines += $line
    }
    
    $newContent = $newLines -join "`n"
    # Remove multiple consecutive empty lines
    $newContent = $newContent -replace "(`n\s*){3,}", "`n`n"
    
    if ($newContent -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
        Write-Host "Processed: $($file.FullName)"
    }
}

Write-Host "Done removing comments from all files."

function ConvertTo-SafeLabel {
    param([AllowEmptyString()][string] $Text)
    # Names and service errors are untrusted terminal input, not ANSI commands.
    [regex]::Replace($Text, '[\p{Cc}\p{Cf}\p{Zl}\p{Zp}]', ' ')
}


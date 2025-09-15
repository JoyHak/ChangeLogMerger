Merge(text) {
    global cStatus
        
    if !(text := Trim(text, ' `r`n`t'))
        return ''

    ; Replace unicode line breaks
	text := RegExReplace(text, '`a)\R', '`n')

    ; Search for blocks that starts from version
    static regex :=
    (Join
        'xm) ^v
        (?#version) (?:\d+ \.)+ \d+
        [- \t]+
        (?# date time) 2025- ((?: \d+ [-: \t])+ \d+)
        (?# block) .*
        (?# empty lines) (?: \r? \n (?!v) .* )+'
    )
    
    blocks := Map()
    for block in RegExMatchAll(&text, regex) {
        ; Add "Date: block" pairs
        ; Map() will sort the keys by date automatically
        blocks.Set(block[1], block[0])
    } else {
        cStatus.SetText('Error: blocks must begin with the version and date, e.g. "v27.10.0800 - 2025-09-09 18:00"')
        return text
    }
    
    history := ''
    for , block in blocks
        history := block . history  ; From new to old
    
    cStatus.SetText('The blocks were sorted by the date')
    return Trim(history, '`r`n `t')
}

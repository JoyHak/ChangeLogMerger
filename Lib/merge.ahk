Merge(text, dateRegex := '') {
    global cStatus
        
    if !(text := Trim(text, ' `r`n`t'))
        return ''

    ; Replace unicode line breaks
	text := RegExReplace(text, '`a)\R', '`n')

    ; Search for blocks that starts from version    
    blocks := Map()
    for block in RegExMatchAll(&text, 'xm) ^[ \t]* v [\d.]+ .* (\r? \n (?!v) .*)+') {
        ; Search for date
        if !(dateRegex && RegExMatch(block[0], dateRegex, &date)) {        
            cStatus.SetText('Error: try to change the regex to search for a date in blocks ⭜')
            return text
        }
        
        ; Add "Date: block" pairs
        ; Map() will sort the keys by date automatically
        blocks.Set(date[0], block[0])
    } else {
        cStatus.SetText('Error: blocks must begin with the version and date, e.g. "v27.10.0800 - 2025-09-09 18:00"')
        return text
    }
    
    history := ''
    for , block in blocks
        history := block '`r`n' history '`r`n'  ; From new to old
    
    cStatus.SetText('The blocks were sorted by the date')
    return Trim(history, ' `r`n`t')
}

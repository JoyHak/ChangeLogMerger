Merge(text) {
    text := Trim(text, ' `r`n`t')
    if !text
        return ''

    ; Replace unicode line breaks
	text := RegExReplace(text, '`a)\R', '`n')

    ; Search for blocks that starts from version
    static regex :=
    (Join
        'xm) ^v
        (?#version) (?:\d+ \.)+ \d+
        [- \t]+
        (?# date) 2025- ((?: \d+ [-: \t])+ \d+)
        (?# block) .*
        (?# empty lines) (?: \r? \n (?!v) .* )+'
    )

    ; for block in RegExMatchAll(&text, '') {
        ; block[1]
    ; }

    ; return Trim(text, '`r`n `t')
    return regex
}

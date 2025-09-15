Merge(text) {
    text  := Trim(text, ' `r`n`t')
    if !text
        return ''

    SplitPath repo,,,,, &domain

    ; Replace unicode line breaks
	text := RegExReplace(text, '`a)\R', '`n')
    text := ParseUrls(text, repo)

    ; Hide individual blocks from the text and process them separately
    blocks := MarkdownBlocks()
    blocks.Add(&text, 'alternate',  'sx)<!-- \s* alternate \s* -->(.+)<!-- \s* /alternate \s* -->',         '{1}')
    blocks.Add(&text, 'code',       's)[ \t]*``````.*?\s(.+?)\s[ \t]*``````',                               '[code]{1}`n[/code]')
    blocks.Add(&text, 'image',      'sx)!\[   [^\]]*   \] \( [ \\\/\.\t]* (.+?) [ \t]* \)',                 '[url]{1}[/url]')
    blocks.Add(&text, 'link',       'sx) \[ ( [^\]]* ) \] \( [ \\\/\.\t]* (.+?) [ \t]* \)',                 '[url={2}]{1}[/url]')
    blocks.Add(&text, 'pathIssue',  'x) (\S+ [\w\d]\/\S+ [\w\d]) \# (\d+)',                                 '[url=' domain '/{1}/issues/{2}]{1}#{2}[/url]')
    blocks.Add(&text, 'GHissue',    'x) [ \t] \b GH- (\d+)',                                                '[url=' repo '/issues/{1}]GH-{1}[/url]')
    blocks.Add(&text, 'issue',      'x) (?<!^|\#) \# (\d+)',                                                '[url=' repo '/issues/{1}]#{1}[/url]')
    blocks.Add(&text, 'pathCommit', 'x) (\S+ [\w\d] (\/ \S+ [\w\d])?) @ ( ([a-f0-9]{7}) [a-f0-9]{33} ) \b', '[url=' domain '/{1}/commit/{3}]{1}@{4}[/url]')
    blocks.Add(&text, 'mention',    'x)            @ (\S+  [\w\d])',                                        '[url=' domain '/{1}]@{1}[/url]')
    blocks.Add(&text, 'commit',     '(([a-f0-9]{7})[a-f0-9]{33})\b',                                        '[url=' repo '/commit/{1}]{2}[/url]')

    text := ParseTables(text)
    ; Replace markdown line breaks
    text := RegExReplace(text, '<\/?br[ \t]*\/?>', '`n')
	text := RegExReplace(text, 'm)(\\| {2})$', '`n')

    ; Parse each block
    text := ParseHtml(text)
    text := ParseLists(text)
    text := ParseQuotes(text)
    text := ParseMarkdown(text)

    blocks.RestoreAll(&text)
    return Trim(text, '`r`n `t')
}

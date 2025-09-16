;@Ahk2Exe-Base C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe, %A_ScriptDir%\Releases\%A_ScriptName~\.ahk%-x32.exe 
;@Ahk2Exe-Base C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe, %A_ScriptDir%\Releases\%A_ScriptName~\.ahk%-x64.exe 

;@Ahk2Exe-SetDescription https://github.com/JoyHak/ChangeLogSorter
;@Ahk2Exe-SetProductName MarkdownToBBCode
;@Ahk2Exe-SetMainIcon Lib\Icon.ico
;@Ahk2Exe-SetCopyright Rafaello
;@Ahk2Exe-SetCompanyName ToYu studio
;@Ahk2Exe-SetLegalTrademarks GPL-3.0 license

#Requires AutoHotKey v2.0.19
#Warn
#SingleInstance force

#Include <output>
#Include <RegExMatchAll>
#Include <SortByDate>
#Include <buttons>

KeyHistory(false)
Listlines(false)
SetKeyDelay(-1, -1)
SetWinDelay(-1)
SetWorkingDir(A_ScriptDir)
try TraySetIcon('Lib\Icon.ico')


ui := Gui('-DpiScale')
ui.LastText := ''
ui.SetFont('q5 s13', 'Maple mono')
cText := ui.Add('Edit', '+WantTab w1490 h900 vText')

ui.Button('+Default',   'Sort',      'Sort the blocks by date (starting with new ones)',        (*) => (cText.value := ParseText()))
ui.Button('yp x+5',     'Restore',   'Restore the previous text (even if it was sorted)',       (*) => (cText.value := ui.LastText))
ui.Button('yp x+5',     'Copy',      'Copy the text (even if its unsorted) to the clipboard',   (*) => (A_Clipboard := ui.Submit(0).Text))
ui.Button('yp x+5',     'Clear',     'Clear input box',                                         (*) => (cText.value := ''))

ui.Button('yp x+15',    'Open',      'Open a new file and add its contents to the text',        (*) => (cText.value .= ParseFile()))
ui.Button('yp x+5',     'Save',      'Save the text to the file (UTF-8)',               (*) => (SaveFile(ui.Submit(0).Text)))
ui.Button('yp x+5 Section', 'Restart',   'Restart the program',                                 (*) => Reload())

ui.AddText('ys+11 x+20',  'Regex for date:')
cRegex := ui.AddEdit('ys+6  x+5 w540 vDateRegex', '\d{4}-\d\d-\d\d[ \t]+\d\d:\d\d')
cRegex.StatusBar := 'Options (if any) must be at the begin. followed by a close-paren., e.g. "ixm)\d{4}..." Capturing groups are not used'

cStatus := ui.AddStatusBar(, 'Open the file or paste text here. Click "Sort" to sort by date')

ui.OnEvent('Escape', (*) => ui.Destroy())
ui.OnEvent(
    'DropFiles', 
    (ui, control, filesArr, *) => (cText.value .= ParseFiles(filesArr))
)
ui.Show()


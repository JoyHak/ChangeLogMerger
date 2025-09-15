;@Ahk2Exe-SetDescription https://github.com/JoyHak/ChangeLogMerger
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
#Include <merge>

KeyHistory(false)
Listlines(false)
SetKeyDelay(-1, -1)
SetWinDelay(-1)
SetWorkingDir(A_ScriptDir)
try TraySetIcon('Lib\Icon.ico')

OpenFile(path?) {
    try {
        f := path ?? FileSelect(1 + 2, 'History.txt')
        return FileRead(f)
    } catch {
        FileErr('Unable to open the changelog', f)
    }
}

SaveFile(text, path?) {
    global cStatus
    
    try {
        f := path ?? FileSelect('S16', 'MergedHistory.txt')
        FileAppend(text, f)
        cStatus.SetText('The text was saved in the "' f '"')
    } catch {
        FileErr('Unable to save merged changelogs', f)
    }
}

ParseText() {
    global ui
    u := ui.Submit(0)
    ui.LastText := u.Text

    return Merge(u.Text, u.DateRegex)
}

ParseFile() {
    global ui
    ui.LastText := ui.Submit(0).Text

    return OpenFile() . '`r`n'
}

ParseFiles(pathsArr) {
    global ui
    ui.LastText := ui.Submit(0).Text
    
    files := ''
    for path in pathsArr
        files .= OpenFile(path) . '`r`n'
    
    return files
}


AddGuiButton(ui, options := '', text := 'Button', statusOnHover := '', callback := (*) => 0) {
    button := ui.AddButton(options, text)
    button.OnEvent('Click', callback)
    button.StatusBar := statusOnHover
    
    return button
}
Gui.Prototype.DefineProp('Button', {Call: AddGuiButton})


ui := Gui('-DpiScale')
ui.LastText := ''
ui.SetFont('q5 s13', 'Maple mono')
cText := ui.Add('Edit', '+WantTab w1490 h900 vText')

ui.Button('+Default',   'Merge',     'Sort the blocks by date (starting with new ones)',        (*) => (cText.value := ParseText()))
ui.Button('yp x+5',     'Restore',   'Restore the previous text (even if it was sorted)',       (*) => (cText.value := ui.LastText))
ui.Button('yp x+5',     'Copy',      'Copy the text (even if its unsorted) to the clipboard',   (*) => (A_Clipboard := ui.Submit(0).Text))
ui.Button('yp x+5',     'Clear',     'Clear input box',                                         (*) => (cText.value := ''))

ui.Button('yp x+15',    'Open',      'Open a new file and add its contents to the text',        (*) => (cText.value .= ParseFile()))
ui.Button('yp x+5',     'Save',      'Save the text to the file (UTF-16 LE BOM)',               (*) => (SaveFile(ui.Submit(0).Text)))
ui.Button('yp x+5 Section', 'Restart',   'Restart the program',                                 (*) => Reload())

ui.AddText('ys+11 x+20',  'Regex for date:')
cRegex := ui.AddEdit('ys+6  x+5 w540 vDateRegex', '\d{4}-\d\d-\d\d[ \t]+\d\d:\d\d')
cRegex.StatusBar := 'Options (if any) must be at the begin. followed by a close-paren., e.g. "ixm)\d{4}..." Capturing groups are not used'

cStatus := ui.AddStatusBar(, 'Open the file or paste text here. Click "Merge" to sort by date')

ui.OnEvent('Escape', (*) => ui.Destroy())
ui.OnEvent(
    'DropFiles', 
    (ui, control, filesArr, *) => (cText.value .= ParseFiles(filesArr))
)
ui.Show()


SetStatusText(wparam, lparam, message, hwnd) {
    global cStatus
    static prevHwnd := 0
    
    if (hwnd != prevHwnd){
        text := ''
        if (curControl := GuiCtrlFromHwnd(hwnd)) {
            if curControl.HasProp("StatusBar")
                cStatus.SetText(curControl.StatusBar)
        }
        
        prevHwnd := hwnd
    }
}
OnMessage(0x0200, SetStatusText)  ; WM_MOUSEMOVE


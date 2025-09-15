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
        return Merge(FileRead(path))
    } catch {
        FileErr('Unable to open the changelog', f)
    }
}

SaveFile(text, path?) {
    try {
        f := path ?? FileSelect('S16', 'MergedHistory.txt')
        FileAppend(text, f)
    } catch {
        FileErr('Unable to save merged changelogs', f)
    }
}

ParseText() {
    global ui
    u := ui.Submit(0)
    ui.LastText := u.Text

    return Merge(u.Text)
}

ParseFile() {
    global ui
    u := ui.Submit(0)
    ui.LastText := u.Text

    return OpenFile()
}


ui := Gui('-DpiScale')
ui.LastText := ''
ui.SetFont('q5 s13', 'Maple mono')
cText := ui.Add('Edit', '+WantTab w1290 h900 vText')

ui.Add('Button', '+Default', 'Merge').OnEvent('Click',       (*) => (cText.value := ParseText()))
ui.Add('Button', 'yp x+5', 'Restore').OnEvent('Click',       (*) => (cText.value := ui.LastText))
ui.Add('Button', 'yp x+5', 'Copy').OnEvent('Click',          (*) => (A_Clipboard := ui.Submit(0).Text))
ui.Add('Button', 'yp x+5', 'Clear').OnEvent('Click',         (*) => (cText.value := ''))

ui.Add('Button', 'yp x+15', 'Open').OnEvent('Click',         (*) => (cText.value := ParseFile()))
ui.Add('Button', 'yp x+5 Section', 'Save').OnEvent('Click',  (*) => (SaveFile(ui.Submit(0).Text)))

ui.OnEvent('Escape', (*) => ui.Destroy())
ui.Show()
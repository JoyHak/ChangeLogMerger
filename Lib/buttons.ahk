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
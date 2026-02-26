on run argv
    if count of argv is 0 then
        log "请传入要退出的App名称参数，例如：osascript quit_app.scpt Google Chrome"
        return "error: 缺少App名称参数"
    end if
    
    set appName to item 1 of argv
    
    try
        tell application "System Events"
            set appIsRunning to (exists process appName)
        end tell
        
        if appIsRunning then
            display notification appName & " has been quited" with title "‼️ Warning ‼️" subtitle "illegal ops" sound name "oyaoyat"
            
            tell application appName to quit without saving
            return "success: " & appName & " 已退出"
        else
            return "info: " & appName & " 未运行"
        end if
    on error errMsg
        return "error: " & errMsg
    end try
end run

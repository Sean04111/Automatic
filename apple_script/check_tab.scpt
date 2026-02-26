on run argv
    if count of argv is 0 then
        log "Please provide TXT file path, e.g.: osascript check_tabs_from_txt.scpt ~/Desktop/blocked_sites.txt"
        return "error: missing TXT file path parameter"
    end if
    
    set txtFilePath to item 1 of argv
    set txtFilePath to do shell script "cd " & quoted form of (do shell script "pwd") & "; echo " & quoted form of txtFilePath
    
    set fileExists to (do shell script "test -f " & quoted form of txtFilePath & "; echo $?") as integer
    if fileExists ≠ 0 then
        return "error: TXT file does not exist → " & txtFilePath
    end if
    
    -- 核心修复：用Shell命令cat读取文件，彻底绕过AppleScript的路径解析
    set urlList to paragraphs of (do shell script "cat " & quoted form of txtFilePath)
    set filteredUrlList to {}
    repeat with urlItem in urlList
        set trimmedUrl to trimWhitespace(urlItem)
        if trimmedUrl is not "" then
            set end of filteredUrlList to trimmedUrl
        end if
    end repeat
    
    if count of filteredUrlList is 0 then
        return "info: no valid URLs in TXT file"
    end if
    
    set detectedUrl to ""
    tell application "Google Chrome"
        if it is running then
            repeat with win in windows
                repeat with tabItem in tabs of win
                    set currentTabUrl to URL of tabItem
                    repeat with targetUrl in filteredUrlList
                        if currentTabUrl contains targetUrl then
                            set detectedUrl to targetUrl
                            exit repeat
                        end if
                    end repeat
                    if detectedUrl is not "" then exit repeat
                end repeat
                if detectedUrl is not "" then exit repeat
            end repeat
        end if
    end tell
    
    if detectedUrl is not "" then
        return "yes" 
    else
        return "no"
    end if
end run

on trimWhitespace(str)
    set AppleScript's text item delimiters to {" ", tab, return, linefeed}
    set trimmed to text items of str
    set AppleScript's text item delimiters to ""
    return trimmed as string
end trimWhitespace

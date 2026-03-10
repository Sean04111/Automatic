on run
    set appName to "Safari"
    set isRunning to (do shell script "pgrep -x " & quoted form of appName & " > /dev/null; echo $?") as integer
    if isRunning = 0 then
        tell application appName to quit
        return "[" & (current date) & "] Safari detected, quitting..."
    else
        return "[" & (current date) & "] Safari not running."
    end if
end run

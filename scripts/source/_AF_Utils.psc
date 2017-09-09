ScriptName _AF_Utils Hidden
{Utility functions used throughout the mod.}

string Function LoadOrderConflict() global
    {The load order conflict category.}
    return "$AFLoadOrderConflict"
EndFunction

string Function IncompatibleMod() global
    {The incompatible mod category.}
    return "$AFIncompatibleMod"
EndFunction

int Function LevelInfo() global
    {The 'info' severity level.}
    return 0
EndFunction

int Function LevelWarning() global
    {The 'warning' severity level.}
    return 1
EndFunction

int Function LevelError() global
    {The 'error' severity level.}
    return 2
EndFunction

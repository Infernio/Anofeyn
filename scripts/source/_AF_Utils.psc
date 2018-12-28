ScriptName _AF_Utils Hidden
{Utility functions used throughout the mod.}

String Function LoadOrderConflict() Global
    {The load order conflict category.}
    return "$AFLoadOrderConflict"
EndFunction

String Function IncompatibleMod() Global
    {The incompatible mod category.}
    return "$AFIncompatibleMod"
EndFunction

String Function CompatibilityFailure() Global
    {The compatbility failed mod category.}
    return "$AFCompatFailure"
EndFunction

String Function CompatibilityMisc() Global
    {The miscellaneous compatibility category.}
    return "$AFCompatMisc"
EndFunction

Int Function LevelInfo() Global
    {The 'info' severity level.}
    return 0
EndFunction

Int Function LevelWarning() Global
    {The 'warning' severity level.}
    return 1
EndFunction

Int Function LevelError() Global
    {The 'error' severity level.}
    return 2
EndFunction

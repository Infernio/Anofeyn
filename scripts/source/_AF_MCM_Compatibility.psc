ScriptName _AF_MCM_Compatibility Extends MLib_Page
{The 'Compatibility' page of the Anofeyn SkyUI Mod Configuration Menu.}

; Properties
_AF_Compatibility       Property CompatibilityScript Auto
{The Anofeyn compatibility script.}

; ID Variables
; The SkyUI ID of the Scarcity toggle
int scarcityID

string Function GetTitle()
    return "$AFConfigPageCompatibility"
EndFunction

Event OnPageReset()
    SetCursorFillMode(LEFT_TO_RIGHT)

    ; Compatible Mods
    AddHeaderOption("$AFCompatibleMods")
    AddEmptyOption()

    scarcityID = AddModToggle("Scarcity", CompatibilityScript.ScarcityLoaded, CompatibilityScript.GetScarcityCompat(), "$AFCompatInfoScarcity")
    AddEmptyOption() ; Remove me for the next mod

    ; One empty line
    AddEmptyOption()
    AddEmptyOption()

    ; Incompatible Mods
    AddHeaderOption("$AFIncompatibleMods")
    AddEmptyOption()

    AddModToggle("Acquisitive Soul Gems", CompatibilityScript.ASGLoaded, CompatibilityScript.ASGLoaded, "$AFCompatInfoASG")
    AddModToggle("Acquisitive Soul Gems Multithreaded", CompatibilityScript.ASGMLoaded, CompatibilityScript.ASGMLoaded, "$AFCompatInfoASGM")
    AddModToggle("Smart Souls", CompatibilityScript.SmartSoulsLoaded, CompatibilityScript.SmartSoulsLoaded, "$AFCompatInfoSmartSouls")
    AddModToggle("The Soul Saver", CompatibilityScript.TSSLoaded, CompatibilityScript.TSSLoaded, "$AFCompatInfoTSS")
EndEvent

Event OnOptionSelect(int option)
    If(option == scarcityID)
        bool newValue = !CompatibilityScript.GetScarcityCompat()
        CompatibilityScript.SetScarcityCompat(newValue)
        SetToggleOptionValue(option, newValue)
    EndIf
EndEvent

int Function AddModToggle(string name, bool loaded, bool enabled, string hover = "")
    {Adds a toggle for the specified mod.}
    If(loaded)
        return AddToggleOption(name, enabled, hover = hover)
    Else
        return AddToggleOption(name, false, OPTION_FLAG_DISABLED, hover)
    EndIf
EndFunction

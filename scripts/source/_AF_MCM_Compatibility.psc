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

    scarcityID = AddModToggle("Scarcity", CompatibilityScript.ScarcityLoaded, CompatibilityScript.ScarcityCompatEnabled(), "$AFCompatInfoScarcity")
    AddEmptyOption() ; Remove me for the next mod

    ; One empty line
    AddEmptyOption()
    AddEmptyOption()

    ; Incompatible Mods
    AddHeaderOption("$AFIncompatibleMods")
    AddEmptyOption()

    ; TODO Add incompatible mods here
EndEvent

Event OnOptionSelect(int option)
    If(option == scarcityID)
        bool newValue = !CompatibilityScript.ScarcityCompatEnabled()
        CompatibilityScript.SetScarcityCompat(newValue)
        SetToggleOptionValue(option, newValue)
    EndIf
EndEvent

int Function AddModToggle(string name, bool loaded, bool enabled, string hoverText = "")
    {Adds a toggle for the specified mod.}
    If(loaded)
        return AddToggleOption(name, enabled, hover = hoverText)
    Else
        return AddToggleOption(name, false, OPTION_FLAG_DISABLED, hoverText)
    EndIf
EndFunction

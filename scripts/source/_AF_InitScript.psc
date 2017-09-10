ScriptName _AF_InitScript Extends ReferenceAlias
{A script used to handle the initialization and version upgrades of Anofeyn.}

; General
_AF_Compatibility   Property CompatibilityScript Auto
{The Anofeyn compatibility script.}
GlobalVariable      Property AnofeynVersion Auto
{The Anofeyn version.}
Actor               Property PlayerRef Auto
{The player reference.}

; Perks
Perk                Property PerkCorpseActivation Auto
{The perk used to intercept OnActivate on corpses that have been prepared.}

; Messages
Message             Property MessageVersionMismatch Auto
{The warning shown to the player when Anofeyn's version does not match this script's version.}

; The stored version
float prevVersion

Event OnInit()
    RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
    If(CompatibilityScript.IsDone)
        Initialize()
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    CheckVersions()
EndEvent

Function Initialize()
    prevVersion = GetAnofeynVersion().GetValue()

    ; Perks
    PlayerRef.AddPerk(PerkCorpseActivation)
EndFunction

Function CheckVersions()
    float version = GetAnofeynVersion().GetValue()
    If(version != 1) ; NOTE: This number has to be updated every time the _AF_Version global variable is changed
        ; If the warning property was filled (a newer version might have changed its name), use that
        If(MessageVersionMismatch)
            MessageVersionMismatch.Show()
        Else
            ; Otherwise, we'll have to use this method
            Debug.MessageBox("The installed version of Anofeyn does not match the version of Anofeyn's scripts.\n\nThis likely indicates an incomplete or corrupt installation. Please check if a new version is available and then uninstall and reinstall Anofeyn completely.")
        EndIf
    Else
        ; TODO Update code goes here, example:
        ; If(prevVersion < 1)
        ;     ; update something
        ; EndIf
        ; If(prevVersion < 2)
        ; ...
        prevVersion = version
    EndIf
EndFunction

GlobalVariable Function GetAnofeynVersion()
    {Attempts to grab the Anofeyn version, first from a property and, if that doesn't work, from the esp itself.}
    GlobalVariable ret = AnofeynVersion
    If(!ret)
        ret = Game.GetFormFromFile(0x042936, "Anofeyn.esp") as GlobalVariable
    EndIf
    return ret
EndFunction

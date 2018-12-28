ScriptName _AF_Compatibility Extends ReferenceAlias
{The main compatibility script used to handle compatibility with other mods.}

; General
Actor           Property PlayerRef Auto
{The player reference.}

; Internals
Bool            Property IsDone = false Auto Hidden
{Whether or not the compatibility checks have run.}

; Messages
Message         Property MessageChecksStarted Auto
{The message shown to the player when the compatibility checks have started running.}
Message         Property MessageChecksFinished Auto
{The message shown to the player when the compatibility checks have finished running.}
Message         Property MessageAnofeynMissing Auto
{The warning shown to the player when Anofeyn.esp could not be found.}
Message         Property MessageScarcityCompatible Auto
{The message shown to the player when Scarcity has been detected.}
Message         Property MessageScarcityUninstalled Auto
{The message shown to the player when Scarcity has been uninstalled.}

; Loot Chances
GlobalVariable  Property ChanceNone0 Auto
{The global variable that stores the 0% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone10 Auto
{The global variable that stores the 10% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone25 Auto
{The global variable that stores the 25% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone50 Auto
{The global variable that stores the 50% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone75 Auto
{The global variable that stores the 75% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone80 Auto
{The global variable that stores the 80% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone90 Auto
{The global variable that stores the 90% chance for a leveled item to resolve to nothing.}
GlobalVariable  Property ChanceNone95 Auto
{The global variable that stores the 95% chance for a leveled item to resolve to nothing.}

; Mod Information
Bool            Property SKSELoaded = false Auto Hidden
{Whether or not SKSE has been detected.}
Bool            Property ScarcityLoaded = false Auto Hidden
{Whether or not Scarcity has been detected.}

; Compatibility Settings
GlobalVariable  Property SettingCompatScarcity Auto
{The global variable that controls whether or not Scarcity's globals will be used for loot generation.}

Event OnInit()
    RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
    ; Ensure that we are ingame before running the compatibility checks
    If(PlayerRef.Is3DLoaded())
        RunAllChecks(true)
    Else
        RegisterForSingleUpdate(5.0)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    Debug.Trace("[Anofeyn] Game load detected - running checks.")
    RunAllChecks(false)
    Debug.Trace("[Anofeyn] Game load checks completed")
EndEvent

Function RunAllChecks(Bool showMessages)
    {Runs all compatibility checks and logs appropriately.}
    IsDone = false
    Debug.Trace("[Anofeyn] Starting compatibility checks - errors are normal and expected.")
    If(showMessages)
        MessageChecksStarted.Show()
    EndIf

    ; Make sure that Anofeyn's esp and version are available
    CheckAnofeyn()

    ; Check if SKSE is available
    CheckSKSE()

    ; Check for other mods and enable automatic compatibility
    ; Scarcity
    CheckScarcity(showMessages)

    If(showMessages)
        MessageChecksFinished.Show()
    EndIf
    Debug.Trace("[Anofeyn] Compatibility checks done.")
    IsDone = true
EndFunction

; ----- ANOFEYN -----
Function CheckAnofeyn()
    {Makes sure that Anofeyn's esp is available (i.e. has not been merged into a different esp) and that its version number can be found.}
    If(!Game.GetFormFromFile(0x042936, "Anofeyn.esp") as GlobalVariable)
        ; If the warning property was filled (a newer version might have changed its name), use that
        If(MessageAnofeynMissing)
            MessageAnofeynMissing.Show()
        Else
            ; Otherwise, we'll have to use this method
            Debug.MessageBox("Anofeyn.esp could not be found. This is a SEVERE error - Anofeyn will not able to continue running.\n\nLikely reasons are:\n - An incomplete, corrupt or outdated installation of Anofeyn.\n - Anofeyn has been merged into a different esp file.\n\nPlease make sure that you have the latest version of Anofeyn installed and that it is NOT merged into a different esp before reporting this issue.")
        EndIf
    EndIf
EndFunction

; ----- SKSE -----
Function CheckSKSE()
    {Checks whether or not SKSE is loaded.}
    SKSELoaded = SKSE.GetVersionRelease() > 0
EndFunction

; ----- SCARCITY -----
Function CheckScarcity(Bool showMessages)
    {Check whether or not Scarcity is loaded and, if so, fills the relevant global variables with its values.}
    Bool scarcityFound = FindScarcity()
    If(scarcityFound && !ScarcityLoaded)
        ; Scarcity or Anofeyn has just been installed
        If(showMessages)
            MessageScarcityCompatible.Show()
        EndIf
        If(ScarcityCompatEnabled())
            ApplyScarcityValues()
        EndIf
        ScarcityLoaded = true
    ElseIf(!scarcityFound && ScarcityLoaded)
        ; Scarcity has been uninstalled, undo its changes
        If(showMessages)
            MessageScarcityUninstalled.Show()
        EndIf
        If(ScarcityCompatEnabled())
            UndoScarcityValues()
        EndIf
        ScarcityLoaded = false
    EndIf
EndFunction

Bool Function FindScarcity()
    {Makes sure that all required globals from Scarcity are available.}
    If(!Game.GetFormFromFile(0x000D64, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D68, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D6A, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D63, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D62, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D66, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x000D65, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    ElseIf(!Game.GetFormFromFile(0x0012D6, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable)
        return false
    Else
        return true
    EndIf
EndFunction

Bool Function ScarcityCompatEnabled()
    {Gets whether Scarcity compatibility is enabled or not.}
    return SettingCompatScarcity.GetValue() == 1.0
EndFunction

Function SetScarcityCompat(Bool enableCompat)
    {Changes whether Scarcity compatibility is enabled or not.}
    If(enableCompat)
        SettingCompatScarcity.SetValue(1.0)
        ApplyScarcityValues()
    Else
        SettingCompatScarcity.SetValue(0.0)
        UndoScarcityValues()
    EndIf
EndFunction

Function ApplyScarcityValues()
    {Applies Scarcity's rarity values to Anofeyn's globals.}
    ChanceNone0.SetValue((Game.GetFormFromFile(0x000D64, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone10.SetValue((Game.GetFormFromFile(0x000D68, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone25.SetValue((Game.GetFormFromFile(0x000D6A, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone50.SetValue((Game.GetFormFromFile(0x000D63, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone75.SetValue((Game.GetFormFromFile(0x000D62, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone80.SetValue((Game.GetFormFromFile(0x000D66, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone90.SetValue((Game.GetFormFromFile(0x000D65, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone95.SetValue((Game.GetFormFromFile(0x0012D6, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
EndFunction

Function UndoScarcityValues()
    {Undoes Scarcity's rarity changes to Anofeyn's globals.}
    ChanceNone0.SetValue(0.0)
    ChanceNone10.SetValue(10.0)
    ChanceNone25.SetValue(25.0)
    ChanceNone50.SetValue(50.0)
    ChanceNone75.SetValue(75.0)
    ChanceNone80.SetValue(80.0)
    ChanceNone90.SetValue(90.0)
    ChanceNone95.SetValue(95.0)
EndFunction

Bool Function ScarcityMismatch()
    {Checks if there is a mismatch between Scarcity's and Anofeyn's globals.}
    If(ChanceNone0.GetValue() != (Game.GetFormFromFile(0x000D64, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone10.GetValue() != (Game.GetFormFromFile(0x000D68, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone25.GetValue() != (Game.GetFormFromFile(0x000D6A, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone50.GetValue() != (Game.GetFormFromFile(0x000D63, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone75.GetValue() != (Game.GetFormFromFile(0x000D62, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone80.GetValue() != (Game.GetFormFromFile(0x000D66, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone90.GetValue() != (Game.GetFormFromFile(0x000D65, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    ElseIf(ChanceNone95.GetValue() != (Game.GetFormFromFile(0x0012D6, "Scarcity SE - Less Loot Mod.esp") as GlobalVariable).GetValue())
        return true
    Else
        return false
    EndIf
EndFunction

ScriptName _AF_Compatibility Extends ReferenceAlias
{The main compatibility script used to handle compatibility with other mods.}

; General
Actor           Property PlayerRef Auto
{The player reference.}

; Internals
bool            Property IsDone = false Auto Hidden
{Whether or not the compatibility checks have run.}

; Messages
Message         Property MessageChecksStarted Auto
{The message shown to the player when the compatibility checks have started running.}
Message         Property MessageChecksFinished Auto
{The message shown to the player when the compatibility checks have finished running.}
Message         Property MessageAnofeynMissing Auto
{The warning shown to the player when Anofeyn.esp could not be found.}
Message         Property MessageVersionMismatch Auto
{The warning shown to the player when Anofeyn's version does not match this script's version.}
Message         Property MessageASGOutdated Auto
{The warning shown to the player when Acquisitive Soul Gems has been detected.}
Message         Property MessageASGMIncluded Auto
{The warning shown to the player when Acquisitive Soul Gems Multithreaded has been detected.}
Message         Property MessageSSIncompatible Auto
{The warning shown to the player when Smart Souls has been detected.}
Message         Property MessageTSSIncompatible Auto
{The warning shown to the player when The Soul Saver has been detected.}
Message         Property MessageScarcityCompatible Auto
{The message shown to the player when Scarcity has been detected.}

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
bool            Property SKSELoaded = false Auto Hidden
{Whether or not SKSE has been detected.}
bool            Property ASGLoaded = false Auto Hidden
{Whether or not ASG has been detected.}
bool            Property ASGMLoaded = false Auto Hidden
{Whether or not ASGM has been detected.}
bool            Property SmartSoulsLoaded = false Auto Hidden
{Whether or not Smart Souls has been detected.}
bool            Property TSSLoaded = false Auto Hidden
{Whether or not The Soul Saver has been detected.}
bool            Property ScarcityLoaded = false Auto Hidden
{Whether or not Scarcity has been detected.}

; Compatibility Settings
GlobalVariable  Property SettingCompatScarcity Auto
{The global variable that controls whether or not Scarcity's globals will be used for loot generation.}

Event OnInit()
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
    ; Ensure that we are ingame before running the compatibility checks
    If(PlayerRef.Is3DLoaded())
        RunAllChecks(true)
    Else
        RegisterForSingleUpdate(1.0)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    Debug.Trace("[Anofeyn] Game load detected - running checks.")
    RunAllChecks(false)
    Debug.Trace("[Anofeyn] Game load checks completed")
EndEvent

Function RunAllChecks(bool showMessages)
    {Runs all compatibility checks and logs appropriately.}
    IsDone = false
    Debug.Trace("[Anofeyn] Starting compatibility checks - errors are normal and expected.")
    If(showMessages)
        MessageChecksStarted.Show()
    EndIf

    ; Make sure that anofeyn's version matches and that we're not merged
    CheckAnofeynVersion()

    ; Check if SKSE is available
    CheckSKSE()

    ; Check for a 'soul gem fix'
    ; Acquisitive Soul Gems
    CheckASG()

    ; Acquisitive Soul Gems Multithreaded
    CheckASGM()

    ; Smart Souls
    CheckSmartSouls()

    ; The Soul Saver
    CheckTSS()

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
Function CheckAnofeynVersion()
    {Makes sure that Anofeyn's version matches this script's version and that it has NOT been merged into a different esp.}
    GlobalVariable AnofeynVersion = Game.GetFormFromFile(0x042936, "Anofeyn.esp") as GlobalVariable
    If(!AnofeynVersion)
        ; If the warning property was filled (a newer version might have changed its name), use that
        If(MessageAnofeynMissing)
            MessageAnofeynMissing.Show()
        Else
            ; Otherwise, we'll have to use this method
            Debug.MessageBox("Anofeyn.esp could not be found. This is a SEVERE error - Anofeyn will not able to continue running.\n\nLikely reasons are:\n - An incomplete, corrupt or outdated installation of Anofeyn.\n - Anofeyn has been merged into a different esp file.\n\nPlease make sure that you have the latest version of Anofeyn installed and that it is NOT merged into a different esp before reporting this issue.")
        EndIf
    ElseIf(AnofeynVersion.GetValue() != 1) ; NOTE: This number has to be updated every time the _AF_Version global variable is changed
        ; If the warning property was filled (a newer version might have changed its name), use that
        If(MessageVersionMismatch)
            MessageVersionMismatch.Show()
        Else
            ; Otherwise, we'll have to use this method
            Debug.MessageBox("The installed version of Anofeyn does not match the version of Anofeyn's scripts.\n\nThis likely indicates an incomplete or corrupt installation. Please check if a new version is available and then uninstall and reinstall Anofeyn completely.")
        EndIf
    EndIf
EndFunction

; ----- SKSE -----
Function CheckSKSE()
    {Checks whether or not SKSE is loaded.}
    SKSELoaded = SKSE.GetVersionRelease() > 0
EndFunction

; ----- ACQUISITIVE SOUL GEMS -----
Function CheckASG()
    {Checks whether or not ASG is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x000D63, "Acquisitive Soul Gems.esp") as Quest)
        MessageASGOutdated.Show()
        ASGLoaded = true
    Else
        ASGLoaded = false
    EndIf
EndFunction

; ----- ACQUISITIVE SOUL GEMS MULTITHREADED -----
Function CheckASGM()
    {Checks whether or not ASGM is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x000D62, "AcquisitiveSoulGemMultithreaded.esp") as Quest)
        MessageASGMIncluded.Show()
        ASGMLoaded = true
    Else
        ASGMLoaded = false
    EndIf
EndFunction

; ----- SMART SOULS -----
Function CheckSmartSouls()
    {Checks whether or not Smart Souls is loaded and shows a warning if it is.}
    If(SKSELoaded && SKSE.GetPluginVersion("Smart Souls") >= 0)
        MessageSSIncompatible.Show()
        SmartSoulsLoaded = true
    Else
        SmartSoulsLoaded = false
    EndIf
EndFunction

; ----- THE SOUL SAVER -----
Function CheckTSS()
    {Checks whether or not The Soul Saver is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x001D97, "ogSoulSaver.esp") as Keyword)
        MessageTSSIncompatible.Show()
        TSSLoaded = true
    Else
        TSSLoaded = false
    EndIf
EndFunction

; ----- SCARCITY -----
Function CheckScarcity(bool showMessages)
    {Check whether or not Scarcity is loaded and, if so, fills the relevant global variables with its values.}
    GlobalVariable chance0 = Game.GetFormFromFile(0x000D64, "Scarcity - Less Loot Mod.esp") as GlobalVariable
    If(chance0 && !ScarcityLoaded)
        ; Scarcity or Anofeyn has just been installed
        If(showMessages)
            MessageScarcityCompatible.Show()
        EndIf
        If(SettingCompatScarcity.GetValue() == 1)
            ApplyScarcityValues()
        EndIf
        ScarcityLoaded = true
    ElseIf(!chance0 && ScarcityLoaded)
        ; Scarcity has been uninstalled, undo its changes
        UndoScarcityValues()
        ScarcityLoaded = false
    EndIf
EndFunction

bool Function GetScarcityCompat()
    {Gets whether Scarcity compatibility is enabled or not.}
    return SettingCompatScarcity.GetValue() == 1.0
EndFunction

Function SetScarcityCompat(bool enableCompat)
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
    ChanceNone0.SetValue((Game.GetFormFromFile(0x000D64, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone10.SetValue((Game.GetFormFromFile(0x000D68, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone25.SetValue((Game.GetFormFromFile(0x000D6A, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone50.SetValue((Game.GetFormFromFile(0x000D63, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone75.SetValue((Game.GetFormFromFile(0x000D62, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone80.SetValue((Game.GetFormFromFile(0x000D66, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone90.SetValue((Game.GetFormFromFile(0x000D65, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
    ChanceNone95.SetValue((Game.GetFormFromFile(0x0012D6, "Scarcity - Less Loot Mod.esp") as GlobalVariable).GetValue())
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

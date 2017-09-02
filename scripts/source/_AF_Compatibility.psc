ScriptName _AF_Compatibility Extends ReferenceAlias
{The main compatibility script used to handle compatibility with other mods.}

Actor       Property PlayerRef Auto
{The player reference.}

; Messages
Message     Property MessageChecksStarted Auto
{The message shown to the player when the compatibility checks have started running.}
Message     Property MessageChecksFinished Auto
{The message shown to the player when the compatibility checks have finished running.}
Message     Property MessageASGOutdated Auto
{The warning shown to the player when Acquisitive Soul Gems has been detected.}
Message     Property MessageASGMIncluded Auto
{The warning shown to the player when Acquisitive Soul Gems Multithreaded has been detected.}
Message     Property MessageSSIncompatible Auto
{The warning shown to the player when Smart Souls has been detected.}
Message     Property MessageTSSIncompatible Auto
{The warning shown to the player when The Soul Saver has been detected.}

; Internals
bool        Property IsDone Auto Hidden
{Whether or not the compatibility checks have run.}

; Mod Information
bool        Property SKSELoaded Auto Hidden
{Whether or not SKSE has been detected on this installation.}

Event OnInit()
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
    ; Ensure that we are ingame before running the compatibility checks
    If(PlayerRef.Is3DLoaded())
        RunAllChecks()
    Else
        RegisterForSingleUpdate(1.0)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    ; When loading a game, make sure SKSE is still available
    Debug.Trace("[Anofeyn] Game load detected - checking SKSE status.")
    CheckSKSE()
EndEvent

Function RunAllChecks()
    {Runs all compatibility checks and logs appropriately.}
    IsDone = false
    Debug.Trace("[Anofeyn] Starting compatibility checks - errors are normal and expected.")
    MessageChecksStarted.Show()

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

    MessageChecksFinished.Show()
    Debug.Trace("[Anofeyn] Compatibility checks done.")
    IsDone = true
EndFunction

Function CheckSKSE()
    {Checks whether or not SKSE is loaded.}
    SKSELoaded = SKSE.GetVersionRelease() > 0
EndFunction

Function CheckASG()
    {Checks whether or not ASG is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x000D63, "Acquisitive Soul Gems.esp") as Quest)
        MessageASGOutdated.Show()
    EndIf
EndFunction

Function CheckASGM()
    {Checks whether or not ASGM is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x000D62, "AcquisitiveSoulGemMultithreaded.esp") as Quest)
        MessageASGMIncluded.Show()
    EndIf
EndFunction

Function CheckSmartSouls()
    {Checks whether or not Smart Souls is loaded and shows a warning if it is.}
    If(SKSELoaded && SKSE.GetPluginVersion("Smart Souls") >= 0)
        MessageSSIncompatible.Show()
    EndIf
EndFunction

Function CheckTSS()
    {Checks whether or not The Soul Saver is loaded and shows a warning if it is.}
    If(Game.GetFormFromFile(0x001D97, "ogSoulSaver.esp") as Keyword)
        MessageTSSIncompatible.Show()
    EndIf
EndFunction

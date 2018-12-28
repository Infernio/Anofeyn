ScriptName _AF_CommonProblemWizard Extends ReferenceAlias
{A wizard used to detect and report on common problems.}

import _AF_Utils

; General
_AF_Compatibility   Property CompatibilityScript Auto
{The Anofeyn compatibility script.}
_AF_MCM_Reports     Property ReportsScript Auto
{The Anofeyn MCM Reports page script.}

; Messages
Message             Property MessageNeedSKSE Auto
{The message shown to the player to inform them that the wizard needs SKSE.}
Message             Property MessageWizardStarted Auto
{The message shown to the player when the wizard has started.}
Message             Property MessageWizardFinished Auto
{The message shown to the player when the wizard has finished.}

Function RunWizard()
    If(!CompatibilityScript.SKSELoaded)
        ; The wizard needs SKSE
        MessageNeedSKSE.Show()
        return
    EndIf

    MessageWizardStarted.Show()
    Debug.Trace("[Anofeyn] Running Problem Wizard. Errors are normal and expected.")
    ReportsScript.ResetReport()

    ; Incompatible Mods - make sure none of those are still installed
    CheckIncompatibleMods()

    ; Compatibility Failures - check if the compatibility script failed to find installed mods
    CheckCompatibilityFailures()

    ; Place a note if Scarcity's chances are out of date
    CheckScarcity()

    ReportsScript.FinishReport()
    Debug.Trace("[Anofeyn] Problem Wizard has finished running.")
    MessageWizardFinished.Show()
EndFunction

Function CheckIncompatibleMods()
    ; Add any incompatible mods here
EndFunction

Function CheckCompatibilityFailures()
    If(Game.IsPluginInstalled("Scarcity SE - Less Loot Mod.esp") && !CompatibilityScript.ScarcityLoaded)
        ; Scarcity is loaded but the compatibility script couldn't find its loot chances
        ReportsScript.AddToReport("Scarcity: Compatibility Failed", CompatibilityFailure(), "Scarcity is installed, but its loot chances could not be found.\nThis may happen if an update or ESL compression changed Scarcity's Form IDs.\nPlease revert to a known working version (1.1).", LevelWarning())
    EndIf
EndFunction

Function CheckScarcity()
    If(CompatibilityScript.ScarcityLoaded && CompatibilityScript.ScarcityCompatEnabled() && CompatibilityScript.ScarcityMismatch())
        ReportsScript.AddToReport("Scarcity: Mismatched Loot Chances", CompatibilityMisc(), "Scarcity is installed and compatibility with it is enabled, but the chances no longer seem to be in sync.\nThis can happen if you change Scarcity loot chances mid-playthrough.\nPlease untick and retick the Scarcity checkbox on the Compatibility page.", LevelInfo())
    EndIf
EndFunction

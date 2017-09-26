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

; Detection
MagicEffect         Property SoulTearEffect Auto
{The soul trap part of Soul Tear, Thunderchild needs to override this.}

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

    ; Thunderchild - ensures that Soul Tear receives the proper keywords
    CheckThunderchild()

    ReportsScript.FinishReport()
    Debug.Trace("[Anofeyn] Problem Wizard has finished running.")
    MessageWizardFinished.Show()
EndFunction

Function CheckIncompatibleMods()
    ; Smart Souls
    If(CompatibilityScript.SmartSoulsLoaded)
        ReportsScript.AddToReport("Smart Souls", IncompatibleMod(), "Smart Souls is incompatible with Anofeyn. See the Compatibility page for more information.\n\nSolution: Uninstall Smart Souls.", LevelError())
    EndIf

    ; ASG
    If(CompatibilityScript.ASGLoaded)
        ReportsScript.AddToReport("Acquisitive Soul Gems", IncompatibleMod(), "ASG is incompatible with Anofeyn. See the Compatibility page for more information.\n\nSolution: Uninstall ASG.", LevelError())
    EndIf

    ; ASGM
    If(CompatibilityScript.ASGMLoaded)
        ReportsScript.AddToReport("Acquisitive Soul Gems Multithreaded", IncompatibleMod(), "ASGM is incompatible with Anofeyn. See the Compatibility page for more information.\n\nSolution: Uninstall ASGM.", LevelError())
    EndIf

    ; TSS
    If(CompatibilityScript.TSSLoaded)
        ReportsScript.AddToReport("The Soul Saver", IncompatibleMod(), "TSS is incompatible with Anofeyn. See the Compatibility page for more information.\n\nSolution: Uninstall TSS.", LevelError())
    EndIf
EndFunction

Function CheckThunderchild()
    If(!SoulTearEffect.HasKeywordString("TC_ShoutAttack_Keyword"))
        ReportsScript.AddToReport("Thunderchild", LoadOrderConflict(), "Thunderchild conflicts with Anofeyn on DLC01_SoulTearTrapFFActor (XX007CB3).\n\nSolution: Either load Thunderchild after Anofeyn or install the compatibility patch available on Anofeyn's page.", LevelWarning())
    EndIf
EndFunction

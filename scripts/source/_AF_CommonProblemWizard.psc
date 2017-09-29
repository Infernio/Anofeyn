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

    ReportsScript.FinishReport()
    Debug.Trace("[Anofeyn] Problem Wizard has finished running.")
    MessageWizardFinished.Show()
EndFunction

Function CheckIncompatibleMods()
    ; Add any incompatible mods here
EndFunction

ScriptName _AF_MCM_Reports Extends MLib_Page

import _AF_Utils
import MLib_Utils

; ID Variables
; Stores the SkyUI IDs of the clickable error messages.
int[] errorClickables
; Stores the SkyUI IDs of the clickable warnings.
int[] warningClickables
; Stores the SkyUI IDs of the clickable notices.
int[] noticeClickables

; Storage Variables
; The errors that were recorded by the wizard.
string[] errors
; The mods corresponding to the errors that were recorded by the wizard.
string[] errorMods
; The detailed error messages that were recorded by the wizard.
string[] errorDetails
; The total number of reported errors.
int numErrors
; The warnings that were recorded by the wizard.
string[] warnings
; The mods corresponding to the warnings that were recorded by the wizard.
string[] warningMods
; The detailed warnings that were recorded by the wizard.
string[] warningDetails
; The total number of reported warnings.
int numWarnings
; The notices that were recorded by the wizard.
string[] notices
; The mods corresponding to the notices that were recorded by the wizard.
string[] noticeMods
; The detailed notices that were recorded by the wizard.
string[] noticeDetails
; The total number of reported notices.
int numNotices
; Whether or not a report is available for viewing.
bool hasReport

string Function GetTitle()
    return "$AFConfigPageReports"
EndFunction

Event OnPageInit()
    ResetReport()
EndEvent

Event OnPageReset()
    SetCursorFillMode(LEFT_TO_RIGHT)

    ; Check if we even have a report to show
    If(!hasReport)
        AddTextOption("$AFNoReports", "", OPTION_FLAG_DISABLED)
    Else
        int i = 0

        ; Errors
        AddHeaderOption("$AFErrors")
        AddHeaderOption("$AFClickForDetailedInfo")

        ; Check if we have errors to show
        If(numErrors <= 0)
            AddTextOption("$AFNoErrorsFound", "", OPTION_FLAG_DISABLED)
            AddEmptyOption()
        Else
            errorClickables = Utility.CreateIntArray(numErrors)
            While(i < numErrors)
                AddTextOption(errorMods[i], "")
                errorClickables[i] = AddTextOption("", errors[i], hover = "$AFClickErrorInfo")
                i += 1
            EndWhile
        EndIf

        ; One empty line
        AddEmptyOption()
        AddEmptyOption()

        ; Warnings
        AddHeaderOption("$AFWarnings")
        AddEmptyOption()

        ; Check if we have warnings to show
        If(numWarnings <= 0)
            AddTextOption("$AFNoWarningsFound", "", OPTION_FLAG_DISABLED)
            AddEmptyOption()
        Else
            i = 0
            warningClickables = Utility.CreateIntArray(numWarnings)
            While(i < numWarnings)
                AddTextOption(warningMods[i], "")
                warningClickables[i] = AddTextOption("", warnings[i], hover = "$AFClickWarningInfo")
                i += 1
            EndWhile
        EndIf

        ; One empty line
        AddEmptyOption()
        AddEmptyOption()

        ; Notices
        AddHeaderOption("$AFNotices")
        AddEmptyOption()

        ; Check if we have notices to show
        If(numNotices <= 0)
            AddTextOption("$AFNoNoticesFound", "", OPTION_FLAG_DISABLED)
        Else
            i = 0
            noticeClickables = Utility.CreateIntArray(numNotices)
            While(i < numNotices)
                AddTextOption(noticeMods[i], "")
                noticeClickables[i] = AddTextOption("", notices[i], hover = "$AFClickNoticeInfo")
                i += 1
            EndWhile
        EndIf
    EndIf
EndEvent

Event OnOptionSelect(int option)
    ; Errors
    int i = 0
    While(i < numErrors)
        If(option == errorClickables[i])
            ShowMessage(errorDetails[i])
            return
        EndIf
        i += 1
    EndWhile

    ; Warnings
    i = 0
    While(i < numWarnings)
        If(option == warningClickables[i])
            ShowMessage(warningDetails[i])
            return
        EndIf
        i += 1
    EndWhile

    ; Notices
    i = 0
    While(i < numNotices)
        If(option == noticeClickables[i])
            ShowMessage(noticeDetails[i])
            return
        EndIf
        i += 1
    EndWhile
EndEvent

Function ResetReport()
    errors = new string[8]
    errorMods = new string[8]
    errorDetails = new string[8]
    numErrors = 0
    warnings = new string[8]
    warningMods = new string[8]
    warningDetails = new string[8]
    numWarnings = 0
    notices = new string[8]
    noticeMods = new string[8]
    noticeDetails = new string[8]
    numNotices = 0
    hasReport = false
EndFunction

Function FinishReport()
    hasReport = true
EndFunction

Function AddToReport(string name, string category, string detailedMessage, int level)
    If(level == LevelError())
        errorMods[numErrors] = name
        errors[numErrors] = category
        errorDetails[numErrors] = detailedMessage
        numErrors += 1
        If(numErrors >= errors.length)
            errorMods = ExtendStringArray(errorMods, 8)
            errors = ExtendStringArray(errors, 8)
            errorDetails = ExtendStringArray(errorDetails, 8)
        EndIf
    ElseIf(level == LevelWarning())
        warningMods[numWarnings] = name
        warnings[numWarnings] = category
        warningDetails[numWarnings] = detailedMessage
        numWarnings += 1
        If(numWarnings >= warnings.length)
            warningMods = ExtendStringArray(warningMods, 8)
            warnings = ExtendStringArray(warnings, 8)
            warningDetails = ExtendStringArray(warningDetails, 8)
        EndIf
    ElseIf(level == LevelInfo())
        noticeMods[numNotices] = name
        notices[numNotices] = category
        noticeDetails[numNotices] = detailedMessage
        numNotices += 1
        If(numNotices >= notices.length)
            noticeMods = ExtendStringArray(noticeMods, 8)
            notices = ExtendStringArray(notices, 8)
            noticeDetails = ExtendStringArray(noticeDetails, 8)
        EndIf
    EndIf
EndFunction

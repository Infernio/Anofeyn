ScriptName _AF_MCMScript Extends SKI_ConfigBase
{The Anofeyn SkyUI Mod Configuration Menu.}

import _AF_Utils

; Anofeyn - Properties
_AF_Compatibility       Property CompatibilityScript Auto
{The Anofeyn compatibility script.}
_AF_CommonProblemWizard Property ProblemWizard Auto
{The Anofeyn problem wizard.}

; General - Properties
GlobalVariable          Property SettingDifficulty Auto
{The global variable that controls the difficulty setting.}

; General - ID Variables
; The SkyUI ID of the Difficulty slider.
int difficultyID
; The SkyUI ID of the Problem Wizard toggle.
int runProblemWizardID

; General - Storage Variables
bool runProblemWizard = false

; ASGM - Properties
GlobalVariable          Property SettingSilenceSuccess Auto
{The global variable that controls whether or not to print messages on capture success.}
GlobalVariable          Property SettingSilenceFailure Auto
{The global variable that controls whether or not to print messages on capture failure.}
GlobalVariable          Property SettingAzuraOnlyFull Auto
{The global variable that controls whether or not Azura's Star / The Black Star may house smaller souls.}
GlobalVariable          Property SettingOnlyBlackSouls Auto
{The global variable that controls whether or not black soul gems may only house black souls.}

; ASGM - ID Variables
; The SkyUI ID of the 'Azura full only' option.
int azuraOnlyFullID
; The SkyUI ID of the 'black souls only' option.
int onlyBlackID
; The SkyUI ID of the 'silence success' option.
int silenceSuccessID
; The SkyUI ID of the 'silence failure' option.
int silenceFailID

; Compatibility - ID Variables
; The SkyUI ID of the Scarcity toggle
int scarcityID
; The SkyUI ID of the ASG 'toggle'
int asgID
; The SkyUI ID of the ASGM 'toggle'
int asgmID
; The SkyUI ID of the Smart Souls 'toggle'
int smartSoulsID
; The SkyUI ID of the TSS 'toggle'
int tssID

; Reports - ID Variables
; Stores the SkyUI IDs of the clickable error messages.
int[] errorClickables
; Stores the SkyUI IDs of the clickable warnings.
int[] warningClickables
; Stores the SkyUI IDs of the clickable notices.
int[] noticeClickables

; Reports - Storage Variables
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

; Constants
; The unique (untranslated) name of the 'General' page
string PAGE_GENERAL = "$AFConfigPageGeneral"
; The unique (untranslated) name of the 'Soul Gems' page
string PAGE_ASGM = "$AFConfigPageSoulGems"
; The unique (untranslated) name of the 'Compatibility' page
string PAGE_COMPATIBILITY = "$AFConfigPageCompatibility"
; The unique (untranslated) name of the 'Reports' page
string PAGE_REPORTS = "$AFConfigPageReports"

int Function GetVersion()
    {Gets the version of this MCM Script.}
    return 1
EndFunction

Event OnConfigInit()
    Pages = new string[4]
    Pages[0] = PAGE_GENERAL
    Pages[1] = PAGE_ASGM
    Pages[2] = PAGE_COMPATIBILITY
    Pages[3] = PAGE_REPORTS

    ResetReport()
EndEvent

Event OnPageReset(string page)
    If(page == "")
        ; LoadCustomContent()
    Else
        ; UnloadCustomContent()
        If(page == PAGE_GENERAL)
            ; General Page
            SetCursorFillMode(LEFT_TO_RIGHT)

            ; Settings
            AddHeaderOption("$AFSettings")
            AddEmptyOption()

            difficultyID = AddMenuOption("$AFDifficulty", GetDifficultyDesc(SettingDifficulty.GetValue() as int))
            AddEmptyOption() ; Remove me for the next option

            ; One empty line
            AddEmptyOption()
            AddEmptyOption()

            ; Troubleshooting
            AddHeaderOption("$AFTroubleshooting")
            AddEmptyOption()

            If(!runProblemWizard)
                runProblemWizardID = AddTextOption("$AFProblemWizard", "$AFClickToRun")
            Else
                runProblemWizardID = AddTextOption("$AFProblemWizard", "$AFExitMenuToRun", OPTION_FLAG_DISABLED)
            EndIf
        ElseIf(page == PAGE_ASGM)
            ; ASGM Page
            SetCursorFillMode(LEFT_TO_RIGHT)

            AddHeaderOption("$ASGOptionsHeader")
            AddEmptyOption()

            azuraOnlyFullID = AddToggleOption("$ASGFilledOption", SettingAzuraOnlyFull.GetValue() == 1)
            onlyBlackID = AddToggleOption("$ASGBlackOption", SettingOnlyBlackSouls.GetValue() == 1)
            silenceSuccessID = AddToggleOption("$ASGSilenceSuccessOption", SettingSilenceSuccess.GetValue() == 1)
            silenceFailID = AddToggleOption("$ASGSilenceFailOption", SettingSilenceFailure.GetValue() == 1)
        ElseIf(page == PAGE_COMPATIBILITY)
            ; Compatibility Page
            SetCursorFillMode(LEFT_TO_RIGHT)

            ; Compatible Mods
            AddHeaderOption("$AFCompatibleMods")
            AddEmptyOption()

            scarcityID = AddModToggle("Scarcity", CompatibilityScript.ScarcityLoaded, CompatibilityScript.GetScarcityCompat())
            AddEmptyOption() ; Remove me for the next mod

            ; One empty line
            AddEmptyOption()
            AddEmptyOption()

            ; Incompatible Mods
            AddHeaderOption("$AFIncompatibleMods")
            AddEmptyOption()

            asgID = AddModToggle("Acquisitive Soul Gems", CompatibilityScript.ASGLoaded, CompatibilityScript.ASGLoaded)
            asgmID = AddModToggle("Acquisitive Soul Gems Multithreaded", CompatibilityScript.ASGMLoaded, CompatibilityScript.ASGMLoaded)
            smartSoulsID = AddModToggle("Smart Souls", CompatibilityScript.SmartSoulsLoaded, CompatibilityScript.SmartSoulsLoaded)
            tssID = AddModToggle("The Soul Saver", CompatibilityScript.TSSLoaded, CompatibilityScript.TSSLoaded)
        ElseIf(page == PAGE_REPORTS)
            ; Reports Page
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
                Else
                    errorClickables = Utility.CreateIntArray(numErrors)
                    While(i < numErrors)
                        AddTextOption(errorMods[i], "")
                        errorClickables[i] = AddTextOption("", errors[i])
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
                Else
                    i = 0
                    warningClickables = Utility.CreateIntArray(numWarnings)
                    While(i < numWarnings)
                        AddTextOption(warningMods[i], "")
                        warningClickables[i] = AddTextOption("", warnings[i])
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
                        noticeClickables[i] = AddTextOption("", notices[i])
                        i += 1
                    EndWhile
                EndIf
            EndIf
        EndIf
    EndIf
EndEvent

int Function AddModToggle(string name, bool loaded, bool enabled)
    {Adds a toggle for the specified mod.}
    If(loaded)
        return AddToggleOption(name, enabled)
    Else
        return AddToggleOption(name, false, OPTION_FLAG_DISABLED)
    EndIf
EndFunction

Event OnOptionMenuOpen(int option)
    ; General Page
    If(option == difficultyID)
        SetMenuDialogStartIndex(SettingDifficulty.GetValue() as int)
        SetMenuDialogDefaultIndex(1)

        string[] options = new string[3]
        options[0] = GetDifficultyDesc(0)
        options[1] = GetDifficultyDesc(1)
        options[2] = GetDifficultyDesc(2)
        SetMenuDialogOptions(options)
    EndIf
EndEvent

Event OnOptionSelect(int option)
    ; General Page
    If(option == runProblemWizardID)
        runProblemWizard = true
        SetTextOptionValue(option, "$AFExitMenuToRun", true)
        SetOptionFlags(option, OPTION_FLAG_DISABLED)

    ; ASGM Page
    ElseIf(option == azuraOnlyFullID)
        bool newValue = SettingAzuraOnlyFull.GetValue() == 0
        SettingAzuraOnlyFull.SetValue(newValue as float)
		SetToggleOptionValue(option, newValue)

	ElseIf(option == onlyBlackID)
        bool newValue = SettingOnlyBlackSouls.GetValue() == 0
        SettingOnlyBlackSouls.SetValue(newValue as float)
		SetToggleOptionValue(option, newValue)

	ElseIf(option == silenceSuccessID)
		bool newValue = SettingSilenceSuccess.GetValue() == 0
        SettingSilenceSuccess.SetValue(newValue as float)
		SetToggleOptionValue(option, newValue)

	ElseIf(option == silenceFailID)
        bool newValue = SettingSilenceFailure.GetValue() == 0
        SettingSilenceFailure.SetValue(newValue as float)
		SetToggleOptionValue(option, newValue)

    ; Compatibility Page
    ElseIf(option == scarcityID)
        bool newValue = !CompatibilityScript.GetScarcityCompat()
        CompatibilityScript.SetScarcityCompat(newValue)
        SetToggleOptionValue(option, newValue)

    ; Reports Page
    Else
        ; Errors
        int i = 0
        While(i < numErrors)
            If(option == errorClickables[i])
                Debug.MessageBox(errorDetails[i])
                return
            EndIf
            i += 1
        EndWhile

        ; Warnings
        i = 0
        While(i < numWarnings)
            If(option == warningClickables[i])
                Debug.MessageBox(warningDetails[i])
                return
            EndIf
            i += 1
        EndWhile

        ; Notices
        i = 0
        While(i < numNotices)
            If(option == noticeClickables[i])
                Debug.MessageBox(noticeDetails[i])
                return
            EndIf
            i += 1
        EndWhile
    EndIf
EndEvent

Event OnOptionMenuAccept(int option, int index)
    If(option == difficultyID)
        SettingDifficulty.SetValue(index)
        SetMenuOptionValue(option, GetDifficultyDesc(index))
    EndIf
EndEvent

Event OnOptionHighlight(int option)
    ; General Page
    If(option == difficultyID)
        SetInfoText("$AFDifficultyInfo")

    ; ASGM Page
    ElseIf(option == azuraOnlyFullID)
        SetInfoText("$ASGFilledInfo")
    ElseIf(option == onlyBlackID)
		SetInfoText("$ASGBlackInfo")
	ElseIf(option == silenceSuccessID)
		SetInfoText("$ASGSilenceSuccessInfo")
	ElseIf(option == silenceFailID)
		SetInfoText("$ASGSilenceFailInfo")

    ; Compatibility Page
    ElseIf(option == scarcityID)
        SetInfoText("$AFCompatInfoScarcity")
    ElseIf(option == asgID)
        SetInfoText("$AFCompatInfoASG")
    ElseIf(option == asgmID)
        SetInfoText("$AFCompatInfoASGM")
    ElseIf(option == smartSoulsID)
        SetInfoText("$AFCompatInfoSmartSouls")
    ElseIf(option == tssID)
        SetInfoText("$AFCompatInfoTSS")
    ElseIf(option == runProblemWizardID)
        SetInfoText("$AFProblemWizardInfo")

    ; Reports Page
    Else
        ; Errors
        int i = 0
        While(i < numErrors)
            If(option == errorClickables[i])
                SetInfoText("$AFClickErrorInfo")
                return
            EndIf
            i += 1
        EndWhile

        ; Warnings
        i = 0
        While(i < numWarnings)
            If(option == warningClickables[i])
                SetInfoText("$AFClickWarningInfo")
                return
            EndIf
            i += 1
        EndWhile

        ; Notices
        i = 0
        While(i < numNotices)
            If(option == noticeClickables[i])
                SetInfoText("$AFClickNoticeInfo")
                return
            EndIf
            i += 1
        EndWhile
    EndIf
EndEvent

string Function GetDifficultyDesc(int difficultyVal)
    {Gets a human-readable description for the specified difficulty.}
    If(difficultyVal == 0)
        return "$AFDifficultyEasy"
    ElseIf(difficultyVal == 1)
        return "$AFDifficultyMedium"
    ElseIf(difficultyVal == 2)
        return "$AFDifficultyHard"
    Else
        return "$AFError"
    EndIf
EndFunction

Event OnConfigClose()
    If(runProblemWizard)
        runProblemWizard = false
        ProblemWizard.RunWizard()
    EndIf
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
            errorMods = ExpandStringArray(errorMods, 8)
            errors = ExpandStringArray(errors, 8)
            errorDetails = ExpandStringArray(errorDetails, 8)
        EndIf
    ElseIf(level == LevelWarning())
        warningMods[numWarnings] = name
        warnings[numWarnings] = category
        warningDetails[numWarnings] = detailedMessage
        numWarnings += 1
        If(numWarnings >= warnings.length)
            warningMods = ExpandStringArray(warningMods, 8)
            warnings = ExpandStringArray(warnings, 8)
            warningDetails = ExpandStringArray(warningDetails, 8)
        EndIf
    ElseIf(level == LevelInfo())
        noticeMods[numNotices] = name
        notices[numNotices] = category
        noticeDetails[numNotices] = detailedMessage
        numNotices += 1
        If(numNotices >= notices.length)
            noticeMods = ExpandStringArray(noticeMods, 8)
            notices = ExpandStringArray(notices, 8)
            noticeDetails = ExpandStringArray(noticeDetails, 8)
        EndIf
    EndIf
EndFunction

string[] Function ExpandStringArray(string[] array, int by)
    {Expands the specified array by the specified amount.}
    string[] ret = Utility.CreateStringArray(array.length + by)
    int i = 0
    While(i < array.length)
        ret[i] = array[i]
        i += 1
    EndWhile
    return ret
EndFunction

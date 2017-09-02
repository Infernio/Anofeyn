ScriptName _AF_MCMScript Extends SKI_ConfigBase
{The Anofeyn SkyUI Mod Configuration Menu.}

; Anofeyn - Properties
_AF_Compatibility   Property CompatibilityScript Auto
{The Anofeyn compatibility script.}

; General - Properties
GlobalVariable      Property SettingDifficulty Auto
{The global variable that controls the difficulty setting.}

; General - ID Variables
int difficultyID = 0

; ASGM - Properties
GlobalVariable      Property SettingSilenceSuccess Auto
{The global variable that controls whether or not to print messages on capture success.}
GlobalVariable      Property SettingSilenceFailure Auto
{The global variable that controls whether or not to print messages on capture failure.}
GlobalVariable      Property SettingAzuraOnlyFull Auto
{The global variable that controls whether or not Azura's Star / The Black Star may house smaller souls.}
GlobalVariable      Property SettingOnlyBlackSouls Auto
{The global variable that controls whether or not black soul gems may only house black souls.}

; ASGM - ID Variables
; The SkyUI ID of the 'Azura full only' option.
int azuraOnlyFullID = 0
; The SkyUI ID of the 'black souls only' option.
int onlyBlackID = 0
; The SkyUI ID of the 'silence success' option.
int silenceSuccessID = 0
; The SkyUI ID of the 'silence failure' option.
int silenceFailID = 0

; Constants
; The unique (untranslated) name of the 'General' page
string PAGE_GENERAL = "$AFConfigPageGeneral"
; The unique (untranslated) name of the 'Soul Gems' page
string PAGE_ASGM = "$AFConfigPageSoulGems"
; The unique (untranslated) name of the 'Compatibility' page
string PAGE_COMPATIBILITY = "$AFConfigPageCompatibility"

int Function GetVersion()
    {Gets the version of this MCM Script.}
    return 1
EndFunction

Event OnConfigInit()
    Pages = new string[3]
    Pages[0] = PAGE_GENERAL
    Pages[1] = PAGE_ASGM
    Pages[2] = PAGE_COMPATIBILITY
EndEvent

Event OnPageReset(string page)
    If(page == "")
        ; LoadCustomContent()
    Else
        ; UnloadCustomContent()
        If(page == PAGE_GENERAL)
            ; General Page
            SetCursorFillMode(LEFT_TO_RIGHT)

            difficultyID = AddMenuOption("Difficulty", GetDifficultyDesc(SettingDifficulty.GetValue() as int))
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
        EndIf
    EndIf
EndEvent

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
    ; ASGM Page
    If(option == azuraOnlyFullID)
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
        SetInfoText("Controls the difficulty of reanimation.")

    ; ASGM Page
    ElseIf(option == azuraOnlyFullID)
        SetInfoText("$ASGFilledInfo")
    ElseIf(option == onlyBlackID)
		SetInfoText("$ASGBlackInfo")
	ElseIf(option == silenceSuccessID)
		SetInfoText("$ASGSilenceSuccessInfo")
	ElseIf(option == silenceFailID)
		SetInfoText("$ASGSilenceFailInfo")
    EndIf
EndEvent

string Function GetDifficultyDesc(int difficultyVal)
    {Gets a human-readable description for the specified difficulty.}
    If(difficultyVal == 0)
        return "Easy"
    ElseIf(difficultyVal == 1)
        return "Medium"
    ElseIf(difficultyVal == 2)
        return "Hard "
    Else
        return "Unknown"
    EndIf
EndFunction

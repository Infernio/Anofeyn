ScriptName _AF_MCM_General Extends MLib_Page
{The 'General' page of the Anofeyn SkyUI Mod Configuration Menu.}

; Properties
_AF_CommonProblemWizard Property ProblemWizard Auto
{The Anofeyn problem wizard.}
GlobalVariable          Property SettingDifficulty Auto
{The global variable that controls the difficulty setting.}

; ID Variables
; The SkyUI ID of the Difficulty slider.
int difficultyID
; The SkyUI ID of the Problem Wizard toggle.
int runProblemWizardID

; General - Storage Variables
bool runProblemWizard = false

string Function GetTitle()
    return "$AFConfigPageGeneral"
EndFunction

Event OnPageReset()
    SetCursorFillMode(LEFT_TO_RIGHT)

    ; Settings
    AddHeaderOption("$AFSettings")
    AddEmptyOption()

    difficultyID = AddGVMenuOption("$AFDifficulty", SettingDifficulty, hover = "$AFDifficultyInfo")
    AddEmptyOption() ; Remove me for the next option

    ; One empty line
    AddEmptyOption()
    AddEmptyOption()

    ; Troubleshooting
    AddHeaderOption("$AFTroubleshooting")
    AddEmptyOption()

    If(!runProblemWizard)
        runProblemWizardID = AddTextOption("$AFProblemWizard", "$AFClickToRun", hover = "$AFProblemWizardInfo")
    Else
        runProblemWizardID = AddTextOption("$AFProblemWizard", "$AFExitMenuToRun", OPTION_FLAG_DISABLED, "$AFProblemWizardInfo")
    EndIf
EndEvent

Event OnOptionSelect(int option)
    If(option == runProblemWizardID)
        runProblemWizard = true
        SetTextOptionValue(option, "$AFExitMenuToRun", true)
        SetOptionFlags(option, OPTION_FLAG_DISABLED)
    EndIf
EndEvent

Event OnConfigClose()
    If(runProblemWizard)
        runProblemWizard = false
        ProblemWizard.RunWizard()
    EndIf
EndEvent

string Function TranslateMenuOption(int option, int selection)
    If(option == difficultyID)
        If(selection == 0)
            return "$AFDifficultyEasy"
        ElseIf(selection == 1)
            return "$AFDifficultyMedium"
        ElseIf(selection == 2)
            return "$AFDifficultyHard"
        Else
            return "$AFError"
        EndIf
    EndIf
EndFunction

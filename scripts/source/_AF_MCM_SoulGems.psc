ScriptName _AF_MCM_SoulGems Extends MLib_Page
{The 'Soul Gems' page of the Anofeyn SkyUI Mod Configuration Menu.}

; Properties
GlobalVariable          Property SettingSilenceSuccess Auto
{The global variable that controls whether or not to print messages on capture success.}
GlobalVariable          Property SettingSilenceFailure Auto
{The global variable that controls whether or not to print messages on capture failure.}
GlobalVariable          Property SettingAzuraOnlyFull Auto
{The global variable that controls whether or not Azura's Star / The Black Star may house smaller souls.}
GlobalVariable          Property SettingOnlyBlackSouls Auto
{The global variable that controls whether or not black soul gems may only house black souls.}

string Function GetTitle()
    return "$AFConfigPageSoulGems"
EndFunction

Event OnPageReset()
    SetCursorFillMode(LEFT_TO_RIGHT)

    AddHeaderOption("$ASGOptionsHeader")
    AddEmptyOption()

    AddGVToggleOption("$ASGFilledOption", SettingAzuraOnlyFull, hover = "$ASGFilledInfo")
    AddGVToggleOption("$ASGBlackOption", SettingOnlyBlackSouls, hover = "$ASGBlackInfo")
    AddGVToggleOption("$ASGSilenceSuccessOption", SettingSilenceSuccess, hover = "$ASGSilenceSuccessInfo")
    AddGVToggleOption("$ASGSilenceFailOption", SettingSilenceFailure, hover = "$ASGSilenceFailInfo")
EndEvent

ScriptName _AF_RecentlyDeceasedCleanup Extends ActiveMagicEffect

Faction Property RecentlyDeceased Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Debug.MessageBox("Yay, starting magic effect")
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.MessageBox("Removing from faction")
    akTarget.RemoveFromFaction(RecentlyDeceased)
EndEvent

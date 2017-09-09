ScriptName _AF_RecentlyDeceasedCleanup Extends ActiveMagicEffect
{A script used to remove 'recently deceased' corpses from the faction in order to prevent bloat.}

Faction Property RecentlyDeceased Auto
{The 'recently deceased' faction.}

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    akTarget.RemoveFromFaction(RecentlyDeceased)
EndEvent

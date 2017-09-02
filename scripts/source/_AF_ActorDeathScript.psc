ScriptName _AF_ActorDeathScript Extends Quest
{Tracks actor deaths caused by the player and acts on them.}

Spell       Property RecentlyDeceasedSpell Auto
{The spell that should be applied to recently deceased corpses.}
Keyword     Property ActorTypeGhost Auto
{The ghost type keyword.}
LeveledItem Property AnimalBones Auto
{The bones that can drop from animal corpses.}
LeveledItem Property HumanBones Auto
{The bones that can drop from human corpses.}
LeveledItem Property ElvenBones Auto
{The bones that can drop from elven corpses.}
LeveledItem Property BeastBones Auto
{The bones that can drop from beast race (i.e. argonians and khajiit) corpses.}

Event OnStoryKillActor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
    Actor victim = akVictim as Actor
    If(victim && LeavesCorpse(victim))
        ; Mark the corpse as recently deceased and add loot to it
        victim.AddSpell(RecentlyDeceasedSpell, false)
        AddLoot(victim)
    EndIf

    ; Reset the quest
    Stop()
EndEvent

bool Function LeavesCorpse(Actor victim)
    return !victim.HasKeyword(ActorTypeGhost)
EndFunction

Function AddLoot(Actor victim)

EndFunction

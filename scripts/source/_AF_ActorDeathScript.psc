ScriptName _AF_ActorDeathScript Extends Quest
{Tracks actor deaths caused by the player and acts on them.}

; GENERAL
Faction     Property RecentlyDeceased Auto
{The faction that recently deceased corpses are added to.}
Keyword     Property ActorTypeGhost Auto
{The ghost type keyword.}
Keyword     Property MagicNoReanimate Auto
{The keyword that indicates that a corpse should not be reanimated.}
FormList    Property DontModifyDrops Auto
{A formlist containing actors whose drops should not be modified.}
Spell       Property CleanupSpell Auto
{The spell used to clean up the 'recently deceased' faction.}

; RACE FACTIONS & LISTS
Faction     Property FactionCreatures Auto
{The creature faction.}
Faction     Property FactionSkeletons Auto
{The skeleton faction.}
Race        Property RaceOrc Auto
{The orc race.}
Race        Property RaceArgonian Auto
{The argonian race.}
Race        Property RaceKhajiit Auto
{The khajiit race.}
FormList    Property RacesHuman Auto
{All playable human races.}
FormList    Property RacesElven Auto
{All playable elven races.}

; LOOT LISTS
LeveledItem Property LootAnimals Auto
{The loot that can drop from animal corpses.}
LeveledItem Property LootHumans Auto
{The loot that can drop from human corpses.}
LeveledItem Property LootElves Auto
{The loot that can drop from elven corpses.}
LeveledItem Property LootOrcs Auto
{The loot that can drop from orc corpses.}
LeveledItem Property LootArgonians Auto
{The loot that can drop from argonian corpses.}
LeveledItem Property LootKhajiit Auto
{The loot that can drop from khajiit corpses.}
LeveledItem Property LootSkeletons Auto
{The loot that can drop from skeletons.}

Event OnStoryKillActor(ObjectReference akVictim, ObjectReference akKiller, Location akLocation, int aiCrimeStatus, int aiRelationshipRank)
    Actor victim = akVictim as Actor
    If(victim && CanModifyLoot(victim))
        ; Mark the corpse as recently deceased and add loot to it
        victim.AddToFaction(RecentlyDeceased)
        CleanupSpell.Cast(akKiller, victim)
        AddLoot(victim)
    EndIf

    ; Reset the quest
    Stop()
EndEvent

bool Function CanModifyLoot(Actor victim)
    {Checks whether or not Anofeyn may modify the drops of the specified actor.}
    return !victim.HasKeyword(ActorTypeGhost) && !victim.HasKeyword(MagicNoReanimate) && DontModifyDrops.Find(victim) == -1
EndFunction

Function AddLoot(Actor victim)
    {Adds loot to the victim based on their race.}
    If(victim.IsInFaction(FactionSkeletons))
        ; Skeletons drop lots of bones
        AddItems(victim, LootSkeletons, 6)
        return
    EndIf

    ; Check the race and add loot based on that
    ; TODO Balance these drops
    If(victim.GetRace() == RaceOrc)
        AddItems(victim, LootOrcs, 3)
    ElseIf(victim.GetRace() == RaceArgonian)
        AddItems(victim, LootArgonians, 3)
    ElseIf(victim.GetRace() == RaceKhajiit)
        AddItems(victim, LootKhajiit, 3)
    ElseIf(victim.IsInFaction(FactionCreatures))
        AddItems(victim, LootAnimals, 3)
    ElseIf(RacesHuman.Find(victim.GetRace()) != -1)
        AddItems(victim, LootHumans, 3)
    ElseIf(RacesElven.Find(victim.GetRace()) != -1)
        AddItems(victim, LootElves, 3)
    EndIf
EndFunction

Function AddItems(Actor victim, LeveledItem items, int max)
    {Adds a number of items between 1 and max to the specified actor.}
    int numItems = Utility.RandomInt(1, max)
    int i = 0
    While(i < numItems)
        victim.AddItem(items)
        i += 1
    EndWhile
EndFunction

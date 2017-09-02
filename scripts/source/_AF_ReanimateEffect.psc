ScriptName _AF_ReanimateEffect Extends ActiveMagicEffect
{Controls the soul-gem-based reanimation in Anofeyn.}

; Internals
Actor           Property PlayerRef Auto
{The player reference.}
GlobalVariable  Property SettingDifficulty Auto
{The global variable that controls the difficulty setting.}

; Balance
bool            Property IsScroll = false Auto
{Whether or not this reanimation effect comes from a scroll.}
int             Property SpellLevel = 0 Auto
{The 'level' of the spell (i.e. novice = 0, apprentice = 1, etc.).}

; Spells and Effects
Spell           Property ReanimationSpell Auto
{The actual spell used to reanimate the minion.}
MagicEffect     Property RecentlyDeceasedEffect Auto
{The effect that signals that a corpse is fresh and therefore more difficult to exert influence over.}
Spell           Property RecentlyDeceasedSpell Auto
{The spell that applies the recently deceased effect, see above.}
Spell           Property RecentlyDeceasedDebuffSpell Auto
{The debuff applied to the player when they reanimate a recently deceased corpse.}

; Messages and Menus
Message         Property MessageDebuffWarning Auto
{The message shown to the player when they attempt to resurrect a recently deceased body.}
Message         Property MessageDebuffApplied Auto
{The message shown to the player when they get the 'recently deceased' debuff applied.}
Message         Property MessageUnsuccessfulResurrection Auto
{The message shown to the player when the resurrection fails.}
Message         Property ReanimationMenu Auto
{The menu used when reanimating a minion.}

; Compatibility
FormList        Property ListNoReanimation Auto
{A list of actors that should not be resurrected.}
FormList        Property ListScriptedReanimations Auto
{A list of actors whose reanimations should always succeed.}
FormList        Property ListScriptedReanimationsNPCOnly Auto
{A list of actors whose reanimations should always succeed, but only when NPCs cast the spells.}

; Soul Gems
SoulGem         Property SoulGemPetty Auto
{The filled petty soul gem item type.}
SoulGem         Property SoulGemLesser Auto
{The filled lesser soul gem item type.}
SoulGem         Property SoulGemCommon Auto
{The filled common soul gem item type.}
SoulGem         Property SoulGemGreater Auto
{The filled greater soul gem item type.}
SoulGem         Property SoulGemGrand Auto
{The filled grand soul gem item type.}
SoulGem         Property SoulGemBlack Auto
{The filled black soul gem item type.}

Event OnEffectStart(Actor akTarget, Actor akCaster)
    If(IsValidTarget(akTarget))
        int choice = -1
        If(akCaster == PlayerRef)
            choice = ReanimationMenu.Show()
            If(choice == 0)
                ; Player chose to cancel
                Dispel()
                return
            EndIf
        EndIf

        ; Go ahead and resurrect
        HandleResurrection(akCaster, akTarget, choice)
    EndIf
    Dispel()
EndEvent

bool Function IsValidTarget(Actor target)
    {Checks if the target is actually valid for reanimation.}
    return target.IsDead() && ListNoReanimation.Find(target) == -1
EndFunction

Function HandleResurrection(Actor caster, Actor target, int choice)
    {Handles the actual resurrection process (level checking, etc.)}
    bool isPlayer = choice != -1
    bool isFresh = target.HasMagicEffect(RecentlyDeceasedEffect)

    ; Check compatibility lists
    If(ListScriptedReanimations.Find(target) != -1 || (!isPlayer && ListScriptedReanimationsNPCOnly.Find(target) != -1))
        ; We're supposed to always allow this resurrection - skip the whole process
        DoResurrection(caster, target, -1)
        return
    EndIf

    ; Show the player a warning if they attempt to reanimate a recently deceased body
    If(isPlayer && isFresh)
        If(MessageDebuffWarning.Show() == 1)
            ; Player chose to cancel
            return
        EndIf
    EndIf

    ; The variable used to track whether or not this resurrection will succeed
    ; Biased against the caster by default
    float successVar = 10

    ; Add in level difference
    ; Higher level enemies are harder to resurrect for a low level necromancer
    successVar += target.GetLevel() - caster.GetLevel()

    ; Add in Conjuration skill
    ; High Conjuration skill makes it easier to bridge the gap
    successVar -= caster.GetActorValue("Conjuration") / 10

    ; Add in the soul gem factor
    ; Better soul gems make it easier to resurrect
    successVar -= GetSoulGemFactor(choice, isPlayer)

    ; Add in the spell level
    ; Higher level spells make resurrection easier
    successVar -= SpellLevel * 5

    If(isPlayer)
        ; Add in the difficulty factor
        ; Higher difficulty levels make it harder to resurrect, lower ones make it easier
        ; Easy = 0, Normal = 1, Hard = 2
        successVar += (SettingDifficulty.GetValue() - 1) * 10

        ; Fresh corpses are much more difficult to reanimate
        If(isFresh)
            ; The difficulty increase is player only, but the debuff gets applied to anyone
            successVar += 10
        EndIf
    EndIf

    ; Check if we managed to overcome the bias
    If(successVar <= 0)
        DoResurrection(caster, target, choice)
        If(isFresh)
            target.RemoveSpell(RecentlyDeceasedSpell)
            RecentlyDeceasedDebuffSpell.Cast(target, caster)
            If(isPlayer)
                MessageDebuffApplied.Show()
            EndIf
        EndIf
    Else
        If(isPlayer)
            MessageUnsuccessfulResurrection.Show()
        EndIf
    EndIf
EndFunction

int Function GetSoulGemFactor(int choice, bool isPlayer)
    {Calculates the soul gem factor that will contribute to the resurrection.}
    If(IsScroll)
        ; Scrolls always give the highest chance
        return 25
    ElseIf(!isPlayer)
        ; Assume enemies always use Greater Soul Gems
        return 10
    ElseIf(choice == 1)
        ; Black - Massive Bonus
        return 25
    ElseIf(choice == 2)
        ; Grand - Significant Bonus
        return 20
    ElseIf(choice == 3)
        ; Greater - Sizable Bonus
        return 10
    ElseIf(choice == 4)
        ; Common - No Bonus
        return 0
    ElseIf(choice == 5)
        ; Lesser - Slight Debuff
        return -5
    ElseIf(choice == 6)
        ; Petty - Sizable Debuff
        return -10
    ElseIf(choice == 7)
        ; None - Significant Debuff
        return -20
    Else
        ; ???
        Debug.Trace("[Anofeyn] Unknown soul gem choice")
        return 0
    EndIf
EndFunction

Function DoResurrection(Actor caster, Actor target, int choice)
    {Executes the actual resurrection of the target, removing a soul gem if the player chose to do so.}
    If(choice != -1)
        RemoveSoulGem(choice)
    EndIf
    ReanimationSpell.Cast(caster, target)
EndFunction

Function RemoveSoulGem(int choice)
    {Removes the selected soul gem from the player's inventory.}
    If(choice == 1)
        PlayerRef.RemoveItem(SoulGemBlack)
    ElseIf(choice == 2)
        PlayerRef.RemoveItem(SoulGemGrand)
    ElseIf(choice == 3)
        PlayerRef.RemoveItem(SoulGemGreater)
    ElseIf(choice == 4)
        PlayerRef.RemoveItem(SoulGemCommon)
    ElseIf(choice == 5)
        PlayerRef.RemoveItem(SoulGemLesser)
    ElseIf(choice == 6)
        PlayerRef.RemoveItem(SoulGemPetty)
    EndIf
EndFunction

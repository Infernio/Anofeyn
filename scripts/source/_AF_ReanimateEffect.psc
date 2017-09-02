ScriptName _AF_ReanimateEffect Extends ActiveMagicEffect
{Controls the soul-gem-based reanimation in Anofeyn.}

; Internals
Actor           Property PlayerRef Auto
{The player reference.}
GlobalVariable  Property SettingDifficulty Auto
{The global variable that controls the difficulty setting.}

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

    ; The variable used to track whether or not this resurrection will succeed
    ; Biased against the caster by default
    float successVar = 10

    ; Add in level difference
    ; Higher level enemies are harder to resurrect for a low level necromancer
    successVar += target.GetLevel() - caster.GetLevel()

    ; Add in Conjuration skill
    ; High Conjuration skill makes it easier to bridge that gap
    successVar -= caster.GetActorValue("Conjuration") / 10

    ; Add in the soul gem factor
    ; Better Soul Gems make it easier to resurrect
    successVar -= GetSoulGemFactor(choice, isPlayer)

    If(isPlayer)
        ; Add in the difficulty factor
        ; Higher difficulty levels make it harder to resurrect, lower ones make it easier
        ; Easy = 0, Normal = 1, Hard = 2
        successVar += (SettingDifficulty.GetValue() - 1) * 10

        ; Fresh corpses are much more difficult to reanimate
        If(isFresh)
            ; TODO Should this be player only?
            successVar += 10
        EndIf
    EndIf

    ; Check if we managed to overcome the bias
    If(successVar <= 0)
        DoResurrection(caster, target, choice)
        If(isPlayer && isFresh)
            target.RemoveSpell(RecentlyDeceasedSpell)
            PlayerRef.AddSpell(RecentlyDeceasedDebuffSpell)
        EndIf
    Else
        If(isPlayer)
            MessageUnsuccessfulResurrection.Show()
        EndIf
    EndIf
EndFunction

int Function GetSoulGemFactor(int choice, bool isPlayer)
    If(!isPlayer)
        ; Assume enemies always use Greater Soul Gems
        return 10
    EndIf

    If(choice == 1)
        ; Black - Very Significant Bonus
        return 25
    ElseIf(choice == 2)
        ; Grand - Significant Bonus
        return 20
    ElseIf(choice == 3)
        ; Greater - Decent Bonus
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
    Else
        ; None - Massive Debuff
        return -20
    EndIf
EndFunction

Function DoResurrection(Actor caster, Actor target, int choice)
    ; Actually reanimate the target
    If(choice != -1)
        RemoveSoulGem(choice)
    EndIf
    ReanimationSpell.Cast(caster, target)
EndFunction

Function RemoveSoulGem(int choice)
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

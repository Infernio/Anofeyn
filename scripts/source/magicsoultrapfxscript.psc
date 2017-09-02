ScriptName magicSoulTrapFXScript extends ActiveMagicEffect
{Scripted effect for the Soul Trap Visual FX}

;======================================================================================;
;   PROPERTIES  /
;=============/
ImageSpaceModifier  Property TrapImod auto
{IsMod applied when we trap a soul.
Set automatically if it is not filled.}
Sound               Property TrapSoundFX auto ; Create a sound property we'll point to in the editor
{Sound played when we trap a soul.
Set automatically if it is not filled.}
VisualEffect        Property TargetVFX auto
{Visual Effect on Target aiming at Caster.
Set automatically if it is not filled.}
VisualEffect        Property CasterVFX auto
{Visual Effect on Caster aiming at Target.
Set automatically if it is not filled.}
EffectShader        Property CasterFXS auto
{Effect Shader on Caster during Soul trap.
Set automatically if it is not filled.}
EffectShader        Property TargetFXS auto
{Effect Shader on Target during Soul trap.
Set automatically if it is not filled.}
bool                Property bIsEnchantmentEffect = false auto
{Set this to true if this soul trap is on a weapon enchantment or a spell that can do damage to deal with a fringe case.
Defaults to false.}

;======================================================================================;
;   VARIABLES   /
;=============/
; The actor that this soul trap instance has been cast on.
Actor victim = None
; Whether or not they were already dead.
bool deadAlready = false
; Whether or not to wait for 0.25 seconds While processing.
; Used to combat out-of-order execution of a soul trap effect that immediately ends (i.e. enchantments).
bool useWait = true

;======================================================================================;
; ASGM PROPERTIES   /
;=================/
ASGThreadLock       Property ASGMThreadLockHandler Auto
{Handles thread locking so only one Soul Trap occurs at a time.
Set automatically if it is not filled.}
ObjectReference     Property ASGMGemHolderRef Auto
{The container that will store soul gems temporarily for the player.
Set automatically if it is not filled.}
GlobalVariable      Property SettingSilenceSuccess Auto
{The global variable that controls whether or not to print messages on capture success.
Set automatically if it is not filled.}
GlobalVariable      Property SettingSilenceFail Auto
{The global variable that controls whether or not to print messages on capture failure.
Set automatically if it is not filled.}
GlobalVariable      Property SettingAzuraOnlyFull Auto
{The global variable that controls whether or not Azura's Star / The Black Star may house smaller souls.
Set automatically if it is not filled.}
GlobalVariable      Property SettingOnlyBlackSouls Auto
{The global variable that controls whether or not black soul gems may only house black souls.
Set automatically if it is not filled.}
Keyword             Property ActorTypeNPC Auto
{The ActorTypeNPC keyword.
Set automatically if it is not filled.}
SoulGem             Property SoulGemLesser Auto
{The lesser soul gem item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemCommon Auto
{The common soul gem item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemGreater Auto
{The greater soul gem item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemGrand Auto
{The grand soul gem item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemBlack Auto
{The black soul gem item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemAzurasStar Auto
{The Azura's Star item type.
Set automatically if it is not filled.}
SoulGem             Property SoulGemBlackStar Auto
{The Black Star item type.
Set automatically if it is not filled.}

;======================================================================================;
; ASGM VARIABLES    /
;=================/
; The ASGM version that is currently used.
string ASGMVersion = "4.5.2"
; The actor value used to make sure that the actor doesn't significantly change during soul trapping.
string storageAV = "BrainCondition"

;======================================================================================;
; Anofeyn PROPERTIES    /
;=====================/
_AF_Compatibility   Property CompatibilityScript Auto
{The Anofeyn compatibility script.
Set automatically if it is not filled.}

;======================================================================================;
;   EVENTS      /
;=============/

Event OnEffectStart(Actor target, Actor Caster)
    ;Debug.Trace("ASGSoulTrap - Beginning Effect")
    ; Check all properties and fill the ones that haven't been filled
    CheckProperties()

    ; Remember our target
    victim = target

    If(!bIsEnchantmentEffect)
        deadAlready = victim.IsDead()
    EndIf
    useWait = False
    If(!victim.isDead() && victim.getActorValue(storageAV) == 8675309)
        victim.setActorValue(storageAV, 100)
    EndIf
    ;Debug.Trace("Is Soultrap target dead? (" + deadAlready + ")(" + victim + ")")
endEvent

Event OnEffectFinish(Actor target, Actor caster)
    ;Debug.Trace("ASGSoulTrap v" + ASGMVersion + " - Ending Effect")
    ;Debug.Trace(self + " is finishing")

    ; Acquire the lock
    If(ASGMThreadLockHandler != None)
        ;Debug.Trace("ASGSoulTrap - Acquiring Lock")
        While(!ASGMThreadLockHandler.AcquireLock(caster))
            ; TODO Maybe make this configurable
            utility.wait(0.1)
            ;Debug.Trace("USKP testMessage: magicSoulTrapFXScript Looping (waiting for permission)....")
        EndWhile
        ;Debug.Trace("ASGSoulTrap - Lock Acquired")
    EndIf

    If(victim)
        If(useWait)
            Utility.Wait(0.25)
        EndIf

        ;Debug.Trace("ASGSoulTrap - storage AV: " + victim.getActorValue(storageAV))
        If(!deadAlready && victim.isDead() && victim.getActorValue(storageAV) != 8675309)
            ;Debug.Trace("ASGSoulTrap - storage AV is good, proceeding")
            ; Count the gems
            int numAzurasStar = caster.GetItemCount(SoulGemAzurasStar)
            int numBlackStar = caster.GetItemCount(SoulGemBlackStar)
            int numBlack = 0
            int numCommon = 0
            int numGrand = 0
            int numGreater = 0
            int numLesser = 0

            ; Perform soul size checks
            int targetLevel = victim.GetLevel()
            ;Debug.Trace("ASGSoulTrap - Performing Gem checks")
            string soulType = "Black"
            If(!victim.HasKeyword(ActorTypeNPC))
                If(SettingOnlyBlackSouls.GetValue() == 1)
                    caster.RemoveItem(SoulGemBlackStar, numBlackStar, true, ASGMGemHolderRef)
                    numBlack = caster.GetItemCount(SoulGemBlack)
                    caster.RemoveItem(SoulGemBlack, numBlack, true)
                EndIf
                soulType = "Grand"
                If(targetLevel < Game.GetGameSettingInt("iGrandSoulActorLevel"))
                    numBlack = numBlack + caster.GetItemCount(SoulGemBlack)
                    caster.RemoveItem(SoulGemBlack, numBlack, true)
                    numGrand = caster.GetItemCount(SoulGemGrand)
                    caster.RemoveItem(SoulGemGrand, numGrand, true)
                    If(SettingAzuraOnlyFull.GetValue() == 1)
                        caster.RemoveItem(SoulGemBlackStar, numBlackStar, true, ASGMGemHolderRef)
                        caster.RemoveItem(SoulGemAzurasStar, numAzurasStar, true, ASGMGemHolderRef)
                    EndIf
                    soulType = "Greater"
                EndIf
                If(targetLevel < Game.GetGameSettingInt("iGreaterSoulActorLevel"))
                    numGreater = caster.GetItemCount(SoulGemGreater)
                    caster.RemoveItem(SoulGemGreater, numGreater, true)
                    soulType = "Common"
                EndIf
                If(targetLevel < Game.GetGameSettingInt("iCommonSoulActorLevel"))
                    numCommon = caster.GetItemCount(SoulGemCommon)
                    caster.RemoveItem(SoulGemCommon, numCommon, true)
                    soulType = "Lesser"
                EndIf
                If(targetLevel < Game.GetGameSettingInt("iLesserSoulActorLevel"))
                    numLesser = caster.GetItemCount(SoulGemLesser)
                    caster.RemoveItem(SoulGemLesser, numLesser, true)
                    soulType = "Petty"
                EndIf
            EndIf

            ; Capture soul
            ;Debug.Trace("ASGSoulTrap - Trapping soul")
            bool result = caster.TrapSoul(victim)
            victim.SetActorValue(storageAV, 8675309)

            ; Return all gems
            ;Debug.Trace("ASGSoulTrap - Returning Gems")
            ASGMGemHolderRef.RemoveItem(SoulGemBlackStar, numBlackStar, true, caster)
            ASGMGemHolderRef.RemoveItem(SoulGemAzurasStar, numAzurasStar, true, caster)
            caster.AddItem(SoulGemBlack, numBlack, true)
            caster.AddItem(SoulGemGrand, numGrand, true)
            caster.AddItem(SoulGemGreater, numGreater, true)
            caster.AddItem(SoulGemCommon, numCommon, true)
            caster.AddItem(SoulGemLesser, numLesser, true)

            ; Custom message
            ;Debug.Trace("ASGSoulTrap - Vanilla handling started")
            If(result)
                ; Vanilla: "You have captured a soul!"
                If(SettingSilenceSuccess.GetValue() == 0)
                    If(CompatibilityScript.SKSELoaded)
                        ; SKSE is available - use translated version
                        Debug.Notification("$ASGCaptured" + soulType)
                    Else
                        ; SKSE not available - use English version
                        Debug.Notification(soulType + " soul captured!")
                    EndIf
                EndIf

                ;Debug.Trace(victim + " is, in fact, dead. Play soul trap visFX")

                ; play TrapSoundFX sound from player
                TrapSoundFX.play(caster)

                ; apply isMod at full strength
                TrapImod.apply()

                ; Play TargetVFX and aim them at the player
                TargetVFX.Play(victim, 4.7, caster)
                CasterVFX.Play(caster, 5.9, victim)

                ; Play Effect Shaders
                TargetFXS.Play(victim, 2)
                CasterFXS.Play(caster, 3)
            Else
                ;Debug.Trace(victim + " is, in fact, dead, But the TrapSoul check failed or came back false")

                ; Vanilla: "There is no Soul Gem large enough to capture the soul."
                If(SettingSilenceFail.GetValue() == 0)
                    If(CompatibilityScript.SKSELoaded)
                        ; SKSE is available - use translated version
                        Debug.Notification("$ASGFailed" + soulType)
                    Else
                        ; SKSE not available - use English version
                        Debug.Notification("Failed to capture " + soulType + " soul.")
                    EndIf
                EndIf
            EndIf
        ;Else
            ;Debug.Trace(self + "tried to soulTrap, but " + victim + " is already Dead.")
        EndIf
    EndIf

    ; Release the lock
    If(ASGMThreadLockHandler != None)
        ;Debug.Trace("ASGSoulTrap - Releasing Lock")
        ASGMThreadLockHandler.ReleaseLock(caster)
        ;Debug.Trace("ASGSoulTrap - Lock Released")
    EndIf
    ;Debug.Trace("ASGSoulTrap - Effect Ended")
EndEvent

Function CheckProperties()
    {Checks all properties in this script and makes sure they are filled.
    Used to automatically guarantee compatibility with third party effects that use this script.}
    ; Vanilla Properties
    If(!TrapImod)
        TrapImod = Game.GetFormFromFile(0x054225, "Skyrim.esm") as ImageSpaceModifier
    EndIf
    If(!TrapSoundFX)
        TrapSoundFX = Game.GetFormFromFile(0x056AC6, "Skyrim.esm") as Sound
    EndIf
    If(!TargetVFX)
        TargetVFX = Game.GetFormFromFile(0x0531AF, "Skyrim.esm") as VisualEffect
    EndIf
    If(!CasterVFX)
        CasterVFX = Game.GetFormFromFile(0x0531B1, "Skyrim.esm") as VisualEffect
    EndIf
    If(!CasterFXS)
        CasterFXS = Game.GetFormFromFile(0x054224, "Skyrim.esm") as EffectShader
    EndIf
    If(!TargetFXS)
        TargetFXS = Game.GetFormFromFile(0x054223, "Skyrim.esm") as EffectShader
    EndIf

    ; ASGM Properties
    If(!ASGMThreadLockHandler)
        ASGMThreadLockHandler = Game.GetFormFromFile(0x0022EE, "Anofeyn.esp") as ASGThreadLock
    EndIf
    If(!ASGMGemHolderRef)
        ASGMGemHolderRef = Game.GetFormFromFile(0x002857, "Anofeyn.esp") as ObjectReference
    EndIf
    If(!SettingSilenceSuccess)
        SettingSilenceSuccess = Game.GetFormFromFile(0x000D65, "Anofeyn.esp") as GlobalVariable
    EndIf
    If(!SettingSilenceFail)
        SettingSilenceFail = Game.GetFormFromFile(0x01500E, "Anofeyn.esp") as GlobalVariable
    EndIf
    If(!SettingAzuraOnlyFull)
        SettingAzuraOnlyFull = Game.GetFormFromFile(0x01F21D, "Anofeyn.esp") as GlobalVariable
    EndIf
    If(!SettingOnlyBlackSouls)
        SettingOnlyBlackSouls = Game.GetFormFromFile(0x01500F, "Anofeyn.esp") as GlobalVariable
    EndIf
    If(!ActorTypeNPC)
        ActorTypeNPC = Game.GetFormFromFile(0x013794, "Skyrim.esm") as Keyword
    EndIf
    If(!SoulGemLesser)
        SoulGemLesser = Game.GetFormFromFile(0x02E4E4, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemCommon)
        SoulGemCommon = Game.GetFormFromFile(0x02E4E6, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemGreater)
        SoulGemGreater = Game.GetFormFromFile(0x02E4F4, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemGrand)
        SoulGemGrand = Game.GetFormFromFile(0x02E4FC, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemBlack)
        SoulGemBlack = Game.GetFormFromFile(0x02E500, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemAzurasStar)
        SoulGemAzurasStar = Game.GetFormFromFile(0x063B27, "Skyrim.esm") as SoulGem
    EndIf
    If(!SoulGemBlackStar)
        SoulGemBlackStar = Game.GetFormFromFile(0x063B29, "Skyrim.esm") as SoulGem
    EndIf

    ; Anofeyn Properties
    If(!CompatibilityScript)
        CompatibilityScript = (Game.GetFormFromFile(0x005902, "Anofeyn.esp") as Quest).GetAlias(0) as _AF_Compatibility
    EndIf
EndFunction

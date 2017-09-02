ScriptName _AF_RecentlyDeceasedDebuff Extends ActiveMagicEffect
{The script used to control the debuff applied to necromancers who reanimate recently deceased corpses.}

; The stored magicka rate
float magickaRate

Event OnEffectStart(Actor akTarget, Actor akCaster)
    magickaRate = akTarget.GetActorValue("MagickaRate")
    akTarget.SetActorValue("MagickaRate", 0.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    akTarget.SetActorValue("MagickaRate", magickaRate)
EndEvent

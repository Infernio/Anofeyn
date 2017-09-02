Scriptname ASGThreadLock extends Quest
{Makes sure only one Soul Trap gets called at a time.
Needed because ASGM removes soul gems from trapper's
inventory while running, so we need to be certain those
gems are put back before we allow another Soul Trap
to occur.}

; An array used to track all active trappers.
Actor[] trappers
; The number of trappers that are currently active.
int activeTrappers = 0

Event OnInit()
    ; Create the array used to track active trappers.
	trappers = new Actor[128]
EndEvent

bool Function AcquireLock(Actor trapper)
    {Determine if trapper has a Soul Trap happening already, and grant lock if not, adding trapper to the array.}
	If(trappers.Find(trapper) >= 0)
		return trapper == None
	Else
		trappers[activeTrappers] = trapper
		activeTrappers += 1
		return true
	EndIf
EndFunction

Function ReleaseLock(Actor trapper)
    {Removes the specified trapper from the array.}
	int lockIndex = trappers.Find(trapper)
	If(lockIndex >= 0)
		trappers[lockIndex] = None
		activeTrappers -= 1
		trappers[lockIndex] = trappers[activeTrappers]
		trappers[activeTrappers] = None
	EndIf
EndFunction

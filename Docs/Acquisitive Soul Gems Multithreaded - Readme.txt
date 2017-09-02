Acquisitive Soul Gems
Multi-Threaded
v. 4.5.1
Author: eyeonus

This mod causes Soul Gems to trap souls of the same size as the gem,
preventing smaller souls from being trapped, such as trapping a Petty
Soul in a Common Soul Gem or a Greater Soul in a Black Soul Gem, etc.

The book "[Settings]ASG Options" allows the easy changing of the following
options, which will also appear in the MCM menu if SkyUI is installed:

OnlyBlack (default:true):
	If set to (true), will force the Black Soul Gems and Black Star to be
	only able to trap Black Souls, otherwise will allow them to trap the same
	souls that Grand Soul Gems and Azura's Star can trap, respectively.

OnlyFull (default:false): 
	If set to (true), will not allow Azura's Star or the Black Star to trap souls
	smaller than Grand. Has no effect on the Black Star if OnlyBlack is true.

SilenceSucces (default:false),
SilenceFail (default:false):
	If set to (true), will turn off in-game notifications of successful or failed
	soul trap attempts, respectiverly.

In the console, if available, "help ASGMSettings" will display the current settings.
They can be changed with "set ASGMSettings to x", where "x" is a number between 0 and 31.

Installation:

Place the contents of the archive in your Skyrim/Data directory.
Works with Nexus Mod Manager and ModOrganizer.

EXTREMELY IMPORTANT:
Make certain that the version of "magicsoultrapfxscript.pex" is the one provided by this mod.

Compatibility:

As long as no other mod overwrites magicSoulTrapFXScript.pex, there will be no compatibility issues.
This mod makes the same fixes to the script as the Unofficial Patch and can overwrite it without issue.

This means it will work with mods like "Perkus Maximus" and "Apocalypse - Magic of Skyrim" WITHOUT needing a patch.

Any mods that also modify the above script will be incompatible unless otherwise noted by that mod's author.

Note on "filled" Soul Gems:
A "Grand Soul Gem" with a Grand Soul trapped in it (ID# 0002E4FC)
is not the same thing as a "Grand Soul Gem (Grand)" (ID# 0002E4FF)
even though they look exactly alike in game. There are mods that will
automagically replace the former with the latter, in part to fix
the Soul Gem dropping bug. I strongly suggest you get one of them.
The Unofficial Patch is a really good one, as it fixes other things as well.

Changelog:
Version 4.5.2:
	Added option to allow removal of book.

Version 4.5.1:
	Added this text to the book.
	Renamed book to sort to top.
	Prevented book from showing in trade menus.
	Prevented crafting book when book exists in inventory.
	Make it more likely book will be given to player on game load.

Version 4.5:
	Added recipe for Options Book so it is craftable if needed. Uses 1 leather strip.
	Changed message silence option to be two settings, one for silencing success messages, and one for silencing fail messages.
	Revamped how settings are stored, now uses one global for all settings rather than one for each.

Version 4.2
	Added Options Menu Book for those without access to the console.
	Minor fixes and optimizations.

Version 4.1.1
	Removed edits to soul gems for mod compatibility.
		No longer fixes soul gem dropping bug. (Unofficial Patch recommended.)
		No longer breaks names from sorting mods.
		Initial release - Skyrim SE (PC/XBone)
Version 4.1
	Fixed Soul Stealer perk not working with mod.
	
Version 4.0.m
	Merged non-SKSE and International forks, SKSE only required for International mode, off by default.
	Fixed Black Soul Gem duplication bug.

Version 3.2.r, 3.2.i.r
	Reupload to fix incorrect linking of Petty Soul Gems.

Version 3.2, 3.2.i
	Fixed soul gem bug regression.

Version 3.1.i
	Language localization support added.
	SKSE required for international version to work correctly! Still not required for standard, English-only version.

Version 3.1
	Fixed bug w/ Black Soul Gems introduced in 3.0, no longer interferes with autolooting mods at all. 

Version 3.0
	Removed mod dependency, no other mods required to be installed for this mod to work correctly.

Version 2.9.1
	Fixed soul gem duplication bug introduced in v.2.9.

Version 2.9
	Updated gem checking to interfere with looting mods less. Glitches will now only occur, if ever, once the player has either Star.

Version 2.8
	Bugfixing: Stop trying to steal souls from the ones that aren't dead yet.

	Initial release - USLEP dependancy update.

Version 2.7

	Bugfixing: (Failed to) Capture spamming, most noticable with soul trap enchanted weapons, fixed.
		Uses unused ActorVariable BrainCondition to make sure soul traps are not performed on soulless victims.

Version 2.6

	Initial release

	No patches required for Apocalypse, PerkusMaximus, etc.

	Uses MCM for configuration. (Not required.)

	Able to capture multiple souls at the same time, unlike ASG v2.5.6

	Upgrade Ordinator if experiencing problems with this and it.
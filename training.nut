/*
	Please don't judge that I use javadoc-like comments, I'm just too used to them and they're very readable and easy on eyes
*/

//The version of the script
const TS_VERSION = 0.1;

/*	
	TODOs

	TODO: Debug messages
	TODO: Add integration with nadetraining.nut
	TODO: Re-add auto-reloading on MOUSE1 release
	TODO: Add trainingHelpExamples()
*/

mTrainingDebug				<- false;

/*
	State variables
	Boolean vars can only be turned on or off(thanks cap!)
	Integer vars can have multiple states. 0 always means its off
*/

mClipBrushes				<- 0;
mImpacts					<- 0;
mInfAmmo					<- 0;
mWeaponTweaks				<- 0;
mHealthweaks				<- 0;
mStartup					<- false;
mWallhack					<- false;
mBunnyhopping				<- false;
mWarmup						<- false;
mGrenadeTrajectory 			<- false;
mMoney						<- false;
mRespawn					<- false;
mDefaultWeapons				<- false;
//v_nadetraining				<- false;

//Weapons available for weapons()
enum WEAPON
{
	NULL,
	AWP,
	AK47,
	M4A4,
	M4A1
}

/*
  Prints general status messages to both the console and the chat
  @param text - the message to print
*/
function printMessage(text)
{
	local prefix = "[Training] ";
	local finalOutput = prefix + text;

	//Print the message to both the console and the chat
	printl(finalOutput);
	ScriptPrintMessageChatAll(finalOutput);
}

/*
  Prints debug messages to console, but only when #mTrainingDebug is true
  @param text - the verbose/debug/error message to print
  @TODO: add different importance levels
  
  P.S. I really hope I'm never gonna need this but who knows ¯\_(ツ)_/¯
*/
function printDebug(text)
{
	//If debugging is turned off, exit
	if(!mTrainingDebug) return;

	//Print the message to console with the prefix
	printl("[TrainingDebug]" + text);
}

/*
  Controls clip brushes
  @param clipType: 0 or any other unsuitable value - turn clip brushes off
 				   1 - turn player clip brushes on
  				   2 - turn grenade clip brushes on
  				   unspecified or -1 - change modes one-by-one in order they're written above
*/
function clipbr(clipType = -1)
{	
	//If #clipType is -1 or unspecified(defaults to -1), then add +1 otherwise use the value specified by the user
	clipType = (clipType == -1) ? mClipBrushes + 1 : clipType;
	
	switch(clipType)
	{
		case 1:
		{
			SendToConsole("r_drawclipbrushes 2");
			mClipBrushes = 1;
			printMessage("Player clip brushes are 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("r_drawclipbrushes 3"); 
			mClipBrushes = 2;
			printMessage("Grenade clip brushes are 'ON'");
			break;
		}
		/*
			If the #clipType is not valid(in case the user specified so or the ternary expression from the above went over 2), 
			then turn the clip brushes off
		*/
		default:
		{
			SendToConsole("r_drawclipbrushes 0"); 
			mClipBrushes = 0;
			printMessage("Clip brushes are 'OFF'");
		}
	}
	
}

/*
  Controls wallhacks(VAC safe, its just a console command lol)
  @param enable: 0 or false - turn off
				 1 or true - turn on
				 unspecified or -1 - toggle
  @TODO: Find a better way to view other player through walls(glowing maybe?)
*/
function wh(enable = -1)
{
	//If #enable is -1 or unspecified(defaults to -1), then toggle otherwise use the value specified by user
	enable = (enable == -1) ? !mWallhack : enable;
	if(enable)
	{
		SendToConsole("r_drawothermodels 2");
		mWallhack = true;
		printMessage("Wallhack is 'ON'");
	}
	else
	{
		SendToConsole("r_drawothermodels 1");
		mWallhack = false;
		printMessage("Wallhack is 'OFF'");
	}
}

/*
  Controls auto bunny hopping
  @param enable: 0 or false - turn off
				 1 or true - turn on
				 unspecified or -1 - toggle
*/
function bhop(enable = -1)
{	
	//If #enable is -1 or unspecified(defaults to -1), then toggle otherwise use the value specified by user
	enable = (enable == -1) ? !mBunnyhopping : enable;
	if(enable)
	{
		SendToConsole("sv_enablebunnyhopping 1");
		SendToConsole("sv_autobunnyhopping 1");
		SendToConsole("sv_clamp_unsafe_velocities 0");
		SendToConsole("sv_airaccelerate 100");
		mBunnyhopping = true;
		printMessage("Bunnyhopping is 'ON'");
	}
	else
	{
		SendToConsole("sv_enablebunnyhopping 0");
		SendToConsole("sv_autobunnyhopping 0");
		SendToConsole("sv_clamp_unsafe_velocities 1");
		SendToConsole("sv_airaccelerate 12");
		mBunnyhopping = false;
		printMessage("Bunnyhopping is 'OFF'");
	}
}

/*
  Controls bullet impacts. Note: modes may be enabled simultaneously
  @param impactsType: 0 or any other unsuitable value - turn all bullet impacts off
 				   	  1 - turn usual bullet impacts on
  				      2 - turn bullet penetration impacts on
  				      unspecified or -1 - change modes one-by-one in order they're written above
*/
function impacts(impactsType = -1)
{
	//If #impactsType is -1 or unspecified(defaults to -1), then add +1 otherwise use the value specified by the user
	impactsType = (impactsType == -1) ? mImpacts + 1 : impactsType;
	
	switch(impactsType)
	{
		case 1:
		{
			SendToConsole("sv_showimpacts 3");
			mImpacts = 1;
			printMessage("Bullet impacts are 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("sv_showimpacts_penetration 1"); 
			mImpacts = 2;
			printMessage("Bullet penetraion impacts are 'ON'");
			break;
		}
		/*
			If the #impactsType is not valid(in case the user specified so or the ternary expression from the above went over 2), 
			then turn the bullet impacts off
		*/
		default:
		{
			SendToConsole("sv_showimpacts 0");
			SendToConsole("sv_showimpacts_penetration 0"); 
			mImpacts = 0;
			printMessage("Bullet impacts are 'OFF'");
		}
	}
}

/*
  Controls warmup
  @param enable: 0 or false - turn off
				 1 or true - turn on
				 unspecified or -1 - toggle
*/
function warmup(enable = -1)
{	
	enable = (enable == -1) ? !ScriptIsWarmupPeriod() : enable;
	if(enable)
	{
		SendToConsole("mp_warmup_start");
		SendToConsole("mp_warmup_pausetimer 1");
		mWarmup = true;
		printMessage("Unlimited warmup is 'ON'")
	}
	else
	{
		SendToConsole("mp_warmup_end");
		//SendToConsole("mp_warmuptime 30");
		SendToConsole("mp_warmup_pausetimer 0");
		mWarmup = false;
		printMessage("Warmup is 'OFF'")

	}
}

/*
  Controls infinite ammo
  @param ammoType: 0 or any other unsuitable value - turn infinite ammo of
 				   1 - turn infinite ammo without reloading on
  				   2 - turn infinite ammo with reloading on
  				   unspecified or -1 - change modes one-by-one in order they're written above
*/
function infAmmo(ammoType = -1)
{		
	//If #ammoType is -1 or unspecified(defaults to -1), then add +1 otherwise use the value specified by the user
	ammoType = (ammoType == -1) ? mInfAmmo + 1 : ammoType;

	switch(ammoType)
	{
		case 1:
		{
		
			SendToConsole("sv_infinite_ammo 1");
			mInfAmmo = 1;
			printMessage("Infinite ammo is 'ON'");
			break;
		}
		case 2:
		{
		
			SendToConsole("sv_infinite_ammo 2");
			mInfAmmo = 2;
			printMessage("Infinite ammo with reloading is 'ON'");
			break;
		}
		/*
			If the #ammoType is not valid(in case the user specified so or 
			the ternary expression from the above went over 3), 
			then turn infinite ammo off
		*/
		default:
		{

			SendToConsole("sv_infinite_ammo 0");
			mInfAmmo = 0;
			printMessage("Infinite ammo is 'OFF'");
		}
	}
}

/*
  Controls grenade trajectories. Note: is shown only on listen server's host
  @param enable: 0 or false - turn off
				 1 or true - turn on
				 unspecified or -1 - toggle
*/
function grenTraj(enable = -1)
{
	enable = (enable == -1) ? !mGrenadeTrajectory : enable;
	
	if(enable)
	{
		SendToConsole("sv_grenade_trajectory 1");
		mGrenadeTrajectory = true;
		printMessage("Grenades trajectories are 'ON'");
	}
	else
	{
		SendToConsole("sv_grenade_trajectory 0");
		mGrenadeTrajectory = false;
		printMessage("Grenades trajectories are 'OFF'");
	}
}

/*
  Tweaks shooting. Note: modes may be enabled simultaneously
  @param wpType: 0 or any other unsuitable value - turn all weapon tweaks off
 				 1 - disable recoil
  				 2 - disable spread
				 3 - disable air inaccuracy
*/
function weaponTweaks(wpType = 0)
{	
	switch(wpType)
	{
		case 1:
		{
			SendToConsole("weapon_recoil_scale 0");
			mWeaponTweaks = 1;
			printMessage("No recoil is 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("weapon_accuracy_nospread 1");
			mWeaponTweaks = 2;
			printMessage("No spread is 'ON'");
			break;
		}
		case 3:
		{
			SendToConsole("weapon_air_spread_scale 0");
			mWeaponTweaks = 3;
			printMessage("No air inaccuracy is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("weapon_recoil_scale 2");
			SendToConsole("weapon_accuracy_nospread 0");
			SendToConsole("weapon_air_spread_scale 1");
			mWeaponTweaks = 0;
			printMessage("All shooting tweaks are 'OFF'");
		}
	}
}

/*
  Tweaks health. Note: modes may be enabled simultaneously
  @param wpType: 0 or any other unsuitable value - turn all health tweaks off
 				 1 - enable regeneration
  				 2 - set health to 10000
*/
function hpTweaks(hpType = 0)
{	
	switch(hpType)
	{
		case 1:
		{
			SendToConsole("sv_regeneration_force_on 1");
			mHealthweaks = 1;
			printMessage("Regeneration is 'ON'");
			break;
		}
		case 2:
		{
			EntFire("player", "addoutput", "health 10000");
			EntFire("player", "addoutput", "max_health 10000");
			mHealthweaks = 3;
			printMessage("10k hp mode is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("sv_regeneration_force_on 0");
			EntFire("player", "addoutput", "health 100");
			EntFire("player", "addoutput", "max_health 100");
			mHealthweaks = 0;
			printMessage("All health tweaks are 'OFF'");
		}
	}
}

/*
  Gives weapons to the listen server's host
  The default set: give P250 + all nades
  @param wpType: empty or unspecified - give the default set
				 "ak47" - give AK47 + the default set
				 "m4a4" - give M4A4 + the default set
				 "m4a1" - give M4A1-S + the default set
				 "awp" - give AWP + the default set

  @TODO: Rework weapon giving system. Replace give command with something else
  @TODO: Give more input options(integers?)
*/
function weapons(wpType = "")
{	
	function giveTheDefaultSet()
	{
		SendToConsole("give weapon_p250");
		SendToConsole("give weapon_hegrenade");
		SendToConsole("give weapon_flashbang");
		SendToConsole("give weapon_smokegrenade");
		SendToConsole("give weapon_molotov");
		SendToConsole("give weapon_decoy");
	}

	local wpTypeEnum;
	if(wpType == "ak47") wpTypeEnum = WEAPON.AK47;
	else if(wpType == "m4a4") wpTypeEnum = WEAPON.M4A4;
	else if(wpType == "m4a1") wpTypeEnum = WEAPON.M4A1;
	else if(wpType == "awp") wpTypeEnum = WEAPON.AWP;
	else wpTypeEnum = WEAPON.NULL;
	
	switch(wpTypeEnum)
	{
		case WEAPON.AK47:
		{
			SendToConsole("give weapon_ak47");
			giveTheDefaultSet();
			break;
		}
		case WEAPON.M4A4:
		{
			SendToConsole("give weapon_m4a1");
			giveTheDefaultSet();
			break;
		}
		case WEAPON.M4A1:
		{
			SendToConsole("give weapon_m4a1_silencer");
			giveTheDefaultSet();
			break;
		}
		case WEAPON.AWP:
		{
			SendToConsole("give weapon_awp");
			giveTheDefaultSet();
			break;
		}
		default:
		{
			giveTheDefaultSet();
		}
	}
}

/*
  Removes all items and weapons except knives from the map
*/
function clearMap()
{
	EntFire("item_*", "kill");
	
	local weaponHandle = null;
	while(Entities.FindByClassname(weaponHandle, "weapon_*") != null)
	{
		weaponHandle = Entities.FindByClassname(weaponHandle, "weapon_*");
		if (weaponHandle.GetClassname() == "weapon_knife") continue;
		weaponHandle.Destroy();
	}
	
	SendToConsole("r_cleardecals");
	SendToConsole("slot3");

	printMessage("The map has been cleared")
}

/*
  Sets maximum amount of money allowed to 50000, sets very long buy time, sets money to the maximum every round and gives 50000$ to the listen server's host
  @param enable: 0 or false - disable
				 1 or true - enable
				 unspecified or -1 - toggle

  @TODO: Give money to every player and not only the host, i.e. replace impulse with a different implementation(EntFire?)
*/
function money(enable = -1)
{		
	enable = (enable == -1) ? !mMoney : enable;

	if(enable)
	{
		SendToConsole("mp_maxmoney 50000");
		SendToConsole("mp_startmoney 50000");
		SendToConsole("mp_afterroundmoney 50000");
		SendToConsole("mp_buytime 999999");
		SendToConsole("impulse 101");
		mMoney = true;
		printMessage("$$$ mode is 'ON'");
	}
	else
	{
		SendToConsole("mp_maxmoney 16000");
		SendToConsole("mp_startmoney 800");
		SendToConsole("mp_afterroundmoney 0");
		SendToConsole("mp_buytime 45");
		mMoney = false;
		printMessage("$$$ mode is 'OFF'");
	}
}

/*
  Makes players respawn on death
  @param enable: 0 or false - disable
				 1 or true - enable
				 unspecified or -1 - toggle
*/
function respawn(enable = -1)
{	
	enable = (enable == -1) ? !mRespawn : enable;

	if(enable)
	{
		SendToConsole("mp_respawn_on_death_ct 1");
		SendToConsole("mp_respawn_on_death_t 1");
		mRespawn = true;
		printMessage("Respawning is 'ON'");
	}
	else
	{
		SendToConsole("mp_respawn_on_death_ct 0");
		SendToConsole("mp_respawn_on_death_t 0");
		mRespawn = false;
		printMessage("Respawning is 'OFF'");
	}
}

/*
  Makes players spawn with AKs on T side and M4s on CT
  @param enable: 0 or false - disable
				 1 or true - enable
				 unspecified or -1 - toggle
*/
function defWeapons(enable = -1)
{	
	enable = (enable == -1)?!mDefaultWeapons:enable;
	if(enable)
	{
		SendToConsole("mp_ct_default_primary weapon_m4a1_silencer");
		SendToConsole("mp_ct_default_secondary weapon_p250");
		SendToConsole("mp_ct_default_grenades \"weapon_flashbang weapon_smokegrenade weapon_molotov weapon_hegrenade\"");
		
		SendToConsole("mp_t_default_primary weapon_ak47");
		SendToConsole("mp_t_default_secondary weapon_p250");
		SendToConsole("mp_t_default_grenades \"weapon_flashbang weapon_smokegrenade weapon_molotov weapon_hegrenade\"");
		
		mDefaultWeapons = true;

		printMessage("Default weapons changed to AK/M4");
	}
	else
	{
		SendToConsole("mp_ct_default_primary \"\"");
		SendToConsole("mp_ct_default_secondary weapon_hkp2000");
		SendToConsole("mp_ct_default_grenades \"\"");
		
		SendToConsole("mp_t_default_primary \"\"");
		SendToConsole("mp_t_default_secondary weapon_glock");
		SendToConsole("mp_t_default_grenades \"\"");
		
		mDefaultWeapons = false;

		printMessage("Default weapons set to the defaults");
	}
}

/*
function nadetr(enable = -1, start_paused = 0)
{
	enable = (enable == -1)?!v_nadetraining:enable;
	if(enable)
	{
		SendToConsole("script_execute nadetraining");
		nadeSetup();
		if(start_paused) nadeIsPaused = 1;
		
		v_nadetraining = true;
	}
	else
	{
		nadeIsPaused = 1;
		EntFire("nadeTimer", "kill");

		v_nadetraining = false;
	}
}
*/

/*
  Sets up all the necessary(from my view) commands
  @param enable: 0 or false - disable
				 1 or true - enable
				 unspecified or -1 - toggle
				 
  @TODO: Change from toggling to enabling only, unless specified otherwise
*/
function trainingStartup(enable = -1)
{	
	enable = (enable == -1) ? !mStartup : enable;
	if(enable)
	{
		SendToConsole("mp_freezetime 1");
		
		SendToConsole("bot_quota_mode normal");
		SendToConsole("bot_quota 0");
		SendToConsole("bot_stop 1");

		SendToConsole("mp_autoteambalance 0");
		SendToConsole("mp_limitteams 0");
		
		SendToConsole("ammo_grenade_limit_total 5");
		SendToConsole("mp_weapons_allow_typecount 9999");
		
		mStartup = true;
	}
	else
	{
		SendToConsole("mp_freezetime 5");
	
		SendToConsole("bot_quota_mode fill");
		SendToConsole("bot_quota 0");
		SendToConsole("bot_stop 0");

		SendToConsole("mp_autoteambalance 1");
		SendToConsole("mp_limitteams 2");
		
		SendToConsole("ammo_grenade_limit_total 3");
		SendToConsole("mp_weapons_allow_typecount 5");		

		mStartup = false;
	}
}

/*
  Sets up all the commands one may want to enable on a usual training
  @param enable: 0 or false - disable
				 1, true or unspecified - enable
*/
function trainingAutoSetup(enable = true)
{	
	if(enable)
	{
		trainingStartup(true);
		bhop(true);
		grenTraj(true);
		infAmmo(2);
		warmup(false);
		money(true);
		respawn(true);
		impacts(1);
		defWeapons(true);

		SendToConsole("mp_ignore_round_win_conditions 1")
	}
	else
	{
		SendToConsole("mp_ignore_round_win_conditions 0")
	}
}

/*
  Shows help message
*/
function trainingHelp()
{
	printl("\n\n");
	printl("[TS] training.nut");
	printl("[TS] Automated Training Script");
	printl("[TS] by Gray");
	printl("------------------------------------------------------------");
	printl("[TS] To view all available commands type");
	printl("[TS]    script trainingHelpCommands()");
	printl("[TS] To view examples of using the script type");
	printl("[TS]    script trainingHelpExamples()");
	printl("[TS] To view this message again type");
	printl("[TS]    script trainingHelp()");
	printl("[TS] To reset the script and bring everything to normal type");
	printl("[TS]    script trainingReset()");
	printl("------------------------------------------------------------");
	printl("\n\n");
}

/*
  Lists all the available commands
*/
function trainingHelpCommands()
{
	printl("\n");
	printl("[TS] Available commands:");
	printl("[TS]    clipbr() - Show clipbrushes. 0 - disable, 1 - player clip brushes, 2 - grenade clip brushes");
	printl("[TS]    wh() - Enable wallhack. 0 - disable, 1 - enable");
	printl("[TS]    bhop() - Enable autobunnyhopping. 0 - disable, 1 - enable");
	printl("[TS]    impacts() - Show bulletimpacts*. 0 - disable, 1 - bullet impacts, 2 - bullet penetration impacts");
	printl("[TS]    warmup() - Enable infinite warmup. 0 - disable, 1 - enable");
	printl("[TS]    infAmmo() - Enable infinite ammo. 0 - disable, 1 - infammo without reloading, 2 - infammo with reloading");
	printl("[TS]    grenTraj() - Enable client-side grenade trajectories. 0 - disable, 1 - enable");
	printl("[TS]    weaponTweaks() - Enable different shooting tweaks*&. 0 - disable, 1 - norecoil, 2 - nospread, 3 - no air inaccuracy");
	printl("[TS]    hpTweaks() - Enable different health tweaks*&. 0 - disable, 1 - regeneration, 2 - give all players 10000hp");
	printl("[TS]    weapons() - Give different guns*. empty - give pistol and grenades, \"awp\", \"ak47\", \"m4a1\", \"m4a4\" - give the specified weapon + pistol and grenades. Note the quotes!");
	printl("[TS]    clearmap() - Remove all the weapons and items from the map(except knifes)");
	printl("[TS]    money() - Set maxmoney and your money to 50000 + set inlimited(almost) buytime. 0 - disable, 1 - enable");
	printl("[TS]    respawn() - Enable respawning. 0 - disable, 1 - enable");
	printl("[TS]    defWeapons() - Enable spawning with m4/ak + pistols and grenades. 0 - disable, 1 - enable");
	printl("[TS]    trainingStartup() - Change some server commads for easier training(freezetime, bot_stop, limitteams, grenade_limit). 0 - disable, 1 - enable")
	printl("[TS]    trainingAutoSetup() - Enable some important commads from the list above by my choice(trainingStartup, bhop, grenTraj, infAmmo(2), warmup(0), money, respawn, impacts(1), defWeapons) + infinite round. 0 - disable infinite round, 1 - enable")
	printl("[TS]    trainingHelp() - Show help");
	printl("[TS]    trainingHelpCommands() - List all available commads");
	printl("[TS]    trainingHelpExamples() - Show some examples of using the script");
	printl("[TS]    trainingReset() - Reset the script. 1) 0 - don't disable sv_cheats(default), 1 - disable sv_cheats\n                                            2) 0 - disable only enabled commands(default), 1 - force disable everything");
	printl("------------------------------------------------------------");
	printl("[TS] Note: Every script command is beggining with \"script \" prefix. Example:");
	printl("[TS]    script trainingHelp()");
	printl("[TS] Note2: Almost every command can have additional value(function parameter), which specifies what mode to turn on. By default the command circles through all modes. Example:");
	printl("[TS]    script trainingReset(1)");
	printl("[TS] All values are specified above.");
	printl("[TS] For move examples type");
	printl("[TS]    script trainingHelpExamples()");
	printl("[TS] Note3: If the command has \"*\" to the right of its difinition, then its parameters don't confront with each other(they can be enabled simultaneously)");
	printl("[TS] Note4: If the command has \"&\" to the right of its difinition, then you need to specify parameter. The default value turns off the command");
	printl("\n");
}

/*
  Resets everything to the defaults
  @param turnOffCheats: false or unspecified - leave sv_cheats on
						true - disable sv_cheats
  @param force: false or unspecified - disable only those functions that were enabled
				true - turn off every function, even those that weren't enabled
*/
function trainingReset(turnOffCheats = false, force = false)
{
	if(!force)
	{
		if(mBunnyhopping) bhop(0);
		if(mClipBrushes) clipbr(0);
		if(mGrenadeTrajectory) grenTraj(0);
		if(mHealthweaks) hpTweaks(0);
		if(mInfAmmo) infAmmo(0);
		if(mWallhack) wh(0);
		if(mWarmup) warmup(0);
		if(mWeaponTweaks) weaponTweaks(0);
		if(mMoney) money(0);
		if(mRespawn) respawn(0);
		if(mDefaultWeapons) defWeapons(0);

		if(mStartup) trainingStartup(0);
		trainingAutoSetup(0);

		printMessage("The script is reset successfully");
	}
	else
	{
		bhop(0);
		clipbr(0);
		grenTraj(0);
		hpTweaks(0);
		infAmmo(0);
		wh(0);
		warmup(0);
		weaponTweaks(0);
		money(0);
		respawn(0);
		defWeapons(0);
		
		trainingStartup(0);
		trainingAutoSetup(0);

		printMessage("The script is force-reset successfully");
	}
	
	if(turnOffCheats) 
	{
		SendToConsole("sv_cheats 0");
		printMessage("sv_cheats turned off")
	}

	SendToConsole("mp_restartgame 2");
}

//Show the help on script execution
trainingHelp();

//TODO: Enable sv_cheats only when needed
SendToConsole("sv_cheats 1");
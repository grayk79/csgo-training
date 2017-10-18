const TS_VERSION = 0.1;

//TODO: Re-add comments and debug messages
mTrainingDebug				<- false;

mClipBrushes				<- 0;
mImpacts					<- 0;
mInfAmmo					<- 0;
mWeaponTweaks				<- 0;
mHealthweaks				<- 0;
mStartup					<- false;
mInfAmmoMode3Enabled 		<- false;
mWallhack					<- false;
mBunnyhop					<- false;
mWarmup						<- false;
mGrenadeTrajectory 			<- false;
mMoney						<- false;
mRespawn					<- false;
mDefaultWeapons				<- false;
//v_nadetraining				<- false;

enum WEAPON
{
	NULL,
	AWP,
	AK47,
	M4A4,
	M4A1
}

function debugPrint(text)
{
	if(!mTrainingDebug) return;
	printl("[TrainingDebug]" + text);
}

function clipbr(clipType = -1)
{	
	clipType = (clipType == -1)?mClipBrushes +1:clipType;
	switch(clipType)
	{
		case 1:
		{
			SendToConsole("r_drawclipbrushes 2");
			mClipBrushes = 1;
			ScriptPrintMessageChatAll("[Training] Player clip brushes are 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("r_drawclipbrushes 3"); 
			mClipBrushes = 2;
			ScriptPrintMessageChatAll("[Training] Grenade clip brushes are 'ON'");
			break;
		}
		default:
		{
			SendToConsole("r_drawclipbrushes 0"); 
			mClipBrushes = 0;
			ScriptPrintMessageChatAll("[Training] Clip brushes are 'OFF'");
		}
	}
	
}

function wh(enable = -1)
{
	enable = (enable == -1)?!mWallhack:enable;
	if(enable)
	{
		SendToConsole("r_drawothermodels 2");
		mWallhack = true;
		ScriptPrintMessageChatAll("[Training] Wallhack is 'ON'");
	}
	else
		{
		SendToConsole("r_drawothermodels 1");
		mWallhack = false;
		ScriptPrintMessageChatAll("[Training] Wallhack is 'OFF'");
	}
}

function bhop(enable = -1)
{	
	enable = (enable == -1)?!mBunnyhop:enable;
	if(enable)
	{
		SendToConsole("sv_enablebunnyhopping 1");
		SendToConsole("sv_autobunnyhopping 1");
		SendToConsole("sv_clamp_unsafe_velocities 0");
		SendToConsole("sv_airaccelerate 100");
		mBunnyhop = true;
		ScriptPrintMessageChatAll("[Training] Bunnyhopping is 'ON'");
	}
	else
		{
		SendToConsole("sv_enablebunnyhopping 0");
		SendToConsole("sv_autobunnyhopping 0");
		SendToConsole("sv_clamp_unsafe_velocities 1");
		SendToConsole("sv_airaccelerate 12");
		mBunnyhop = false;
		ScriptPrintMessageChatAll("[Training] Bunnyhopping is 'OFF'");
	}
}

function impacts(impactsType = -1)
{
	impactsType = (impactsType == -1)?mImpacts +1:impactsType;
	switch(impactsType)
	{
		case 1:
		{
			SendToConsole("sv_showimpacts 3");
			mImpacts = 1;
			ScriptPrintMessageChatAll("[Training] Bullet impacts are 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("sv_showimpacts_penetration 1"); 
			mImpacts = 2;
			ScriptPrintMessageChatAll("[Training] Bullet penetraion impacts are 'ON'");
			break;
		}
		default:
		{
			SendToConsole("sv_showimpacts 0");
			SendToConsole("sv_showimpacts_penetration 0"); 
			mImpacts = 0;
			ScriptPrintMessageChatAll("[Training] Bullet impacts are 'OFF'");
		}
	}
}

function warmup(enable = -1)
{	
	enable = (enable == -1)?!ScriptIsWarmupPeriod():enable;
	if(enable)
	{
		SendToConsole("mp_warmup_start");
		SendToConsole("mp_warmup_pausetimer 1");
		mWarmup = true;
	}
	else
	{
		SendToConsole("mp_warmup_end");
		SendToConsole("mp_warmuptime 30");
		SendToConsole("mp_warmup_pausetimer 0");
		mWarmup = false;
	}
}

function infAmmo(ammoType = -1)
{		
	ammoType = (ammoType == -1)?mInfAmmo +1:ammoType;
	switch(ammoType)
	{
		case 1:
		{
			if(mInfAmmoMode3Enabled) infAmmoMode3Enabled();
		
			SendToConsole("sv_infinite_ammo 1");
			mInfAmmo = 1;
			ScriptPrintMessageChatAll("[Training] Infinite ammo is 'ON'");
			break;
		}
		case 2:
		{
			if(mInfAmmoMode3Enabled) infAmmoMode3Enabled();
		
			SendToConsole("sv_infinite_ammo 2");
			mInfAmmo = 2;
			ScriptPrintMessageChatAll("[Training] Infinite ammo with reloading is 'ON'");
			break;
		}
		case 3:
		{
			SendToConsole("alias +noreload \"+attack; sv_infinite_ammo 2\"");
			SendToConsole("alias -noreload \"-attack; sv_infinite_ammo 1\""); 
			SendToConsole("bind mouse1 +noreload");
			mInfAmmo = 3;
			mInfAmmoMode3Enabled = true;
			ScriptPrintMessageChatAll("[Training] Infinite ammo without reloading is 'ON'");
			break;
		}
		default:
		{
			if(mInfAmmoMode3Enabled) infAmmoMode3Enabled();

			SendToConsole("sv_infinite_ammo 0");
			mInfAmmo = 0;
			ScriptPrintMessageChatAll("[Training] Infinite ammo is 'OFF'");
		}
	}
	
	function infAmmoMode3Enabled()
	{	
		SendToConsole("bind mouse1 +attack");
		mInfAmmoMode3Enabled = false;
	}
}

function grenTraj(enable = -1)
{
	enable = (enable == -1)?!mGrenadeTrajectory:enable;
	
	if(enable)
	{
		SendToConsole("sv_grenade_trajectory 1");
		mGrenadeTrajectory = true;
		ScriptPrintMessageChatAll("[Training] Grenade trajectory is 'ON'");
	}
	else
	{
		SendToConsole("sv_grenade_trajectory 0");
		mGrenadeTrajectory = false;
		ScriptPrintMessageChatAll("[Training] Grenade trajectory is 'OFF'");
	}
}

function weaponTweaks(wpType = 0)
{	
	switch(wpType)
	{
		case 1:
		{
			SendToConsole("weapon_recoil_scale 0");
			mWeaponTweaks = 1;
			ScriptPrintMessageChatAll("[Training] No recoil is 'ON'");
			break;
		}
		case 2:
		{
			SendToConsole("weapon_accuracy_nospread 1");
			mWeaponTweaks = 2;
			ScriptPrintMessageChatAll("[Training] No spread is 'ON'");
			break;
		}
		case 3:
		{
			SendToConsole("weapon_air_spread_scale 0");
			mWeaponTweaks = 3;
			ScriptPrintMessageChatAll("[Training] No air inaccuracy is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("weapon_recoil_scale 2");
			SendToConsole("weapon_accuracy_nospread 0");
			SendToConsole("weapon_air_spread_scale 1");
			mWeaponTweaks = 0;
			ScriptPrintMessageChatAll("[Training] All shooting tweaks are 'OFF'");
		}
	}
}

function hpTweaks(hpType = 0)
{	
	switch(hpType)
	{
		case 1:
		{
			SendToConsole("sv_regeneration_force_on 1");
			mHealthweaks = 1;
			ScriptPrintMessageChatAll("[Training] Regeneration is 'ON'");
			break;
		}
		case 2:
		{
			EntFire("player", "addoutput", "health 10000");
			EntFire("player", "addoutput", "max_health 10000");
			mHealthweaks = 3;
			ScriptPrintMessageChatAll("[Training] 10k hp mode is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("sv_regeneration_force_on 0");
			EntFire("player", "addoutput", "health 100");
			EntFire("player", "addoutput", "max_health 100");
			mHealthweaks = 0;
			ScriptPrintMessageChatAll("[Training] All health tweaks are 'OFF'");
		}
	}
}

function weapons(wpType = "")
{	
	function give_other_weapons()
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
			give_other_weapons();
			break;
		}
		case WEAPON.M4A4:
		{
			SendToConsole("give weapon_m4a1");
			give_other_weapons();
			break;
		}
		case WEAPON.M4A1:
		{
			SendToConsole("give weapon_m4a1_silencer");
			give_other_weapons();
			break;
		}
		case WEAPON.AWP:
		{
			SendToConsole("give weapon_awp");
			give_other_weapons();
			break;
		}
		default:
		{
			give_other_weapons();
		}
	}
}

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
}

function money(enable = -1)
{		
	enable = (enable == -1)?!mMoney:enable;
	if(enable)
	{
		SendToConsole("mp_maxmoney 50000");
		SendToConsole("mp_startmoney 50000");
		SendToConsole("mp_afterroundmoney 50000");
		SendToConsole("mp_buytime 999999");
		SendToConsole("impulse 101");
		mMoney = true;
	}
	else
	{
		SendToConsole("mp_maxmoney 16000");
		SendToConsole("mp_startmoney 800");
		SendToConsole("mp_afterroundmoney 0");
		SendToConsole("mp_buytime 45");
		mMoney = false;
	}
}

function respawn(enable = -1)
{	
	enable = (enable == -1)?!mRespawn:enable;
	if(enable)
	{
		SendToConsole("mp_respawn_on_death_ct 1");
		SendToConsole("mp_respawn_on_death_t 1");
		mRespawn = true;
	}
	else
	{
		SendToConsole("mp_respawn_on_death_ct 0");
		SendToConsole("mp_respawn_on_death_t 0");
		mRespawn = false;
	}
}

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

//TODO: Change from toggling to enabling only, unless specified otherwise
function trainingStartup(enable = -1)
{	
	enable = (enable == -1)?!mStartup:enable;
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

function trainingHelpCommands()
{
	printl("\n");
	printl("[TS] Available commands:");
	printl("[TS]    clipbr() - Show clipbrushes. 0 - disable, 1 - player clip brushes, 2 - grenade clip brushes");
	printl("[TS]    wh() - Enable wallhack. 0 - disable, 1 - enable");
	printl("[TS]    bhop() - Enable autobunnyhopping. 0 - disable, 1 - enable");
	printl("[TS]    impacts() - Show bulletimpacts*. 0 - disable, 1 - bullet impacts, 2 - bullet penetration impacts");
	printl("[TS]    warmup() - Enable infinite warmup. 0 - disable, 1 - enable");
	printl("[TS]    infAmmo() - Enable infinite ammo. 0 - disable, 1 - infammo without reloading, 2 - infammo with reloading, 3 - infammo with autoreloading on mouse1 release");
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

function trainingReset(turnOffCheats = false, force = false)
{
	if(!force)
	{
		if(mBunnyhop) bhop(0);
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
	}
	
	if(turnOffCheats) SendToConsole("sv_cheats 0");
	SendToConsole("mp_restartgame 2");
}

trainingHelp();
SendToConsole("sv_cheats 1");

//SendToConsole("sv_grenade_trajectory_time 10");
//SendToConsole("sv_grenade_trajectory_thickness 0.6");

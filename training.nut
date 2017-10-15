//Status variables
v_debug					<- false;
////Manually turn this var on to enable debugging. Type
////	"script v_debug = true"
////in console

v_clipbrushes			<- 0;
v_impacts				<- 0;
v_infammo				<- 0;
v_weapontweaks			<- 0;
v_healthweaks			<- 0;
v_startup				<- false;
v_infammo_mode3_enabled <- false;
v_wallhack				<- false;
v_bunnyhop				<- false;
v_warmup				<- false;
v_grenadetrajectory 	<- false;
v_money					<- false;
v_respawn				<- false;
v_defaultweapons		<- false;
v_nadetraining			<- false;

//Enum for giving weapons(weapons() function)
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
	if(!v_debug) return;
	printl("[Tr Debug]" + text);
}


function clipbr(cliptype = -1)
{	//Show player and grenades clip brushes

	debugPrint("v_clipbrushes = " + v_clipbrushes);
	debugPrint("cliptype = " + cliptype);

	
	cliptype = (cliptype == -1)?v_clipbrushes +1:cliptype;
	//If function was called without a parameter, set cliptype to increased v_clipbrushes(current mode)
	//For some reason the "function clipbr(cliptype = v_clipbrushes +1)" isn't working
	switch(cliptype)
	{
		case 1:
		{	//If cliptype == mode 1(player clip brushes)
			SendToConsole("r_drawclipbrushes 2");
			v_clipbrushes = 1;
			ScriptPrintMessageChatAll("[Training] Player clip brushes are 'ON'");
			break;
		}
		case 2:
		{	//If cliptype == mode 2(grenade clip brushes)
			SendToConsole("r_drawclipbrushes 3"); 
			v_clipbrushes = 2;
			ScriptPrintMessageChatAll("[Training] Grenade clip brushes are 'ON'");
			break;
		}
		default:
		{	//Default variant
			SendToConsole("r_drawclipbrushes 0"); 
			v_clipbrushes = 0;
			ScriptPrintMessageChatAll("[Training] Clip brushes are 'OFF'");
		}
	}
	
}

function wh(enable = -1)
{
	debugPrint("v_wallhack = " + v_wallhack);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_wallhack:enable;
	//If function was called without a parameter, set enable to inverted v_wallhack
	if(enable)
	{
		SendToConsole("r_drawothermodels 2");
		v_wallhack = true;
		ScriptPrintMessageChatAll("[Training] Wallhack is 'ON'");
	}
	else
		{
		SendToConsole("r_drawothermodels 1");
		v_wallhack = false;
		ScriptPrintMessageChatAll("[Training] Wallhack is 'OFF'");
	}
}

function bhop(enable = -1)
{
	debugPrint("v_bunnyhop = " + v_bunnyhop);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_bunnyhop:enable;
	if(enable)
	{
		SendToConsole("sv_enablebunnyhopping 1");
		SendToConsole("sv_autobunnyhopping 1");
		SendToConsole("sv_clamp_unsafe_velocities 0");
		SendToConsole("sv_airaccelerate 100");
		v_bunnyhop = true;
		ScriptPrintMessageChatAll("[Training] Bunnyhopping is 'ON'");
	}
	else
		{
		SendToConsole("sv_enablebunnyhopping 0");
		SendToConsole("sv_autobunnyhopping 0");
		SendToConsole("sv_clamp_unsafe_velocities 1");
		SendToConsole("sv_airaccelerate 12");
		v_bunnyhop = false;
		ScriptPrintMessageChatAll("[Training] Bunnyhopping is 'OFF'");
	}
}

function impacts(impactstype = -1)
{	//Bullet impacts
	debugPrint("v_impacts = " + v_impacts);
	debugPrint("impactstype = " + impactstype);
	
	impactstype = (impactstype == -1)?v_impacts +1:impactstype;
	switch(impactstype)
	{
		case 1:
		{	//Bullet impacts
			SendToConsole("sv_showimpacts 3");
			v_impacts = 1;
			ScriptPrintMessageChatAll("[Training] Bullet impacts are 'ON'");
			break;
		}
		case 2:
		{	//Bullet penetraion impacts
			SendToConsole("sv_showimpacts_penetration 1"); 
			v_impacts = 2;
			ScriptPrintMessageChatAll("[Training] Bullet penetraion impacts are 'ON'");
			break;
		}
		default:
		{
			SendToConsole("sv_showimpacts 0");
			SendToConsole("sv_showimpacts_penetration 0"); 
			v_impacts = 0;
			ScriptPrintMessageChatAll("[Training] Bullet impacts are 'OFF'");
		}
	}
}

function warmup(enable = -1)
{
	debugPrint("v_warmup = " + v_warmup);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!ScriptIsWarmupPeriod():enable;
	if(enable)
	{
		SendToConsole("mp_warmup_start");
		SendToConsole("mp_warmup_pausetimer 1");
		v_warmup = true;
	}
	else
	{
		SendToConsole("mp_warmup_end");
		SendToConsole("mp_warmuptime 30");
		SendToConsole("mp_warmup_pausetimer 0");
		v_warmup = false;
	}
}

function infammo(ammotype = -1)
{	
	debugPrint("v_infammo = " + v_infammo);
	debugPrint("v_infammo_mode3_enabled = " + v_infammo_mode3_enabled);
	debugPrint("ammotype = " + ammotype);
	
	ammotype = (ammotype == -1)?v_infammo +1:ammotype;
	switch(ammotype)
	{
		case 1:
		{	//Infinite ammo(sv_infinite_ammo 1)
			if(v_infammo_mode3_enabled) infammo_mode3_enabled();	//Have the mode 3 been enabled, if yes, rebind the mouse1 to +attack
		
			SendToConsole("sv_infinite_ammo 1");
			v_infammo = 1;
			ScriptPrintMessageChatAll("[Training] Infinite ammo is 'ON'");
			break;
		}
		case 2:
		{	//Infinite ammo dm-like(sv_infinite_ammo 2)
			if(v_infammo_mode3_enabled) infammo_mode3_enabled();
		
			SendToConsole("sv_infinite_ammo 2");
			v_infammo = 2;
			ScriptPrintMessageChatAll("[Training] Infinite ammo with reloading is 'ON'");
			break;
		}
		case 3:
		{	//Infinite ammo, which fills up ammo on mouse1 release
			SendToConsole("alias +noreload \"+attack; sv_infinite_ammo 2\"");
			SendToConsole("alias -noreload \"-attack; sv_infinite_ammo 1\""); 
			SendToConsole("bind mouse1 +noreload");
			v_infammo = 3;
			v_infammo_mode3_enabled = true;
			ScriptPrintMessageChatAll("[Training] Infinite ammo without reloading is 'ON'");
			break;
		}
		default:
		{
			if(v_infammo_mode3_enabled) infammo_mode3_enabled();

			SendToConsole("sv_infinite_ammo 0");
			v_infammo = 0;
			ScriptPrintMessageChatAll("[Training] Infinite ammo is 'OFF'");
		}
	}
	
	function infammo_mode3_enabled()
	{
		debugPrint("infammo_mode3_enabled function executed");
	
		SendToConsole("bind mouse1 +attack");
		v_infammo_mode3_enabled = false;
	}
}

function grentraj(enable = -1)
{
	debugPrint("v_grenadetrajectory = " + v_grenadetrajectory);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_grenadetrajectory:enable;
	
	if(enable)
	{
		SendToConsole("sv_grenade_trajectory 1");
		v_grenadetrajectory = true;
		ScriptPrintMessageChatAll("[Training] Grenade trajectory is 'ON'");
	}
	else
	{
		SendToConsole("sv_grenade_trajectory 0");
		v_grenadetrajectory = false;
		ScriptPrintMessageChatAll("[Training] Grenade trajectory is 'OFF'");
	}
}

function weapontweaks(wptype = 0)
{	
	debugPrint("v_weapontweaks = " + v_weapontweaks);	
	
	switch(wptype)
	{
		case 1:
		{	//No recoil
			SendToConsole("weapon_recoil_scale 0");
			v_weapontweaks = 1;
			ScriptPrintMessageChatAll("[Training] No recoil is 'ON'");
			break;
		}
		case 2:
		{	//No spread
			SendToConsole("weapon_accuracy_nospread 1");
			v_weapontweaks = 2;
			ScriptPrintMessageChatAll("[Training] No spread is 'ON'");
			break;
		}
		case 3:
		{	//No air inaccuracy
			SendToConsole("weapon_air_spread_scale 0");
			v_weapontweaks = 3;
			ScriptPrintMessageChatAll("[Training] No air inaccuracy is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("weapon_recoil_scale 2");
			SendToConsole("weapon_accuracy_nospread 0");
			SendToConsole("weapon_air_spread_scale 1");
			v_weapontweaks = 0;
			ScriptPrintMessageChatAll("[Training] All shooting tweaks are 'OFF'");
		}
	}
}

function hptweaks(hptype = 0)
{	
	debugPrint("v_healthweaks = " + v_healthweaks);	
	
	switch(hptype)
	{
		case 1:
		{	//Regeneration
			SendToConsole("sv_regeneration_force_on 1");
			v_healthweaks = 1;
			ScriptPrintMessageChatAll("[Training] Regeneration is 'ON'");
			break;
		}
		case 2:
		{	//10k hp
			EntFire("player", "addoutput", "health 10000");
			EntFire("player", "addoutput", "max_health 10000");
			v_healthweaks = 3;
			ScriptPrintMessageChatAll("[Training] 10k hp mode is 'ON'");
			break;
		}
		default:
		{
			SendToConsole("sv_regeneration_force_on 0");
			EntFire("player", "addoutput", "health 100");
			EntFire("player", "addoutput", "max_health 100");
			v_healthweaks = 0;
			ScriptPrintMessageChatAll("[Training] All health tweaks are 'OFF'");
		}
	}
}

function weapons(wptype_string = "")
{	
	function give_other_weapons()
	{
		SendToConsole("give weapon_p250");
		SendToConsole("give weapon_hegrenade");
		SendToConsole("give weapon_flashbang");
		SendToConsole("give weapon_smokegrenade");
		SendToConsole("give weapon_molotov");
		SendToConsole("give weapon_decoy");
		debugPrint("Given a p250 + nades");
	}

	local wptype_enum;
	if(wptype_string == "ak47") wptype_enum = WEAPON.AK47;
	else if(wptype_string == "m4a4") wptype_enum = WEAPON.M4A4;
	else if(wptype_string == "m4a1") wptype_enum = WEAPON.M4A1;
	else if(wptype_string == "awp") wptype_enum = WEAPON.AWP;
	else wptype_enum = WEAPON.NULL;
	
	switch(wptype_enum)
	{
		case WEAPON.AK47:
		{
			SendToConsole("give weapon_ak47");
			debugPrint("Given an ak47");
			give_other_weapons();
			break;
		}
		case WEAPON.M4A4:
		{
			SendToConsole("give weapon_m4a1");
			debugPrint("Given a m4a4");
			give_other_weapons();
			break;
		}
		case WEAPON.M4A1:
		{
			SendToConsole("give weapon_m4a1_silencer");
			debugPrint("Given a m4a1-s");
			give_other_weapons();
			break;
		}
		case WEAPON.AWP:
		{
			SendToConsole("give weapon_awp");
			debugPrint("Given an awp");
			give_other_weapons();
			break;
		}
		default:
		{
			give_other_weapons();
		}
	}
}

function clearmap()
{
	EntFire("item_*", "kill");
	
	local weapon_handle = null;
	while(Entities.FindByClassname(weapon_handle, "weapon_*") != null)
	{
		weapon_handle = Entities.FindByClassname(weapon_handle, "weapon_*");
		if (weapon_handle.GetClassname() == "weapon_knife") continue;
		weapon_handle.Destroy();
	}
	
	SendToConsole("r_cleardecals");
	SendToConsole("slot3");
}

function money(enable = -1)
{	
	debugPrint("v_money = " + v_money);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_money:enable;
	if(enable)
	{
		SendToConsole("mp_maxmoney 50000");
		SendToConsole("mp_startmoney 50000");
		SendToConsole("mp_afterroundmoney 50000");
		SendToConsole("mp_buytime 999999");
		SendToConsole("impulse 101");
		v_money = true;
	}
	else
	{
		SendToConsole("mp_maxmoney 16000");
		SendToConsole("mp_startmoney 800");
		SendToConsole("mp_afterroundmoney 0");
		SendToConsole("mp_buytime 45");
		v_money = false;
	}
}

function respawn(enable = -1)
{
	debugPrint("v_respawn = " + v_respawn);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_respawn:enable;
	if(enable)
	{
		SendToConsole("mp_respawn_on_death_ct 1");
		SendToConsole("mp_respawn_on_death_t 1");
		v_respawn = true;
	}
	else
	{
		SendToConsole("mp_respawn_on_death_ct 0");
		SendToConsole("mp_respawn_on_death_t 0");
		v_respawn = false;
	}
}

function defweapons(enable = -1)
{
	debugPrint("v_defaultweapons = " + v_defaultweapons);
	debugPrint("enable = " + enable);
	
	enable = (enable == -1)?!v_defaultweapons:enable;
	if(enable)
	{
		SendToConsole("mp_ct_default_primary weapon_m4a1_silencer");
		SendToConsole("mp_ct_default_secondary weapon_p250");
		SendToConsole("mp_ct_default_grenades \"weapon_flashbang weapon_smokegrenade weapon_molotov weapon_hegrenade\"");
		
		SendToConsole("mp_t_default_primary weapon_ak47");
		SendToConsole("mp_t_default_secondary weapon_p250");
		SendToConsole("mp_t_default_grenades \"weapon_flashbang weapon_smokegrenade weapon_molotov weapon_hegrenade\"");
		
		v_defaultweapons = true;
	}
	else
	{
		SendToConsole("mp_ct_default_primary \"\"");
		SendToConsole("mp_ct_default_secondary weapon_hkp2000");
		SendToConsole("mp_ct_default_grenades \"\"");
		
		SendToConsole("mp_t_default_primary \"\"");
		SendToConsole("mp_t_default_secondary weapon_glock");
		SendToConsole("mp_t_default_grenades \"\"");
		
		v_defaultweapons = false;
	}
}

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

function trainingStartup(enable = -1)
{	
	if(v_debug)
	{
		printl("[Debug] v_startup = " + v_startup);
		printl("[Debug] enable = " + enable);
	}
	
	enable = (enable == -1)?!v_startup:enable;
	//If function was called without a parameter, set enable to inverted v_startup
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
		
		v_startup = true;
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

		v_startup = false;
	}
}

function trainingAutoSetup(enable = true)
{
	if(v_debug)
	{
		printl("[Debug] enable = " + enable);
	}
	
	if(enable)
	{
		trainingStartup(true);
		bhop(true);
		grentraj(true);
		infammo(2);
		warmup(false);
		money(true);
		respawn(true);
		impacts(1);
		defweapons(true);

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
	printl("[TS] Automated Training Script v2.0");
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
	printl("[TS]    infammo() - Enable infinite ammo. 0 - disable, 1 - infammo without reloading, 2 - infammo with reloading, 3 - infammo with autoreloading on mouse1 release");
	printl("[TS]    grentraj() - Enable client-side grenade trajectories. 0 - disable, 1 - enable");
	printl("[TS]    weapontweaks() - Enable different shooting tweaks*&. 0 - disable, 1 - norecoil, 2 - nospread, 3 - no air inaccuracy");
	printl("[TS]    hptweaks() - Enable different health tweaks*&. 0 - disable, 1 - regeneration, 2 - give all players 10000hp");
	printl("[TS]    weapons() - Give different guns*. empty - give pistol and grenades, \"awp\", \"ak47\", \"m4a1\", \"m4a4\" - give the specified weapon + pistol and grenades. Note the quotes!");
	printl("[TS]    clearmap() - Remove all the weapons and items from the map(except knifes)");
	printl("[TS]    money() - Set maxmoney and your money to 50000 + set inlimited(almost) buytime. 0 - disable, 1 - enable");
	printl("[TS]    respawn() - Enable respawning. 0 - disable, 1 - enable");
	printl("[TS]    defweapons() - Enable spawning with m4/ak + pistols and grenades. 0 - disable, 1 - enable");
	printl("[TS]    trainingStartup() - Change some server commads for easier training(freezetime, bot_stop, limitteams, grenade_limit). 0 - disable, 1 - enable")
	printl("[TS]    trainingAutoSetup() - Enable some important commads from the list above by my choice(trainingStartup, bhop, grentraj, infammo(2), warmup(0), money, respawn, impacts(1), defweapons) + infinite round. 0 - disable infinite round, 1 - enable")
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

function trainingReset(turn_off_cheats = false, force = false)
{
	if(!force)
	{
		if(v_bunnyhop) bhop(0);
		if(v_clipbrushes) clipbr(0);
		if(v_grenadetrajectory) grentraj(0);
		if(v_healthweaks) hptweaks(0);
		if(v_infammo) infammo(0);
		if(v_wallhack) wh(0);
		if(v_warmup) warmup(0);
		if(v_weapontweaks) weapontweaks(0);
		if(v_money) money(0);
		if(v_respawn) respawn(0);
		if(v_defaultweapons) defweapons(0);

		if(v_startup) trainingStartup(0);
		trainingAutoSetup(0);
	}
	else
	{
		bhop(0);
		clipbr(0);
		grentraj(0);
		hptweaks(0);
		infammo(0);
		wh(0);
		warmup(0);
		weapontweaks(0);
		money(0);
		respawn(0);
		defweapons(0);
		
		trainingStartup(0);
		trainingAutoSetup(0);
	}
	
	if(turn_off_cheats) SendToConsole("sv_cheats 0");
	SendToConsole("mp_restartgame 2");
}

//First setup
trainingHelp();
SendToConsole("sv_cheats 1");

SendToConsole("sv_grenade_trajectory_time 10");
SendToConsole("sv_grenade_trajectory_thickness 0.6");

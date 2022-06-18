
#include	<YSI_Coding\y_hooks>
#include 	<YSI_Coding\y_timers>

#define     MAX_FTBEE                (4)

static FTbeeTake[MAX_PLAYERS];

static FTbeePs[MAX_PLAYERS];

//new ftgActorbeeing;
/*
new const itemData[][ITEM_NAME_DATA] = {
	{ "ชุดกันผึ้ง" }
};*/

new gActorBee;
new gActorBee2;

enum FTBEE_DATA
{
    FTbeeID,
    Float: FTbeePosX,
	Float: FTbeePosY,
	Float: FTbeePosZ,
	Float: FTbeePosA,
    Text3D: FTbee3D,
    FTbeePickup
};
new const FTbeeData[MAX_FTBEE][FTBEE_DATA] =
{
	{ 0, -1105.2062,-1085.3644,129.2188,340.0258, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 1, -1144.5228,-1073.2537,129.2188,72.1466, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 2, -1155.4227,-1082.2085,129.2188,122.9071, Text3D: INVALID_3DTEXT_ID, -1 },
	{ 3, -1058.4817,-1090.9679,129.2188,257.0150, Text3D: INVALID_3DTEXT_ID, -1 }
	
};

hook OnPlayerConnect(playerid)
{
    FTbeeTake[playerid] = 0;
    
    FTbeePs[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (FTbeeTake[playerid] != 0)
    {
		StopProgress(playerid);
    }
    
    if (FTbeePs[playerid] != 0)
    {
		StopProgress(playerid);
    }
    
    return 1;
}

hook OnGameModeInit()
{
    for(new i = 0; i < sizeof(FTbeeData); i++)
	{
        FTbeeData[i][FTbeePickup] = CreateDynamicPickup(1239, 23, FTbeeData[i][FTbeePosX], FTbeeData[i][FTbeePosY], FTbeeData[i][FTbeePosZ]);
		FTbeeData[i][FTbee3D] = CreateDynamic3DTextLabel("[JOB: Bee]:{FFFFFF}[ {FFFF00}N{FFFFFF} ]", COLOR_GREEN, FTbeeData[i][FTbeePosX], FTbeeData[i][FTbeePosY], FTbeeData[i][FTbeePosZ], 5.0);
	}
	
	CreateDynamic3DTextLabel("{FF6347}[ขายรังผึ้ง]\n[ N ]", COLOR_GREEN, 682.2521,-1679.9305,3.1499+1.0,  5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	gActorBee = CreateActor(4 ,1136.6976,-1453.5757,15.7969,90);
	
	CreateDynamic3DTextLabel("{FF6347}[แพ็ครังผึ้ง]\n[ N ]", COLOR_GREEN, -1183.9771,-1142.5985,129.2188,  5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

    CreateDynamic3DTextLabel("{FF6347}[สกัดรังผึ้ง]\n[ N ]", COLOR_GREEN, 753.5330,-1357.0560,13.5000+1,  5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
    gActorBee2 = CreateActor(5 ,752.5215,-1358.5088,13.5000,353.3763);
    
    //ON_LOOKERS	panic_shout
    ApplyActorAnimation(gActorBee, "ON_LOOKERS", "panic_shout", 4.1, 0, 0, 0, 0, 1); // ตะโกน ตื่นตระหนก
    ApplyActorAnimation(gActorBee2, "BD_FIRE", "M_SMKLEAN_LOOP", 4.1, 0, 0, 0, 0, 1); // พิงกำแพง
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid))
	{
		for(new i = 0; i < sizeof(FTbeeData); i++)
		{
		    if (IsPlayerInRangeOfPoint(playerid, 2.5, FTbeeData[i][FTbeePosX], FTbeeData[i][FTbeePosY], FTbeeData[i][FTbeePosZ]))
		    {
		        	if (FTbeeTake[playerid] == 1)
	                    return SendClientMessage(playerid, COLOR_YELLOW, "[นายแอปเปิ้ล] {FFFFFF}ไม่ใช้ชุดกันผึ้ง ก็ระวังผึ้งต่อยนะจ้ะ กำลังเก็บอยู่");

					SetPlayerPos(playerid, FTbeeData[i][FTbeePosX], FTbeeData[i][FTbeePosY], FTbeeData[i][FTbeePosZ]);
					SetPlayerFacingAngle(playerid, FTbeeData[i][FTbeePosA]);

                    new strees = random(3);
					playerData[playerid][pStress] -= strees;
					//SetPlayerAttachedObject(playerid, 0, 18632, 6, 0.079376, 0.037070, 0.007706, 181.482910, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
					new rand = randomEx(50, 200);
	                StartProgress(playerid, rand, 0, INVALID_OBJECT_ID);
		        	FTbeeTake[playerid] = 1;
		        	SendClientMessage(playerid, COLOR_YELLOW, "[นายแอปเปิ้ล] {FFFFFF}คุณกำลังพยายามเก็บรังผึ้ง");

		        	break;
	    	}
		}
		if (IsPlayerInRangeOfPoint(playerid, 2.0, -1183.9771,-1142.5985,129.2188))
  		{
  		    if (Inventory_Count(playerid, "รังผึ้ง") < 2)
		 		return SCM(playerid, COLOR_RED, "รังผี้ง < 2");

  		    new rand = randomEx(1, 100);
        	StartProgress(playerid, rand, 0, INVALID_OBJECT_ID);
        	
        	FTbeePs[playerid] = 1;
  		    Inventory_Remove(playerid, "รังผึ้ง", 2);
        }
		
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 682.2521,-1679.9305,3.1499))
        {
            Dialog_Show(playerid, DIALOG_SELLBEE, DIALOG_STYLE_MSGBOX, "[รายการรับซื้อ]", "\
				ชื่อรายการ\tราคา\n\
				แพ็ครังผึ้ง\t{00FF00}$%d\n\
				", "ขาย", "ออก", FutureCash[26]);
        }
        
        if (IsPlayerInRangeOfPoint(playerid, 2.0, 753.5330,-1357.0560,13.5000))
        {
            Dialog_Show(playerid, DIALOG_PSBEE, DIALOG_STYLE_MSGBOX, "[การสกัด]", "\
				รายการ\tการได้รับ\n\
				น้ำผึ้ง\t{00FF00}Random\n\
				", "สกัด", "ออก");
        }
	}
	if (newkeys & KEY_CTRL_BACK && !IsPlayerInAnyVehicle(playerid))
	{
 		StopProgress(playerid);
	}
	return 1;
}

Dialog:DIALOG_SELLBEE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    
			    new ammo = Inventory_Count(playerid, "แพ็ครังผึ้ง");
			    new price = ammo*FutureCash[26];

			    if (ammo <= 0)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีแพ็ครังผึ้งอยู่ในตัวเลย");

		        GivePlayerMoneyEx(playerid, price);
		        SendClientMessageEx(playerid, COLOR_GREEN, "[ร้านค้า] {FFFFFF}คุณได้รับเงินจำนวน {00FF00}%s {FFFFFF}จากการขาย แพ็ครังผึ้ง {00FF00}%d {FFFFFF}แพ็ค", FormatMoney(price), ammo);
				Inventory_Remove(playerid, "แพ็ครังผึ้ง", ammo);
	
	}
	return 1;
}

Dialog:DIALOG_PSBEE(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    
				new ammo2 = randomEx(1, 4);

			    if (Inventory_Count(playerid, "แพ็ครังผึ้ง") < 1)
			        return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณไม่มีแพ็ครังผึ้งอยู่ในตัวเลย");
		        
				Inventory_Remove(playerid, "แพ็ครังผึ้ง", 1);
				Inventory_Add(playerid, "น้ำผึ้ง", ammo2);
				SendClientMessageEx(playerid, COLOR_RED, "[สกัดแพ็ครังผึ้ง] {FFFFFF} น้ำผึ้ง -1");
				SendClientMessageEx(playerid, COLOR_GREEN, "[สกัดแพ็ครังผึ้ง] {FFFFFF} น้ำผึ้ง +%d", ammo2);
		
	}
	return 1;
}

FTPlayerbeeUnfreeze(playerid)
{
	FTbeeTake[playerid] = 0;
	
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 0);
	RemovePlayerAttachedObject(playerid, 1);
	RemovePlayerAttachedObject(playerid, 2);
	RemovePlayerAttachedObject(playerid, 3);
	RemovePlayerAttachedObject(playerid, 4);
	RemovePlayerAttachedObject(playerid, 5);
	RemovePlayerAttachedObject(playerid, 6);
 	TogglePlayerControllable(playerid, 1);
  	ClearAnimations(playerid);
  	
    new Float:hp;
   	new string[10];
	new exprand = randomEx(10, 20);
	new rand = randomEx(1, 50);
	new ranbee = randomEx(1, 5);
	new rand2 = randomEx(1, 12);
	new ranhp = randomEx(2, 22);
	GetPlayerHealth(playerid, hp);
	
	if (Inventory_Count(playerid, "ชุดกันผึ้ง") >= 1)
	{
		switch(rand)
		{
		    case 1..15: SendClientMessage(playerid, COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}เก็บรัง ต้องอ้อนผึ้งก่อนดิ หยอกกกก!");
			case 16..50:
		    {
				new id = Inventory_Add(playerid, "รังผึ้ง", ranbee);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

				GivePlayerExp(playerid, exprand);
				
				format(string, sizeof(string), "{FFFFFF}รังผึ้ง +%d", ranbee);
				SendClientMessage(playerid, COLOR_WHITE, string);
		    }
		}
	}
	if (Inventory_Count(playerid, "ชุดกันผึ้ง") < 1)
	{
	    switch(rand2)
		{
		    case 1:
			{

                        new strees = random(1);
						playerData[playerid][pStress] -= strees;
                        SetPlayerHealth(playerid, hp - ranhp);
                        FTbeePs[playerid] = 1;
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}รังผึ้งก็คือรังผึ้งโดนต่อยไปสาาาา! [ %s ]", GetPlayerNameEx(playerid));
    		}
			case 2:
    		{
    		            new strees = random(2);
						playerData[playerid][pStress] -= strees;
					    SetPlayerHealth(playerid, hp - ranhp);
					    FTbeePs[playerid] = 1;
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}เอ้ โง่ไรงี้เนี่ย ก็บอกว่าไปซื้อชุดกันผึ้ง![ %s ]", GetPlayerNameEx(playerid));
			}
			case 3:
			{
					    new id = Inventory_Add(playerid, "รังผึ้ง", 1);

						if (id == -1)
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

						GivePlayerExp(playerid, exprand);

						SNM(playerid, 15,COLOR_SERVER, "{00FF00}รังผึ้ง +1{FFFFFF} [ %s ]",GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_SERVER, " {00FF00}รังผึ้ง +1{FFFFFF}");
			}
			case 4:
			{
			            new strees = random(1);
						playerData[playerid][pStress] -= strees;
					    SetPlayerHealth(playerid, hp - ranhp);
					    FTbeePs[playerid] = 1;
					    SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}555555 ไอโง่นี่โดนผึ้งต่อยสะแล้ว![ %s ]", GetPlayerNameEx(playerid));
			}
			case 5:
			{
			            new strees = random(1);
						playerData[playerid][pStress] -= strees;
					    SetPlayerHealth(playerid, hp - ranhp);
					    FTbeePs[playerid] = 1;
					    SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}เอ้าๆๆๆ เกือบโดนผึ้งต่อยแล้วไหมหละะะ![ %s ]", GetPlayerNameEx(playerid));
			}
			case 6:
			{
					    new id = Inventory_Add(playerid, "รังผึ้ง", 1);

						if (id == -1)
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

						GivePlayerExp(playerid, exprand);

						SNM(playerid, 15,COLOR_SERVER, "{00FF00}รังผึ้ง +1{FFFFFF} [ %s ]",GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_SERVER, " {00FF00}รังผึ้ง +1{FFFFFF}");
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}บ้าแท้ๆ หนุ่มสาวที่ไม่กลัวผึ้ง![ %s ]", GetPlayerNameEx(playerid));
			}
			case 7:
			{
			            new strees = random(1);
						playerData[playerid][pStress] -= strees;
					    SetPlayerHealth(playerid, hp - ranhp);
					    FTbeePs[playerid] = 1;
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}ถ้าเธอเป็นผญ.สู้ๆน้าา แต่ถ้านายเป็น ผช. ไอดวงซวยเอ้ยยยยย! ผึ้งต่อย[ %s ]", GetPlayerNameEx(playerid));
			}
			case 8:
			{
						new id = Inventory_Add(playerid, "รังผึ้ง", 1);

						if (id == -1)
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

						GivePlayerExp(playerid, exprand);
						SNM(playerid, 15,COLOR_SERVER, "{00FF00}รังผึ้ง +1{FFFFFF} [ %s ]",GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_SERVER, " {00FF00}รังผึ้ง +1{FFFFFF}");
			}
			case 9:
			{
					    new id = Inventory_Add(playerid, "รังผึ้ง", 1);

						if (id == -1)
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

						GivePlayerExp(playerid, exprand);
						SNM(playerid, 15,COLOR_SERVER, "{00FF00}รังผึ้ง +1{FFFFFF} [ %s ]",GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_SERVER, " {00FF00}รังผึ้ง +1{FFFFFF}");
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}โชคร้ายจริงๆเล้ยยย![ %s ]", GetPlayerNameEx(playerid));
			}
			case 10:
			{
			            new strees = random(3);
						playerData[playerid][pStress] -= strees;
					    SetPlayerHealth(playerid, hp - ranhp);
					    FTbeePs[playerid] = 1;
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}ไปซื้อชุดเถอะไป จริง เสียเวลาเปล่านะถ้าไม่ซื้อชุด! (ไอนี่โดนผึ้งต่อยอีกละ)[ %s ]", GetPlayerNameEx(playerid));
			}
			case 12:
			{
					    new id = Inventory_Add(playerid, "รังผึ้ง", 1);

						if (id == -1)
						    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);

						GivePlayerExp(playerid, exprand);
						SNM(playerid, 15,COLOR_SERVER, "{00FF00}รังผึ้ง +1{FFFFFF} [ %s ]",GetPlayerNameEx(playerid));
						SendClientMessageEx(playerid, COLOR_SERVER, " {00FF00}รังผึ้ง +1{FFFFFF}");
						SNM(playerid, 15,COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}ความพยายามอยู่ที่ไหน ความสำเร็จอยู่ที่นั่น ตามหามันเร็ววววว![ %s ]", GetPlayerNameEx(playerid));
			}
		}
	}
	return 1;
}

FTPlayerbeeUnfreeze2(playerid)
{
    FTbeePs[playerid] = 0;

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 0);
	RemovePlayerAttachedObject(playerid, 1);
	RemovePlayerAttachedObject(playerid, 2);
	RemovePlayerAttachedObject(playerid, 3);
	RemovePlayerAttachedObject(playerid, 4);
	RemovePlayerAttachedObject(playerid, 5);
	RemovePlayerAttachedObject(playerid, 6);
 	TogglePlayerControllable(playerid, 1);
  	ClearAnimations(playerid);

	new string[10];
  	new rand = randomEx(1, 50);
	
    if (Inventory_HasItem(playerid, "รังผึ้ง"))
	{
		switch(rand)
		{
		    case 1..15: SendClientMessage(playerid, COLOR_RED, "[นายแอปเปิ้ล] {FFFFFF}!");
			case 16..50:
		    {
				new id = Inventory_Add(playerid, "แพ็ครังผึ้ง", 1);

				if (id == -1)
				    return SendClientMessageEx(playerid, COLOR_RED, "[ระบบ] {FFFFFF}ความจุของกระเป๋าไม่เพียงพอ (%d/%d)", Inventory_Items(playerid), playerData[playerid][pMaxItem]);
				    
                format(string, sizeof(string), "{FD2A1C}[รังผึ้ง] {FFFFFF}คงเหลือ %d", Inventory_Count(playerid, "รังผึ้ง"));
                SendClientMessage(playerid, COLOR_RED, "{00FF00}รังผึ้ง -1{FFFFFF} ");
				SendClientMessage(playerid, COLOR_GREEN, "{00FF00}แพ็ครังผึ้ง +1{FFFFFF} ");
				SendClientMessage(playerid, COLOR_SERVER, string);
		    }
		}
	}
	return 1;
}

hook OnProgressFinish(playerid, objectid)
{
	if(FTbeeTake[playerid] == 1)
		return FTPlayerbeeUnfreeze(playerid);
		
    if(FTbeePs[playerid] == 1)
        return FTPlayerbeeUnfreeze2(playerid);
        

	return Y_HOOKS_CONTINUE_RETURN_0;
}

hook OnProgressUpdate(playerid, progress, objectid)
{
	if(FTbeeTake[playerid] == 1)
	{
	  	ApplyAnimation(playerid, "BSKTBALL", "BBALL_Dnk", 4.1, 1, 0, 0, 0, 0, 1);
		return Y_HOOKS_BREAK_RETURN_1;
	}
	
	if(FTbeePs[playerid] == 1)
    {
		ApplyAnimation(playerid, "FIGHT_D", "HitD_2", 4.1, 0, 0, 0, 0, 0, 1);
		return Y_HOOKS_BREAK_RETURN_1;
	}

	return Y_HOOKS_CONTINUE_RETURN_0;
}

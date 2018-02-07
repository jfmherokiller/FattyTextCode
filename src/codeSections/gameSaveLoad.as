import valueObjects.Gender;
import valueObjects.Locations;
import valueObjects.Species;

//Creates a backup of the input array. Useful for how flash stores temporary information
/*Flash stores information in certain areas of your computer memory, and if you change one thing and another thing is stored in that same spot, 
such as the weapon you're equipped with and the weapon the save slot says you're equipped with, then both end up changed if one of them changes. 
This is what caused a lot of the inventory glitches related to loading saves. */
//This is very confusing, and I can't explain it very well, but there you go
protected function backupArray(savingArray:Array):Array{
	var arrayBackup:Array = new Array();
	if(savingArray != null){ for(i=0;i<savingArray.length;i++){ arrayBackup.push(savingArray[i]); } }
	return arrayBackup;
	arrayBackup = new Array();
}

//Displays dialogue for saving
protected function trySave():void {
	
	//Pulls up the saved game object from the players computer
	var saveGame:SharedObject = SharedObject.getLocal("fattyStripped");
	
	clearView();
	clrBtnTxt();
	returnView(12);
	
	//Displays saved game information to the buttons if a saved game exists in that slot
	if(saveGame.data.saveGame1){btntxt(1,"1 "+saveGame.data.saveGame1["name"]+" Day:"+saveGame.data.saveGame1["day"]+","+saveGame.data.saveGame1["display hour"]+":"+saveGame.data.saveGame1["tens minute"]+int(saveGame.data.saveGame1["ones minute"]));}
	if(saveGame.data.saveGame2){btntxt(2,"2 "+saveGame.data.saveGame2["name"]+" Day:"+saveGame.data.saveGame2["day"]+","+saveGame.data.saveGame2["display hour"]+":"+saveGame.data.saveGame2["tens minute"]+int(saveGame.data.saveGame2["ones minute"]));}
	if(saveGame.data.saveGame3){btntxt(3,"3 "+saveGame.data.saveGame3["name"]+" Day:"+saveGame.data.saveGame3["day"]+","+saveGame.data.saveGame3["display hour"]+":"+saveGame.data.saveGame3["tens minute"]+int(saveGame.data.saveGame3["ones minute"]));}
	if(saveGame.data.saveGame4){btntxt(4,"4 "+saveGame.data.saveGame4["name"]+" Day:"+saveGame.data.saveGame4["day"]+","+saveGame.data.saveGame4["display hour"]+":"+saveGame.data.saveGame4["tens minute"]+int(saveGame.data.saveGame4["ones minute"]));}
	if(saveGame.data.saveGame5){btntxt(5,"5 "+saveGame.data.saveGame5["name"]+" Day:"+saveGame.data.saveGame5["day"]+","+saveGame.data.saveGame5["display hour"]+":"+saveGame.data.saveGame5["tens minute"]+int(saveGame.data.saveGame5["ones minute"]));}
	if(saveGame.data.saveGame6){btntxt(6,"6 "+saveGame.data.saveGame6["name"]+" Day:"+saveGame.data.saveGame6["day"]+","+saveGame.data.saveGame6["display hour"]+":"+saveGame.data.saveGame6["tens minute"]+int(saveGame.data.saveGame6["ones minute"]));}
	if(saveGame.data.saveGame7){btntxt(7,"7 "+saveGame.data.saveGame7["name"]+" Day:"+saveGame.data.saveGame7["day"]+","+saveGame.data.saveGame7["display hour"]+":"+saveGame.data.saveGame7["tens minute"]+int(saveGame.data.saveGame7["ones minute"]));}
	if(saveGame.data.saveGame8){btntxt(8,"8 "+saveGame.data.saveGame8["name"]+" Day:"+saveGame.data.saveGame8["day"]+","+saveGame.data.saveGame8["display hour"]+":"+saveGame.data.saveGame8["tens minute"]+int(saveGame.data.saveGame8["ones minute"]));}
	if(saveGame.data.saveGame9){btntxt(9,"9 "+saveGame.data.saveGame9["name"]+" Day:"+saveGame.data.saveGame9["day"]+","+saveGame.data.saveGame9["display hour"]+":"+saveGame.data.saveGame9["tens minute"]+int(saveGame.data.saveGame9["ones minute"]));}
	
	scene("Where would you like to save? ",true);
	
	scene("\n\n<i>Your saved games are stored locally on your computer either at some location or other. " +
		"\n\nInside whichever relevant folder it is, there's a file called fattyStripped.sol which represents all your saved games. " +
		"This is a temporary internet file that can and will get deleted any time your temporary internet files get cleaned out. " +
		"If you would like to make a backup of your save games, copy the fattyStripped.sol file and save it somewhere else. " +
		"To restore your saved games; place a copy of your backup back in whichever folder it came from originally, making sure the file name is still fattyStripped.sol. " +
		"<\i>",false);
	
	//Creates buttons for you to select which slot to save in. 
	listen = function():void{
		switch(btnchc){
			case 1:
				doSave(1);
				break;
			case 2:
				doSave(2);
				break;
			case 3:
				doSave(3);
				break;
			case 4:
				doSave(4);
				break;
			case 5:
				doSave(5);
				break;
			case 6:
				doSave(6);
				break;
			case 7:
				doSave(7);
				break;
			case 8:
				doSave(8);
				break;
			case 9:
				doSave(9);
				break;
			default:
				if(btnchc == 12){
					specialEvent = 1;
					subEvent = "";
					doEvent(location);
				}
				break;
		}
	}
}

//Displays dialogue for loading a game
protected function tryLoad():void {
	
	//Pulls up the saved game object from the players computer
	var saveGame:SharedObject = SharedObject.getLocal("fattyStripped");
	currentState = "options";
	
	clearView();
	//Displays saved game information to the buttons if a saved game exists in that slot
	if(saveGame.data.saveGame1){btntxt(1,"1 "+saveGame.data.saveGame1["name"]+" Day:"+saveGame.data.saveGame1["day"]+","+saveGame.data.saveGame1["display hour"]+":"+saveGame.data.saveGame1["tens minute"]+int(saveGame.data.saveGame1["ones minute"]));}
	if(saveGame.data.saveGame2){btntxt(2,"2 "+saveGame.data.saveGame2["name"]+" Day:"+saveGame.data.saveGame2["day"]+","+saveGame.data.saveGame2["display hour"]+":"+saveGame.data.saveGame2["tens minute"]+int(saveGame.data.saveGame2["ones minute"]));}
	if(saveGame.data.saveGame3){btntxt(3,"3 "+saveGame.data.saveGame3["name"]+" Day:"+saveGame.data.saveGame3["day"]+","+saveGame.data.saveGame3["display hour"]+":"+saveGame.data.saveGame3["tens minute"]+int(saveGame.data.saveGame3["ones minute"]));}
	if(saveGame.data.saveGame4){btntxt(4,"4 "+saveGame.data.saveGame4["name"]+" Day:"+saveGame.data.saveGame4["day"]+","+saveGame.data.saveGame4["display hour"]+":"+saveGame.data.saveGame4["tens minute"]+int(saveGame.data.saveGame4["ones minute"]));}
	if(saveGame.data.saveGame5){btntxt(5,"5 "+saveGame.data.saveGame5["name"]+" Day:"+saveGame.data.saveGame5["day"]+","+saveGame.data.saveGame5["display hour"]+":"+saveGame.data.saveGame5["tens minute"]+int(saveGame.data.saveGame5["ones minute"]));}
	if(saveGame.data.saveGame6){btntxt(6,"6 "+saveGame.data.saveGame6["name"]+" Day:"+saveGame.data.saveGame6["day"]+","+saveGame.data.saveGame6["display hour"]+":"+saveGame.data.saveGame6["tens minute"]+int(saveGame.data.saveGame6["ones minute"]));}
	if(saveGame.data.saveGame7){btntxt(7,"7 "+saveGame.data.saveGame7["name"]+" Day:"+saveGame.data.saveGame7["day"]+","+saveGame.data.saveGame7["display hour"]+":"+saveGame.data.saveGame7["tens minute"]+int(saveGame.data.saveGame7["ones minute"]));}
	if(saveGame.data.saveGame8){btntxt(8,"8 "+saveGame.data.saveGame8["name"]+" Day:"+saveGame.data.saveGame8["day"]+","+saveGame.data.saveGame8["display hour"]+":"+saveGame.data.saveGame8["tens minute"]+int(saveGame.data.saveGame8["ones minute"]));}
	if(saveGame.data.saveGame9){btntxt(9,"9 "+saveGame.data.saveGame9["name"]+" Day:"+saveGame.data.saveGame9["day"]+","+saveGame.data.saveGame9["display hour"]+":"+saveGame.data.saveGame9["tens minute"]+int(saveGame.data.saveGame9["ones minute"]));}
	
	miscScene("Which file would you like to load? ",true);
	
	miscScene("\n\n<i>Your saved games are stored locally on your computer either at some location or other. " +
		"\n\nInside whichever relevant folder it is, there's a file called fattyStripped.sol which represents all your saved games. " +
		"This is a temporary internet file that can and will get deleted any time your temporary internet files get cleaned out. " +
		"If you would like to make a backup of your save games, copy the fattyStripped.sol file and save it somewhere else. " +
		"To restore your saved games; place a copy of your backup back in whichever folder it came from originally, making sure the file name is still fattyStripped.sol. " +
		"<\i>",false);
	
	//Creates buttons for you to choose which slot to load. 
	listen = function():void{
		switch(btnchc){
			case 1:
				doLoad(1);
				break;
			case 2:
				doLoad(2);
				break;
			case 3:
				doLoad(3);
				break;
			case 4:
				doLoad(4);
				break;
			case 5:
				doLoad(5);
				break;
			case 6:
				doLoad(6);
				break;
			case 7:
				doLoad(7);
				break;
			case 8:
				doLoad(8);
				break;
			case 9:
				doLoad(9);
				break;
		}
	}
}

//Saves the game in the input slot
protected function doSave(slot:int):void {
	
	//Pulls up the saved game data from the player's computer
	var saveGame:SharedObject = SharedObject.getLocal("fattyStripped");
	
	//Creates the object that'll store all of the current game's data
	var saveArray:Object = new Object();
	
	scene("Your game has been saved. ",true);
	nextView();
	listen = function():void{
		if(btnchc == 12){
			common.visible = true;
			specialEvent = 0;
			subEvent = "";
			doEvent(location);
		}
	}
	
	//Location
	saveArray["locationName"] = location.Name;
	
	//basic stats
	saveArray["strength"] = bSTR;
	saveArray["speed"] = bAGI;
	saveArray["intelligence"] = bINT;
	saveArray["stomach"] = bSTO;
	saveArray["endurance"] = bEND;
		
	//stats
	saveArray["health"] = HEA;
	saveArray["max health"] = bmaxHEA;
	saveArray["MANA"] = MANA;
	saveArray["eaten"] = Eaten;
	saveArray["drank"] = Drank;
	saveArray["Inflated"] = Inflated;
	saveArray["InflatedMass"] = InflatedMass;
	saveArray["max full"] = maxFUL;
	saveArray["stamina"] = STA;
	saveArray["calories"] = Calories;
	saveArray["fat"] = FAT;
	
	//description
	saveArray["name"] = playerName;
	saveArray["player species"] = ObjectUtil.copy(playerSpecies) as Species;
	saveArray["gender"] = ObjectUtil.copy(playerGender) as Gender;
	saveArray["height"] = playerHeight;
	
	//inventory
	saveArray["inventory"] = backupArray(invArray);
	saveArray["keyInvArray"] = backupArray(keyInvArray);
	saveArray["max inventory"] = maxInv;
	saveArray["gold"] = GLD;
	
	//storage
	saveArray["storage"] = backupArray(storageArray);
	saveArray["max storage"] = maxStorage;
	saveArray["storage gold"] = storageGold;
	
	//quests
	saveArray["questArray"] = backupArray(questArray);
	
	//Spells
	saveArray["spellArray"] = backupArray(spellArray);
	
	//experience
	saveArray["experience"] = XP;
	saveArray["xp to level"] = XPtoLevel;
	saveArray["level"] = LVL;
	saveArray["level up"] = LVLup;
	
	//equipment
	saveArray["weapon"] = ObjectUtil.copy(WEA) as Items;
	saveArray["armor"] = ObjectUtil.copy(ARM) as Items;
	saveArray["top"] = ObjectUtil.copy(TOP) as Items;
	saveArray["bottom"] = ObjectUtil.copy(BTM) as Items;
	
	//Options
	saveArray["optionsMetric"] = optionsMetric;
	saveArray["optionsImperial"] = optionsImperial;
	saveArray["optionsPopping"] = optionsPopping;
	saveArray["optionsFemales"] = optionsFemales;
	saveArray["optionsMales"] = optionsMales;
	saveArray["optionsDescription"] = optionsDescription;
	
	//timed events
	saveArray["stomach stretch"] = statusStomachStretch;
	saveArray["statusBeeVenom"] = statusBloatVenom;
	saveArray["statusBeeVenomPower"] = statusBloatVenomPower;
	saveArray["statusWellFed"] = statusWellFed;
	saveArray["statusWellFedPower"] = statusWellFedPower;
	
	//Modified stats
	saveArray["statusSTRBuff"] = statusSTRBuff;
	saveArray["statusSTRBuffPower"] = statusSTRBuffPower;
	saveArray["statusINTBuff"] = statusINTBuff;
	saveArray["statusINTBuffPower"] = statusINTBuffPower;
	saveArray["statusENDBuff"] = statusENDBuff;
	saveArray["statusENDBuffPower"] = statusENDBuffPower;
	saveArray["statusAGIBuff"] = statusAGIBuff;
	saveArray["statusAGIBuffPower"] = statusAGIBuffPower;
	saveArray["statusMANABuff"] = statusMANABuff;
	saveArray["statusMANABuffPower"] = statusMANABuffPower;
	saveArray["statusSTOBuff"] = statusSTOBuff;
	saveArray["statusSTOBuffPower"] = statusSTOBuffPower;
	
	//time
	saveArray["day"] = day;
	saveArray["am pm"] = AMPM;
	saveArray["hour"] = hour;
	saveArray["display hour"] = displayHour;
	saveArray["tens minute"] = tensMinute;
	saveArray["ones minute"] = onesMinute;
	
	
	if(slot == 1){saveGame.data.saveGame1 = saveArray;}
	if(slot == 2){saveGame.data.saveGame2 = saveArray;}
	if(slot == 3){saveGame.data.saveGame3 = saveArray;}
	if(slot == 4){saveGame.data.saveGame4 = saveArray;}
	if(slot == 5){saveGame.data.saveGame5 = saveArray;}
	if(slot == 6){saveGame.data.saveGame6 = saveArray;}
	if(slot == 7){saveGame.data.saveGame7 = saveArray;}
	if(slot == 8){saveGame.data.saveGame8 = saveArray;}
	if(slot == 9){saveGame.data.saveGame9 = saveArray;}
	
	//Creates the save game object on the player's computer
	saveGame.flush();
}

//Loads the game from the input slot
protected function doLoad(slot:int):void {

	//Pulls up the saved game data from the player's compute
	var saveGame:SharedObject = SharedObject.getLocal("fattyStripped");
	
	//Creates the object that'll store all of the current game's data
	var saveArray:Object = new Object();
	
	currentState = "default";
	scene("Your game has been loaded. ",true);

	switch(slot){
		case 1:
			saveArray = saveGame.data.saveGame1;
			break;
		case 2:
			saveArray = saveGame.data.saveGame2;
			break;
		case 3:
			saveArray = saveGame.data.saveGame3;
			break;
		case 4:
			saveArray = saveGame.data.saveGame4;
			break;
		case 5:
			saveArray = saveGame.data.saveGame5;
			break;
		case 6:
			saveArray = saveGame.data.saveGame6;
			break;
		case 7:
			saveArray = saveGame.data.saveGame7;
			break;
		case 8:
			saveArray = saveGame.data.saveGame8;
			break;
		case 9:
			saveArray = saveGame.data.saveGame9;
			break;
	}
	
	//basic stats
	bSTR = saveArray["strength"];
	bAGI = saveArray["speed"];
	bINT = saveArray["intelligence"];
	bSTO = saveArray["stomach"];
	bEND = saveArray["endurance"];
	

	//advanced stats
	HEA = saveArray["health"];
	bmaxHEA = saveArray["max health"];
	if(saveArray["MANA"] != null){MANA = saveArray["MANA"];}
	if(saveArray["MANA"] == null){MANA = 0;}
	Eaten = saveArray["eaten"];
	Drank = saveArray["drank"];
	if(saveArray["Inflated"] != null){Inflated = saveArray["Inflated"];}
	if(saveArray["InflatedMass"] != null){InflatedMass = saveArray["InflatedMass"];}
	if(saveArray["Inflated"] == null){Inflated = 0;}
	if(saveArray["InflatedMass"] == null){InflatedMass = 0;}
	maxFUL = saveArray["max full"];
	STA = saveArray["stamina"];
	Calories = saveArray["calories"];
	FAT = saveArray["fat"];
	
	//player description
	playerName = saveArray["name"];
	playerSpecies = ObjectUtil.copy(saveArray["player species"]) as Species;
	var loadedGender:Gender = ObjectUtil.copy(saveArray["gender"]) as Gender;
	switch(loadedGender.name){
		case Male.name:
			playerGender = ObjectUtil.copy(Male) as Gender;
			break;
		default:
			playerGender = ObjectUtil.copy(Female) as Gender;
			break;
	}
	playerHeight = saveArray["height"];
	
	//inventory
	invArray = new Array();
	invArray = backupArray(saveArray["inventory"]);
	keyInvArray = new Array();
	keyInvArray = backupArray(saveArray["keyInvArray"]);
	maxInv = saveArray["max inventory"];
	GLD = saveArray["gold"];
	
	//quests
	questArray = new Array();
	questArray = backupArray(saveArray["questArray"]);
	
	//Spells
	spellArray = new Array();
	spellArray = backupArray(saveArray["spellArray"]);
	
	//storage
	storageArray = new Array();
	storageArray = backupArray(saveArray["storage"]);
	maxStorage = saveArray["max storage"];
	storageGold = saveArray["storage gold"];
	
	//experience
	XP = saveArray["experience"];
	XPtoLevel = saveArray["xp to level"];
	LVL = saveArray["level"];
	LVLup = saveArray["level up"];
	
	//equipment
	WEA = ObjectUtil.copy(saveArray["weapon"]) as Items;
	ARM = ObjectUtil.copy(saveArray["armor"]) as Items;
	TOP = ObjectUtil.copy(saveArray["top"]) as Items;
	BTM = ObjectUtil.copy(saveArray["bottom"]) as Items;
	
	//Options
	if(saveArray["optionsMetric"] != null){optionsMetric = saveArray["optionsMetric"];}
	if(saveArray["optionsImperial"] != null){optionsImperial = saveArray["optionsImperial"];}
	if(saveArray["optionsMetric"] == null){optionsMetric = false;}
	if(saveArray["optionsImperial"] == null){optionsImperial = true;}
	
	if(saveArray["optionsPopping"] != null){optionsPopping = saveArray["optionsPopping"];}
	if(saveArray["optionsPopping"] == null){optionsPopping = false;}
	
	if(saveArray["optionsDescription"] != null){optionsDescription = saveArray["optionsDescription"];}
	if(saveArray["optionsDescription"] == null){optionsDescription = true;}
	
	if(saveArray["optionsFemales"] != null){optionsFemales = saveArray["optionsFemales"];}
	if(saveArray["optionsFemales"] == null){optionsFemales = true;}
	if(saveArray["optionsMales"] != null){optionsMales = saveArray["optionsMales"];}
	if(saveArray["optionsMales"] == null){optionsMales = true;}
		
	//timed events
	statusStomachStretch = saveArray["stomach stretch"];
	statusBloatVenom = saveArray["statusBeeVenom"];
	statusWellFed = saveArray["statusWellFed"];
	statusBloatVenomPower = saveArray["statusBeeVenomPower"];
	statusWellFedPower = saveArray["statusWellFedPower"];

	//Modified stats
	statusSTRBuff = saveArray["statusSTRBuff"];
	statusSTRBuffPower = saveArray["statusSTRBuffPower"];
	statusINTBuff = saveArray["statusINTBuff"];
	statusINTBuffPower = saveArray["statusINTBuffPower"];
	statusENDBuff = saveArray["statusENDBuff"];
	statusENDBuffPower = saveArray["statusENDBuffPower"];
	statusAGIBuff = saveArray["statusAGIBuff"];
	statusAGIBuffPower = saveArray["statusAGIBuffPower"];
	statusMANABuff = saveArray["statusMANABuff"];
	statusMANABuffPower = saveArray["statusMANABuffPower"];
	statusSTOBuff = saveArray["statusSTOBuff"];
	statusSTOBuffPower = saveArray["statusSTOBuffPower"];
	
	//time
	day = saveArray["day"];
	AMPM = saveArray["am pm"];
	hour = saveArray["hour"];
	displayHour = saveArray["display hour"];
	tensMinute = saveArray["tens minute"];
	onesMinute = saveArray["ones minute"];
	
	//Moves the player to whatever location the loaded game was saved at
	var savedLocationName:String = saveArray["locationName"];
	switch(savedLocationName){
		default:
			locationUpdate(YourHouse);
			break;
	}
	
	//Creates default button setup
	nextView();
	listen = function():void{
		if(btnchc == 12){
			newGame = false;
			common.visible = true;
			specialEvent = 0;
			scene("",true);
			doEvent(location);
		}
	}

}

import spark.effects.easing.Power;

import valueObjects.Items;
import valueObjects.Quests;

//Tests whether the character should be alive or not
protected function alive():Boolean{
	if(HEA >= 1){return true;}
	else{return false;}
}

//Tests a players skills minus opposing skills against a d100
protected function testSkill(player:Number,enemy:Number):Boolean{
	var succeeded:Boolean = false;
	if(d100() <= player - enemy){succeeded = true;}
	return succeeded;
}

//Tests a player's skill with a maximum and minimum chance
protected function testSkillRange(player:Number,enemy:Number,minChance:int,maxChance:int):Boolean{
	var successChance:Number = player - enemy;
	if(successChance < minChance){successChance = minChance;}
	if(successChance > maxChance){successChance = maxChance;}
	return testSkill(successChance,0);
}

//Brings up the options dialogue and allows the player to change options
protected function changeOptions():void{
	clearView();
	appView(0);
	
	currentState = "options";
	miscScene("<b>Options</b>" +
		"\n~~~~~~~~~~~~~~~~~~~~~~",true);
	
	//Measurement system
	miscScene("<li>Measurement system: ",false);
	if(optionsMetric){miscScene("Metric</li>",false);}
	if(optionsImperial){miscScene("Imperial</li>",false);}
	
	//Popping
	miscScene("<li>Allow bursting: "+optionsPopping+"</li>",false);
	
	//Character description length
	miscScene("<li>Long player description: "+optionsDescription+"</li>",false);
	
	//Allowed random genders
	miscScene("<li>Allow random male NPCs: "+optionsMales+"</li>",false);
	miscScene("<li>Allow random female NPCs: "+optionsFemales+"</li>",false);
	
	//Goes to cheat menu
	miscScene("<li>Go to cheat menu</li>",false);
	
	
	//Buttons
	btntxt(1,"Metric/Imperial");
	btntxt(2,"Popping");
	btntxt(3,"Long player descriptions");
	btntxt(4,"Allow random males");
	btntxt(5,"Allow random females");
	btntxt(6,"Cheats");
	
	listen = function():void{
		if(btnchc == 1){
			optionsMetric = !optionsMetric;
			optionsImperial = !optionsImperial;
			changeOptions();
		}
		if(btnchc == 2){
			optionsPopping = !optionsPopping;
			changeOptions();
		}
		if(btnchc == 3){
			optionsDescription = !optionsDescription;
			changeOptions();
		}
		if(btnchc == 4){
			optionsMales = !optionsMales;
			changeOptions();
		}
		if(btnchc == 5){
			optionsFemales = !optionsFemales;
			changeOptions();
		}
		if(btnchc == 6){currentState = "cheat";}
		
	}
}

//Inputs cheat option
protected function acceptCheat():void{
	if(cheatStrength.text != ""){bSTR = parseInt(cheatStrength.text);}
	if(cheatAgility.text != ""){bAGI = parseInt(cheatAgility.text);}
	if(cheatIntelligence.text != ""){bINT = parseInt(cheatIntelligence.text);}
	if(cheatEndurance.text != ""){bEND = parseInt(cheatEndurance.text);}
	if(cheatStomach.text != ""){bSTO = parseInt(cheatStomach.text);}
	if(cheatHealth.text != ""){bmaxHEA = parseInt(cheatHealth.text);}
	if(cheatFat.text != ""){FAT = parseInt(cheatFat.text);}
	if(cheatGold.text != ""){GLD = parseInt(cheatGold.text);}
	updateStats();
	changeOptions();
}

//Returns your maximum surviveable fullness
protected function maximumFullness():Number{
	fixFull();
	var testFullness:int = (maxFUL / 100) * STO;
	var testHealth:int = ((maxFUL - (testFullness/STO)) / (maxFUL - 100)) * (bmaxHEA + modHealth());
	if(testHealth <= 0){testFullness--;}
	return testFullness;
}

//Returns you remaining survivable capacity
protected function remainingCapacity():Number{return maximumFullness() - ATE;}

//Inflates you to the point of floating
protected function inflateToFloating():void{
	if(weight() > 0){doInflate( weight()*.5,-20 - weight() );}
}

//Fills you past your maximum fullness
protected function stuffToBursting():void{
	var tempInt:Number = remainingCapacity() + 1;
	if(tempInt > 0){doConsume(tempInt,0,tempInt * .5);}
}

//Fills you just below maximum fullness
protected function stuffToAlmostBursting():void{
	var almostBursting:Number = remainingCapacity();
	if(almostBursting > 0){doConsume(almostBursting,0,almostBursting * .5);}
}

//Sleep function
protected function doSleep():void{
	doRest();
	doRest();
	doRest();
	doRest();
	doRest();
	doRest();
	doRest();
	doRest();
}

//Resting function
protected function doRest():void{
	doTime(60);
	doStamina(25);
	doHealth(END);
	updateStats();
	//Randomly starts a fight if you rest in a dangerous area
	if(location.type == wilderness && location.enemies != null){
		if(dXY(1,5) == 1){
			appView(0);
			combatEvent(location.enemies[dXY(0,location.enemies.length-1)]);
			scene("\tYou are awoken from your sleep by "+enemyt.article+" "+enemyt.name+"! ",true);
		}
	}
}

//Brings up the area description
protected function doArea():void{
	currentState = "surroundings";
	miscScene("\t"+location.Description,true);
}

//Adds gold and prevents gold from going into negative numbers
protected function doGold(ID:int):void{
	GLD += ID;
	if(ID != 0){
		if(ID > 0){scene("<li>+"+ID+" gold!</li>",false);}
		if(ID < 0){scene("<li>"+ID+" gold!</li>",false);}
	}
	if(GLD < 0){GLD = 0;}
}

//Adds XP and checks for level up
protected function doXP(gained:int):void{
	if(gained > 0){scene("<li>+"+gained+" XP!</li>",false);}
	while(gained > 0){
		XP += gained;
		gained = 0;
		if(XP >= XPtoLevel){
			scene("<li>Level up!</li>",false);
			gained = XP - XPtoLevel;
			XP = 0;
			XPtoLevel = 100 + ((LVL - 1)*10);
			LVL++;
			LVLup++;
			bmaxHEA += Math.floor(bEND * .1);
			updateStats();
			HEA = maxHEA;
		}
	}
}

//Activates level up dialogue
protected function doLevel():void{
	currentState = "levelUp";
	scene("You've gained a level! Choose a stat to increase. ", true);
	clearView();
	btntxt(1,"Strength");
	btntxt(2,"Agility");
	btntxt(3,"Endurance");
	btntxt(4,"Intelligence");
	btntxt(5,"Stomach");
	listen = function():void{
		var levelStats:Array = new Array(0,0,0,0,0);
		levelStats.splice(btnchc - 1,1,5);
		chgStats(levelStats[0],levelStats[1],levelStats[2],levelStats[3],levelStats[4]);
		LVLup--;
		currentState = "default";
		general();
	}
}

//Returns weight of input integer as a string based on player settings
protected function sayWeight(weight:Number):String{
	if(optionsMetric == false){return(int(weight)+" pounds");}
	else{return(int(weight * 0.453592)+" kilograms");}
}

//Returns distance of input number based on player settings
protected function sayDistance(inches:int):String{
	var returnDistance:String = Math.floor(inches)+" inches";
	var centimeters:int = Math.round(inches * 2.54);
	
	switch(optionsImperial){
		case true:
			if(inches == 12){ returnDistance = "a foot"; }
			if(inches > 24){
				if(inches % 12 == 0){ returnDistance = Math.floor(inches / 12)+" feet"; }
				if(inches % 12 != 0){ returnDistance = Math.floor(inches / 12)+"'"+(inches % 12)+"\""; }
			}
			if(inches == 1){returnDistance = "1 inch";}
			break;
		case false:
			if(centimeters > 100){returnDistance = (centimeters / 100)+" meters";}
			else{
				returnDistance = ""+centimeters;
				if(centimeters == 1){returnDistance += " centimeter";}
				else{returnDistance += " centimeters";}
			}
			break;
	}
	return(returnDistance);
}

//Returns the description for how you walk based on your weight
protected function walk():String{
	var tempStr:String = "walk";
	var tempInt:int = ATE + (FAT * .4);
	if(tempInt > 100){tempStr = "wobble";}
	if(tempInt > 150){tempStr = "waddle";}
	if(tempInt > 200){tempStr = "lumber";}
	if(testImmobileClose() == true){tempStr = "slowly "+tempStr;}
	return tempStr;
}
protected function walking():String{
	var tempStr:String = "walking";
	var tempInt:int = ATE + (FAT * .4);
	if(tempInt > 100){tempStr = "wobbling";}
	if(tempInt > 150){tempStr = "waddling";}
	if(tempInt > 200){tempStr = "lumbering";}
	if(testImmobileClose() == true){tempStr = "slowly "+tempStr;}
	return tempStr;
}

include "gameCharacterDescriptions.as";
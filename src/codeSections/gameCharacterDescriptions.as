//Displays your characters appearance
protected function doAppearance():void{
	currentState = "appearance";
	updateStats();
	
	//Name
	miscScene("<b>"+playerName+"</b>,\n\t",true);
	//Species
	miscScene("You are a "+playerGender.name+" "+playerSpecies.name+" ",false);
	//Weight
	miscScene("that weighs "+sayWeight(weight()),false);
	//Height
	miscScene(" and is "+sayDistance(playerHeight)+" tall. ",false);
	//Physical description
	miscScene("You have " +muscles()+ " muscles under your "+fatness()+" body and have "+playerSpecies.furBack+" colored "+playerSpecies.fur+". " +
		"Your "+playerSpecies.furBelly+" "+playerSpecies.furred+" stomach is "+waist()+" and sticks out "+sayDistance(waistDiameter())+" and you are " +hungry()+ ". ",false);
	

	//Equipment
	miscScene("\n~~~~~~~~~~~~~~~~~~~~~~",false);
	miscScene("\n<b>You are wearing:</b> ",false);
	miscScene("<li>",false);
	//Shirt
	miscScene(capFirst(TOP.Name)+"</li>\t\t",false);
	if (TOP.Popped == false){ miscScene(TOP.Description,false); }
	if (TOP.Popped == true) { miscScene(TOP.PoppedDescription,false); }
	miscScene("<li>",false);
	//Pants
	miscScene(capFirst(BTM.Name)+"</li>\t\t",false);
	if (BTM.Popped == false){ miscScene(BTM.Description,false); }
	if (BTM.Popped == true) { miscScene(BTM.PoppedDescription,false); }
	//Armor
	miscScene("<li>"+capFirst(ARM.Name)+"</li>" +
		"\t\t"+ARM.Description +
		"\n\t\t<i>"+ARM.Defense+" defense</i>",false);
	//Weapon
	var damageScaleAmount:Number = 0.4;
	var damageScaleStat:String = "STR";
	if(WEA.damageScaling != 0){damageScaleAmount = WEA.damageScaling;}
	if(WEA.damageStat != null){damageScaleStat = WEA.damageStat;}
	miscScene("<li>"+capFirst(WEA.Name)+"</li>" +
		"\t\t"+WEA.Description +
		"\n\t\t<i>Deals "+WEA.WEAd+"d"+WEA.WEAr+" +"+damageScaleAmount*100+"% "+damageScaleStat+" "+WEA.damageType.name+" damage ",false);
	if(WEA.damageStat == "INT" && WEA.damageScaling > 0.4){miscScene("\n\t\tIncreases spell damage/healing by "+WEA.damageScaling*100+"% INT ",false);}
	miscScene("</i> ",false);
	
	//Status effects
	miscScene("\n~~~~~~~~~~~~~~~~~~~~~~" +
		"\n<b>Status effects:</b> ",false);
	var statusText:String = "";
	if(STA <= 5){statusText += "<li>STA low</li>";}
	if(Calories <= 0){statusText += "<li>Calories low</li>";}
	if(FUL > 100){statusText += "<li>Very full</li>";}
	if(testImmobileClose() == true){"<li>Almost imobile</li>",false;}
	if(statusWellFed > 0){statusText += "<li>Well fed</li>";}
	
	if(statusSTRBuffPower > 0){statusText += "<li>STR+</li>";}
	if(statusSTRBuffPower < 0){statusText += "<li>STR-</li>";}
	
	if(statusAGIBuffPower > 0){statusText += "<li>AGI+</li>";}
	if(statusAGIBuffPower < 0){statusText += "<li>AGI-</li>";}
	
	if(statusINTBuffPower > 0){statusText += "<li>INT+</li>";}
	if(statusINTBuffPower < 0){statusText += "<li>INT-</li>";}
	
	if(statusENDBuffPower > 0){statusText += "<li>END+</li>";}
	if(statusENDBuffPower < 0){statusText += "<li>END-</li>";}
	
	if(statusMANABuffPower > 0){statusText += "<li>MANA+</li>";}
	if(statusMANABuffPower < 0){statusText += "<li>MANA-</li>";}
	
	if(statusSTOBuffPower > 0){statusText += "<li>STO+</li>";}
	if(statusSTOBuffPower < 0){statusText += "<li>STO-</li>";}
	
	if(statusBloatVenomPower > 0 && statusBloatVenom > 0){statusText += "<li>Bloat venomed</li>";}
	if(statusText != ""){miscScene(statusText,false);}
	if(statusText == ""){miscScene("<li>None!</li>",false)}
	
	//Quests
	miscScene("~~~~~~~~~~~~~~~~~~~~~~" +
		"\n<b>Quests:</b> ",false);
	var questLog:Array = new Array();
	for(var j:int=0;j<questArray.length;j++){
		var questLogTest:Quests = questArray[j];
		if(questLogTest.visible == true && questLogTest.completed == false){questLog.push(questLogTest);}
	}
	if(questLog.length == 0 || questArray == null){miscScene("\nNone!",false);}
	if(questLog.length > 0){
		for(i=0;i<questLog.length;i++){ miscScene(questDescriptionDisplay(questLog[i]),false); }
	}
}

//Displays quest description
protected function questDescriptionDisplay(inputQuest:Quests):String{
	var questText:String = "";
	//Quest name
	questText += "<li><u>"+inputQuest.questName+"</u>";
	//Quest goal
	if(inputQuest.questTarget == null && inputQuest.questGoal > 0){
		questText += " <i>(";
		if(inputQuest.questProgress < inputQuest.questGoal){questText += inputQuest.questProgress+"/"+inputQuest.questGoal;}
		if(inputQuest.questProgress >= inputQuest.questGoal){questText += "Complete!";}
		questText += ")</i>";
	}
	if(inputQuest.questTarget != null){
		questText += " <i>("+capFirst(inputQuest.questTarget.Name)+")</i>";
	}
	//Quest description
	questText += "</li>\t\t"+inputQuest.questDescription;
	
	return questText;
}

//Calculates total body weight
protected function weight():Number{return(bodyMass() + Eaten + Drank + InflatedMass)}

//Calculates total body weight not including what you're consumed
protected function bodyMass():Number{return((bSTR * 3) + FAT + 40)}

//Calculates and returns waist size in inches
protected function waistDiameter():int{
	var tempInt:int = 2*Math.pow( ( (90 *(ATE + ((FAT + tenemyFATdebuff) * .21) ) )/(4*Math.PI) ),(1/3) ) - 5;
	if(tempInt <= 0){tempInt = 0;}
	return(tempInt);
}

//Describes how fat you are
protected function fatness():String{
	var tempStr:String = "error " +FAT;
	//you look
	if (FAT <= 1){tempStr = "fatless";}
	else if (FAT <= 10){tempStr = "lean";}
	else if (FAT <= 45){tempStr = "average";}
	else if (FAT <= 60){tempStr = "chubby";}
	else if (FAT <= 75){tempStr = "pudgy";}
	else if (FAT <= 90){tempStr = "fat";}
	else if (FAT <= 115){tempStr = "doughy";}
	else if (FAT <= 140){tempStr = "rotund";}
	else if (FAT <= 170){tempStr = "squishy";}
	else if (FAT <= 210){tempStr = "obese";}
	else if (FAT <= 270){tempStr = "porcine";}
	else if (FAT <= 400){tempStr = "incredibly obese";}
	else if (FAT <= 700){tempStr = "elephantine";}
	else{tempStr = "whale-like";}
	return tempStr;
}

//Describes how strong you are
protected function muscles():String{
	var tempStr:String;
	var tempInt:int = STR - FAT;	
	//your muscles are
	if(tempInt <= 5){tempStr = "unnoticeable";}
	else if(tempInt <= 10){tempStr = "barely noticeable";}
	else if(tempInt <= 20){tempStr = "average";}
	else if(tempInt <= 30){tempStr = "well-defined";}
	else if(tempInt <= 40){tempStr = "impressive";}
	else if(tempInt <= 50){tempStr = "rippling";}
	else if(tempInt <= 60){tempStr = "tremendous";}
	else if(tempInt <= 70){tempStr = "bodybuilderesque";}
	else if(tempInt <= 80){tempStr = "gargantuan";}
	else{tempStr = "mountain-like"; }
	return tempStr;
}

//Describes how large your waist is
protected function waist():String{
	//your waist is
	var tempStr:String;
	var tempInt:int = waistDiameter();
	if (tempInt <= 1) {tempStr = "flat";}
	else if (tempInt <= 3){tempStr = "small";}
	else if (tempInt <= 4){tempStr = "slightly rounded";}
	else if (tempInt <= 5){tempStr = "rounded";}
	else if (tempInt <= 6){tempStr = "swollen";}
	else if (tempInt <= 7){tempStr = "bulging";}
	else if (tempInt <= 10){tempStr = "basketball sized";}
	else if (tempInt <= 17){tempStr = "beachball sized";}
	else if (tempInt <= 24){tempStr = "too big to reach around";}
	else if (tempInt <= 30){tempStr = "person sized";}
	else if (tempInt <= 55){tempStr = "enormous";}
	else {tempStr = "big enough to reach the ground";}
	return tempStr;
}

//Describes how hungry you are
protected function hungry():String{
	var tempStr:String;
	fixFull();
	//you are
	if (FUL <= 10) { tempStr = "starving"; }
	else if (FUL <= 25) { tempStr = "hungry"; }
	else if (FUL <= 45) { tempStr = "not very hungry"; }
	else if (FUL <= 55) { tempStr = "sated"; }
	else if (FUL <= 65) { tempStr = "well fed"; }
	else if (FUL <= 75) { tempStr = "pretty full"; }
	else if (FUL <= 85) { tempStr = "stuffed"; }
	else if (FUL <= 100) { tempStr = "bloated"; }
	else if (FUL <= 110) { tempStr = "ready to pop"; }
	else { tempStr = "on the verge of bursting"; }
	return tempStr;
}

//Returns the name of fatness tier
protected function bodyFatTier():String{
	var tempFatTier:String = "";
	if(FAT <= 25){tempFatTier = "malnourished";}
	else if(FAT <= 75){tempFatTier = "healthy";}
	else if(FAT <= 150){tempFatTier = "robust";}
	else if(FAT <= 250){tempFatTier = "overweight";}
	else if(FAT <= 400){tempFatTier = "chubby";}
	else if(FAT <= 600){tempFatTier = "corpulent";}
	else if(FAT <= 900){tempFatTier = "obese";}
	else if(FAT <= 1300){tempFatTier = "morbidly obese";}
	else if(FAT <= 1800){tempFatTier = "massive";}
	else if(FAT <= 2300){tempFatTier = "spherical";}
	else if(FAT <= 3000){tempFatTier = "mountainous";}
	else if(FAT > 3000){tempFatTier = "colossal";}
	return tempFatTier;
}

//Returns name of strength tier
protected function bodyStrengthTier():String{
	var tempStrengthTier:String = "";
	var strengthTier:Number = (STR + STR + AGI + END) / 4.2;
	
	if(strengthTier <= 50){tempStrengthTier = "regular";}
	else if(strengthTier <= 150){tempStrengthTier = "athletic";}
	else if(strengthTier <= 250){tempStrengthTier = "muscular";}
	else if(strengthTier > 250){tempStrengthTier = "bodybuilder";}
	return tempStrengthTier;
}
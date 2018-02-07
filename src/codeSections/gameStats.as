import spark.components.Label;

//Changes fat level by input amount and displays the relevant stat change arrow
protected function doFat(fattened:Number):void{
	FAT += fattened;
	if(FAT < 0){FAT = 0;}
	if(fattened > 0){doArrow("FATup");}
	if(fattened < 0){doArrow("FATdown");}
}

//Changes stats by input amount
protected function chgStats(strength:Number,speed:Number,endurance:Number,intelligence:Number,stomach:Number):void{
	//Removes old arrows
	removeArrows();
	
	//Adds new arrows based on wether went up or down or neither
	if (strength > 0){doArrow("STRup");}
	if (speed > 0){doArrow("SPDup");}
	if (endurance > 0){doArrow("ENDup");}
	if (intelligence > 0){doArrow("INTup");}
	if (stomach < 0){doArrow("FULup");}
	if (strength < 0){doArrow("STRdown");}
	if (speed < 0){doArrow("SPDdown");}
	if (endurance < 0){doArrow("ENDdown");}
	if (intelligence < 0){doArrow("INTdown");}
	if (stomach > 0){doArrow("FULdown");}
	
	//Stat increases for when the stat is below 100
	if(bSTR < 100){bSTR += strength;}
	if(bAGI < 100){bAGI += speed;}
	if(bEND < 100){bEND += endurance;}
	if(bINT < 100){bINT += intelligence;}
	if(bSTO < 200){bSTO += stomach;}
	
	//Stat increases for when a stat is over 100 and thus incurs diminishing returns
	if(bSTR >= 100){bSTR += strength / (bSTR *.01);}
	if(bAGI >= 100){bAGI += speed / (bAGI *.01);}
	if(bEND >= 100){bEND += endurance / (bEND *.01);}
	if(bINT >= 100){bINT += intelligence / (bINT *.01);}
	if(bSTO >= 200){bSTO += stomach / (bSTO *.005);}
	
	updateStats();
}

//Changes input temporary stat by input amount
protected function chgTempStats(debuffType:String,debuffAmount:Number):void{
	
	//Debuffs character
	switch(debuffType){
		case "AGI":
			tenemyAGIdebuff -= debuffAmount;
			break;
		case "END":
			tenemyENDdebuff -= debuffAmount;
			break;
		case "INT":
			tenemyINTdebuff -= debuffAmount;
			break;
		case "STO":
			tenemySTOdebuff -= debuffAmount;
			break;
		case "STR":
			tenemySTRdebuff -= debuffAmount;
			break;
		case "stun":
			pStatusStunTime += debuffAmount;
			break;
		case "burn":
			statusBurnPower += debuffAmount;
			break;
		case "fat":
			tenemyFATdebuff += debuffAmount;
			break;
		default:
			debuffType = "debuff error";
			break;
	}
	
	//Displays status change message
	if(inCombat()){
		scene("\n\t<i>(",false);
		switch(debuffType){
			case "stun":
				scene("You've been stunned!",false);
				break;
			case "poison":
				scene("You've been poisoned!",false);
				break;
			case "burn":
				scene("You're burning!",false);
				break;
			case "fat":
				scene(debuffType,false);
				if(debuffAmount > 0){scene(" +"+debuffAmount,false);}
				if(debuffAmount < 0){scene(" "+-debuffAmount,false);}
				break;
			default:
				scene(debuffType,false);
				if(debuffAmount > 0){scene(" -"+debuffAmount,false);}
				if(debuffAmount < 0){scene(" +"+-debuffAmount,false);}
				break;
		}
		scene(")</i> ",false);
	}
	
	updateStats();
}

//Removes temporary combat stats, usually used whenever combat ends
protected function rmvTempStats():void{
	tenemySTRdebuff = 0;
	tenemyAGIdebuff = 0;
	tenemyINTdebuff = 0;
	tenemyENDdebuff = 0;
	tenemySTOdebuff = 0;
	tenemyFATdebuff = 0;
	
	tmagicSTRbuff = 0;
	tmagicAGIbuff = 0;
	tmagicINTbuff = 0;
	tmagicENDbuff = 0;
	tmagicSTObuff = 0;
	tmagicDEFbuff = 0;
	tmagicREGENbuff = 0;
	tmagicREGENbuffDamage = 0;
	tmagicREGENbuffRange = 0;
	tmagicDODGEbuff = 0;
	
	pStatusStunTime = 0;
}

//Removes temporary buffs/debuffs, usually from dying
protected function rmvTempBuffs():void{	
	statusBloatVenomPower = 0;
	statusBloatVenom = 0;
	
	statusWellFedPower = 0;
	statusWellFed = 0;
	
	statusSTRBuff = 0;
	statusSTRBuffPower = 0;
	
	statusAGIBuff = 0;
	statusAGIBuffPower = 0;
	
	statusINTBuff = 0;
	statusINTBuffPower = 0;
	
	statusENDBuff = 0;
	statusENDBuffPower = 0;
	
	statusMANABuff = 0;
	statusMANABuffPower = 0;
	
	statusSTOBuff = 0;
	statusSTOBuffPower = 0;
	
	statusBurn = 0;
	statusBurnPower = 0;

	updateStats();
}

//Returns modified base stats
protected function modStrength():int{
	var modStrength:Number = 0;
	modStrength += statusWellFedPower;
	modStrength += statusSTRBuffPower;
	modStrength += WEA.strBuff;
	modStrength += ARM.strBuff;
	return modStrength;
}
protected function modSpeed():int{
	var modSpeed:Number = 0;
	modSpeed += statusWellFedPower;
	modSpeed += statusAGIBuffPower;
	modSpeed += WEA.agiBuff;
	modSpeed += ARM.agiBuff;
	return modSpeed;
}
protected function modEndurance():int{
	var modEndurance:Number = 0;
	modEndurance += statusWellFedPower;
	modEndurance += statusENDBuffPower;
	modEndurance += WEA.endBuff;
	modEndurance += ARM.endBuff;
	return modEndurance;
}
protected function modIntelligence():int{
	var modIntelligence:Number = 0;
	modIntelligence += statusWellFedPower;
	modIntelligence += statusINTBuffPower;
	modIntelligence += WEA.intBuff;
	modIntelligence += ARM.intBuff;
	return modIntelligence;
}
protected function modStomach():int{
	var modStomach:Number = 0;
	modStomach += statusSTOBuffPower;
	return modStomach;
}
protected function modMana():int{
	var modMana:Number = 0;
	modMana += statusMANABuffPower;
	modMana += WEA.manaBuff;
	modMana += ARM.manaBuff;
	return modMana;
}
protected function modHealth():int{
	var modHealth:Number = 0;
	modHealth += WEA.healthBuff;
	modHealth += ARM.healthBuff;
	return modHealth;
}

//Returns temporary combat stat changes
protected function tempStrength():int{
	var tempStrength:Number = 0;
	tempStrength += tenemySTRdebuff;
	tempStrength += tmagicSTRbuff;
	return tempStrength;
}
protected function tempSpeed():int{
	var tempSpeed:Number = 0;
	tempSpeed += tenemyAGIdebuff;
	tempSpeed += tmagicAGIbuff;
	return tempSpeed;
}
protected function tempEndurance():int{
	var tempEndurance:Number = 0;
	tempEndurance += tenemyENDdebuff;
	tempEndurance += tmagicENDbuff;
	return tempEndurance;
}
protected function tempIntelligence():int{
	var tempIntelligence:Number = 0;
	tempIntelligence += tenemyINTdebuff;
	tempIntelligence += tmagicINTbuff;
	return tempIntelligence;
}
protected function tempStomach():int{
	var tempStomach:Number = 0;
	tempStomach += tenemySTOdebuff;
	tempStomach += tmagicSTObuff;
	return tempStomach;
}

//Increases/decreases health and makes sure it's within bounds
protected function doHealth(ID:int):void{
	HEA += ID;
	
	if(inCombat()){
		if(ID > 0){scene("\n\t<i>(Health +"+ID+")</i>",false);}
		if(ID < 0){scene("\n\t<i>(Health "+ID+")</i>",false);}
	}
	
	if(ID > 0){doArrow("HEAup");}
	if(ID < 0){doArrow("HEAdown");}
	
	//prevents health from going over your maximum HP or below 0
	if(HEA > maxHEA){HEA = maxHEA;}
	if(HEA < 0){HEA = 0;}
	
	//Updates health bar collor
	if(HEA/bmaxHEA <= 2/3){healthBar.fill = new SolidColor(0xff9900, 1);}
	if(HEA/bmaxHEA <= 1/3){healthBar.fill = new SolidColor(0x550000, 1);}
	if(HEA/bmaxHEA > 2/3){healthBar.fill = new SolidColor(0x005500, 1);}
	
	//Updates health bar size
	if(bmaxHEA > 0){HEAbarScale = HEA / bmaxHEA;}
	if(bmaxHEA <= 0){HEAbarScale = 0;}
}

//Increases/decreases enemy health, makes sure they don't go over their max health, and displays a status message
protected function doEnemyHealth(ID:int):void{
	
	//Prevents enemy from being healed for more health than they're missing
	if(eHEA + ID > enemyt.maxHEA){ ID = enemyt.maxHEA - eHEA; }
	
	eHEA += ID;
	
	if(ID > 0){scene("\n\t<i>(Enemy health +"+ID+")</i>",false);}
	if(ID < 0){scene("\n\t<i>(Enemy health "+ID+")</i>",false);}
	
	//Prevents enemy health from going above it's maximum HP or below 0
	if(eHEA > enemyt.maxHEA){eHEA = enemyt.maxHEA;}
	if(eHEA < 0){eHEA = 0;}
}

//Increases/decreases mana and makes sure it's within bounds
protected function doMana(ID:Number):void{
	MANA += ID;
	
	if(ID > 0){doArrow("MANAup");}
	if(ID < 0){doArrow("MANAdown");}
	
	//Prevents mana from going over maximum mana or below 0
	if(MANA > maxMANA){MANA = maxMANA;}
	if(MANA < 0){MANA = 0;}
}

//Updates stats
protected function updateStats():void{
	//Sets your stats based on their base level +/- all relevant modifiers
	STR = bSTR + tempStrength() + modStrength();
	AGI = bAGI + tempSpeed() + modSpeed();
	END = bEND + tempEndurance() + modEndurance();
	INT = bINT + tempIntelligence() + modIntelligence();
	STO = bSTO + tempStomach() + modStomach();
	maxMANA = (bINT * 0.5) + tmaxMANA  + modMana();
	
	//Updates size of the mana bar
	if(maxMANA > 0){MANAbarScale = MANA / maxMANA;}
	if(maxMANA <= 0){MANAbarScale = 0;}
	
	//Prevents any stats from going negative
	if(STR < 0){STR = 0;}
	if(AGI < 0){AGI = 0;}
	if(END < 0){END = 0;}
	if(INT < 0){INT = 0;}
	if(STO < 0){STO = 0;}
	if(maxMANA < 0){maxMANA = 0;}
	
	//Updates how full the player should be
	fixFull();
	
	if (FUL > 100){
		//Reduces health when over 100% full
		tmaxHEA = ((maxFUL - FUL) / (maxFUL - 100)) * (bmaxHEA + modHealth());
		if (tmaxHEA < 0){tmaxHEA = 0}
		maxHEA = tmaxHEA;
		
		//Updates bar coloring and size
		fullnessBar.fill = new SolidColor(0xff9900, 1);
		if(FUL > 120){fullnessBar.fill = new SolidColor(0x550000, 1);}
		
		//updates fullnes bar size
		FULbarScale = 1;
	}
	if (FUL <= 100){
		maxHEA = bmaxHEA + modHealth();
		
		//Updates bar coloring
		fullnessBar.fill = new SolidColor(0x005500, 1);
		
		//updates fullness bar size
		FULbarScale = FUL/100;
	}
	
	//Updates stat bar colors based on whether they're above/below/at their default value
	if(STR < bSTR){strColor = uint(0x550000);}
	if(AGI < bAGI){agiColor = uint(0x550000);}
	if(END < bEND){endColor = uint(0x550000);}
	if(INT < bINT){intColor = uint(0x550000);}
	if(STO < bSTO){stoColor = uint(0x550000);}
	if(maxHEA < bmaxHEA){healthColor = uint(0x550000);}
	if(maxMANA < int(bINT * 0.5)){manaColor = uint(0x550000);}
	
	if(STR > bSTR){strColor = uint(0x005500);}
	if(AGI > bAGI){agiColor = uint(0x005500);}
	if(END > bEND){endColor = uint(0x005500);}
	if(INT > bINT){intColor = uint(0x005500);}
	if(STO > bSTO){stoColor = uint(0x005500);}
	if(maxHEA > bmaxHEA){healthColor = uint(0x005500);}
	if(maxMANA > int(bINT * 0.5)){manaColor = uint(0x005500);}
	
	if(STR == bSTR){strColor = uint(0x000000);}
	if(AGI == bAGI){agiColor = uint(0x000000);}
	if(END == bEND){endColor = uint(0x000000);}
	if(INT == bINT){intColor = uint(0x000000);}
	if(STO == bSTO){stoColor = uint(0x000000);}
	if(maxHEA == bmaxHEA){healthColor = uint(0x000000);}
	if(maxMANA == int(bINT * 0.5)){manaColor = uint(0x000000);}
	
	//Prevents stats from going out of bounds
	if (GLD < 0){GLD = 0;}
	if (HEA > maxHEA){HEA = maxHEA;}
	if (HEA < 0){HEA = 0;}
	if (MANA > maxMANA){MANA = maxMANA;}
	if (MANA < 0){MANA = 0;}
	if (STA > 100){STA = 100;}
	if (STA < 0){STA = 0;}
	
	//Updates health bar color
	if(HEA/bmaxHEA <= 2/3){healthBar.fill = new SolidColor(0xff9900, 1);}
	if(HEA/bmaxHEA <= 1/3){healthBar.fill = new SolidColor(0x550000, 1);}
	if(HEA/bmaxHEA > 2/3){healthBar.fill = new SolidColor(0x005500, 1);}
	
	//Updates health bar size
	if(bmaxHEA > 0){HEAbarScale = HEA / bmaxHEA;}
	if(bmaxHEA <= 0){HEAbarScale = 0;}

}

//Recalculates how full you should be
protected function fixFull():void{
	ATE = Eaten + Drank + Inflated;
	FUL = (ATE / STO) * 100;
	
	//Tests whether you clothes should pop off or not and displays the relevant descriptions
	if (waistDiameter() > TOP.Expand && TOP.Popped == false && TOP.Expand > 0){
		scene("<i>"+TOP.Popoff+"</i>",false);
		TOP.Popped = true;
	}
	if (waistDiameter() > BTM.Expand && BTM.Popped == false && BTM.Expand > 0){
		scene("<i>"+BTM.Popoff+"</i>",false);
		BTM.Popped = true;
	}
}

//Removes up and down arrows
protected function removeArrows():void{
	strengthUpArrow.visible=false;
	speedUpArrow.visible=false;
	enduranceUpArrow.visible=false;
	intelligenceUpArrow.visible=false;
	healthUpArrow.visible=false;
	manaUpArrow.visible=false;
	staminaUpArrow.visible=false;
	fullnessUpArrow.visible=false;
	fatnessUpArrow.visible=false;
	
	strengthDownArrow.visible=false;
	speedDownArrow.visible=false;
	enduranceDownArrow.visible=false;
	intelligenceDownArrow.visible=false;
	healthDownArrow.visible=false;
	manaDownArrow.visible=false;
	staminaDownArrow.visible=false;
	fullnessDownArrow.visible=false;
	fatnessDownArrow.visible=false;
}

//Displays arrows based on input
protected function doArrow(stat:String):void{
	switch(stat){
		case "STRup":
			strengthUpArrow.visible = true;
			break;
		case "SPDup":
			speedUpArrow.visible = true;
			break;
		case "ENDup":
			enduranceUpArrow.visible = true;
			break;
		case "INTup":
			intelligenceUpArrow.visible = true;
			break;
		case "FULup":
			fullnessUpArrow.visible = true;
			break;
		case "HEAup":
			healthUpArrow.visible=true;
			break;
		case "MANAup":
			manaUpArrow.visible=true;
			break;
		case "STAup":
			staminaUpArrow.visible=true;
			break;
		case "FATup":
			fatnessUpArrow.visible=true;
			break;
		case "STRdown":
			strengthUpArrow.visible = false;
			strengthDownArrow.visible = true;
			break;
		case "SPDdown":
			speedUpArrow.visible = false;
			speedDownArrow.visible = true;
			break;
		case "ENDdown":
			enduranceUpArrow.visible = false;
			enduranceDownArrow.visible = true;
			break;
		case "INTdown":
			intelligenceUpArrow.visible = false;
			intelligenceDownArrow.visible = true;
			break;
		case "FULdown":
			fullnessUpArrow.visible = false;
			fullnessDownArrow.visible = true;
			break;
		case "HEAdown":
			healthUpArrow.visible=false;
			healthDownArrow.visible=true;
			break;
		case "MANAdown":
			manaUpArrow.visible=false;
			manaDownArrow.visible=true;
			break;
		case "STAdown":
			staminaUpArrow.visible=false;
			staminaDownArrow.visible=true;
			break;
		case "FATdown":
			fatnessUpArrow.visible=false;
			fatnessDownArrow.visible=true;
			break;
	}
}

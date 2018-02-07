import valueObjects.Spells;

//Displays the input spell's description
protected function spellDescription(ID:Spells):void{
	
	//Displays spell's basic description
	scene("<b>"+capFirst(ID.name)+":</b> " +
		"\n\t"+ID.description +
		"\n\t<i>"+ID.manaCost+" mana. ",false);
	
	//Says when a spell is castable
	if(ID.castableCombat && ID.castableOOC == false){scene("Castable in combat. ",false);}
	if(ID.castableOOC && ID.castableCombat == false){scene("Castable out of combat. ",false);}
	if(ID.castableCombat && ID.castableOOC){scene("Castable in or out of combat. ",false);}
	
	//Says much damage the spell does
	var spellScaling:Number = 0.4;
	if(WEA.damageStat == "INT" && WEA.damageScaling > spellScaling){spellScaling = WEA.damageScaling;}
	switch(ID.spellType){
		case "attack":
			scene("\n\t",false);
			if(ID.damage > 0){scene("Deals "+ID.damage+"d"+ID.damageRange+" +"+spellScaling * 100+"% INT damage. ",false);}
			
			//lists the spell's special effects
			switch(ID.statusEffect){
				case "burn":
					scene("Has a chance to burn your enemy, causing damage over time for "+ID.statusTime+" turn(s). Cancels out the soak effect. ",false);
					break;
				case "stun":
					scene("Has a chance to stun your enemy, causing it to sometimes be unable to attack "+ID.statusTime+" turn(s). ",false);
					break;
				case "slow":
					scene("Has a chance to slow your enemy, causing it to act last in combat for "+ID.statusTime+" turn(s). ",false);
					break;
				case "soak":
					scene("Soaks your enemy in water, causing them to be weak to lightning attacks for "+ID.statusTime+" turn(s). Cancels out the burn effect. ",false);
					break;
			}
			break;
		case "heal":
			scene("\n\tHeals "+ID.damage+"d"+ID.damageRange+" +"+spellScaling+"% INT damage. ",false);
			break;
		case "buff":
			//lists the spell's special effects
			switch(ID.buffStat){
				case "REGEN":
					scene("\n\tRegenerates "+ID.damage+"d"+ID.damageRange+" +"+spellScaling+"% INT health for "+ID.buffAmount+" rounds/"+ID.buffAmount+"0 minutes. ",false);
					break;
				case "DODGE":
					scene("\n\tIncreases your chance of you dodging attacks by "+ID.buffAmount+"%. ",false);
					break;
				default:
					scene("\n\tIncreases "+ID.buffStat+" by "+ID.buffAmount+". ",false);
					break;
			}
			break;
	}
	scene("</i>",false);
}

//Displays your known spells
protected function doSpells():void{
	updateStats();
	clearView();
	appView(0);
	
	//Stores which spell you've selected to cast
	var tempSpell:Spells;
	
	//Sorts your spell list alphabetically
	spellArray.sortOn("name",Array.CASEINSENSITIVE);
	
	//Moves you to the correct state based on wether you're in combat or not
	if (currentState == "combat"){currentState = "combatSpells";}
	if (currentState != "combat" && currentState != "combatSpells"){currentState = "spells";}
	invView(1);
	
	listen = function():void{
		if (btnchc > 0 && btnchc < 10 && spellArray[(btnchc - 1)+((spellPage-1)*9)] != null){
			
			//Selects the spell you've clicked on and asks if you want to cast the spell
			tempSpell = spellArray[(btnchc - 1)+((spellPage-1)*9)];
			if(currentState == "combatSpells"){
				combatDialogue();
				if(tempSpell.castableCombat){btntxt(11,"Cast");}
				else{clearDecisionView();}
			}
			if(currentState == "spells"){
				scene("",true);
				if(tempSpell.castableOOC){btntxt(11,"Cast");}
				else{clearDecisionView();}
			}
			spellDescription(tempSpell);
		}
		if(btnchc == 11 && tempSpell != null){
			//Casts the spell you've selected
			clrchc();
			if(tempSpell.manaCost <= MANA){
				if(currentState != "combatSpells"){playerCast(tempSpell);}
				else{combatCast(tempSpell);}
			}
			else{ if(eventText.htmlText.match("Not enough mana") == null){scene("\nNot enough mana! ",false);} }
		}
	}
	spellButtons();
}

//Writes spells to buttons based on page number
protected function spellButtons():void{
	for(i = ((spellPage - 1) * 9) + 1;i <= spellPage * 9;i++){
		var tempSpell:Spells = spellArray[i - 1];
		if(tempSpell != null){
			buttonIcons(i,null);
			writeSpells(i,tempSpell);
		}
	}
}

//Writes the spells' names
protected function writeSpells(slot:int,ID:Spells):void{
	if(slot > 9){slot %= 9}
	if(slot == 0){slot = 9}
	btntxt(slot,capFirst(ID.name));
}

//Adds the input spell to your spell book if you don't know it already
protected function spellLearn(ID:Spells):void{
	if(spellFind(ID) == -1){
		var spellReceived:Spells = ObjectUtil.copy(ID) as Spells;
		spellArray.push(spellReceived);
	}
}

//Returns wether you know a spell a not
protected function spellKnown(ID:Spells):Boolean{
	if(spellFind(ID) > -1){return true;}
	else{return false;}
}

//Returns the index of the input spell. If you don't knwo the spell then it returns an index of -1
protected function spellFind(ID:Spells):Number{
	var spellIndex:int = -1;
	for(i=0;i<spellArray.length;i++){
		var testSpell:Spells = spellArray[i];
		if(testSpell.name == ID.name){spellIndex = i;}
	}
	return spellIndex;
}

//Displays spell teacher buttons/dialogue
protected function doTeaching(ID:Vendors):void{
	Vendor = ObjectUtil.copy(ID) as Vendors;
	Vendor.StoreExit = ID.StoreExit;
	scene(Vendor.Buying+"\n",true);
	clearView();
	leaveButton(12);
	
	//Removes known spells from spells you can try to learn
	for(var j:int=Vendor.vendArray.length;j > 0;j--){
		var tempRemoveSpell:Spells = Vendor.vendArray[j-1];
		if(spellFind(tempRemoveSpell) != -1){Vendor.vendArray.splice(j-1,1);}
	}
	
	//Removes spells you're too dumb to learn
	Vendor.vendArray.sortOn("requirementINT",Array);
	for(i=1;i <= 9 && i <= Vendor.vendArray.length;i++){
		var tempVendSpell:Spells = Vendor.vendArray[i-1];
		if(tempVendSpell.requirementINT <= bINT){ btntxt(i,capFirst(tempVendSpell.name)); }
		scene("\n",false)
		spellDescription(tempVendSpell);
		scene("\n\t"+tempVendSpell.Value+" gold, "+tempVendSpell.requirementINT+" INT",false)
	}
	
	//Response based on what spells your character knows
	if(buttonVisible1 == false){
		scene("\n\n",false);
		if(Vendor.vendArray.length == 0){scene(Vendor.allKnown,false);}
		else{scene(Vendor.lowINT,false);}
	}
	
	//Creates buttons for you to click on to learn that spell. 
	listen = function():void{
		if(btnchc > 0 && btnchc < 10){
			var tempLearnSpell:Spells = Vendor.vendArray[btnchc -1];
			if(GLD > tempLearnSpell.Value){
				spellLearn(tempLearnSpell);
				doTeaching(Vendor);
				scene("\n"+Vendor.Bought,false);
				doGold(-tempLearnSpell.Value);
				doTime(30);
			}
			else{
				doTeaching(Vendor);
				scene("\n"+Vendor.NoMoney,false);
			}
		}
		if(btnchc == 12){
			doEvent(Vendor.StoreExit);
			scene(Vendor.Leaving,true);
		}
	}
	
}


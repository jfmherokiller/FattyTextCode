//Calculates the damage you should do with a basic attack
protected function doDMG():void{
	
	//Sets your weapons scaling based on the type of weapon and your stats
	var tempStat:int = STR;
	var tempScale:Number = 0.4;
	if(WEA.damageStat != null){		
		switch(WEA.damageStat){
			case "AGI":
				tempStat = AGI;
				break;
			case "INT":
				tempStat = INT;
				break;
			default:
				tempStat = STR;
				break;
		}
	}
	//I don't really remember why this is here, but apparently it also adds damage scaling from your armor
	if(WEA.damageScaling > 0){
		tempScale = WEA.damageScaling;
		if(WEA.damageStat == ARM.damageStat){tempScale += ARM.damageScaling;}
	}
	
	//Calculates the base damage you should do based on the weapon damage, scaling, your stats, and the enemy's defense
	DMG = xdy(WEA.WEAd,WEA.WEAr) + (tempStat * tempScale) - enemyt.DEF;
	
	//Adds weakness/resistance multipliers to your base damage
	if(WEA.damageType != null){
		var damageMultiplier:Number = 1;
		//Damage resistance multiplier
		if(enemyt.damageResistance.length > 0){
			for(i=0;i<enemyt.damageResistance.length;i++){
				var testResistance:DamageType = enemyt.damageResistance[i];
				if(testResistance.name == WEA.damageType.name){damageMultiplier /= 1.5;}
			}
		}
		//Damage weakness multiplier
		if(enemyt.damageWeakness.length > 0){
			for(i=0;i<enemyt.damageWeakness.length;i++){
				var testWeakness:DamageType = enemyt.damageWeakness[i];
				if(testWeakness.name == WEA.damageType.name){damageMultiplier *= 1.5;}
			}
		}
		//Multiplies your damage based on previous weakness/resistance calculations
		DMG *= damageMultiplier;
	}
	
	//Prevents the player from doing negative damage to enemies
	if(DMG < 0){DMG = 0;}
}

//Attack your enemy with your equipped weapon
protected function playerAttack():void{
	if (inCombat()){
		scene("<li><b>Attack</b></li>",false);
		
		//Calculates the damage you should do
		doDMG();
		
		//Displays the appropriate scene for the weapon you attacked with
		if(WEA.attackDescription != "Attack error"){scene(WEA.attackDescription,false);}
		if(WEA.attackDescription == "Attack error"){scene("You hit your enemy with your "+WEA.Name+", ",false);}
		scene("dealing "+DMG+" damage. ",false);
		
		//Tests to see if your weapon matches the enemies weaknesses/resistances
		if(WEA.damageType != null){testEffectiveness(WEA.damageType);}
		
		//Applies the weapon's special effects where applicable
		if(DMG > 0){
			switch(WEA.attackProc){
				case "stun":
					if(d100() < WEA.attackProcChance){
						scene("Your opponent has becomed stunned! ",false);
						eStatusStunTime = WEA.attackProcPower;
					}
					break;
				case "drain":
					if(d100() < WEA.attackProcChance){
						scene("The "+WEA.Name+" draws life from them! ",false);
						doHealth( DMG * (WEA.attackProcPower / 100) );
					}
					break;
			}
		}
		
		//Applies the results of your attack
		doEnemyHealth(-DMG);
		doStamina(-3);
		if(eHEA <= 0){winBattle(enemyt.victory);}
	}
}

//Tests an attack's effectiveness and displays the appropriate scene for it
protected function testEffectiveness(ID:DamageType):void{
	var damageText:String = "";
	
	//Damage resisted message
	if(enemyt.damageResistance.length > 0){
		for(i=0;i<enemyt.damageResistance.length;i++){
			var testResistance:DamageType = enemyt.damageResistance[i];
			if(testResistance.name == ID.name){damageText = "It's not very effective. ";}
		}
	}
	
	//Damage weakness message
	if(enemyt.damageWeakness.length > 0){
		for(i=0;i<enemyt.damageWeakness.length;i++){
			var testWeakness:DamageType = enemyt.damageWeakness[i];
			if(testWeakness.name == ID.name){damageText = "It's super effective! ";}
		}
	}
	
	//displays the appropriate scene based on the precious calculations
	scene(damageText,false);
}

//Calculates the damage for the input spell. Some stat affecting spells use this calculation to decide how much to affect a stat
protected function doSpellDMG(ID:Spells):void{
	
	//Applies the intelligence modifier of your equipped weapon when applicaplble
	var castModifier:Number = 0.4;
	if(WEA.damageStat == "INT" && WEA.damageScaling > castModifier){castModifier = WEA.damageScaling;}
	DMG = xdy(ID.damage,ID.damageRange)+(INT * castModifier);
	
	//Calculates damage multipliers based on weakness/resistances
	if(ID.damageType != null){
		var damageMultiplier:Number = 1;
		//Damage resistance multiplier
		if(enemyt.damageResistance.length > 0){
			for(i=0;i<enemyt.damageResistance.length;i++){
				var testResistance:DamageType = enemyt.damageResistance[i];
				if(testResistance.name == ID.damageType.name){damageMultiplier /= 1.5;}
			}
		}
		//Damage weakness multiplier
		if(enemyt.damageWeakness.length > 0){
			for(i=0;i<enemyt.damageWeakness.length;i++){
				var testWeakness:DamageType = enemyt.damageWeakness[i];
				if(testWeakness.name == ID.damageType.name){damageMultiplier *= 1.5;}
			}
		}
		DMG *= damageMultiplier;
	}
	
	//Prevents damage from being negative
	if(DMG < 0){DMG = 0;}
}

//Equation for healing done by the input spell
protected function doSpellHeal(ID:Spells):void{
	DMG = xdy(ID.damage,ID.damageRange)+(INT * 0.4);
	if(DMG < 0){DMG = 0;}
}

//Casts a spell in combat and allows your opponent to attack for the round
protected function combatCast(ID:Spells):void{
	if(currentState == "combatSpells"){currentState = "combat";}
	
	//Tests who should act first in combat this round
	switch(INT >= enemyt.INT || enemySlowEffect()){
		case true:
			if(playerStatusEffect() == false){playerCast(ID);}
			scene("\n", false);
			if(eHEA > 0 && enemyStunEffect() == false){enemyAttack();}
			break;
		default:
			if(enemyStunEffect() == false){enemyAttack();}
			scene("\n", false);
			if(grapple <= 0 && inCombat()){ if(playerStatusEffect() == false){playerCast(ID);} }
			break;
	}
	
	//If you're still in combat after the results of the case spell, then the appropriate combat buttons are displayed
	if(inCombat()){combatButtons();}
}

//Casts the input spell
protected function playerCast(ID:Spells):void{
	//displays the appropriate scene based on whether you're in combat or not
	if(inCombat()){
		combatDialogue();
		scene("<li><b>Spell: "+capFirst(ID.name)+"</b></li>",false);
	}
	if(!inCombat()){scene("",true);}
	
	
	switch(ID.spellType){
		case "attack":
			//Activates effect of damaging spells
			if(ID.damage > 0){
				doSpellDMG(ID);
				scene(ID.descriptionCast+"dealing "+DMG+" damage. ",false);
				doEnemyHealth(-DMG);
				testEffectiveness(ID.damageType);
			}
			
			//Activates effect of Debuff spells
			if(ID.damage == 0){ scene(ID.descriptionCast,false); }
			
			//Activates effect of Status effecting spells
			switch(ID.statusEffect){
				case "burn":
					if(d100() < 25){
						scene("Your opponent has become burnt! ",false);
						eStatusBurnPower = DMG * 0.2;
						eStatusBurnTime = ID.statusTime;
						if(eStatusSoakTime > 0){
							scene("Which has unfortunately stopped them from being soaked. ",false);
							eStatusSoakTime = 0;
							enemyt.damageWeakness.splice(enemyt.damageWeakness.indexOf(LightningDamage),1);
						}
					}
					break;
				case "stun":
					if(d100() < 20){
						scene("Your opponent has becomed stunned! ",false);
						eStatusStunTime = ID.statusTime;
					}
					break;
				case "slow":
					if(d100() < 30){
						scene("Your opponent has become slowed! ",false);
						eStatusSlowTime = ID.statusTime;
					}
					break;
				case "soak":
					scene("Your opponent has become soaked with water! ",false);
					eStatusSoakTime = ID.statusTime;
					if(eStatusBurnPower > 0){
						scene("Which has unfortunately stopped them from burning. ",false);
						eStatusBurnPower = 0;
						eStatusBurnTime = 0;
					}
					enemyt.damageWeakness.push(LightningDamage);
					break;
			}
			break;
		
		//Activates effect of healing spells
		case "heal":
			doSpellDMG(ID);
			scene(ID.descriptionCast+"restoring "+DMG+" health. ",false);
			doHealth(DMG);
			break;
		
		//Activates effect of buffing spells
		case "buff":
			scene(ID.descriptionCast,false);
			switch(ID.buffStat){
				case "STR":
					if(tmagicSTRbuff < ID.buffAmount){
						scene("increasing your "+ID.buffStat+" by "+ID.buffAmount+". ",false);
						tmagicSTRbuff = ID.buffAmount;
					}
					else{scene("but your "+ID.buffStat+" has already been raised by magical means. ",false);}
					break;
				case "INT":
					if(tmagicINTbuff < ID.buffAmount){
						scene("increasing your "+ID.buffStat+" by "+ID.buffAmount+". ",false);
						tmagicINTbuff = ID.buffAmount;
					}
					else{scene("but your "+ID.buffStat+" has already been raised by magical means. ",false);}
					break;
				case "END":
					if(tmagicENDbuff < ID.buffAmount){
						scene("increasing your "+ID.buffStat+" by "+ID.buffAmount+". ",false);
						tmagicENDbuff = ID.buffAmount;
					}
					else{scene("but your "+ID.buffStat+" has already been raised by magical means. ",false);}
					break;
				case "AGI":
					if(tmagicAGIbuff < ID.buffAmount){
						scene("increasing your "+ID.buffStat+" by "+ID.buffAmount+". ",false);
						tmagicAGIbuff = ID.buffAmount;
					}
					else{scene("but your "+ID.buffStat+" has already been raised by magical means. ",false);}
					break;
				case "STO":
					if(tmagicSTObuff < ID.buffAmount){
						scene("increasing your "+ID.buffStat+" by "+ID.buffAmount+". ",false);
						tmagicSTObuff = ID.buffAmount;
					}
					else{scene("but your "+ID.buffStat+" has already been raised by magical means. ",false);}
					break;
				case "DEF":
					if(tmagicDEFbuff < ID.buffAmount){
						scene("increasing your defense by "+ID.buffAmount+". ",false);
						tmagicDEFbuff = ID.buffAmount;
					}
					else{scene("but your defense has already been raised by magical means. ",false);}
					break;
				case "REGEN":
					if(tmagicREGENbuff < ID.buffAmount){
						tmagicREGENbuff = ID.buffAmount;
						tmagicREGENbuffDamage = ID.damage;
						tmagicREGENbuffRange = ID.damageRange;
						doSpellDMG(ID);
						doHealth(DMG);
					}
					break;
				case "DODGE":
					if(tmagicDODGEbuff < ID.buffAmount){
						scene("increasing your chance of dodging by "+ID.buffAmount+"%. ",false);
						tmagicDODGEbuff = ID.buffAmount;
					}
					else{scene("but your evasion has already been raised by magical means. ",false);}
					break;
			}
			break;
		
		//Activates effect of any other spells not previously covered
		case "other":
			scene(ID.descriptionCast,false);
			switch(ID.name){
			}
			break;
	}
	
	//Charges you mana for casting the input spell
	MANA -= ID.manaCost;
	updateStats();
	
	//If your spell defeted the opponent, then you win!
	if (currentState == "combat" && eHEA <= 0){winBattle(enemyt.victory);}
}

//Activates the effect of your opponent being slowed
protected function enemySlowEffect():Boolean{
	var slowed:Boolean = false;
	if(eStatusSlowTime > 0 && inCombat()){
		slowed = true;
		//Ticks down the slow timer
		eStatusSlowTime--;
		if(eStatusSlowTime <= 0){
			//Removes the slow effect and displays a scene to reflect this
			eStatusSlowTime = 0;
			scene("<i>Your opponent is no longer slowed.</i> ",false);
		}
	}
	//Returns wether your opponent was affected by slow or not
	return slowed;
}

//Activates the effect of your opponent being burned. Also activates the soak effect because I'm lazy and they're both checked at the same point anyway
protected function enemyBurnEffect():void{
	
	if(eStatusBurnPower > 0 && eStatusBurnTime > 0 && inCombat()){
		scene("<li><i>Burn</i></li>" +
			"\tYour opponent burns for "+eStatusBurnPower+" damage. ",false);
		doEnemyHealth(-eStatusBurnPower);
		//ticks down the burn timer
		eStatusBurnTime--;
		if(eStatusBurnTime <= 0){
			//Removes the burn effect and displays a scene to reflect this
			eStatusBurnTime = 0;
			eStatusBurnPower = 0;
			scene("<i>Your opponent is no longer burning.</i> ",false);
		}
		//If the burn effect defeated your opponent, then you win!
		if(eHEA <= 0){winBattle(enemyt.victory);}
	}
	
	//Activates the soak effect
	if(eStatusSoakTime > 0 && inCombat()){
		//ticks down soak timer
		eStatusSoakTime--;
		if(eStatusSoakTime <= 0){
			//removes soak effect and displays a scene to reflect this
			eStatusSoakTime = 0;
			enemyt.damageWeakness.splice(enemyt.damageWeakness.indexOf(LightningDamage),1);
			scene("<i>Your opponent has shaken off most of the water from your spell.</i> ",false);
		}
	}
}

//Does the effect of your opponent being stunned
protected function enemyStunEffect():Boolean{
	var stunned:Boolean = false;
	if(eStatusStunTime > 0 && inCombat()){
		if(d100() < 34){
			scene("<li><i>Stunned</i></li>" +
				"Your enemy is too stunned to attack! ",false);
			eStatusStunTime--;
			stunned = true;
			if(eStatusStunTime <= 0){
				eStatusStunTime = 0;
				scene("<i>Your opponent seems to be shaking off the effects of the stun though.</i> ",false);
			}
		}
	}
	return stunned;
}

//Activates the status effects on the player
protected function playerStatusEffect():Boolean{
	
	//Tracks wether the player should be stunned from any of the followoing status effects
	var incapacitated:Boolean = false;
	
	if(inCombat()){
		//Regeneration effect
		if(tmagicREGENbuff > 0){
			var tempRegen:int = xdy(tmagicREGENbuffDamage,tmagicREGENbuffRange) + (INT * 0.4);
			scene("<li><b><i>Regeneration</i></b></li>" +
				"Your regenerate "+tempRegen+" health! ",false);
			doHealth(tempRegen);
			tmagicREGENbuff--;
			if(tmagicREGENbuff <= 0){
				tmagicREGENbuff = 0;
				tmagicREGENbuffDamage = 0;
				tmagicREGENbuffRange = 0;
				scene("<i>The healing effects surrounding you have begun to fade though.</i> ",false);
			}
		}
		
		//Stun effect
		if(pStatusStunTime > 0){
			if(d100() < 51){
				scene("<li><b><i>Stunned</i></b></li>" +
					"You were too stunned to act! ",false);
				pStatusStunTime--;
				incapacitated = true;
				if(pStatusStunTime <= 0){
					pStatusStunTime = 0;
					scene("<i>You finally shake off the effects of the stun though.</i> ",false);
				}
			}
		}
		
		//Burn effect
		if(statusBurnPower > 0){
			scene("<li><b><i>Burn</i></b></li>" +
				"You take "+statusBurnPower+" damage from the flames. ",false);
			doHealth(-statusBurnPower);
			statusBurnPower--;
			if(statusBurnPower <= 0){
				statusBurn = 0;
				statusBurnPower = 0;
				scene("<i>You finally stop burning though.</i> ",false);
			}
			if(HEA <= 0){incapacitated = true;}
		}
		
		//Bloat venom effect
		if(statusBloatVenomPower > 0){
			scene("<li><b><i>Bloat Venom</i></b></li>" +
				"Your stomach gurgles as you feel pressure as if you had just eaten a meal. ",false);
			doInflate(statusBloatVenomPower,0);
			statusBloatVenomPower--;
			if(statusBloatVenomPower <= 0){
				statusBloatVenom = 0;
				statusBloatVenomPower = 0;
				scene("<i>Fortunately, your head no longer feels fuzzy and it seems you're finally over the effect's of the bloat venom.</i> ",false);
			}
			if(HEA <= 0){incapacitated = true;}
		}
	}
	
	return incapacitated;
}

//Attempts to devour your enemy
protected function playerVore():void{
	//Skill check to see if you succeed in hitting your enemy with the vore attack
	switch(testSkillRange(AGI+STR+INT+50,enemyt.AGI+enemyt.STR+enemyt.INT+(eHEA * .5),0,90)){
		case false:
			//Vore attempt missed
			voreing = false;
			scene("Vore attempt missed. ",false);
			scene("\n",false);
			break;
		
		/*default vore template
		enemy name
			scene describing your attemp to eat the enemy
				game tests to see if you survived consuming the enemy
					if you survive, you win the fight and gain calories for devouring your enemy
					if you explode, you lose the fight
		*/
		
		case true:
			//Consumes the enemy without displaying any fullness descriptions or gaining any calories. 
			//Used to test if you can survive eating the enemy without exploding before continuing with the description
			doConsumeQuiet(enemyt.weight,0,0);
			voreing = true;
			
			//The list of enemy voreing descriptions goes here
			switch(enemy){
				
			}
			break;
		
		//End of voreing descriptions
	}
}


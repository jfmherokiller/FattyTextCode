import mx.utils.ObjectUtil;

import valueObjects.Items;

//Rolls up how much damage the opponent should do with an attack 
//(note that the damage is not dealt, the variable is just set for how much damage should be dealt)
protected function doeDMG():void{
	var damageStat:int = 0;
	switch(enemyt.attackStat){
		case "AGI":
			damageStat = enemyt.AGI;
			break;
		case "INT":
			damageStat = enemyt.INT;
			break;
		default:
			damageStat = enemyt.STR;
			break;
	}
	eDMG = dXY(damageStat*.8,damageStat*1.2) - ARM.Defense - tmagicDEFbuff;
	if(eDMG < 0){eDMG = 0;}
}

//Rolls up the damage for an enemy casting the input spell
protected function doeSpellDMG(ID:Spells):void{
	eDMG = xdy(ID.damage,ID.damageRange)+(enemyt.INT * 0.4);
	if(eDMG < 0){eDMG = 0;}
}

//Causes the enemy to cast the input spell
protected function enemyCast(ID:Spells):void{
	switch(ID.spellType){
		case "attack":
			doSpellDMG(ID);
			doHealth(-eDMG);
			break;
		case "heal":
			doSpellDMG(ID);
			doEnemyHealth(eDMG);
			break;
	}
	eMANA -= ID.manaCost;
	updateStats();
}

//Rolls up your character's dodge chance and returns whether they succeeded in dodging or not
protected function dodge():Boolean{ 
	return testSkillRange(AGI + INT + modDodge(),enemyt.AGI + enemyt.INT,5,75); 
}

//Calculates any modifiers to your dodge chance from buffs
protected function modDodge():Number{
	var tempDodge:Number = 0;
	tempDodge += tmagicDODGEbuff;
	return tempDodge;
}

//Enemy's attack AI//////////////////////////////////
protected function enemyAttack():void{
	if (inCombat()){
		
		//Records starting health. Used at the end of the function to see if the player gained or lost health and displays the appropriate health arrow on screen
		var startingHEA:int = HEA;
		
		//Rolls up the damage an enemy's attack is going to do (although not all attacks will event use this number)
		doeDMG();
		
		//Records whether the enemy attacked or not. Used for various enemies who have multiple "attacks" in a row
		var enemyAttacked:Boolean = false;
		
		//Based on who the enemy is, this looks for that enemy's AI and runs it
		//Enemies are listed alphabetically
		switch(enemy){
			
			/*Default enemy AI structure:
			Enemy name
				Test whether the player is surrendering or not
				If not surrendering; tests wether the enemy is grappled or not
					If grappled; then does the grapple attack
					If not grappled; then does a nongrapple attack
						If an attack can be dodged; the game checks wether you dodge or not and resolves the attack accordingly
				Once attacks are completed; checks if the player/enemy is defeated and runs an event if appropriate
			*/
			
		//Default monster attack if it's actual AI hasn't been added in yet
			default:
				scene("The "+enemyt.name+" attacks you, dealing "+eDMG+" damage. ", false);
				doHealth(-eDMG);
				if(!alive()){
					scene("\n\tYou're vision fades to black as you fall unconscious. ",false);
					defeatEvent(battle);
				}
				break;
			
		}
	}
	
	//Resets the surrender tag in case surrendering doesn't actually end the fight for whatever reason
	surrender = false;
	
	//If the attack didn't end the combat, then this displays the normal combat options
	if(inCombat()){combatButtons();}
	
	//Displays health arrows based on if/how your health changed from the attack
	if(startingHEA > HEA){doArrow("HEAdown");}
	if(startingHEA < HEA){doArrow("HEAup");}
	
	//Prevents health from going negative as that can easily mess up several calculations
	if(HEA < 0){HEA = 0;}
}

//import org.hamcrest.collection.hasItem;

import valueObjects.DamageType;
import valueObjects.Enemies;
import valueObjects.Gender;
import valueObjects.Items;
import valueObjects.Species;
import valueObjects.Spells;


//Returns wether your character is in combat or not. Important for how other functions work
protected function inCombat():Boolean{
	if(currentState == "combat" || currentState == "combatInventory"){return true;}
	else{return false;}
}

//Displays the description of your enemy and adds the page break
protected function combatDialogue():void{
	scene("\t"+enemyt.description,true);
	scene("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n",false);
}

//Displays combat buttons
protected function combatButtons():void{
	clearView();
	
	//Attack/struggle button
	if(grapple > 0){btntxt(1,"Struggle");}
	if(grapple <= 0){btntxt(1,"Attack");}
	
	//Item button
	if(grapple <= 0){
		btntxt(2,"Item");
	}
	
	//Run button (if you're capable of running)
	if(enemy.bossOf == null && grapple <= 0){
		btntxt(3,"Run");
	}
	
	//Spells button (if you know any spells)
	if(spellArray.length != 0 && grapple <= 0){
		btntxt(4,"Spells");
	}
	
	//Wait button
	btntxt(5,"Wait");
	
	//Devour button (if enemy is devourable)
	if(enemyt.voreable == true && enemyt.weight <= maximumFullness() && grapple <= 0){
		btntxt(7,"Devour");
	}
	
	//Submit button
	btntxt(8,"Submit");
	
	listen = function():void{
		
		combatDialogue();
		removeArrows();
		
		switch(btnchc){
			case 1:
				//Fight against being grappled
				if(grapple > 0){
					var highestStat:int = STR;
					if(INT > highestStat){highestStat = INT};
					if(AGI > highestStat){highestStat = AGI};
					grapple -= highestStat;
					if(grapple < 0){grapple = 0;}
					
					scene("<li><b>Struggle</b></li>",false);
					switch(grapple){
						case 0:
							combatButtons();
							scene(enemyt.grappleEscapeSucceed+"\n",false);
							playerAttack();
							break;
						default:
							scene(enemyt.grappleEscapeFail+"\n",false);
							if(enemyStunEffect() == false){enemyAttack();}
							enemyBurnEffect();
							break;
					}
				}
				//Attacks with your equipped weapon
				else{
					//Tests wether you or your opponent should go first
					switch(AGI + INT >= enemyt.AGI + enemyt.INT || enemySlowEffect()){
						case true:
							if(playerStatusEffect() == false){playerAttack();}
							scene("\n",false);
							if(eHEA > 0 && enemyStunEffect() == false){enemyAttack();}
							enemyBurnEffect();
							break;
						default:
							if(enemyStunEffect() == false){enemyAttack();}
							enemyBurnEffect();
							scene("\n",false);
							if(HEA > 0 && grapple <= 0 && currentState != "defeated" && playerStatusEffect() == false){playerAttack();}
							break;
					}
				}
				break;
			case 2:
				//Displays your inventory
				doInventory();
				break;
			case 3:
				//Attempt to run from your opponent
				scene("<li><b>Run</b></li>",false);
				switch(enemyt.escapable){
					case true:
						switch(testSkillRange(25 + AGI + INT,enemyt.AGI + enemyt.INT,10,75)){
							case true:
								scene(enemyt.playerEscape,false);
								currentState = "default";
								endCombat();
								nextButton();
								break
							default:
								scene(enemyt.playerEscapeFail+"\n",false);
								if(enemyStunEffect() == false){enemyAttack();}
								enemyBurnEffect();
								break;
						}
						break;
					case false:
						scene(enemyt.playerEscape+"<i>(You can't escape this fight)</i> ",false);
						if(enemyStunEffect() == false){enemyAttack();}
						enemyBurnEffect();
						break;
				}
				break;
			case 4:
				//Displays your spell menu
				doSpells();
				break;
			case 5:
				//Waits for you enemy's attack
				scene("<li><b>Wait</b></li>",false);
				doStamina(15);
				playerStatusEffect();
				if(enemyStunEffect() == false){enemyAttack();}
				enemyBurnEffect();
				break;
			case 7:
				//Attempts to devour your enemy
				scene("<li><b>Devour</b></li>",false);
				if(playerStatusEffect() == false){playerVore();}
				enemyBurnEffect();
				if(inCombat() && eHEA > 0 && enemyStunEffect() == false){enemyAttack();}
				break;
			case 8:
				//Surrender to your opponent
				scene("<li><b>Surrender</b></li>",false);
				surrender = true;
				enemyAttack();
				break;
		}
	}
	//Updates your stats after whatever events happened from that combat round
	updateStats();
}

//Function that starts a combat round
protected function doBattle():void{
	appView(0);
	if (!inCombat()){
		//Does the initial combat setup (probably redundant with the startFight function)
		eHEA = enemyt.maxHEA;
		grapple = 0;
		if(enemyt.introduction != ""){scene(enemyt.introduction,true);}	
		else{scene(enemyt.description,true);}
	}
	if(inCombat()){
		//Once you're in combat it will just display the normal combat message
		combatDialogue();
	}
	voreing = false;
	surrender = false;
	currentState = "combat";
	combatButtons();
}

//Starts the initial fight setup and setups the next button that leads into the fight proper
protected function startFight():void{
	eHEA = enemyt.maxHEA;
	eMANA = enemyt.maxMANA;
	grapple = 0;
	currentState = "combat";
	clearView();
	appView(0);
	btntxt(12,"Fight!");
	listen = function():void{ if(btnchc == 12){doNext();} }
}

//Resets all temporary combat modifiers to their default value
protected function endCombat():void{
	surrender = false;
	voreing = false;
	grapple = 0;
	rmvTempStats();
	eStatusBurnPower = 0;
	eStatusBurnTime = 0;
	eStatusStunTime = 0;
	eStatusSlowTime = 0;
	eStatusSoakTime = 0;
}

//Rewards you for winning a battle and displays the inut victory text
protected function winBattle(winText:String):void{
	scene("<li><u>Victory!</u></li>",false);
	if(winText != ""){scene(winText,false);}
	currentState = "default";
	endCombat();
	doXP(enemyt.XP);
	if(enemyt.GLD > 0){doGold(dXY((enemyt.GLD * 0.8)+1,(enemyt.GLD * 1.2)-1));}
	nextView();
	listen = function():void{
		if(btnchc == 12){
			//If the enemy was part of a larger event, then it will activate the next step in that event, otherwise it does the default end combat function
			if(enemy.bossOf != null){doEvent(enemy.bossOf);}
			if(enemy.bossOf == null){doNext();}	
		}
	}
	//Tests to see if your enemy should drop an item and gives it to the player
	if(enemyt.item != null && d100() <= enemyt.itemChance && voreing == false){
		scene("\n\t"+enemyt.itemFound,false);
		getItem(enemyt.item);
	}
	
	//Advances quests where applicable
	switch(enemy){
		
	}
}

//Starts a combat event with the input enemy
protected function combatEvent(fighting:Enemies):void{
	setEnemy(fighting);
	startFight();
}

//Performs all the functions that happen when the player is defeated
protected function doDefeat():void{
	
	//Returns player to the default state and sends them to the appropiate location depending on type of defeat
	endEvent(defeatedBy.location);
	endCombat();
	specialEvent = 0;
	subEvent = "";
	
	//Activates all the penalties for being defeated and removes any temporary modifiers
	if(currentState == "defeated"){
		currentState = "default";
		rmvTempBuffs();
		Eaten = 0;
		Drank = 0;
		Inflated = 0;
		InflatedMass = 0;
		Calories = 0;
		updateStats();
		doRest();
		HEA = 0;
		doHealth(maxHEA * 0.5);
		doGold(-10);
	}
	
	//Displays the different defeat scenes based on what type of defeat happened
	switch(defeatedBy){
		default:
			scene("You died ",true);
			break;
	}
}

//Subpages for different combat actions
include "gamePlayerAttacks.as";
include "gameSpells.as";
include "gameEnemyAttacks.as";

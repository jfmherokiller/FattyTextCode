import valueObjects.Enemies;
import valueObjects.Gender;
import valueObjects.NPCs;
import valueObjects.Species;

//Returns a random number between 1-100
protected function d100():int{return Math.floor(Math.random()*(100))+1;}

//Rolls x amount of y-sided dice and returns their total
protected function xdy(amount:int,size:int):int{
	var rolled:int;
	for (i=1;i<=amount;i++){rolled += dXY(1,size);}
	return rolled;
}

//Returns a random number between the first and second number inclusive.
protected function dXY(low:int, high:int):int{ 
	var diceRoll:int = low;
	
	//Only rolls if the "high" input is actually higher than the "low" input
	if(high > low){diceRoll = Math.floor(Math.random()*(1+high-low))+low;}
	
	//Prevents dice roll from being higher than the input maximum. Probably not necessary
	if(diceRoll > high){diceRoll = high;}
	
	return diceRoll;
}

//Returns a random race. There's a 50/50 shot of it being an herbivore or a carnivore
protected function randomSpecies():Species{
	var tempSpecies:Species = randomHerbivore();
	if(dXY(1,2) == 1){tempSpecies = randomCarnivore();}
	return tempSpecies;
} 

//Returns a random carnivore
protected function randomCarnivore():Species{
	var carnivoreArray:Array = new Array();
	//These are where the different groups of carnivores go
	switch(dXY(1,4)){
		case 1:
			carnivoreArray = [];
			break;
		case 2:
			carnivoreArray = [];
			break;
		case 3:
			carnivoreArray = [];
			break;
		default:
			carnivoreArray = [];
			break;
	}
	return carnivoreArray[dXY(0,carnivoreArray.length - 1)];
} 

//Returns a random herbivore
protected function randomHerbivore():Species{
	var herbivoreArray:Array = new Array();
	//This is where the different groups of herbivores go
	switch(dXY(1,2)){
		case 1:
			herbivoreArray = [];
			break;
		default:
			herbivoreArray = [];
			break;
	}
	return herbivoreArray[dXY(0,herbivoreArray.length - 1)];
} 

//Returns a random gender
protected function randomGender():Gender{
	var returnGender:Gender = Male;
	if(optionsMales == optionsFemales){ if(dXY(1,2) == 1){returnGender = Female;} }
	if(optionsMales != optionsFemales){ if(optionsFemales){returnGender = Female;} }
	return returnGender;
}

//Creates a specific NPC in the input slot of the input species and input gender. You can have 4 different random NPCs concurrently, otherwise you should just write over old NPCs
protected function createNPC(ID:int,IDspecies:Species,IDgender:Gender):void{
	var outputNPC:NPCs = ObjectUtil.copy(defaultNPC) as NPCs;
	
	//Sets the NPCs species and gender
	outputNPC.species = ObjectUtil.copy(IDspecies) as Species;
	outputNPC.gender = ObjectUtil.copy(IDgender) as Gender;
	
	//Properly sets the NPCs species name based on gender I.E. "lion" vs "lioness" etc.
	switch(IDgender){
		case Male:
			if(IDspecies.mName != null){outputNPC.species.name = IDspecies.mName;}
			else{outputNPC.species.name = IDspecies.speciesName;}
			break;
		default:
			if(IDspecies.fName != null){outputNPC.species.name = IDspecies.fName;}
			else{outputNPC.species.name = IDspecies.speciesName;}
			break;
	}
	
	//Writes the created NPC to the input NPC slot
	switch(ID){
		case 1:
			NPC1 = ObjectUtil.copy(outputNPC) as NPCs;
			break;
		case 2:
			NPC2 = ObjectUtil.copy(outputNPC) as NPCs;
			break;
		case 3:
			NPC3 = ObjectUtil.copy(outputNPC) as NPCs;
			break;
		case 4:
			NPC4 = ObjectUtil.copy(outputNPC) as NPCs;
			break;
	}
}

//Generates an npc of random race and gender to the input slot
protected function randomNPC(ID:int):void{createNPC(ID,randomSpecies(),randomGender());}

//Creates the temporary version of the enemy based on the input enemy
//The purpose of this is so you can edit the object's characteristics without changing the original object
protected function setEnemy(ID:Enemies):void{
	
	enemy = ID;
	enemyt = ObjectUtil.copy(ID) as Enemies;
	
	//Sets the enemy portrait if it has one
	if(ID.image != null){enemyImageSource = ID.image;}
	
	//Sets the enemy species randomly if the species isn't set already
	if(ID.species == null){randomEnemyRace("any");}
	switch(ID.gender){
		case Male:
			setEnemyGender(Male);
			break;
		case Female:
			setEnemyGender(Female);
			break;
		case Neutral:
			setEnemyGender(Neutral);
			break;
		default:
			setEnemyGender(randomGender());
			break;
	}
	
	//Updates enemy descriptions to the most current characteristics based on species gender/species etc.
	enemyt.name = ObjectUtil.copy(ID.name) as String;
	enemyt.victory = ObjectUtil.copy(ID.victory) as String;
	enemyt.description = ObjectUtil.copy(ID.description) as String;
	enemyt.introduction = ObjectUtil.copy(ID.introduction) as String;
	enemyt.defeat = ObjectUtil.copy(ID.defeat) as String;
	enemyt.playerEscape = ObjectUtil.copy(ID.playerEscape) as String;
	enemyt.playerEscapeFail = ObjectUtil.copy(ID.playerEscapeFail) as String;
	enemyt.grappleEscapeFail = ObjectUtil.copy(ID.grappleEscapeFail) as String;
	enemyt.grappleEscapeSucceed = ObjectUtil.copy(ID.grappleEscapeSucceed) as String;
	enemyt.itemFound = ObjectUtil.copy(ID.itemFound) as String;
	
}

//Sets an ememy's race at random based on what it eats
protected function randomEnemyRace(eater:String):void{
	var tempSpecies:Species;
	switch(eater){
		case "carnivore":
			tempSpecies = randomCarnivore();
			break;
		case "herbivore":
			tempSpecies = randomHerbivore();
			break;
		default:
			tempSpecies = randomSpecies();
			break;
	}
	enemyt.species = ObjectUtil.copy(tempSpecies) as Species;
} 

//Sets the enemy's gender to the input gender
protected function setEnemyGender(ID:Gender):void{
	enemyt.gender = ObjectUtil.copy(ID) as Gender;

	switch(ID){
		case Male:
			if (enemyt.species.mName != null){enemyt.species.name = enemyt.species.mName;}
			else{enemyt.species.name = enemyt.species.speciesName;}
			break;
		case Female:
			if(enemyt.species.fName != null){enemyt.species.name = enemyt.species.fName;}
			else{enemyt.species.name = enemyt.species.speciesName;}
			break;
	}
}
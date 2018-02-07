import flash.display.StageScaleMode;

import valueObjects.Species;

//Displays the instructions for the game
protected function instructions():void{
	currentState = "appearance";
	
	miscScene("\tThis space intentionally left blank. ",true);
}

//Displays the credits for the game
protected function credits():void{
	scene("\nCoding by Noone ",true);
	clearView();
	returnView(8);
	listen = function():void{if(btnchc == 8){introduction();}}
}

//Displays the games introduction and sets up the introductory buttons
protected function introduction():void{
	
	//Sets the game's scaling so that it updates when you resize the window
	//I'm almost certainly doing this the wrong way
	this.stage.scaleMode = StageScaleMode.SHOW_ALL;
	
	//Moves you to the starting location of the game
	location = exampleCenter;
	
	//Displays your games intro
	scene("\tThis space intentionally left blank. ",true);
	
	clearView();
	btntxt(1,"New Game");
	btntxt(2,"Load");
	btntxt(3,"Instructions");
	btntxt(8,"Credits");
	
	listen = function():void{
		switch(btnchc){
			case 1:
				selectSpecies();
				break;
			case 2:
				tryLoad();
				break;
			case 3:
				instructions();
				break;
			case 8:
				credits();
				break;
		}
	}
}

//Selects which family of species you want to be
protected function selectSpecies():void{
	//Sets base stats
	bSTR = 15;
	bAGI = 15;
	bINT = 15;
	bEND = 15;
	bSTO = 20;
	Drank = 2;
	Eaten = 2;
	maxFUL = 130;
	bmaxHEA = 100;
	HEA = maxHEA;
	STA = 100;
	FAT = 5;
	Calories = 10;
	GLD = 30;
	
	//Sets base equipment
	WEA = ObjectUtil.copy(Weaponless) as Items;
	ARM = ObjectUtil.copy(Armorless) as Items;
	TOP = ObjectUtil.copy(Shirtless) as Items;
	BTM = ObjectUtil.copy(Pantsless) as Items;
	
	removeArrows();
	updateStats();
	
	scene("Please select your race... ",true);
	
	//Displays relevant UI panel
	speciesDropDown.visible = true;
	
	nextButton();
	btntxt(11,"Custom Species");
	
	listen = function():void{
		if (btnchc == 12 && speciesDropDown.selectedIndex != -1){
			//Makes the player into the species selected from the drop down menu
			var speciesID:Species = speciesDropDown.selectedItem.type;
			playerSpecies = ObjectUtil.copy(speciesID) as Species;
			playerHeight = speciesID.baseHeight;
			chgStats(playerSpecies.statChange[0],playerSpecies.statChange[1],playerSpecies.statChange[2],playerSpecies.statChange[3],playerSpecies.statChange[4]);
			FAT += playerSpecies.statChange[5];
			selectGender();
		}
		if(btnchc == 11){ currentState = "customSpecies"; }
	}
}

protected function completeCustomSpecies():void{
	if(inputAngry.text != "" && inputArticle.text != "" && inputBack.text != "" && inputBelly.text != "" && inputFeet.text != "" && inputFName.text != "" && inputFoot.text != "" 
		&& inputFur.text != "" && inputFurred.text != "" && inputFurry.text != "" && inputHair.text != "" && inputHand.text != "" && inputHands.text != "" && inputHead.text != "" 
		&& inputMName.text != "" && inputName.text != "" && inputTail.text != "" && inputTeeth.text != ""
		&& parseInt(inputStrength.text)+parseInt(inputAgility.text)+parseInt(inputEndurance.text)+parseInt(inputIntelligence.text)+parseInt(inputStomach.text) <= 25
		&& parseInt(inputHeight.text) >= 48 && parseInt(inputHeight.text) <= 144){
			//After testing to make sure all fields are filled in, sets all descriptions for your character's species
			playerSpecies = ObjectUtil.copy(Lion) as Species;
			playerSpecies.angry = inputAngry.text;
			playerSpecies.article = inputArticle.text;
			playerSpecies.furBack = inputBack.text;
			playerSpecies.furBelly = inputBelly.text;
			playerSpecies.feet = inputFeet.text;
			playerSpecies.fName = inputFName.text;
			playerSpecies.foot = inputFoot.text;
			playerSpecies.fur = inputFur.text;
			playerSpecies.furred = inputFurred.text;
			playerSpecies.furry = inputFurry.text;
			playerSpecies.hair = inputHair.text;
			playerSpecies.hand = inputHand.text;
			playerSpecies.hands = inputHands.text;
			playerSpecies.furHead = inputHead.text;
			playerSpecies.mName = inputMName.text;
			playerSpecies.speciesName = inputName.text;
			playerSpecies.tail = inputTail.text;
			playerSpecies.teeth = inputTeeth.text;
			playerSpecies.baseHeight = parseInt(inputHeight.text);
			playerSpecies.statChange = [parseInt(inputStrength.text),parseInt(inputAgility.text),parseInt(inputEndurance.text),parseInt(inputIntelligence.text),parseInt(inputStomach.text),5]
				
			switch(newGame){
				case true:
					//If it's the start of the game, also updates your states and moves you to the gender select screen
					playerHeight = playerSpecies.baseHeight;
					chgStats(playerSpecies.statChange[0],playerSpecies.statChange[1],playerSpecies.statChange[2],playerSpecies.statChange[3],playerSpecies.statChange[4]);
					FAT += playerSpecies.statChange[5];
					currentState = "default";
					selectGender();
					break;
				case false:
					//If your using the cabal to change species, removes some of your fat and updates your species
					FAT -= 200;
					switch(playerGender.name){
						case Male.name:
							if(playerSpecies.mName != null){playerSpecies.name = playerSpecies.mName;}
							else{playerSpecies.name = playerSpecies.speciesName;}
							break;
						default:
							if(playerSpecies.fName != null){playerSpecies.name = playerSpecies.fName;}
							else{playerSpecies.name = playerSpecies.speciesName;}
							break;										
					}
					break;
			}
	}
}

//Moves you to the correct custom species screen based on wether you're starting a new character or using the cabal
protected function customSpeciesBack():void{
	currentState = "default";
	selectSpecies();
}

//Displays the selected species stats/description
protected function displaySpeciesStats():void{
	if(newGame){
		var tempSpecies:Species = speciesDropDown.selectedItem.type;
		scene("<b>"+capFirst(tempSpecies.speciesName)+"</b>" +
			"\n~~~~~~~~~~~~~~~~~~~~~~\n",true);
		for(i=0;i<=5;i++){
			var tempStat:int = tempSpecies.statChange[i];
			if(tempStat > 0){
				scene("<li>",false);
				switch(i){
					case 0:
						scene("Strength: +",false);
						break;
					case 1:
						scene("Agility: +",false);
						break;
					case 2:
						scene("Endurance: +",false);
						break;
					case 3:
						scene("Intelligence: +",false);
						break;
					case 4:
						scene("Starting Stomach capacity: +",false);
						break;
					case 5:
						scene("Starting fatness: +",false);
						break;
				}
				scene(tempStat+"</li>",false);
			}
		}
		scene("<li>Starting height: "+(Math.floor(tempSpecies.baseHeight / 12))+"'"+(tempSpecies.baseHeight % 12)+"\" ("+Math.floor(tempSpecies.baseHeight * 2.54)+" centimeters)</li>",false);
	}
}


//Makes your character the selected gender
protected function selectGender():void{
	scene("Are you male or female? ",true);
	clearView();
	speciesDropDown.visible = false;
	btntxt(1,"Male");
	btntxt(3,"Female");
	btntxt(13,"Back");
	listen = function():void{
		var genderID:Gender;
		switch(btnchc){
			case 1:
				if(playerSpecies.mName != null){playerSpecies.name = playerSpecies.mName;}
				else{playerSpecies.name = playerSpecies.speciesName;}
				genderID = Male;
				playerGender = ObjectUtil.copy(genderID) as Gender;
				selectName();
				break;
			case 3:
				if(playerSpecies.fName != null){playerSpecies.name = playerSpecies.fName;}
				else{playerSpecies.name = playerSpecies.speciesName;}
				genderID = Female;
				playerGender = ObjectUtil.copy(genderID) as Gender;
				selectName();
				break;
			case 13:
				selectSpecies();
				break;
		}
	}
}


//Allows the player to input their name
protected function selectName():void{
	scene("What is your name? ",true);
	nameInput.visible = true;
	nameInput.text = "Hero";
	nameInput.setFocus();
	nameInput.selectAll();
	clearView();
	
	nextView();
	btntxt(13,"Back");
	
	listen = function():void{
		if (nameInput.text != "" && btnchc == 12){
			playerName = nameInput.text;
			startNewGame();
		}
		if (btnchc == 13){
			clrchc();
			nameInput.visible = false;
			selectGender();
		}
	}
}

//Makes sure all the flags and whatnot are appropriatel set up for when you start a new game
protected function startNewGame():void{
	doXP(0);
	doTime(0);
	nameInput.visible = false;
	common.visible = true;
	newGame = false;
	general();
	locationTravel(YourHouse);
	scene("The inroductory scene for starting a new game would go here. ",true);
}

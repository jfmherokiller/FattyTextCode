//Display stuff//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Display stuff//

//Displays input text as a scene and either overwrites what was already there based on the input boolean
protected function scene(texts:String, reset:Boolean):void{
	if(reset == false){mainText = mainText + texts;}
	else{
		mainText = texts;
		//Scrolls to the top of the page
		eventText.verticalScrollPosition = 0;
	}
}

//Works as the scene function except for miscellaneous scenes (player description, surroundings description, etc.)
//These functions are split up so that you can go back and forth between two different states without overwriting text on the default screen
protected function miscScene(texts:String, reset:Boolean):void{
	if (reset == false) {miscellaneousText = miscellaneousText + texts;}
	else {miscellaneousText = texts;}
}

//Returns the input string with the first letter capitalized
protected function capFirst(stringID:String):String {
	return stringID.charAt(0).toUpperCase()+stringID.substr(1).toLowerCase();
}

//Sets up the general display for when the player is just traveling around normally
protected function general():void{
	appView(1);
	clearView();
	removeArrows();
	rmvTempStats();
	updateStats();
	if(LVLup > 0){restLvlBtn.label = "Level Up!";}
	if(LVLup == 0){restLvlBtn.label = "Rest";}
	explore();
}

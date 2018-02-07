import valueObjects.Defeats;
import valueObjects.Enemies;
import valueObjects.Locations;
import valueObjects.Zones;

//Returns an integer representing which random event to do next from the input array
//This system is a bit complicated, basically an array is made with twice as many indexes as you have categories of events you want to do
//The odd indexes are added to the previous index, and then whichever even index is the highest is returned
//The odd indexes represent how fast you want it's associated index's event to happen
//Once an even index is pulled up, it's reset to 0 and must tick back up again
//For instance you might want an array like [random fight,random fight rate,random event,random event rate,random item,random item rate]
//Which could be something like [0,2,0,1,0,3] 
//which would cause the "random item" event to tick up 3 times, and the "random fight" event to tick up 2 times, and the "random event" event to tick up 1 time every time the array is run through the function
//So the first several times you ran that index through this function it would look like;
//[0,2,0,1,0,3] - the array you start with before applying the function
//[2,2,1,1,3,3] - the 3rd even index is highest, so the function would return "3" and then reset the 3rd even index to 0
//[4,2,2,1,3,3] - the 1st even index is highest, so the function would return "1" and then reset the 1st even index to 0
//[2,2,3,1,6,3] - the 3rd even index is highest, so the function would return "3" and then reset the 3rd even index to 0
//[4,2,4,1,3,3] - the 1st even index is highest, so the function would return "1" and then reset the 1st even index to 0
//[2,2,5,1,6,3] - the 3rd even index is highest, so the function would return "3" and then reset the 3rd even index to 0
//[4,2,6,1,3,3] - the 2nd even index is highest, so the function would return "2" and then reset the 2nd even index to 0
//[6,2,1,1,6,3] - the 1st and 3rd index are tied for highest so the function returns the last highest even index, which is "3", and then resets that index to 0
protected function eventRandomization(ID:Array):int{
	//Represents which of the even events is the highest
	var caseNumber:int = 0;
	//represents the actual index of the highest event
	var highestEvent:int = 0;
	
	//Adds the odd indexes to the even index that precedes them
	for(i=0;i<ID.length-1;i+=2){ ID[i] += ID[i+1]; }
	
	//Goes through the array and tests to see which index is highest
	for(i=0;i<ID.length-1;i+=2){
		if (ID[i] >= ID[highestEvent]){
			//Records which index needs to be reset
			highestEvent = i;
			//Converts the selected highest even index to what the function will return
			//(So "0" would be even index "1", "2" would be even index "2", "4" would be even index "3", etc.)
			caseNumber = (i * .5) + 1;
		}
	}
	
	//Resets the selected index to 0
	ID[highestEvent] = 0;
	
	//Returns which even index was the highest
	return caseNumber;
}

//Changes game location and background image
protected function locationUpdate(ID:Locations):void{
	if (ID != wall && ID != null && ID != blank){
		
		//Records where you came from, in case an event cares about it
		cameFrom = location;
		
		//Changes your location to the input location
		location = ID;
		
		//Creates a new array containing the surrounding areas of the input location
		//This is done so you can change the surroundings based on different criteria rather than always being stuck with what's set with the location object
		surroundingsArray = new Array();
		for(i=0;i<9;i++){ surroundingsArray[i] = location.Surroundings[i]; }
		
		updateStats();
		
		//Updates background image
		//updateBackground();
	}
}

//Updates background image based on your location and the time of day
protected function updateBackground():void{
	if(dayTime()){backgroundImageSource = location.locationZone.dayBackground;}
	else{backgroundImageSource = location.locationZone.nightBackground;}
}

//Walks to input location, removing stamina and advancing time, and does the event at that location
protected function locationTravel(ID:Locations):void{
	//Checks to make sure the input location actually exists, and is not impassable (ie not a wall)
	if(ID != null && ID.locationZone != impassable){
		//Does walking calculations if you're traveling to a new place
		if(location != ID){doWalk(3);}
		//Changes your location to the input location
		locationUpdate(ID);
		//does the event at the input location
		doEvent(ID);
	}
}

//Tests if you are immobile after multiplying by the input ration
//(for instance if you ran the function testImmobile(1.5), it would test whether you'd be immobile at 1.5x your current weight)
protected function testImmobile(ratio:Number):Boolean{
	var tempBool:Boolean = false;
	if((FAT + (ATE * 2)) * ratio > STR * 12){tempBool = true;}
	return tempBool;
}

//Tests if you're close to being immobile. Used as the default ratio that you'd consider "close" to being immobile
protected function testImmobileClose():Boolean{return testImmobile(1.3);}

//Displays travleable locations
protected function explore():void{
	//Removes previous buttons
	clearView();
	
	//Creates buttons for you to travel to and adds the relevant icon if it exists
	for(i=0;i<9;i++){
		var exploreLocation:Locations = surroundingsArray[i];
		if(exploreLocation != null){
			if(exploreLocation.Name != ""){btntxt(i+1,capFirst(exploreLocation.Name));}
			if(exploreLocation.icon != null){buttonIcons(i+1,exploreLocation.icon);}
		}
	}
	
	//Out of stamina warning. Doesn't work very well
	if(STA <= 0){
		if(eventText.htmlText.match("Out of stamina.") == null){
			scene("\n\n<i>Out of stamina.</i> ",false);
		}
	}
	
	//Causes the buttons to make you travel somewhere if you click on it
	listen = function():void{if(STA > 0){locationTravel(surroundingsArray[btnchc-1]);}}
}

//Ends special event, resets special event tracking variable, travels you to the input location, and brings up the default travel buttons for that location
protected function endEvent(traveling:Locations):void{
	specialEvent = 0;
	subEvent = "";
	appView(0);
	locationUpdate(traveling);
	general();
}

//Does the input defeat event
protected function defeatEvent(defeated:Defeats):void{
	defeatedBy = defeated;
	currentState = "defeated";
	nextButton();
}


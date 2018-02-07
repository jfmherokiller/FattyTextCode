import flash.geom.Point;

import valueObjects.Items;
import valueObjects.NPCs;
import valueObjects.Quests;
import valueObjects.Species;

switch(ID){
	
	//Your house/////////////////////////////
	case YourHouse:
		clearView();
		switch(specialEvent){
			case 0:
				scene("You step into your sparsely furnished living room. ",true);
				leaveButton(13);
				btntxt(1,"Bedroom");
				btntxt(3,"Storage");
				listen = function():void{
					switch(btnchc){
						case 1:
							specialEvent = 1;
							doEvent(YourHouse);
							break;
						case 3:
							depositing = true;
							invPage = 1;
							doStorage();
							break;
						case 13:
							scene("You "+walk()+" out of your house and onto the city's central square. ",true);
							endEvent(exampleCenter);
							break;
					}
				}
				break;
			case 1:
				scene("You "+walk()+" into your small bedroom. ",true);
				btntxt(1,"Save");
				btntxt(2,"Load");
				btntxt(3,"Sleep");
				leaveButton(13);
				listen = function():void{
					switch(btnchc){
						case 1:
							trySave();
							break;
						case 2:
							tryLoad();
							break;
						case 3:
							doSleep();
							break;
						case 13:
							specialEvent = 0;
							doEvent(YourHouse);
							break;
					}
				}
				break;
		}
		break;
	
	//end events
}



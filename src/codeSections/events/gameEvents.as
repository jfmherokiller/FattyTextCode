import valueObjects.Items;
import valueObjects.Species;

protected function doEvent(ID:Locations):void{
//Default event for uncoded area
	scene("",true);
	general();
	
	//Automatically hides or shows the miscellaneous buttons based on whether it's safe for those buttons to be there or not
	if(ID.Surroundings.length == 0){appView(0);}
	if(ID.Surroundings.length > 0){appView(1);}
	
	//Events are broken up into sub pages so it's easier to navigate through events
	//This is where you include those sub pages
	include "EventCity.as";
	
	//Ambient descriptions used to go here, but they were removed
	if(ID == exampleCenter){
		general();
	}
	
	//Store events
	else if (ID.type == store && ID.locationVendor != null){ enterStore(ID.locationVendor); }
	
	//Automatic location descriptions for when nothing got displayed from the rest of this function
	if(eventText.htmlText == ""){
		if(ID.Description == ""){scene("You traveled to "+ID.Name,true);}
		else{scene("\t"+ID.Description,true);}
	}
}
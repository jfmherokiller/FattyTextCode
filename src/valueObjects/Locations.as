package valueObjects
{
	[Bindable] 
	public class Locations
	{
		//Name of location
		public var Name:String = "Name error";
		
		//What zone the location is in. Used for updating background images
		public var locationZone:Zones;
		
		//What type of area it is, as in "wilderness" or "store"
		public var type:LocationType;
		
		//The vendor at the given location
		public var locationVendor:Vendors;
		
		//What other locations surround this location
		public var Surroundings:Array = new Array();
		
		//What random enemies you can encounter when resting at this location
		public var enemies:Array = new Array();
		
		//The icon that should appear on the button for this location
		public var icon:Class;
		
		//the description of this location, most often brought up by clicking the "surroundings" button
		public var Description:String = "";
		
		public function Locations()
		{
		}
	}
}
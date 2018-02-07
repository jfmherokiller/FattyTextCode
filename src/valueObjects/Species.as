package valueObjects
{
	[Bindable] 
	public class Species
	{
		//Name of the overall species, I.E. cattle
		public var speciesName:String = "speciesName";
		
		//Male and female version of the species name, I.E. bull/cow
		public var mName:String;
		public var fName:String;
		
		//The name that that specific NPC should be called, which is set after the gender has been set.
		//I.E., the character is set to be a cattle, and then after its gender is assigned then "name" is either set to "cow" or "bull" depending on what's appropriate
		public var article:String = "a";
		public var name:String = "name";
		
		//Textual description of the species
		public var furBack:String = "black";
		public var furBelly:String = "white";
		public var furHead:String = "brown";
		public var hair:String = "head fur";
		public var fur:String = "fur";
		public var furred:String = "furred";
		public var furry:String = "furry";
		public var hands:String = "paws";
		public var hand:String = "paw";
		public var feet:String = "paws";
		public var foot:String = "paw";
		public var mouth:String = "mouth";
		public var teeth:String = "teeth";
		public var tail:String = "long";
		public var angry:String = "growl";
		
		//Species base height in inches
		public var baseHeight:int = 70;
		
		//What stats get increased by how much at character creation. See "chgStats" to see how the array will be used
		public var statChange:Array = new Array(0,0,0,0,0);
		public function Species()
		{
		}
	}
}
package valueObjects
{
	[Bindable] 
	public class Enemies
	{
		//Enemy descriptors
		public var species:Species;
		public var gender:Gender;
		public var image:Class;
		
		//Relative power level of enemy. Not actually used in any calculations, just displayed to player
		public var level:int = 1;
		
		//Name of the enemy and the article that should preceed it, I.E. a lion, or an alligator
		public var article:String = "a";
		public var name:String;
		
		//If the enemy has a location it is set as being the "boss" of, after the enemy is defeated the game will run the event for that location
		public var bossOf:Locations;
		
		//Flage telling whether you can escape from the boss or not
		public var escapable:Boolean = true;
		
		//Counters used for enemies with more advanced AIs
		public var attackCounterA:int = 0;
		public var attackCounterB:int = 0;
		
		//Enemy base stats
		public var STR:int = 1;
		public var AGI:int = 1;
		public var INT:int = 1;
		public var DEF:int = 1;
		
		//Defines which stat is used in calculating enemy damage
		public var attackStat:String = "STR";
		
		//Enemy's secondary stats
		public var maxHEA:int = 10;
		public var maxMANA:int = 0;
		public var eaten:int = 0;
		
		//How much stomach capacity the enemy takes up when vored
		public var weight:int = 0;
		
		//Records whether the enemy can be vored at all
		public var voreable:Boolean = false;
		
		//Array containing enemy's resistances and weaknesses if any
		public var damageResistance:Array = [];
		public var damageWeakness:Array = [];
		
		//Rewards you get for defeating an enemy
		public var GLD:int = 1;
		public var XP:int = 101;
		public var item:Items;
		
		//Percentage chance of the enemy dropping its' item
		public var itemChance:int = 100;
		
		//Scene that's displayed when the enemy drops its item
		public var itemFound:String = "Your opponent dropped an item! ";
		
		//Various text scenes displayed when told to by other functions
		public var description:String = "";
		public var introduction:String = "";
		public var victory:String = "You have defeated your enemy! ";
		public var defeat:String = "Your vision fades to black as you fall unconscious. ";
		public var playerEscape:String = "You ran away! ";
		public var playerEscapeFail:String = "You failed to run. ";
		public var grappleEscapeFail:String = "You struggle against your captor and loosen their grasp, but you can't quite break free. ";
		public var grappleEscapeSucceed:String = "You manage to break free from your enemy's grasp! ";
		
		public function Enemies()
		{
		}
	}
}
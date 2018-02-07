package valueObjects
{
	[Bindable]
	public class Spells
	{
		//Description
		public var name:String = "";
		public var description:String = "";
		public var descriptionCast:String = "";
		public var iconType:String = "";
		public var level:int = 0;
		public var version:int = 1;
		public var statusEffect:String = "";
		public var statusTime:int = 0;
		public var ability:Boolean = false;
		
		//Stat requirements to learn
		public var requirementINT:int = 0;
		public var requirementAGI:int = 0;
		public var requirementSTR:int = 0;
		public var requirementEND:int = 0;
		public var requirementRep:int = 0;

		//Gold cost to learn
		public var Value:int = 0;
		
		//Cost to cast
		public var manaCost:int = 0;
		
		//Category of spell
		public var spellType:String = "";
		
		//Who the spell can target
		public var targets:String = "";
		
		//Flag for wether the spell can be cast in or out of combat or both
		public var castableCombat:Boolean = true;
		public var castableOOC:Boolean = false;
		
		//Damage
		public var damage:int = 0;
		public var damageRange:int = 0;
		
		//damage type
		public var damageType:DamageType;
		
		//Which stat the spell buffs, "END", "STR", "STO", etc
		public var buffStat:String = "";
		
		//How much it buffs that stat
		public var buffAmount:int = 0;
		
		public function Spells()
		{
		}
	}
}
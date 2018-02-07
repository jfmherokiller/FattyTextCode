package valueObjects
{
	[Bindable] 
	public class Vendors
	{
		//Text to be displayed when a function calls for it
		public var Buying:String = "\"What would you like?\" ";
		public var Selling:String = "\"What are you selling?\" ";
		public var Bought:String = "\"Thank you.\" ";
		public var Sold:String = "\"Thank you.\" ";
		public var NoMoney:String = "\"You don't have enough money.\" ";
		public var Leaving:String = "You leave the store. ";
		
		public var lowINT:String = "Come back when you're smarter. ";
		public var allKnown:String = "I have nothing left to teach you. ";
		
		//List of things the cendor sells
		public var vendArray:Array = new Array();
		
		//Location you got to when you leave the store
		public var StoreExit:Locations;
		
		public function Vendors()
		{
		}
	}
}
package gameobjects
{
	import starling.display.Sprite;
	
	public class BlankSprite extends Sprite
	{
		public var title:String;
		public var kind:String = 'blank';
		public var pickupable:Boolean = false;
		public var collectable:Boolean = false;
		
		public function BlankSprite()
		{
			
		}
	}
}
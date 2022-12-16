package gameobjects
{
	import starling.display.Sprite;
	import starling.display.Image;

	public class Rock extends Sprite
	{
		public var title:String;
		public var kind:String = 'rock';
		public var pickupable:Boolean = false;
		public var collectable:Boolean = false;

		
		public function Rock(Pic:Image)
		{
			addChild(Pic);
			pivotX = width >> 1;
			pivotY = height >> 1;
			this.flatten();
		}
	}
}
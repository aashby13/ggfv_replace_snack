package gameobjects
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Block extends Sprite
	{
		/*[Embed(source="/assets/gameobjects/block.jpg")]
		private var img:Class;*/
		
		public var title:String;
		public var kind:String = 'block';
		public var collectable:Boolean = false;
		public var pickupable:Boolean = false;
		
		
		public function Block(Img:Image)
		{
			//addChild(Image.fromBitmap(new img()));
			addChild(Img);
			pivotX = width >> 1;
			pivotY = height >> 1;
			this.flatten();
		}
	}
}
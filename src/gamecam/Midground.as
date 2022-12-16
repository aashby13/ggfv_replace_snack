package gamecam 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import gameobjects.ArtRegistry;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Midground extends Sprite
	{
		private var image:Image;
		
		public function Midground()
		{
			image = new Image(ArtRegistry.midgroundTexture);
			addChild(image);
			
			image.x = 250;
			image.y = 780;
			
			this.flatten();
		
		}
	}
}
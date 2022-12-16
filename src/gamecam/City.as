package gamecam 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import gameobjects.ArtRegistry;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class City extends Sprite
	{
		private var image:Image;
		
		public function City()
		{
			image = new Image(ArtRegistry.cityTexture);
			addChild(image);
			
			image.x = 55;
			image.y = 212;
			
			this.flatten();
		
		}
	}
}
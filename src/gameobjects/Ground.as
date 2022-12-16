package gameobjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Ground extends Sprite
	{
		public var title:String;
		public var kind:String = 'ground';
		
		public function Ground()
		{
			var texture:Texture = ArtRegistry.groundTexture;
			var image:Image = new Image(texture);
			addChild(image);
			
			var image2:Image = new Image(texture);
			image2.x = 1806 - 5;
			addChild(image2);
			
			var image3:Image = new Image(texture);
			image3.x = 3612 - 10;
			addChild(image3);
			
			var image4:Image = new Image(texture);
			image4.x = 4518 - 15;
			addChild(image4);
			
			this.flatten();
		}
	}
}
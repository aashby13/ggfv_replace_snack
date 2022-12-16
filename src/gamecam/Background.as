package gamecam 
{
	import gameobjects.ArtRegistry;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Background extends Sprite
	{
		public function Background()//Max is 2048x2048
		{
			var image:Image = new Image(ArtRegistry.bg_tileTexture);
			image.x = -20;
			image.y = -20;
			addChild(image);
			
			var pl:Image = new Image(ArtRegistry.earthTexture);
			pl.x = 367;
			pl.y = 110;
			addChild(pl);
			
			this.flatten();
			
		}
		
	}
}
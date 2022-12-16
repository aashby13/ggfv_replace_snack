package gamecam
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import gameobjects.ArtRegistry;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class Mountains extends Sprite
	{
		private var tween:Tween;
		private var light:Image;

		public function Mountains()
		{
			var bg:Sprite = new Sprite;
			addChild(bg);
			
			var mtns:Image = new Image(ArtRegistry.mountainsTexture);
			mtns.x = -20;
			mtns.y = 208;//125 for png
			bg.addChild(mtns);
			
			var fill:Image = new Image(ArtRegistry.mountains_fillTexture);
			fill.x = -20;
			fill.y = this.height + 203;
			bg.addChild(fill);
			bg.flatten();
			
			light = new Image(ArtRegistry.mountains_lightTexture);
			light.x = 653;
			light.y = 182;
			addChild(light);
			
			refade();
		}
		
		private function refade():void
		{
			tween = new Tween(light,1,'easeInOut');
			if(light.alpha == 0) tween.fadeTo(1) else tween.fadeTo(0);
			tween.onComplete = refade;
			Starling.juggler.add(tween);
		}
	}
}
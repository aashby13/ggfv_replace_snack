package gameobjects
{
	import com.kleinbuendel.util.DisplayObjectToStarling;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ArtRegistry
	{
		[Embed(source="/assets/actor/dude.xml", mimeType="application/octet-stream")]
		private static var dudeXML:Class;
		
		[Embed(source="/assets/actor/dude.png")]
		private static var dudeTexture:Class;
		public static var dudeAtlas:TextureAtlas;
		
		[Embed(source="/assets/background/bg_tile.gif")]
		private static var _bg_tile:Class;
		public static var bg_tileTexture:Texture;
		
		[Embed(source="/assets/background/planet.png")]
		private static var _earth:Class;
		public static var earthTexture:Texture;
		
		[Embed(source="/assets/background/bg_vector.swf", symbol="CityMC")]
		private static var  _city:Class;
		public static var cityTexture:Texture;
		
		[Embed(source="/assets/background/bg_vector.swf", symbol="MidgroundMC")]
		private static var  _midground:Class;
		public static var midgroundTexture:Texture;
		
		[Embed(source="/assets/background/bg_vector.swf", symbol="MountainsMC")]
		private static var  _mountains:Class;
		public static var mountainsTexture:Texture;
		
		[Embed(source="/assets/background/mountains_light.png")]
		private static var _mountains_light:Class;
		public static var mountains_lightTexture:Texture;
		
		public static var mountains_fillTexture:Texture;
		
		[Embed(source="/assets/gameobjects/foodholder.png")]
		private static var _foodholder:Class;
		public static var foodholderTexture:Texture;
		
		[Embed(source="/assets/gameobjects/food.xml", mimeType="application/octet-stream")]
		private static var foodXML:Class;
		
		[Embed(source="/assets/gameobjects/food.png")]
		private static var _food:Class;
		public static var foodAtlas:TextureAtlas;
		
		[Embed(source="/assets/gameobjects/food_wanted_level1.xml", mimeType="application/octet-stream")]
		private static var _fwl1XML:Class;
		public static var fwl1XML:XML;
		
		[Embed(source="/assets/gameobjects/food_wanted_level2.xml", mimeType="application/octet-stream")]
		private static var _fwl2XML:Class;
		public static var fwl2XML:XML;
		
		[Embed(source="/assets/gameobjects/food_stealth_level1.xml", mimeType="application/octet-stream")]
		private static var _fsl1XML:Class;
		public static var fsl1XML:XML;
		
		[Embed(source="/assets/gameobjects/food_stealth_level2.xml", mimeType="application/octet-stream")]
		private static var _fsl2XML:Class;
		public static var fsl2XML:XML;
		
		[Embed(source="/assets/gameobjects/ground.jpg")]
		private static var _ground:Class;
		public static var groundTexture:Texture;
		
		[Embed(source="/assets/gameobjects/platform.jpg")]
		private static var _platform:Class;
		private static var platformBitmap:Bitmap;
		public static var platformTexture400:Texture;
		public static var platformTexture800:Texture;
		public static var platformTexture1200:Texture;
		public static var platformTexture2048:Texture;
		
		[Embed(source="/assets/gameobjects/thruster1.png")]
		private static var _thruster1:Class;
		public static var thruster1Texture:Texture;
		
		[Embed(source="/assets/gameobjects/thruster2.png")]
		private static var _thruster2:Class;
		public static var thruster2Texture:Texture;
		
		[Embed(source="/assets/gameobjects/ContainerPod.png")]
		private static var _pod:Class;
		public static var podTexture:Texture;
		
		[Embed(source="/assets/gameobjects/rocks.xml", mimeType="application/octet-stream")]
		private static var rocksXML:Class;
		
		[Embed(source="/assets/gameobjects/rocks.png")]
		private static var _rocks:Class;
		public static var rockAtlas:TextureAtlas;
		
		[Embed(source="/assets/gameobjects/block.jpg")]
		private static var _block:Class;
		public static var blockTexture:Texture;
		
		public static function init():void
		{
			trace('ArtRegistry initialized');
			
			dudeAtlas = new TextureAtlas(Texture.fromBitmap(new dudeTexture),XML(new dudeXML));
			
			bg_tileTexture = DisplayObjectToStarling.getTextureFillSetDims(new _bg_tile,1700,700,false);
			
			earthTexture = Texture.fromBitmap(new _earth);
			
			var city:DisplayObject = new _city;
			cityTexture = DisplayObjectToStarling.getTexture(city);
			city = null;
			
			var midground:DisplayObject = new _midground;
			midgroundTexture = DisplayObjectToStarling.getTexture(midground);
			midground = null;
				
			var mountains:DisplayObject = new _mountains;
			mountainsTexture = DisplayObjectToStarling.getTexture(mountains);
			mountains = null;
			
			mountains_lightTexture = Texture.fromBitmap(new _mountains_light);
			
			mountains_fillTexture = DisplayObjectToStarling.getTextureDrawFill(0x292F47,mountainsTexture.width,200);
			
			foodholderTexture = Texture.fromBitmap(new _foodholder);
			
			foodAtlas = new TextureAtlas(Texture.fromBitmap(new _food),XML(new foodXML));
			
			fwl1XML = XML(new _fwl1XML);
			
			fwl2XML = XML(new _fwl2XML);
			
			fsl1XML = XML(new _fsl1XML);
			
			fsl2XML = XML(new _fsl2XML);
			
			groundTexture = DisplayObjectToStarling.getTextureFillSetDims(new _ground,1806,100,false);
			
			platformBitmap = new _platform;
			platformTexture400 = makePlatformTexture(platformBitmap,400);
			platformTexture800 = makePlatformTexture(platformBitmap,800);
			platformTexture1200 = makePlatformTexture(platformBitmap,1200);
			platformTexture2048 = makePlatformTexture(platformBitmap,2048);
			
			thruster1Texture = Texture.fromBitmap(new _thruster1);
			
			thruster2Texture = Texture.fromBitmap(new _thruster2);
			
			podTexture = Texture.fromBitmap(new _pod);
			
			rockAtlas = new TextureAtlas(Texture.fromBitmap(new _rocks),XML(new rocksXML));
			
			blockTexture = Texture.fromBitmap(new _block);
			
		}
		
		private static function makePlatformTexture(BM:Bitmap, Width:Number):Texture
		{
			var rect:flash.display.Sprite = new flash.display.Sprite;
			rect.graphics.lineStyle(2,0x000,1,false,'normal','square','miter');
			rect.graphics.beginBitmapFill(BM.bitmapData,null,true);
			rect.graphics.drawRect(0,0,Width,50);
			rect.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData(Width,50,false,0x0000);
			bmd.draw(rect);
			
			var texture:Texture = Texture.fromBitmapData(bmd);
			
			rect = null;
			
			return texture;
		}
	}
}
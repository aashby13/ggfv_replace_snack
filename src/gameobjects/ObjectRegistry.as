package gameobjects
{
	import gamecam.*;
	
	import managers.ParticleManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class ObjectRegistry
	{
		private static var rock1:Rock;
		private static var rock2:Rock;
		private static var rock3:Rock;
		
		private static var rock1Pool:Array;
		private static var rock2Pool:Array;
		private static var rock3Pool:Array;
		
		private static var rock1InUse:int = 0;
		private static var rock2InUse:int = 0;
		private static var rock3InUse:int = 0;
		
		private static var block:Block;
		private static var blockPool:Array;
		private static var blockInUse:int = 0;
		
		public static var background:Background;
		public static var midground:Midground;
		public static var city:City;
		public static var mountains:Mountains;
		public static var pod:Pod;
		public static var ground:Ground;
		
		private static var _bubDude:Dude;

		public static function get bubDude():Dude
		{
			_bubDude = new Dude('bub');
			return _bubDude;
		}

		private static var _botDude:Dude;

		public static function get botDude():Dude
		{
			_botDude = new Dude('bot');
			return _botDude;
		}
		
		
		public static function init():void
		{
			trace('ObjectRegistry initialized');
			
			background = new Background();
			
			midground= new Midground();
			
			city = new City();
			
			mountains = new Mountains();
			
			pod = new Pod();
			
			ground = new Ground();
			
			rock1Pool = makePool(ArtRegistry.rockAtlas.getTexture('rock1'), Rock,10);
			rock2Pool = makePool(ArtRegistry.rockAtlas.getTexture('rock2'), Rock,6);
			rock3Pool = makePool(ArtRegistry.rockAtlas.getTexture('rock3'), Rock,2);
			
			blockPool = makePool(ArtRegistry.blockTexture, Block, 36);
			
		}
		
		public static function reset():void
		{
			rock1InUse = 0;
			rock2InUse = 0;
			rock3InUse = 0;
			blockInUse = 0
		}
		
		private static function makePool(Txtr:Texture, Cls:Class, Num:int):Array
		{
			var array:Array = [];
			for(var i:int=0; Num>i; i++) array.push(new Cls(new Image(Txtr)));
			return array;
		}
		
		public static function getBlock():Block 
		{
			var b:Block;
			
			if(blockInUse > blockPool.length-1) trace('exceded blockPool');
			b = blockPool[blockInUse];
			blockInUse++;
			trace('blockInUse = ' + blockInUse);
			
			return b;
		}
		
		public static function getRock(Kind:int = 1):Rock 
		{
			var r:Rock;
			
			switch(Kind)
			{
				case 1:
					if(rock1InUse > rock1Pool.length-1) trace('exceded rock1Pool');
					r = rock1Pool[rock1InUse];
					rock1InUse++
					break;
				case 2:
					if(rock2InUse > rock2Pool.length-1) trace('exceded rock2Pool');
					r = rock2Pool[rock2InUse];
					rock2InUse++
					break;
				case 3:
					if(rock3InUse > rock3Pool.length-1) trace('exceded rock3Pool');
					r = rock3Pool[rock3InUse];
					rock3InUse++
					break;
			}
			
			return r;
		}
	}
}
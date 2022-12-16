package screens  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import mx.core.ByteArrayAsset;
	
	public class Preloader extends MovieClip
	{
		[Embed(source="/assets/menus/preloader_screen.swf", mimeType="application/octet-stream")]
		private var PreScreen:Class;
		
		private var loader:Loader=new Loader;
		private var screen:ByteArrayAsset;
		private var swf:MovieClip;
		private var loadbar:Sprite;
		private var percent:Number;
		private var timer:Timer;
		public var bm:Bitmap;
		
		public var app:Object;
		public var isReady:Boolean = false;
		public var holderReady:Boolean = false;
		
		public function Preloader()
		{
			stop();
			
			screen = new PreScreen();
			loader.contentLoaderInfo.addEventListener(Event.INIT,start);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
			loader.loadBytes(screen);
		}
		
		/*private function onLoaded(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaded);
			this.nextFrame();
			init();
		}*/
		
		private function onLoaded():void
		{
			this.nextFrame();
			var mainClass:Class = Class(getDefinitionByName("ggfv_replace_snack"));
			//var mainClass:Class = Class(Main);
			
			if(mainClass)
			{
				app = new mainClass();
				addChild(app as DisplayObject);
				isReady = true;
				trace('app ready');
				trace('game parent = ' + this.parent);
			}
		}
		
		private function start(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT,start);
			
			swf = MovieClip(loader.content);
			addChild(swf);
	
			loadbar = swf.loadbar.bar; 
			loadbar.scaleX = 0;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			//trace('onEnterFrame')
			percent = loaderInfo.bytesLoaded/loaderInfo.bytesTotal;
			loadbar.scaleX = percent;
			if(framesLoaded == totalFrames && !app) onLoaded();
			if(isReady && holderReady) setTimer();// will start game when in gameholder
			if(isReady && this.parent == stage ) setTimer(); // will start game when solo (not in gameolder)
		}
		
		public function setTimer():void 
		{
			trace('setTimer');
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			timer = new Timer(2500,1);
			timer.addEventListener(TimerEvent.TIMER, exit);
			timer.start();
			app.sound.musicStart();
			app.startStarling();
		}
		
		private function exit(e:TimerEvent):void 
		{
			trace('exit Preloader');
			timer.removeEventListener(TimerEvent.TIMER, exit);
			var bmd:BitmapData = new BitmapData(swf.width,swf.height,false,0x0000);
			bmd.draw(swf);
			bm = new Bitmap(bmd);
			this.addChild(bm);
			this.removeChild(swf);
			app.pre = bm;
			app.currentScreen = app.pre;
			app.start();
		}
	}
}
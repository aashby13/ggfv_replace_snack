package screens
{
	import controls.MenuControls;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.ByteArrayAsset;
	
	import statemachine.States;
	
	public class GameOverMenu extends Sprite
	{
		[Embed('/assets/menus/gameover_menu.swf', mimeType="application/octet-stream")]
		private var Screen:Class;
		
		private var loader:Loader=new Loader;
		private var screen:ByteArrayAsset;
		public var menu:MovieClip;
		private var flashroot:ggfv_replace_snack;
		private var _showBitmap:Boolean;
		
		public function get showBitmap():Boolean
		{
			return _showBitmap;
		}
		
		public function set showBitmap(value:Boolean):void
		{
			
			if(value)
			{
				if(_showBitmap != value) addBitmap();
			}
			else
			{
				bitmap.visible = false;
				menu.visible = true;
			}
			
			_showBitmap = value;
		}
		
		public var isDone:Boolean;
		public var btnArray:Array;
		public var controls:MenuControls;
		public var bitmap:Bitmap;
		
		public function GameOverMenu(FlashRoot:ggfv_replace_snack)
		{
			trace('new game over menu');
			flashroot = FlashRoot;
			alpha = 0;
			isDone = false;
			screen = new Screen();
			loader.contentLoaderInfo.addEventListener(Event.INIT,init,false,0,true);
			loader.loadBytes(screen);
		}
		
		private function init(e:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT,init);
			
			menu = MovieClip(loader.content);
			menu.againBTN.id = 'again';
			menu.downloadBTN.id = 'download';
			menu.doneBTN.id = 'quit';
			
			btnArray = [menu.againBTN, menu.downloadBTN, menu.doneBTN];
			controls = new MenuControls(this, flashroot.holderSound);
			addChild(menu);
			showBitmap = true;
		}
		
		private function addBitmap():void 
		{
			if(bitmap) {removeChild(bitmap); bitmap = null};
			var bmd:BitmapData = new BitmapData(menu.width,menu.height,true,0x000000);
			bmd.draw(menu);
			bitmap = new Bitmap(bmd);
			bitmap.addEventListener(Event.ADDED_TO_STAGE, onBitmap);
			addChildAt(bitmap,0);
		}
		
		private function onBitmap(e:Event):void 
		{
			bitmap.visible = true;
			menu.visible = false;
		}
		
		public function setButton(ID:String):void 
		{
			//Do something special when setting button
		}
		
		public function onButtonSelect(ID:String):void 
		{
			//Do something special if button is selected
		}
		
		public function onButtonDown(ID:String):void 
		{
			switch (ID)
			{
				case 'again':
					flashroot.currentLevel = States.LEVEL1;
					isDone = true;
					break;
				case 'download':
					flashroot.download();
					break;
				case 'quit':
					flashroot.done();
					break;
				default:
					break;
			}
		}
	}
}
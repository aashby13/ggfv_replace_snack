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
	
	public class ChooseMenu extends Sprite
	{
		[Embed('/assets/menus/choose_menu.swf', mimeType="application/octet-stream")]
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
		public var actor:String = '';
		public var bitmap:Bitmap;
		
		public function ChooseMenu(FlashRoot:ggfv_replace_snack)
		{
			trace('new choose menu');
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
			menu.bubBTN.id = 'bub';
			menu.botBTN.id = 'bot';
			menu.backBTN.id = 'back';
			menu.doneBTN.id = 'done';
			menu.backBTN.visible = flashroot.changeGoalAbility;
			
			if(menu.backBTN.visible) 
			{
				btnArray = [menu.bubBTN, menu.botBTN, menu.backBTN, menu.doneBTN];
			}
			else 
			{
				btnArray = [menu.bubBTN, menu.botBTN, menu.doneBTN];
				menu.doneBTN.x = 450 - (menu.doneBTN.width/2);
			}
			
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
			switch (ID)
			{
				case 'bub':
					if(actor != 'bub') menu.bubBTN.check.visible = false;
					break;
				case 'bot':
					if(actor != 'bot') menu.botBTN.check.visible = false;
					break;
				case 'done':
					if(actor == '') menu.doneBTN.alpha = .5;
					break;
				default:
					break;
			}
		}
		
		public function onButtonSelect(ID:String):void 
		{
			//Do something special if button is selected
		}
		
		public function onButtonDown(ID:String):void 
		{
			switch (ID)
			{
				case 'bub':
					actor = 'bub';
					menu.bubBTN.check.visible = true;
					menu.botBTN.check.visible = false;
					menu.doneBTN.alpha = 1;
					break;
				case 'bot':
					actor = 'bot';
					menu.bubBTN.check.visible = false;
					menu.botBTN.check.visible = true;
					menu.doneBTN.alpha = 1;
					break;
				case 'back':
					flashroot.back();
					break;
				default:
					break;
			}
		}

	}
}
package screens
{
	import controls.ContentScroller;
	import controls.MenuControls;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.core.ByteArrayAsset;
	
	public class InstructMenu extends Sprite
	{
		[Embed('/assets/menus/instruct_menu.swf', mimeType="application/octet-stream")]
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
		private var howTxt:TextField;
		public var isDone:Boolean;
		public var btnArray:Array;
		public var controls:MenuControls;
		public var scroller:ContentScroller;
		public var bitmap:Bitmap;
		
		public function InstructMenu(FlashRoot:ggfv_replace_snack)
		{
			trace('new instruct menu');
			flashroot = FlashRoot;
			alpha = 0;
			isDone = false;
			screen = new Screen();
			loader.contentLoaderInfo.addEventListener(Event.INIT,start,false,0,true);
			loader.loadBytes(screen);
		}
		
		private function start(e:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT,start);
			
			menu = MovieClip(loader.content);
			menu.instructBTN.id = 'instruct';
			menu.controlsBTN.id = 'controls';
			menu.tipsBTN.id = 'tips';
			menu.doneBTN.id = 'done';
			
			howTxt = new TextField;
			howTxt.antiAliasType =  "advanced";
			howTxt.setTextFormat(flashroot.css.format);
			howTxt.embedFonts = true;
			howTxt.multiline = true;
			howTxt.wordWrap = true;
			howTxt.styleSheet = flashroot.css;
			howTxt.x = 483;
			howTxt.y = 80;
			menu.instructMC.addChild(howTxt);
			
			setText(flashroot.currentLevel);
			
			btnArray = [menu.instructBTN,menu.controlsBTN,menu.tipsBTN,menu.doneBTN];
			controls = new MenuControls(this, flashroot.holderSound);
			addChild(menu);
			
			scroller = new ContentScroller(menu.tipsMC.content,menu.tipsMC.contentMask,menu.tipsMC.scrollbar,8,"vertical",true);
			
			showBitmap = true;
		}
		
		public function setText(Level:String):void 
		{
			//trace('set text');
			howTxt.width = 354;
			howTxt.height = 175;
			
			if(Level == 'level1')
			{
				menu.instructMC.levelTxt.text = 'Level 1';
				howTxt.text = '<p>Put the high fat snacks and sugary snacks in the Collection Pod.\n\nYou don’t have much time, so be quick.</p>'
				//howTxt.text = '<p>Find high fat and sugary snacks and put them in the Collection Pod.\n\nYou have '+ flashroot.secondsL1 +' seconds to find as many as you can.</p>'
			}
			else if(Level == 'level2')
			{
				menu.instructMC.levelTxt.text = 'Level 2';
				howTxt.text = '<p>Good job.  Now find healthy fruits and vegetable snacks to eat instead.\n\nTime is even shorter, so be super quick.</p>'
				//howTxt.text = '<p>Now find healthy fruit and vegetable snacks to replace the high fat and sugary snacks you found.\n\nYou have '+ flashroot.secondsL2 +' seconds.</p>'
			}
			
			howTxt.autoSize = 'left';
			howTxt.y = menu.instructMC.height/2 - howTxt.height/2 + 20;

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
			if(ID == 'instruct')
			{
				menu.instructMC.visible = true;
				menu.controlsMC.visible = false;
				menu.tipsMC.visible = false;
			}
		}
		
		public function onButtonSelect(ID:String):void 
		{
			switch (ID)
			{
				case 'instruct':
					menu.instructMC.visible = true;
					menu.controlsMC.visible = false;
					menu.tipsMC.visible = false;
					break;
				case 'controls':
					menu.controlsMC.visible = true;
					menu.instructMC.visible = false;
					menu.tipsMC.visible = false;
					break;
				case 'tips':
					menu.tipsMC.visible = true;
					menu.instructMC.visible = false;
					menu.controlsMC.visible = false;
					break;
				default:
					break;
			}
		}
		
		public function onButtonDown(ID:String):void 
		{
			//Do something special if button is clicked
		}
		
	}
}
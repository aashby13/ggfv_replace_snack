package screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.BlurFilterPlugin; 
	import com.greensock.plugins.GlowFilterPlugin; 
	
	import controls.ContentScroller;
	import controls.MenuControls;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.core.ByteArrayAsset;
	
	import statemachine.States;
	
	public class ResultsMenu extends Sprite
	{
		[Embed('/assets/menus/results_menu.swf', mimeType="application/octet-stream")]
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
		private var resultsText:TextField;
		private var numWanted:int;
		private var palette:Sprite;
		private var scroller:ContentScroller;
		private var dsfilter:BitmapFilter;
		private var currentArray:Array;
		private var timer:Timer;
		
		public var isDone:Boolean = false;
		public var btnArray:Array;
		public var controls:MenuControls;
		public var bitmap:Bitmap;
		
	
		public function ResultsMenu(FlashRoot:ggfv_replace_snack)
		{
			trace('new results menu');
			
			TweenPlugin.activate([BlurFilterPlugin]);
			TweenPlugin.activate([GlowFilterPlugin]);
			
			alpha = 0;
			flashroot = FlashRoot;
			screen = new Screen();
			loader.contentLoaderInfo.addEventListener(Event.INIT,init,false,0,true);
			loader.loadBytes(screen);
		}
		
		private function init(e:Event):void 
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT,init);
			menu = MovieClip(loader.content);
			menu.doneBTN.id = 'done';
			
			resultsText = new TextField();
			resultsText.antiAliasType =  "advanced";
			//resultsText.setTextFormat(flashroot.css.format);
			resultsText.embedFonts = true;
			resultsText.multiline = true;
			resultsText.wordWrap = true;
			resultsText.styleSheet = flashroot.css;
			menu.resultsBox.body.addChild(resultsText);

			btnArray = [menu.doneBTN];
			controls = new MenuControls(this, flashroot.holderSound);
			addChild(menu);
			start();
		}
		
		public function start():void 
		{
			menu.resultsBox.circleMC.bg.msk.scaleX = 0;
			menu.resultsBox.circleMC.foundTxt.visible = false;
			menu.resultsBox.body.alpha = 0;
			setText();
			makePalette();
			showBitmap = true;
		}
		
		private function setText():void 
		{
			numWanted = 0;
			
			if(flashroot.currentLevel == States.LEVEL1)
			{
				//trace('Set Result text Level 1');
				menu.resultsBox.circleMC.foundTxt.text = 'FOUND';
				menu.resultsBox.titleMC.txt.text = 'What You Found';
				getGameResults1(flashroot.caughtArrayL1);
			}
			else if(flashroot.currentLevel == States.LEVEL2)
			{
				//trace('Set Result text Level 2');
				menu.resultsBox.circleMC.foundTxt.text  = 'REPLACED';
				menu.resultsBox.titleMC.txt.text  = 'What You Replaced';
				getGameResults2(flashroot.caughtArrayL2);
			}
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
		
		
		private function getGameResults1(Arr:Array):void
		{
			currentArray = Arr;
			resultsText.htmlText = '';
			
			for each (var item:Object in Arr)
			{
				var rt:String = item.wanted ? item.feedback : '<span class="error">Whoops! ' + item.feedback + '</span>';
				var title:String = '<span class="title">' + item.title + ': </span>';
				resultsText.htmlText += '<p class="results">' + title + rt + '\n</p>' ;
				if(item.wanted) numWanted ++;
				trace('results item = ' + item.title);
			}
			
			menu.resultsBox.circleMC.numTxt.text = numWanted;
			flashroot.numWantedL1 = numWanted;
			resultsText.width = menu.resultsBox.txtMask.width;
			resultsText.height = resultsText.textHeight+16;
			if(resultsText.height > menu.resultsBox.txtMask.height) setScroller(true) else setScroller(false);
		}
		
		private function getGameResults2(Arr:Array):void
		{
			currentArray = Arr;
			resultsText.htmlText = '';
			
			var newL1Array:Array = new Array();
			
			for (var n:int=0; flashroot.caughtArrayL1.length > n; n++)
			{
				if(flashroot.caughtArrayL1[n].wanted) newL1Array.push(flashroot.caughtArrayL1[n]);
			}
			
			for (var i:int=0; newL1Array.length > i; i++)
			{
				var rt:String;
				var title:String = '<span class="title">' + newL1Array[i].title + ': </span>';
				
				if(Arr[i])
				{
					numWanted ++;
					rt = '<span class="title">' + Arr[i].title + '</span>';
					resultsText.htmlText += '<p class="results">' + title + 'Replaced with ' + rt + '\n</p>' ;
				}
				else
				{
					resultsText.htmlText += '<p class="results">' + title + '<span class="error">NOT REPLACED</span>\n</p>' ;
				}

				//trace('txt = ' + resultsText.text);
			}
			
			menu.resultsBox.circleMC.numTxt.text = numWanted;
			resultsText.width = menu.resultsBox.txtMask.width;
			resultsText.height = resultsText.textHeight+16;
			if(resultsText.height > menu.resultsBox.txtMask.height) setScroller(true) else setScroller(false);
		}
		
		private function setScroller(On:Boolean):void 
		{
			//trace('setScroller ' + On);
			menu.resultsBox.scrollbar.visible = false;
			menu.resultsBox.groove.visible = false;
			menu.resultsBox.body.y = menu.resultsBox.txtMask.y
			menu.resultsBox.scrollbar.scaleY = 1;
			menu.resultsBox.scrollbar.y = menu.resultsBox.groove.y;
			scroller = null;
			
			if(On)
			{
				var content:Sprite = menu.resultsBox.body;
				var txtMask:Sprite = menu.resultsBox.txtMask;
				var bar:Sprite = menu.resultsBox.scrollbar
				menu.resultsBox.scrollbar.visible = true;
				menu.resultsBox.groove.visible = true;
				menu.resultsBox.scrollbar.alpha = 0;
				menu.resultsBox.groove.alpha = 0;
				scroller = new ContentScroller(content, txtMask, bar, 6, "vertical", true);
			}
		}
		
		private function makePalette():void
		{
			var w:Number = 852;
			var h:Number = menu.resultsBox.scrollbar.visible ? menu.resultsBox.txtMask.height + 115 : menu.resultsBox.body.height + 115;
				
			if(palette) {menu.resultsBox.removeChild(palette); palette.visible = false; palette = null};
			//trace(palette);
			palette = new Sprite;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, Math.PI/2, 0, 0);
			
			var gradColors:Array = [0x9CB96F,0x4E5B39];
			
			var rect:Sprite = new Sprite;
			rect.graphics.lineStyle(2, 0xFFFFFF, 1, true, "normal");
			rect.graphics.beginGradientFill('linear', gradColors, [1, 1], [0, 0xFF], matrix, "pad", "rgb", 0);
			rect.graphics.drawRoundRect(0, 0, w, h, 20, 20);
			rect.graphics.endFill();
			
			dsfilter = new DropShadowFilter(8.5, 45, 0x000000, .6, 12, 12, 1, 1); //distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject
			rect.filters = [dsfilter];
			rect.cacheAsBitmap = true;
			
			palette.addChild(rect);
			//palette.y = 90;
			
			menu.resultsBox.addChildAt(palette,0);
			palette.height = 120;
			center();

			timer = new Timer(17);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			var bluron:TweenLite = TweenLite.to(menu.resultsBox.circleMC.numTxt, .1, {blurFilter:{blurX:20, blurY:4, addFilter:true, quality:1} });
			
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			center();
			var n:Number = Math.floor(Math.random() * 13);
			menu.resultsBox.circleMC.numTxt.text = n;
			center();
		}
		
		public function reveal():void
		{
			menu.resultsBox.circleMC.foundTxt.scaleY = 0;
			menu.resultsBox.circleMC.foundTxt.visible = true;
			var tween1:TweenLite = TweenLite.to(menu.resultsBox.circleMC.bg.msk,.4,{scaleX:1, ease:Sine.easeOut, onComplete: tweenComplete});
			var tween2:TweenLite = TweenLite.to(palette,.4,{scaleY:1, ease:Sine.easeOut});
			
			
			function tweenComplete():void
			{
				var tween3:TweenLite = TweenLite.to(menu.resultsBox.circleMC.foundTxt,.6,{scaleY:1, ease:Elastic.easeOut, 
					onComplete:function():void
					{
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER, onTimer);
						menu.resultsBox.circleMC.numTxt.text = numWanted;
						
						var filtersoff:TweenLite = TweenLite.to(menu.resultsBox.circleMC.numTxt, .3, {blurFilter:{blurX:0, blurY:0, remove:true},
							glowFilter:{blurX:0, blurY:0, strength:0, alpha:0, remove:true}});
					} });
				
				var glowon:TweenLite = TweenLite.to(menu.resultsBox.circleMC.numTxt, .5, {glowFilter:{color:0xFFFFCC, blurX:8, blurY:8, strength:2, alpha:1, inner:true, addFilter:true, quality:3}});	
				var tween4:TweenLite = TweenLite.to(menu.resultsBox.body,.5,{alpha:1, ease:Sine.easeOut});
				var tween5:TweenLite = TweenLite.to(menu.resultsBox.scrollbar,.5,{alpha:1, ease:Sine.easeOut});
				var tween6:TweenLite = TweenLite.to(menu.resultsBox.groove,.5,{alpha:1, ease:Sine.easeOut});
				menu.doneBTN.alpha = 1;
				
			}
		}
		
		private function center():void 
		{
			menu.resultsBox.circleMC.numTxt.width = menu.resultsBox.circleMC.numTxt.textWidth;
			
			if(numWanted >= 10 && numWanted <= 19){
				menu.resultsBox.circleMC.numTxt.x = menu.resultsBox.circleMC.width/2 - menu.resultsBox.circleMC.numTxt.width/2 - 8;
				if(numWanted == 11) menu.resultsBox.circleMC.numTxt.x = menu.resultsBox.circleMC.width/2 - menu.resultsBox.circleMC.numTxt.width/2;
			}else{
				menu.resultsBox.circleMC.numTxt.x = menu.resultsBox.circleMC.width/2 - menu.resultsBox.circleMC.numTxt.width/2;
			}
			
			/*trace('currentArray.length = ' + currentArray.length)
			if(currentArray.length > 3) menu.resultsBox.circleMC.y = palette.height/2 - menu.resultsBox.circleMC.height/2
			else */menu.resultsBox.circleMC.y = -menu.resultsBox.circleMC.height/2;
			
			//if(scroller) menu.resultsBox.circleMC.y = -menu.resultsBox.circleMC.height/3;
				
			menu.resultsBox.x = 900/2 - (menu.resultsBox.width/2); //trace('menu.resultsBox.x = ' + menu.resultsBox.x);
			menu.resultsBox.y = 580/2 - (palette.height/2);

		}
		
		public function setButton(ID:String):void 
		{
			menu.doneBTN.alpha = .5;
		}
		
		public function onButtonSelect(ID:String):void 
		{
			//Do something special if button is selected
		}
		
		public function onButtonDown(ID:String):void 
		{
			//Do something special if button is clicked
			if(ID == 'done' && scroller) scroller.removeAllListeners();
		}
	}
}
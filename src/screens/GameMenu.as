package screens
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.core.ByteArrayAsset;
	
	public class GameMenu extends Sprite
	{
		[Embed('/assets/menus/game_menu.swf', mimeType="application/octet-stream")]
		private var Screen:Class;
		
		private var loader:Loader=new Loader;
		private var screen:ByteArrayAsset;
		private var menu:MovieClip;
		private var flashroot:ggfv_replace_snack;
		private var timer:Timer;
		private var readyTimer:Timer;
		private var count:int;
		private var smallFormat:TextFormat = new TextFormat('Bitwise',46);
		private var defaultFormat:TextFormat = new TextFormat('Bitwise',56);
		
		private var _isDone:Boolean = false;
		
		public function get isDone():Boolean
		{
			return _isDone;
		}
		
		public function set isDone(value:Boolean):void
		{
			_isDone = value;
			if(_isDone) 
			{
				flashroot.game.gcontrols.stop();
				flashroot.sound.runStop();
			}
		}
		
		public var isPaused:Boolean = false;
		
		public function GameMenu(FlashRoot:ggfv_replace_snack)
		{
			trace('GameMenu(): new game menu');
			flashroot = FlashRoot;
			screen = new Screen();
			loader.contentLoaderInfo.addEventListener(Event.INIT,init,false,0,true);
			loader.loadBytes(screen);
			
			if(flashroot.currentLevel == 'level1') count = flashroot.secondsL1;
			if(flashroot.currentLevel == 'level2') count = flashroot.secondsL2;
			
			timer = new Timer(1000,count);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
			
			readyTimer = new Timer(1000,4);
			readyTimer.addEventListener(TimerEvent.TIMER, onReadyTick);
			readyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onReadyTimeUp);
		}
		
		private function init(e:Event):void 
		{
			trace('GameMenu.init()');
			loader.contentLoaderInfo.removeEventListener(Event.INIT,init);
			if(menu == null) menu = MovieClip(loader.content);
			addChild(menu);
			start();
		}
		
		public function reset():void 
		{
			trace('GameMenu.reset()');
			readyTimer = new Timer(1000,4);
			readyTimer.addEventListener(TimerEvent.TIMER, onReadyTick);
			readyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onReadyTimeUp);
			
			if(flashroot.currentLevel == 'level1') count = flashroot.secondsL1;
			if(flashroot.currentLevel == 'level2') count = flashroot.secondsL2;
			
			timer = new Timer(1000,count);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
			//setMCs();
		}
		
		private function setMCs():void 
		{
			if(flashroot.currentLevel == 'level1')
			{
				menu.collect1.visible = true;
				menu.collect2.visible = false;
			}
			else if(flashroot.currentLevel == 'level2')
			{
				menu.collect2.visible = true;
				menu.collect1.visible = false;
			}
			menu.block.alpha = .2;
			menu.block.visible = true;
			menu.ready.visible = false;
			menu.setMC.visible = false;
			menu.go.visible = false;
			menu.whoops.visible = false;
			menu.timesUp.visible = false;
			menu.replaced.visible = false;
			menu.tryAgain.visible = false;
			menu.clock.green.visible = false;
			menu.clock.orange.visible = false;
		}
		
		public function start():void 
		{
			trace('GameMenu.start()');
			if(!isPaused) reset();
				
			if(readyTimer != null) 
			{
				readyTimer.start();
				setMCs();
				menu.clock.seconds.text = count;
				menu.clock.seconds.autoSize = 'center';
				if(count >= 100) menu.clock.seconds.setTextFormat(smallFormat) else menu.clock.seconds.setTextFormat(defaultFormat);
				centerTimerText();
			}
			else
			{
				timer.start();
				flashroot.playToggle();
				flashroot.game.gcontrols.start();
			}

			isDone = false;
			isPaused = false;
			flashroot.tryAgain = false;
		}
		
		public function pause():void 
		{
			timer.stop();
			isPaused = true;
		}
		
		private function onReadyTick(e:TimerEvent):void
		{
			if(readyTimer.currentCount == 2) {menu.ready.visible = true; flashroot.sound.ready();};
			if(readyTimer.currentCount == 3) {menu.ready.visible = false; menu.setMC.visible = true; menu.clock.orange.visible = true;};
		}
		
		private function onReadyTimeUp(e:TimerEvent):void
		{
			menu.go.alpha = 1;
			menu.go.visible = true;
			menu.setMC.visible = false;
			menu.clock.green.visible = true;
			
			readyTimer.removeEventListener(TimerEvent.TIMER, onReadyTick);
			readyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onReadyTimeUp);
			readyTimer = null;
			
			var tween1:TweenLite = TweenLite.to(menu.block,.3,{alpha:0, ease:Sine.easeOut, 
				onComplete: function():void
				{
					menu.block.visible = false;
					flashroot.game.gcontrols.start();
					timer.start();
					var tween2:TweenLite = TweenLite.to(menu.go,.3,{alpha:0, delay:.7, ease:Sine.easeOut});
					menu.helpBTN.buttonMode = true;
					menu.helpBTN.addEventListener(MouseEvent.MOUSE_DOWN, onHelp);
					menu.helpBTN.addEventListener(MouseEvent.MOUSE_OVER, onHelpOver);
				} 
			});
			
		}
		
		private function onTick(e:TimerEvent):void
		{
			count--;
			menu.block.visible = false;
			menu.clock.orange.visible = false
			menu.clock.seconds.text = count;
			if(count > 10) menu.clock.green.visible = true;
			if(count == 10) {menu.clock.green.visible = false; flashroot.sound.clock()};
			if(count > 99) menu.clock.seconds.setTextFormat(smallFormat) else menu.clock.seconds.setTextFormat(defaultFormat);
			centerTimerText();
		}
		
		
		private function centerTimerText():void
		{
			if(count > 99)
			{
				menu.clock.seconds.x = menu.clock.width/2 - menu.clock.seconds.width/2 - 5;
				menu.clock.seconds.y = menu.clock.height/2 - menu.clock.seconds.height/2 + 2;
			}
			else if(count >= 10 && count <= 19)
			{
				menu.clock.seconds.x = menu.clock.width/2 - menu.clock.seconds.width/2 - 4;
				menu.clock.seconds.y = menu.clock.height/2 - menu.clock.seconds.height/2 + 3;
			}	
			else
			{
				menu.clock.seconds.x = menu.clock.width/2 - menu.clock.seconds.width/2 - 2;
				menu.clock.seconds.y = menu.clock.height/2 - menu.clock.seconds.height/2 + 3;
			}
			
			
		}
		
		private function onTimeUp(e:TimerEvent):void
		{
			flashroot.sound.runStop();
			flashroot.sound.stopAllThrusters();
			flashroot.sound.buzzer();
			trace('fuckin stop!');
			isDone = true;
			menu.clock.orange.visible = false;
			menu.timesUp.visible = true;
			flashroot.playToggle();
			menu.helpBTN.removeEventListener(MouseEvent.MOUSE_DOWN, onHelp);
			menu.helpBTN.removeEventListener(MouseEvent.MOUSE_OVER, onHelpOver);
			
			if(menu.whoops.visible) 
				var tween:TweenLite = TweenLite.to(menu.whoops,.3,{alpha:0, ease:Sine.easeOut,onComplete: function():void{ menu.whoops.visible = false; } });
		}
		
		public function onHelp(e:MouseEvent):void
		{
			pause();
			flashroot.playToggle();
			flashroot.game.gcontrols.stop();
			if(flashroot.holderSound) flashroot.holderSound.mouse();
			
		}
		
		public function onHelpOver(e:MouseEvent):void
		{
			if(flashroot.holderSound) flashroot.holderSound.dit();
		}
		
		public function allReplaced():void
		{
			isDone = true;
			flashroot.playToggle();
			menu.replaced.visible = true;
			flashroot.sound.allReplaced();
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTick);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
			menu.helpBTN.removeEventListener(MouseEvent.MOUSE_DOWN, onHelp);
			
			if(menu.whoops.visible) 
				var tween:TweenLite = TweenLite.to(menu.whoops,.3,{alpha:0, ease:Sine.easeOut,onComplete: function():void{ menu.whoops.visible = false; } });
		}
		
		public function onWrong(Feedback:String):void
		{
			menu.whoops.alpha = 0;
			menu.whoops.visible = true;
			menu.whoops.addChild(makeFB(Feedback));
			
			var tween1:TweenLite = TweenLite.to(menu.whoops,.3,{alpha:1, ease:Sine.easeOut, 
				onComplete: function():void
				{
					flashroot.sound.whoops();
					var tween2:TweenLite = TweenLite.to(menu.whoops,.3,{alpha:0, delay:5, ease:Sine.easeOut,
						onComplete: function():void{ menu.whoops.visible = false; } });
				} 
			})
		}
		
		private function makeFB(Feedback:String):Sprite
		{
			if(menu.whoops.numChildren > 1) while(menu.whoops.numChildren > 1) menu.whoops.removeChildAt(menu.whoops.numChildren-1);
			
			var fb:Sprite = new Sprite();
			
			var txt:TextField = new TextField();
			//txt.setTextFormat(flashroot.css.format);
			txt.embedFonts = true; 
			txt.multiline = true;
			txt.wordWrap = true;
			txt.antiAliasType = 'advanced';
			txt.styleSheet = flashroot.css;
			txt.width = 500; // set max width of txt
			txt.text = '<p class = "whoops">' +Feedback+ '</p>';
			txt.autoSize = 'center';
			txt.width = txt.textWidth + 6; 
			txt.height = txt.textHeight + 4;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(txt.width + 30, txt.height + 30, Math.PI/2, 0, 0);
			
			var gradColors:Array = [0xE16D71,0xB01E2B];
			
			var rect:Sprite = new Sprite;
			rect.graphics.lineStyle(2, 0xFFFFFF, 1, true, "normal");
			rect.graphics.beginGradientFill('linear', gradColors, [1, 1], [0, 0xFF], matrix, "pad", "rgb", 0);
			rect.graphics.drawRoundRect(0, 0, txt.width + 30, txt.height + 30, 20, 20);
			rect.graphics.endFill();
			
			var dsfilter:DropShadowFilter = new DropShadowFilter(8.5, 45, 0x000000, .6, 12, 12, 1, 1); //distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject
			rect.filters = [dsfilter];
			rect.cacheAsBitmap = true;
			fb.addChild(rect);
			
			txt.x = txt.y = 15;
			fb.addChild(txt);
			
			fb.y = 120;
			fb.x = menu.whoops.width/2 - fb.width/2;
			
			return fb;
			
			
		}
		
		public function haveToPlayAgain():Boolean
		{
			var n:int;
			var b:Boolean;
			
			for each (var item:Object in flashroot.caughtArrayL1)
			{
				if(item.wanted) n++;
			}
			
			if(n == 0) b = true else b = false;
			if(b) {menu.timesUp.visible = false; menu.tryAgain.visible = true; flashroot.tryAgain = true; flashroot.sound.tryagain();};
			//trace('haveToPlayAgain = ' + b);
			return b;
		}
	}
}
package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.display.Bitmap;
//	import flash.display.DisplayObject;
	import flash.display.Sprite;
//	import flash.display.Stage;
	import flash.display.Stage3D;
//	import flash.display.StageAlign;
//	import flash.display.StageScaleMode;
//	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
    import screens.Wrapper;

import starling.events.Event;

//import flash.system.System;
	
	import gameobjects.ArtRegistry;
	import gameobjects.ObjectRegistry;
	
	import managers.CSS;
	import managers.SoundManager;
	
	import screens.*;
	
	import starling.core.Starling;
	
	import statemachine.*; 

	[SWF(frameRate=60, width=900, height=580, backgroundColor='#2A3146')]
	[Frame(factoryClass="screens.Preloader")]

	public class ggfv_replace_snack extends Sprite
	{
		
		private var s3d:Stage3D;
		private var tween:TweenLite;
        public var wrapper:Wrapper;
		public var star:Starling;
		public var viewport:Rectangle;
		public var game:Game;
		public var machine:StateMachine;
		public var currentScreen:*;
		public var prevScreen:*;
		
		public var choosemenu:ChooseMenu;
		public var instructmenu:InstructMenu;
		public var resultsmenu:ResultsMenu;
		public var gamemenu:GameMenu;
		public var gameovermenu:GameOverMenu;
		public var blocker:Sprite; // blocks game menu and game for fades, same color as bg
		
		public var currentLevel:String = States.LEVEL1;
		public var actor:String;
		public var caughtArrayL1:Array = new Array();
		public var caughtArrayL2:Array = new Array();
		public var numWantedL1:int;
		public var tformat:TextFormat;
		public var css:CSS = new CSS();
		public var prevGameSceen:int= -1;
		public var tryAgain:Boolean = false;
		public var firstGame:Boolean = true;
		public var bgColor:Number;
		public var pre:Bitmap;
		
		public var sound:SoundManager = new SoundManager();
		
		//Set Game times here
		public var secondsL1:int = 120;//120
		public var secondsL2:int = 60;//60
		
		//To be set by gameholder.swf
		public var onDone:Function;
		public var onDownload:Function;
		public var onBack:Function;
		public var onMakePDF:Function;
		public var onStart:Function;
		public var changeGoalAbility:Boolean = true;
		
		// use sounds from gameholder for menus
		public var holderSound:*;
		
		//args for onMakePDF function
		public var handoutObj:*; //optional wildcard object to pass info/images to gameholder for PDF creation
		
		public function ggfv_replace_snack()
		{
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_BORDER;
			bgColor = 0x2A3146;// gameholder gets this so stage color can be set custom per game
		}
		
		
		public function start():void 
		{
			trace (this + ' has started');
			if(onStart != null) onStart();
			machine = new StateMachine(); 
			machine.addState(States.CHOOSE_MENU, new ChooseState(this), [States.INSTRUCT_MENU]);
			machine.addState(States.INSTRUCT_MENU, new InstructState(this), [States.LEVEL1, States.LEVEL2]);
			machine.addState(States.LEVEL1, new Level1State(this), [States.RESULTS_MENU, States.INSTRUCT_MENU]);
			machine.addState(States.LEVEL2, new Level2State(this), [States.RESULTS_MENU, States.INSTRUCT_MENU]);
			machine.addState(States.RESULTS_MENU, new ResultsState(this), [States.INSTRUCT_MENU, States.GAME_OVER]);
			machine.addState(States.GAME_OVER, new GameOverState(this), [States.CHOOSE_MENU]);
			
			machine.setState(States.CHOOSE_MENU);
			
			this.addEventListener(flash.events.Event.ENTER_FRAME, update);
		}
		
		protected function update(e:flash.events.Event):void
		{
			machine.update();
			//trace(machine.current);
			//trace('memory in use: ' + System.totalMemory);
		}
		
		public function startStarling():void 
		{
			//trace('create star');
			//create new Starling instance	
			//use this for release
			viewport = new Rectangle(0,0,stage.stageWidth, stage.stageHeight);
			star = new Starling(Wrapper, stage, viewport);
			s3d = stage.stage3Ds[0];
			s3d.addEventListener(flash.events.Event.CONTEXT3D_CREATE, onContextCreated);

			//set antiAliasing (0-16, higher better but slower performance)
			star.antiAliasing = 1;	
			//star.showStats = true;
			playToggle();
		}
		
		
		
		private function onContextCreated(e:flash.events.Event):void
		{
			trace('CONTEXT3D CREATED');
			s3d.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, onContextCreated);
			star.makeCurrent();
			ArtRegistry.init();
			ObjectRegistry.init();
		}
		
		public function setLevel(Level:String):void 
		{
			trace('set state to ' + Level);
			if(!blocker)
			{
				blocker = new Sprite;
				blocker.graphics.beginFill(bgColor);
				blocker.graphics.drawRect(0,0,900,580);
				blocker.graphics.endFill();
				blocker.cacheAsBitmap = true;
				addChildAt(blocker,0);
			}
			
			star.start();
			currentLevel = Level;
			startGame();
			machine.setState(Level);
		}
		
		private function startGame():void
		{
			trace('startGame');
			
			if(firstGame)
			{
				trace('star set 0 as game');
                game = new Game();
				wrapper = star.stage.getChildAt(0) as Wrapper;
                wrapper.addChild(game);
			}
			else
			{
				trace('make new game');
				game = new Game();
				wrapper.addChildAt(game,0);
			}
			
			game.flashroot = this;
			game.actor = actor;
			game.start();
			
			if(!tryAgain) switchScreens(star,1) else currentScreen = star;
			sound.musicStop();
		}
		
		public function switchScreens(Screen:*, Delay:Number = 0):void 
		{
			stage.dispatchEvent(new flash.events.Event(flash.events.Event.RESIZE));
			prevScreen = currentScreen;
			currentScreen = Screen;
			if(prevScreen != star && prevScreen != pre) if(prevScreen.bitmap) prevScreen.showBitmap = true;
			if(currentScreen != star && currentScreen != pre) if(currentScreen.bitmap) currentScreen.showBitmap = true;
			screenOff(Delay);
		}
		
		private function screenOn():void 
		{
			//trace('currentScreen=' + currentScreen);
			if(currentScreen != star  ) currentScreen.visible = true;
			if(prevScreen != star && prevScreen != pre)
			{
				prevScreen.visible = false;
				if(prevScreen.bitmap) prevScreen.showBitmap = false;
			}
				
			
			if(currentScreen == star  )
			{
				//trace('game.alpha = ' + game.alpha);
				tween = TweenLite.to(blocker,.4,{alpha:0, ease:Sine.easeIn, onComplete: function():void{ blocker.visible = false } });
			}
			else
			{
				tween = TweenLite.to(currentScreen,.4,{alpha:1, ease:Sine.easeIn, onComplete: function():void{ currentScreen.showBitmap = false }})
			}
		}
		
		private function screenOff(Delay:Number):void 
		{
			//trace('prevScreen =' + prevScreen);
			if(prevScreen == star)
			{
				blocker.visible = true ;
				tween = TweenLite.to(blocker,.4,{alpha:1, ease:Sine.easeIn, delay:Delay, onComplete: screenOn});
			}		
			else 
			{
				tween = TweenLite.to(prevScreen,.4,{alpha:0, ease:Sine.easeIn, delay:Delay, onComplete: screenOn});
			}
			
			if(prevScreen != pre) sound.sweep();
		}
		
		public function playToggle():void
		{
			trace('playToggle')
			if(star.isStarted) 
			{
				trace('star stop')
				sound.runStop();
				sound.stopAllThrusters(false);
				sound.clockPause();
				star.stop();
			} else {
				trace('star start')
				star.start();
				sound.restartThrusters();
				if(sound.clockStartTime != 0) sound.clock();
			}
		}
		
		public function resetGame():void
		{
			trace('reset game');
			firstGame = false;
			sound.reset();
			game.reset();
			wrapper.removeChild(game);
			game = null;
			gamemenu.reset();
			ObjectRegistry.reset();
		}
		
		public function done():void
		{
			if(onDone != null) 
			{
				onDone();
				sound.musicStop();
			}
		}
		
		public function download():void
		{
			if(onDownload != null) onDownload();
		}
		
		public function back():void
		{
			if(onBack != null) 
			{
				onBack();
				sound.musicStop();
			}
		}
		
		public function makePDF():void
		{
			if(onMakePDF != null) onMakePDF(handoutObj);
		}
		
		
	}
}
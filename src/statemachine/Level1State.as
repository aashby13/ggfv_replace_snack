package statemachine
{
	import flash.display.Sprite;
	
	import screens.Game;
	import screens.GameMenu;
	
	import statemachine.States;
	
	public class Level1State implements IState
	{
		private var flashroot:ggfv_replace_snack;
		private var tick:int = 0;

		public function Level1State(FlashRoot:ggfv_replace_snack)
		{
			flashroot = FlashRoot;
		}
		
		public function enter():void
		{
			//trace('enter level1 state');
			if(flashroot.gamemenu == null)
			{
				flashroot.gamemenu = new GameMenu(flashroot);
				flashroot.addChildAt(flashroot.gamemenu,0);
			}
			else
			{
				flashroot.gamemenu.start();
			}
		}
		
		public function update(tickCount:int):void
		{
			if(flashroot.gamemenu.isDone) countTicks();
			if(flashroot.gamemenu.isPaused) flashroot.machine.setState(States.INSTRUCT_MENU);
			if(flashroot.game) if(flashroot.game.dude.graphic.readyBody) countReadyTicks();
			//trace(flashroot.sound.soundArray.length);
		}
		
		public function exit():void
		{
			//if(flashroot.gamemenu.isDone)flashroot.game.gcontrols.stop();
		}
		
		private function countReadyTicks():void 
		{
			flashroot.game.dude.graphic.readyTick++
			if(flashroot.game.dude.graphic.readyTick >= flashroot.game.dude.graphic.readyTickMax) 
			{
				flashroot.game.dude.graphic.readyBody = null;
				flashroot.game.dude.graphic.readyTick = 0;
			}
		}
		
		private function countTicks():void 
		{
			tick++
			//trace('tick' + tick);	
			if(tick == 1) flashroot.caughtArrayL1 = flashroot.game.caughtArray;
			
			if(tick == 180) if(!flashroot.gamemenu.haveToPlayAgain()) {flashroot.machine.setState(States.RESULTS_MENU), tick = 0};
			
			if(tick == 300)
			{	
				tick = 0;
				flashroot.resetGame();
				flashroot.setLevel(States.LEVEL1);
				enter();
			}
		}
	}
}
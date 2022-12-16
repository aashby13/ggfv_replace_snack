package statemachine
{
	import flash.display.Sprite;
	
	import screens.GameMenu;
	
	import statemachine.States;
	
	public class Level2State implements IState
	{
		private var flashroot:*;
		private var tick:int = 0;
		
		public function Level2State(FlashRoot:Sprite)
		{
			flashroot = FlashRoot;
		}
		
		public function enter():void
		{
			if(flashroot.gamemenu == null)
			{
				flashroot.gamemenu = new GameMenu(flashroot);
				flashroot.addChildAt(flashroot.gamemenu,0);
			}
			else
			{
				flashroot.gamemenu.start();
			}
			
			tick == 0;
			
		}
		
		public function update(tickCount:int):void
		{
			if(flashroot.gamemenu.isDone) countTicks();
			if(!flashroot.gamemenu.isDone && flashroot.numWantedL1 == flashroot.game.caughtArray.length) flashroot.gamemenu.allReplaced();
			if(flashroot.gamemenu.isPaused) flashroot.machine.setState(States.INSTRUCT_MENU);
			if(flashroot.game) if(flashroot.game.dude.graphic.readyBody) countReadyTicks();
		}
		
		public function exit():void
		{
			flashroot.caughtArrayL2 = flashroot.game.caughtArray;
		}
		
		private function countReadyTicks():void 
		{
			flashroot.game.dude.graphic.readyTick++
			if(flashroot.game.dude.graphic.readyTick >= flashroot.game.dude.graphic.readyTickMax) 
			{
				flashroot.game.dude.graphic.readyBody = null;
				flashroot.game.dude.graphic.readyTick = 0;
			}
			
			trace('dude.graphic.readyBody is active');
		}
		
		private function countTicks():void 
		{
			tick++
			if(tick == 180) {flashroot.machine.setState(States.RESULTS_MENU), tick = 0};
		}
	}
}
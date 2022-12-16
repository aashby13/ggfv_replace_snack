package statemachine
{
	import flash.display.Sprite;
	
	import screens.ResultsMenu;
	
	import statemachine.States;
	
	public class ResultsState implements IState
	{
		private var flashroot:*;
		
		public function ResultsState(FlashRoot:Sprite)
		{
			flashroot = FlashRoot;
		} 
		
		public function enter():void
		{
			if(flashroot.resultsmenu == null)
			{
				flashroot.resultsmenu = new ResultsMenu(flashroot);
				flashroot.addChild(flashroot.resultsmenu);
			}
			else
			{
				flashroot.resultsmenu.start();
				flashroot.resultsmenu.controls.start();
			}
			
			flashroot.switchScreens(flashroot.resultsmenu);
			flashroot.sound.roll(flashroot.resultsmenu.reveal);
		}
		
		public function update(tickCount:int):void
		{
			//flashroot.resultsmenu.alpha = .2
			if(tickCount == 60) { flashroot.resetGame()};
				
			
			if(flashroot.currentScreen.isDone) 
			{
				if(flashroot.currentLevel == States.LEVEL1)
				{
					flashroot.currentLevel = States.LEVEL2;
					flashroot.machine.setState(States.INSTRUCT_MENU)
				} else {
					flashroot.machine.setState(States.GAME_OVER);
				}

			}
		}
		
		public function exit():void
		{
			flashroot.resultsmenu.isDone = false;
			flashroot.resultsmenu.controls.stop();
		}
	}
}
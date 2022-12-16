package statemachine
{
	import flash.display.Sprite;
	
	import screens.GameOverMenu;
	
	import statemachine.States;
	
	public class GameOverState implements IState
	{
		private var flashroot:*;
		
		public function GameOverState(FlashRoot:Sprite)
		{
			flashroot = FlashRoot;
		}
		
		public function enter():void
		{
			if(flashroot.gameovermenu == null)
			{
				flashroot.gameovermenu = new GameOverMenu(flashroot);
				flashroot.addChild(flashroot.gameovermenu);
			}
			else
			{
				//flashroot.gameovermenu.start();
				flashroot.gameovermenu.controls.start();
			}
			
			flashroot.makePDF();
			flashroot.switchScreens(flashroot.gameovermenu);
		}
		
		public function update(tickCount:int):void
		{
			if(flashroot.currentScreen.isDone) flashroot.machine.setState(States.CHOOSE_MENU);
		}
		
		public function exit():void
		{
			flashroot.gameovermenu.isDone = false;
			flashroot.gameovermenu.controls.stop();
		}
	}
}
package statemachine
{
	import flash.display.Sprite;
	
	import screens.ChooseMenu;
	
	import statemachine.States;

	public class ChooseState implements IState
	{
		private var flashroot:*;
		
		public function ChooseState(FlashRoot:Sprite)
		{
			flashroot = FlashRoot;
		}
		
		public function enter():void
		{
			if(flashroot.choosemenu == null)
			{
				flashroot.choosemenu = new ChooseMenu(flashroot);
				flashroot.addChild(flashroot.choosemenu);
			}
			else
			{
				flashroot.choosemenu.controls.start();
			}
			
			flashroot.switchScreens(flashroot.choosemenu);
		}
		
		public function update(tickCount:int):void
		{
			if(tickCount == 60)
			{
				flashroot.caughtArrayL1 = [];
				flashroot.caughtArrayL2 = [];
			}
			
			if(flashroot.currentScreen.isDone) flashroot.machine.setState(States.INSTRUCT_MENU);
		}
		
		public function exit():void
		{
			flashroot.sound.musicStart();
			flashroot.currentScreen.isDone = false;
			flashroot.actor = flashroot.choosemenu.actor;
			flashroot.choosemenu.controls.stop();
		}
		
	}
}
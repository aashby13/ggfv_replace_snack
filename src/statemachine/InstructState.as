package statemachine
{
	import flash.display.Sprite;
	import screens.InstructMenu;
	//import statemachine.States;
	
	public class InstructState implements IState
	{
		private var flashroot:*;
		private var tick:int = 0;
		
		public function InstructState(FlashRoot:Sprite)
		{
			flashroot = FlashRoot;
		}
		
		public function enter():void
		{
			//trace('enter Instruct State');
			if(flashroot.instructmenu == null)
			{
				flashroot.instructmenu = new InstructMenu(flashroot);
				flashroot.addChild(flashroot.instructmenu);
			}
			else
			{
				flashroot.instructmenu.setText(flashroot.currentLevel);
				flashroot.instructmenu.controls.start();
			}
			
			tick = 0;
			flashroot.switchScreens(flashroot.instructmenu);
		}
		
		public function update(tickCount:int):void
		{
			//trace("update instruct state. game = "+ flashroot.game);
			if(flashroot.instructmenu.isDone && flashroot.game == null)
			{
				flashroot.setLevel(flashroot.currentLevel);
				trace('flashroot.setLevel(' +flashroot.currentLevel+')');
			}
			
			if(flashroot.instructmenu.isDone && flashroot.game != null) 
			{
				flashroot.machine.setState(flashroot.currentLevel);
				flashroot.switchScreens(flashroot.star);
			}
		}
		
		public function exit():void
		{
			flashroot.instructmenu.isDone = false;
			flashroot.instructmenu.controls.stop();
		}
	}
}
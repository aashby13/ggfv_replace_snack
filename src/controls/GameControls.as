package controls
{
	import flash.ui.Keyboard;
	
	import gameobjects.Dude;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class GameControls
	{
		private var main:Sprite;
		private var dude:Dude;
		private var flashroot:*;
		
		public function GameControls(MAIN:Sprite)
		{
			main = MAIN;	
		}
		
		public function set(DUDE:Dude,FlashRoot:Object):void
		{
			dude = DUDE;
			flashroot = FlashRoot;
		}
		
		public function start():void
		{
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownMove);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpMove);
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownJump);	
			main.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpJump);
		}
		
		public function stop():void
		{
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownMove);
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpMove);
			main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownJump);	
			main.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpJump);
			dude.stand();
		}
		
		private function onKeyDownMove(e:KeyboardEvent):void
		{
			//trace("down " + e.keyCode);
			switch (e.keyCode)
			{
				case Keyboard.RIGHT: // right arrow
					dude.runRight();
					break;
				case Keyboard.D:// D for right
					dude.runRight();
					break;
				case Keyboard.LEFT: // left arrow
					dude.runLeft();
					break;
				case Keyboard.A: // A for left
					dude.runLeft();
					break;
				case Keyboard.X: // X for pickup
					//flashroot.star.dispose();
					break;
				case Keyboard.ENTER: 
					flashroot.gamemenu.onHelp(null);
					//trace()
					break;
				default:
					break;
			}
		}
		
		private function onKeyUpMove(e:KeyboardEvent):void
		{
			//trace("up " + e.keyCode);
			switch (e.keyCode)
			{
				case Keyboard.RIGHT: // right arrow
					dude.stand();
					break;
				case Keyboard.D:// D for right
					dude.stand();
					break;
				case Keyboard.LEFT: // left arrow
					dude.stand();
					break;
				case Keyboard.A: // A for left
					dude.stand();
					break;
				case Keyboard.X: // X for pickup
					dude.pickupOrToss();
					break;
				default:
					break;
			}
		}
		
		private function onKeyDownJump(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE) dude.jumpKeyDown();
					
		}
		
		private function onKeyUpJump(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE ) dude.jumpKeyUp(); 
		}
		
	}
}
package controls
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import screens.InstructMenu;

	public class MenuControls
	{
		private var array:Array;
		private var menu:Object;
		private var hsound:*
		
		public function MenuControls(Menu:Object,HolderSound:* = null)
		{
			menu = Menu;
			hsound = HolderSound;
			array = menu.btnArray;
			start();
		}
		
		public function start():void
		{
			for each (var button:Object in array)
			{
				setButton(button);
				button.addEventListener(MouseEvent.MOUSE_OVER, over);
				button.addEventListener(MouseEvent.MOUSE_DOWN, down);
			}
			
			menu.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function stop():void
		{
			for each (var button:Object in array)
			{
				button.buttonMode = false;
				button.removeEventListener(MouseEvent.MOUSE_OVER, over);
				button.removeEventListener(MouseEvent.MOUSE_DOWN, down);
			}
			
			menu.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function over(e:MouseEvent):void
		{
			if(e.currentTarget.alpha == 1) onSelect(e.currentTarget);
		}
		
		private function down(e:MouseEvent):void
		{
			if(e.currentTarget.alpha  == 1) onEnter(e.currentTarget);
		}
		
		private function onSelect(Button:Object):void 
		{
			if(hsound) hsound.dit();
			Button.over.visible = true;
			Button.off.visible = false;
			Button.on = true;
			menu.onButtonSelect(Button.id);
			
			for each (var button:Object in array)
			{
				if(button.id != Button.id)
				{
					button.over.visible = false;
					button.off.visible = true;
					button.on = false;
				}
			}
	
		}
		
		private function onEnter(Button:Object):void
		{

			if(Button.id == 'done') 
			{
				stop();
				onSelect(Button);
				menu.onButtonDown(Button.id);
				menu.isDone = true;
				if(hsound) hsound.mouse();
			} 
			else 
			{
				if(menu.toString() != '[object InstructMenu]') {if(hsound) hsound.mouse(); trace('menu = InstructMenu = false')};
				menu.onButtonDown(Button.id);
			}
		}
		
		public function setButton(Button:Object):void 
		{
			//trace('setButton ' + Button.id);
			Button.buttonMode = true;
			
			if(Button == array[0])
			{
				//trace('set first button' + 0);
				Button.over.visible = true;
				Button.on = true;
			} 
			else
			{
				Button.over.visible = false;
				Button.off.visible = true;
				Button.on = false;
			}
			//Special shit
			if(menu.setButton) menu.setButton(Button.id);
					
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			var i:int;
			var n:int;
			
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
					for (i=0; array.length > i; i++) 
					{
						if(array[i].on)
						{
							n = i - 1
							if(n == -1) n = array.length-1;
							if(array[n].alpha != 1) n--;
							if(n == -1) n = array.length-1;
							onSelect(array[n]);
							return;
						}	
					} 
					break;
				case Keyboard.RIGHT:
					for (i=0; array.length > i; i++) 
					{
						if(array[i].on)
						{
							n = i + 1
							if(n == array.length) n = 0;
							if(array[n].alpha != 1) n++;
							if(n == array.length) n = 0;
							onSelect(array[n]);
							return;
						}	
					}
					break;
				case Keyboard.ENTER:
					for (i=0; array.length > i; i++) 
					{
						if(array[i].on)
						{
							onEnter(array[i]);
							return;
						}	
					}
					break;
				case Keyboard.X:
					for each (var button:Object in array)
				{
					if(button.id == 'done' || button.id == 'quit')
					{
						if(button.alpha == 1) { onSelect(button); onEnter(button); }
						return;
					}	
				}
					break;
				default:
					break;
			}
		}
		
		
	}
}
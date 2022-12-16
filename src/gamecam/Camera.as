package gamecam 
{
	import flash.geom.Rectangle;
	
	import gameobjects.ObjectRegistry;
	
	import nape.phys.Body;
	
	import starling.display.Sprite;

	
	public class Camera
	{
		public var X:Number;
		public var Y:Number;
		public var player:Body;
		private var bounds:Rectangle;
		private var world:Sprite;
		
		private var bg:Background;
		private var mbg:Mountains;
		private var bmg:City;
		private var mg:Midground;
        private var _viewport:Rectangle;
		
		public function Camera(PLAYER:Body, BOUNDS:Rectangle, WORLD:Sprite, VIEWPORT:Rectangle = null)
		{
			player = PLAYER;
			bounds = BOUNDS;
			world = WORLD;
			
			bg = ObjectRegistry.background;
			mbg = ObjectRegistry.mountains;
			bmg = ObjectRegistry.city;
			mg = ObjectRegistry.midground;
			
			world.addChildAt(bg,0);
			world.addChildAt(bmg,1);
			world.addChildAt(mbg,2);
			world.addChildAt(mg,3);
			
			if(!VIEWPORT) _viewport = new Rectangle(0,0,world.stage.stageWidth,world.stage.stageHeight)
			else _viewport = VIEWPORT;
			
			//need to set starting points for bg.y/mg.ys
			if(bg) bg.y = 2023;
			if(bmg) bmg.y = 1987;
			if(mbg) mbg.y = 1927;
			if(mg) mg.y = 1739;
		}
		
		public function update():void
		{
			
			//Determine X
			if (player.position.x < _viewport.width/2 )
			{
				X = 0;
			}
			else if (player.position.x > ( bounds.width - (_viewport.width/2) ) )
			{
				X = (bounds.width - _viewport.width ) * -1;
				//trace('at end')
			}
			else
			{
				X = (_viewport.width/2) - player.position.x;
				backgroundUpdateX();
				backMidgroundUpdateX();
				midBackgroundUpdateX();
				midgroundUpdateX();
			};
			
			//Determine Y
			if (player.position.y > (bounds.height - _viewport.height/2))
			{
				Y = -(bounds.height -_viewport.height);
				//trace(bottom);
			}
			else if (player.position.y < _viewport.height/2 )
			{
				Y = 0;
				//trace('top');
			}
			else
			{
				Y = (_viewport.height/2) - player.position.y;
				backgroundUpdateY();
				backMidgroundUpdateY();
				midBackgroundUpdateY();
				midgroundUpdateY();
				//trace('mid');
			};
			
			world.x = X;
			world.y = Y;
		}
		
		private function backgroundUpdateX():void
		{
			if(bg)
			{
				bg.x = player.position.x - (_viewport.width/2) - ((player.position.x - _viewport.width/2)/8);
			}
		}
		
		private function backgroundUpdateY():void
		{
			if(bg)
			{
				bg.y = (player.position.y - _viewport.height/2) - (player.position.y - _viewport.height/2)/8; 
				//trace(bg.y);
			}
		}
		
		private function backMidgroundUpdateX():void
		{
			if(bmg)
			{
				bmg.x = player.position.x - (_viewport.width/2) - ((player.position.x - _viewport.width/2)/7);
			}
		}
		
		private function backMidgroundUpdateY():void
		{
			if(bmg)
			{
				bmg.y = (player.position.y - _viewport.height/2) - (player.position.y - _viewport.height/2)/7;
				//trace(bmg.y);
			}
		}
		
		private function midBackgroundUpdateX():void
		{
			if(mbg)
			{
				mbg.x = player.position.x - (_viewport.width/2) - ((player.position.x - _viewport.width/2)/6);
			}
		}
		
		private function midBackgroundUpdateY():void
		{
			if(mbg)
			{
				mbg.y = (player.position.y - _viewport.height/2) - (player.position.y - _viewport.height/2)/6;
				//trace(mbg.y);
			}
		}
		
		private function midgroundUpdateX():void
		{
			if(mg)
			{
				mg.x = player.position.x - (_viewport.width/2) - ((player.position.x - _viewport.width/2)/4);
			}
		}
		
		private function midgroundUpdateY():void
		{
			if(mg)
			{
				mg.y = (player.position.y - _viewport.height/2) - (player.position.y - _viewport.height/2)/4; 
				//trace(mg.y);
			}
		}
    }
}
package managers
{
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.callbacks.PreListener;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.phys.Body;
	import nape.phys.Interactor;
	import nape.space.Space;
	
	public class CollisionDectcor
	{
		private var space:Space;
		
		public function CollisionDectcor(SPACE:Space)
		{
			space = SPACE;
		}
		
		public function checkCollisionByGraphic( TYPE1:CbType, TYPE2:CbType, Graphic1Array:Array, Graphic2Array:Array, Player:Body,  FuncArray:Array = null):void
		{
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION,TYPE1,TYPE2, onCollision));

			function onCollision(cb:InteractionCallback):void
			{
				var n:Number = Math.sqrt((cb.int1.castBody.position.x - Player.position.x) * (cb.int1.castBody.position.x - Player.position.x)
					+ (cb.int1.castBody.position.y - Player.position.y) * (cb.int1.castBody.position.y - Player.position.y));
				
				if(n < 900)
				{
					for (var i:int = 0; Graphic2Array.length > i; i++)
					{
						if(cb.int1.castBody.graphic.kind == Graphic1Array[i] && cb.int2.castBody.graphic.kind == Graphic2Array[i]) 
						{
							if(FuncArray[i].length == 2) FuncArray[i](Player,cb.int1.castBody);
							if(FuncArray[i].length == 3) FuncArray[i](Player,cb.int1.castBody, cb.int2.castBody);
						}
					}
					
				}
			}
		}
		
		public function checkDistanceOnCollision( TYPE1:CbType, TYPE2:CbType, DISTANCE:Number, ifTrueFUNC:Function = null, ifFalseFUNC:Function = null):void
		{
			space.listeners.add(new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION,TYPE1,TYPE2, onCollision));
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION,TYPE1,TYPE2, onCollision2));
			
			function onCollision(cb:InteractionCallback):void
			{
				var n:Number = Math.sqrt((cb.int1.castBody.position.x - cb.int2.castBody.position.x) * (cb.int1.castBody.position.x - cb.int2.castBody.position.x)
					+ (cb.int1.castBody.position.y - cb.int2.castBody.position.y) * (cb.int1.castBody.position.y - cb.int2.castBody.position.y));
				
				//trace(n);
				
				if(n < DISTANCE)
				{
					//trace('with in distance  = true');
					if(ifTrueFUNC != null) ifTrueFUNC(cb.int2.castBody);
					space.listeners.remove(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION,TYPE1,TYPE2, onCollision2));
				}
				
			}
			
			function onCollision2(cb:InteractionCallback):void
			{
				if(ifFalseFUNC != null) ifFalseFUNC(cb.int2.castBody);
			}
		}
		
		// this function checks TYPE2 is below TYPE1 on Collision
		public function checkCollisionBelow( TYPE1:CbType, TYPE2:CbType, ifTrueFUNC:Function = null, ifFalseFUNC:Function = null):void
		{
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION,TYPE1,TYPE2, onCollision));
			
			function onCollision(cb:InteractionCallback):void
			{
				//trace(cb.int2.castBody.graphic); 
				if(cb.int2.castBody.graphic.kind == 'platform-reg')
				{
					if (ifTrueFUNC.length == 2 && ifTrueFUNC != null) ifTrueFUNC(cb.int1.castBody, cb.int2.castBody)
					else if(ifTrueFUNC != null) ifTrueFUNC();
				}
				else if(cb.int1.castBody.bounds.y + (cb.int1.castBody.bounds.height/2) < cb.int2.castBody.bounds.y/* - (cb.int2.castBody.bounds.height/2)*/)
				{
					//trace('Collision Below  = true');
					if (ifTrueFUNC.length == 2 && ifTrueFUNC != null) ifTrueFUNC(cb.int1.castBody, cb.int2.castBody)
					else if(ifTrueFUNC != null) ifTrueFUNC();	
				}
				else
				{
					//trace('Collision Below  = false');
					if (ifFalseFUNC.length == 2 && ifFalseFUNC != null) ifFalseFUNC(cb.int1.castBody, cb.int2.castBody)
					else if(ifFalseFUNC != null) ifFalseFUNC();				
				}
			}
		}
		
		// this function checks TYPE2 is below TYPE1 on Collision
		public function checkCollisionAbove( TYPE1:CbType, TYPE2:CbType, ifTrueFUNC:Function = null, ifFalseFUNC:Function = null):void
		{
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION,TYPE1,TYPE2, onCollision));
			
			function onCollision(cb:InteractionCallback):void
			{
				//trace(cb.int1.castBody.bounds.y + ", " + (cb.int2.castBody.bounds.y /*+ cb.int2.castBody.bounds.height*/));
				
				if(cb.int1.castBody.bounds.y > (cb.int2.castBody.bounds.y + cb.int2.castBody.bounds.height - 30))
				{
					//trace('Collision Above  = true');
					if(ifTrueFUNC != null) ifTrueFUNC();
				}
				else
				{
					//trace('Collision Above = false');
					if(ifFalseFUNC != null) ifFalseFUNC();				
				}
			}
		}
		
		public function checkforTouching( TYPE1:CbType, TYPE2:CbType):void
		{
			space.listeners.add(new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION,TYPE1,TYPE2, onCollision));
			
			function onCollision(cb:InteractionCallback):void
			{
				for ( var i:int = 0; TYPE2.interactors.length > i; i++)
				{
					if(TYPE2.interactors.at(i).castBody == cb.int2.castBody)
					{
						//trace('is Touching ' + TYPE2.interactors.at(i).castBody.graphic);
						TYPE2.interactors.at(i).castBody.graphic.pickupable = true;
					}
					else
					{
						//trace('is NOT Touching ' + TYPE2.interactors.at(i).castBody.graphic);
						TYPE2.interactors.at(i).castBody.graphic.pickupable = false;				
					}
				}
			}
			
			
		}
		
		
	}
}
/* Use Nape_9_1 r10 !!!
*   Later release will need re-fractoring: ie cbTypes are handled differently.
*/

package screens
{
	import controls.GameControls;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	import gamecam.Camera;
	
	import gameobjects.*;
	
	import managers.CollisionDectcor;
	import managers.ParticleManager;
	import managers.SoundManager;
	
	import nape.callbacks.CbType;
	import nape.callbacks.Listener;
	import nape.constraint.Constraint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class Game extends Sprite
	{
		private var pod:Body;
		public var dude:Body;
		public var border:Body;
		public var floor:Body;
		public var cd:CollisionDectcor;
		public var sound:SoundManager;
		public var gcontrols:GameControls;
		public var statictype:CbType = new CbType();
		public var playertype:CbType = new CbType();
		public var pickuptype:CbType = new CbType();
		private var podtype:CbType = new CbType();
		public var worldBounds:Rectangle;
		public var space:Space;
		private var camera:Camera;
		private var up:Boolean = false;
		public var flashroot:ggfv_replace_snack;
		public var actor:String;
		public var caughtArray:Array;;
		
		private var sceenMaker:SceenMaker;

		public function Game()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			gcontrols = new GameControls(this);
			space = new Space(new Vec2(0,2000));
			cd = new CollisionDectcor(space);
		}
		
		public function start():void
		{
			trace('game start');
			caughtArray = [];
			worldBounds = new Rectangle(0,0,6300,2800);
			sound = flashroot.sound;
			

			border = new Body(BodyType.STATIC);
			//left border
			border.shapes.add(new Polygon(Polygon.rect(0,-400,-200,3200), new Material(0.2))); 
			//right border
			border.shapes.add(new Polygon(Polygon.rect(6300,-400,200,3200), new Material(0.2))); 
			//top border
			border.shapes.add(new Polygon(Polygon.rect(0,-400,4500,-200), new Material(0.2)));
			border.cbType = statictype;
			border.graphic = new BlankSprite();
			border.graphic.kind = 'border'; 
			border.space = space;
			//trace(border.bounds);

			floor = new Body(BodyType.STATIC,new Vec2(0,2800));
			floor.shapes.add(new Polygon(Polygon.rect(0,0,6300,100),new Material(0.4)));
			floor.space = space;
			floor.graphic = ObjectRegistry.ground;
			floor.cbType = statictype;
			floor.graphic.y = floor.position.y;
			addChild(floor.graphic);

			dude = PhysicsData.createBody(actor, actor == 'bot'? ObjectRegistry.botDude : ObjectRegistry.bubDude);
			dude.position = new Vec2(450,2630);
			dude.setShapeMaterials(new Material(0.4));
			dude.space = space;
			dude.graphic.set(this,sound,dude);
			dude.align();
			dude.allowRotation = false;
			dude.graphicUpdate = updateGraphics;
			dude.cbType = playertype;
            addChild(dude.graphic);
			
			gcontrols.set(dude.graphic,flashroot);
			
			sceenMaker = new SceenMaker(this);
			sceenMaker.makeSceen();
			
			pod = PhysicsData.createBody('pod', ObjectRegistry.pod);
			pod.position = new Vec2(260,2632);
			pod.setShapeMaterials(new Material(0.2));
			pod.type = BodyType.STATIC;
			pod.space = space;
			pod.graphic.set(this,pod);
			pod.cbType = podtype;
            addChild(pod.graphic);
				
			cd.checkCollisionBelow(playertype, statictype, StaticBelowBump, StaticAboveBump);
			cd.checkCollisionBelow(playertype, pickuptype, PickupBelowBump, PickupAboveBump);
			cd.checkCollisionBelow(playertype, podtype, playerHitPod, playerHitPod);
			cd.checkDistanceOnCollision(podtype, pickuptype, 50, pod.graphic.onCapture, pickupHitPod);
			cd.checkforTouching(playertype, pickuptype);
			
			cd.checkCollisionByGraphic(pickuptype, pickuptype, ['rock','rock','rock','block','block','block', 'food','food','food'],
				['rock','block','food', 'block','rock','food', 'food','rock','block'], dude, 
				[sound.rock,sound.blockThump, sound.foodhit, sound.block,sound.blockThump,sound.foodhit, sound.foodhit,sound.foodhit,sound.foodhit ]);
			
			cd.checkCollisionByGraphic(pickuptype, statictype, ['rock','rock','rock', 'block','block','block', 'food', 'food', 'food'], 
				['ground','platform','platform-reg','ground','platform','platform-reg','ground','platform','platform-reg'], dude, 
				[sound.thump,sound.thump,sound.thump,sound.blockThump,sound.blockThump,sound.blockThump, sound.foodhit,sound.foodhit,sound.foodhit]);

			camera = new Camera(dude,worldBounds,this,new Rectangle(0,0,stage.stageWidth,stage.stageHeight-100));

			this.addEventListener(Event.ENTER_FRAME, loop);
			
			trace('Game.numchildren = ' + this.numChildren);
		}

		public function loop(e:Event):void
		{
			//trace(dude.position);
			space.step(1/60,16,16);
			dude.graphic.rules();
			camera.update();
		}
		
		
		public function updateGraphics(b:Body):void
		{
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			b.graphic.rotation = b.rotation;
		}
		
		public function reset():void
		{
			this.removeEventListener(Event.ENTER_FRAME, loop);
			this.removeChildren();
			space.clear();
		}
		
		private function pickupHitPod(Obj:Body):void 
		{
			//get distance between dude & pod
			var n:Number = Math.sqrt((dude.position.x - pod.position.x) * (dude.position.x - pod.position.x)
				+ (dude.position.y - pod.position.y) * (dude.position.y - pod.position.y));
			
			if(n < 900)
			{
				switch (Obj.graphic.kind)
				{
					case 'food':
						sound.podhit(dude,Obj,.1);
						sound.foodhit(dude,Obj,null);
						break;
					case 'rock':
						sound.podhit(dude,Obj);
						sound.thump(dude,Obj);
						break;
					case 'block':
						sound.podhit(dude,Obj);
						sound.block(dude,Obj);
						break;
				}
			}
		}
		
		private function playerHitPod():void 
		{
			sound.podwalk();
			dude.graphic.endJump();
		}
		
		private function StaticBelowBump():void 
		{
			sound.bump();
			dude.graphic.endJump();
		}
		
		private function PickupBelowBump(Player:Body, Obj:Body):void 
		{
			sound.bump();
			dude.graphic.endJump();
			dude.graphic.readyTick = 0;
			dude.graphic.readyBody = Obj;
			
			
			switch (Obj.graphic.kind)
			{
				case 'food':
					sound.foodhit(Player,Obj,null);
					break;
				case 'rock':
					//sound.thump(Player,Obj);
					break;
				case 'block':
					//sound.block(Player,Obj);
					break;
			}
		}
		
		private function PickupAboveBump(Player:Body, Obj:Body):void 
		{
			dude.graphic.endMoveInJump();
			dude.graphic.readyTick = 0;
			dude.graphic.readyBody = Obj;
			
			
			if ( Obj.bounds.y + Obj.bounds.height < Player.bounds.y + 50)
			{
				var X:Number = Obj.velocity.x < 0 ? Obj.velocity.x * -1 : Obj.velocity.x;
				var Y:Number = Obj.velocity.y < 0 ? Obj.velocity.y * -1 : Obj.velocity.y;
				if(X > 10 || Y > 10 ) sound.hit();
				trace('pickup item hit me da head!');
			}
				
			switch (Obj.graphic.kind)
			{
				case 'food':
					sound.foodhit(Player,Obj,null);
					break;
				case 'rock':
					sound.thump(Player,Obj);
					break;
				case 'block':
					sound.block(Player,Obj);
					break;
			}
			
		}
		
		private function StaticAboveBump(Player:Body, Obj:Body):void 
		{
			dude.graphic.endMoveInJump();
			trace(Obj.graphic.kind);
			
			if ( Obj.bounds.y + 50 < Player.bounds.y + 50)
			{
				var X:Number = Obj.velocity.x < 0 ? Obj.velocity.x * -1 : Obj.velocity.x;
				var Y:Number = Obj.velocity.y < 0 ? Obj.velocity.y * -1 : Obj.velocity.y;
				if(X > 10 || Y > 10 ) sound.hit();
				trace('platform hit me da head!');
			}
			
		}
	}
}


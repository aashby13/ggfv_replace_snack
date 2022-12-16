package gameobjects
{
	//import flash.events.Event;
	//import flash.events.KeyboardEvent;
	
	import managers.ParticleManager;
	import managers.SoundManager;
	
	import nape.constraint.Constraint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.Arbiter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	
	import screens.Game;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class Dude extends Sprite
	{
		public var title:String = 'dude';
		public var kind:String = 'dude';
		private var main:Game;
		private var runMC:MovieClip;
		private var standMC:MovieClip;
		private var jumpMC:MovieClip;
		private var atlas:TextureAtlas;
		private var state:String = 'standing';
		public var direction:String = 'right';
		private var framesRun:Vector.<Texture>;
		private var framesStand:Vector.<Texture>;
		private var framesJump:Vector.<Texture>;
		private var jumpBTNDown:Boolean = false;
		private var arrowBTNDown:Boolean = false;
		private var holding:Boolean = false;
		private var jumpFrame:int = 0;
		private var jumpMax:int = 31;//max jumping frames, higher frames = higher max jump
		private var currentXVel:Number = 0;
		private var step:int = 550; //running speed
		private var gravityMass:Number = 12;
		
		public var actor:String;
		public var body:Body;
		public var carryBody:Body;
		public var readyBody:Body;
		public var readyTick:int = 0;
		public var readyTickMax:int = 20;//max fames to pick something up ater touching it. 
		public var joint:WeldJoint;
		private var jet:PDParticleSystem;
		private var sound:SoundManager;
		

		public function Dude(Actor:String)
		{
			actor = Actor;
			
			atlas = ArtRegistry.dudeAtlas;

			framesRun = atlas.getTextures( actor.toLowerCase() + "_run");
			runMC = new MovieClip(framesRun,30);
			runMC.visible = false;
			addChild(runMC);
			runMC.pivotX = runMC.width >> 1;
			runMC.pivotY = runMC.height >> 1;
			if(actor == 'bot') runMC.y -=  11 else runMC.y += 3;
			
			framesStand = atlas.getTextures( actor.toLowerCase() + "_stand");
			standMC = new MovieClip(framesStand,1);
			standMC.visible = true;
			addChild(standMC);
			standMC.pivotX = standMC.width >> 1;
			standMC.pivotY = standMC.height >> 1;
			if(actor == 'bot') standMC.y -=  11 else standMC.y += 3;
			
			framesJump = atlas.getTextures( actor.toLowerCase() + "_jump");
			jumpMC = new MovieClip(framesJump,1);
			jumpMC.visible = false;
			addChild(jumpMC);
			jumpMC.pivotX = jumpMC.width >> 1;
			jumpMC.pivotY = jumpMC.height >> 1;
			if(actor == 'bot') jumpMC.y -= 11 else jumpMC.y += 3;

			Starling.juggler.add(runMC);
			runMC.stop();
		}
		
		public function set(MainSprite:Game, SM:SoundManager, NapeBody:Body):void 
		{
			main = MainSprite;
			sound = SM;
			if(body) body.constraints.foreach(function (c:Constraint):void { body.space.constraints.remove(c); });
			body = NapeBody;
			joint = null;
			this.scaleX = 1;
			jumpFrame = 0;
			readyTick = 0;
			jumpBTNDown = false; 
			arrowBTNDown = false;
			holding = false;
			state = 'standing';
			direction = 'right';
			setState('standing');
			body.gravMass = gravityMass;
			this.removeEventListener(Event.ENTER_FRAME, jumpLoop);
			this.removeEventListener(Event.ENTER_FRAME, move);
			jet = null;
		}

		
		public function setState(STATE:String):void
		{
			switch (STATE)
			{
				case 'running':
					startMove();
					if(state != 'jumping')
					{
						runMC.visible = true;
						standMC.visible = false;
						jumpMC.visible = false;
						runMC.play();
						sound.runStart(actor);
					}
					break;
				case 'standing':
					stopMove();
					if(state != 'jumping')
					{
						runMC.stop();
						sound.runStop();
						runMC.visible = false;
						standMC.visible = true;
						jumpMC.visible = false;
					}
					break;
				case 'jumping':
					runMC.stop();
					sound.runStop();
					runMC.visible = false;
					standMC.visible = false;
					jumpMC.visible = true;
					break;
				default:
					break;
			}
			
			state = STATE;
			
		}
		
		public function getState():String
		{
			return state;
		}
		
		public function jumpKeyDown():void
		{
			if(state != 'jumping')
			{
				if( !jumpBTNDown /*&& body.velocity.y > -10*/)
				{
					setState('jumping');
					jumpBTNDown = true;
					jumpFrame = 0;
					if(!jet) { jet = ParticleManager.jet(); main.addChild(jet); } else { jet.start() }; trace(main.numChildren);
					this.addEventListener(Event.ENTER_FRAME, jumpLoop);
					sound.jetStart();
				}
			}
		}
		
		public function jumpKeyUp():void
		{
			jumpBTNDown = false; 
		}

		public function jumpLoop(e:Event):void
		{
			particlesFollow();
			
			currentXVel = body.velocity.x;

			if(jumpBTNDown && jumpFrame < jumpMax) 
			{
				body.velocity.y = -step;
				jumpFrame += 1;
				//trace('jump loop');
			} else {
				body.velocity.x = currentXVel;
				jet.stop();
				this.removeEventListener(Event.ENTER_FRAME, jumpLoop);
				sound.jetStop();
				//trace('end jump loop');
			}

		}

		public function endJump():void
		{
			//trace('endJump')
			if(state == 'jumping')
			{
				state = 'none';
				if(arrowBTNDown) setState('running') else setState('standing');
			}
			else if(state == 'running') { setState('running') }
			else if(state == 'standing') { setState('standing') };
			
			if(jet)jet.stop();
				
		}
		
		public function endMoveInJump():void
		{
			if(state == 'jumping') 
				removeEventListener(Event.ENTER_FRAME, move)
				if(jet)jet.stop();
			
		}
		
		// called on Right/Left keys up
		public function stand():void
		{
			arrowBTNDown = false;
			if(state != 'jumping') setState("standing");
		}
		
		// called on Left Keys down
		public function runLeft():void
		{
			direction='left';
			this.scaleX = -1;
			arrowBTNDown = true;
			setState("running");
			body.scaleShapes(this.scaleX,this.scaleY);
		}
		
		// called on Right Keys down
		public function runRight():void
		{
			direction='right';
			this.scaleX = 1;
			arrowBTNDown = true;
			setState("running");
			body.scaleShapes(this.scaleX,this.scaleY);
		}

		// Frame Event called on setState('running') 
		private function move(e:Event):void
		{
			switch (direction)
			{
				case 'left':
					body.velocity.x = -step;
					particlesFollow();
					break;
				case 'right':
					body.velocity.x = step;
					particlesFollow();
					break;
			}
		}
		
		private function startMove():void
		{
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function stopMove():void
		{
			removeEventListener(Event.ENTER_FRAME, move);
		}
		
		public function pickupOrToss():void
		{
			trace(body.constraints.length)
			if(body.constraints.length > 0) holding = true else holding = false;
			trace('holding =' + holding);
			if(!holding) pickup() else toss();
		}
		
		private function doPickup(PickUpBody:Body):void
		{
			trace(joint);
			if(PickUpBody.graphic.pickupable && joint == null )
			{
				carryBody = PickUpBody; 
				//trace('Picked up ' + carryBody.graphic.kind);
				
				if(actor == 'bot')
				{
					carryBody.position = new Vec2(body.position.x,body.bounds.y - carryBody.bounds.height-16);
					joint = new WeldJoint(body, carryBody, new Vec2(0,-body.bounds.height/2-8), new Vec2(0,carryBody.bounds.height/2+8), 0);
				}
				else 
				{
					carryBody.position = new Vec2(body.position.x,body.bounds.y - carryBody.bounds.height-10);
					joint = new WeldJoint(body, carryBody, new Vec2(0,-body.bounds.height/2), new Vec2(0,carryBody.bounds.height/2), 0);
				}
				
				sound.pickup();
				joint.space = body.space;
				holding = true;
				//body.position.y -= 50;
			}
		}
		
		private function pickup():void
		{
			if(readyBody)
			{
				doPickup(readyBody);
				readyBody = null;
				readyTick = 0;
			}
			else if(!holding && body.constraints.length == 0)
			{
				
				body.arbiters.foreach(function (arb:Arbiter):void 
				{
					if(!arb.isCollisionArbiter()) return;
					var other_body:Body = arb.body1==body ? arb.body2 : arb.body1;
					doPickup(other_body)
				});
			}
		}
		
		private function toss():void
		{
			if(holding)
			{
				//trace('toss');
				body.constraints.foreach(function (c:Constraint):void { body.space.constraints.remove(c); });
				joint = null;
				holding = false;
				carryBody.velocity.y += -500;
				
				if(direction == 'right') 
				{
					carryBody.velocity.x += 600;
					sound.toss('right', body, carryBody);
				}
				else if(direction =='left') 
				{
					carryBody.velocity.x += -600;
					sound.toss('left', body, carryBody);
				}
			}
		}
		
		
		public function rules():void
		{
			//So I don't run in mid-air
			if(body.arbiters.length == 0) setState('jumping');
			
			//trace(body.position);
			
			//Incase I somehow jump out of this world
			if(body.position.x > main.border.bounds.width-400) {body.position.x = 6222;trace('position.x > main.border.bounds.width, position = ' + body.position)};
			if(body.position.x < 0) {body.position.x = 70; trace('position.x < main.border.bounds.x, position = ' + body.position)};
			if(body.position.y > main.floor.bounds.y) {body.position.y = 2700; trace('position.y > main.floor.bounds.y, position = ' + body.position )};
			if(body.position.y < main.border.bounds.y-400) {body.position.y = -150; trace('position.y < main.border.bounds.y, position = ' + body.position)} ;
			
			//Incase something I pick up gets out of this world
			if(carryBody != null)
			{
				if(carryBody.position.x > main.border.bounds.width-400) {carryBody.position.x = 6222;trace('carryBody.position.x > main.border.bounds.width, position = ' + carryBody.position)};
				if(carryBody.position.x < 0) {carryBody.position.x = 70; trace('carryBody.position.x < main.border.bounds.x, position = ' + carryBody.position)};
				if(carryBody.position.y > main.floor.bounds.y) {carryBody.position.y = 2700; trace('carryBody.position.y > main.floor.bounds.y, position = ' + carryBody.position )};
				if(carryBody.position.y < main.border.bounds.y-400) {carryBody.position.y = -150; trace('carryBody.position.y < main.border.bounds.y, position = ' + carryBody.position)} ;
			}
			
			//So I don't pick up something from across the world
			if(!holding && body.constraints.length == 0) carryBody = null;
		}
		
		private function particlesFollow():void 
		{
			if(jet)
			{
				if(direction == 'right')	
				{
					if(actor == 'bot') jet.emitterX  = this.x - 62 else jet.emitterX  = this.x - 53;
					jet.emitAngle = 40;
					
				}else {
					if(actor == 'bot') jet.emitterX  = this.x + 62 else jet.emitterX  = this.x + 53;
					jet.emitAngle = 120;
				}
				
				/*jet.gravityX = -body.velocity.x * 1.8;
				jet.gravityY = -body.velocity.y * .5;*/
				if(actor == 'bot') jet.emitterY = this.y + 10 else jet.emitterY = this.y + 66;
			}
		}

	}
}
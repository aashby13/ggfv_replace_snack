package gameobjects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import managers.ParticleManager;
	import managers.SoundManager;
	
	import nape.callbacks.CbType;
	import nape.constraint.LineJoint;
	import nape.dynamics.InteractionFilter;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class PlatformMaker
	{
		private var dude:Body;
		private var parent:Sprite;
		private var space:Space;
		private var sm:SoundManager;
		private var update:Function;
		
		
		public function PlatformMaker( DUDE:Body, PARENT:Sprite, SPACE:Space, SM:SoundManager, UPDATEGFX:Function)
		{
			dude = DUDE;
			parent = PARENT;
			space =SPACE;
			sm = SM;
			update = UPDATEGFX;
		}
		
		public function make(KIND:String, X:Number, Y:Number, WIDTH:Number, TYPE:CbType = null, DROP_AMOUNT:Number = 100):Body
		{
			var b:Body;
			
			if(KIND == 'floater') b = makeFloater(X, Y, WIDTH, TYPE, DROP_AMOUNT);
			
			if(KIND == 'static') b = makeStatic(X, Y, WIDTH, TYPE);
			
			if(KIND == 'reg') b = makeReg(X, Y, WIDTH, TYPE);
			
			return b;

		}
		
		private function getTexture(WIDTH:Number):Texture
		{
			var t:Texture;
			
			switch(WIDTH)
			{
				case 400:
					t = ArtRegistry.platformTexture400;
					break;
				case 800:
					t = ArtRegistry.platformTexture800;
					break;
				case 1200:
					t = ArtRegistry.platformTexture1200;
					break;
				case 2048:
					t = ArtRegistry.platformTexture2048;
					break;
				default:
					t = ArtRegistry.platformTexture400;
					trace("platformTexture width can only be 400, 800, 1200, or 2048. here's a 400");
					break;
			}
			
			return t;
		}
		
		private function makeReg(X:Number, Y:Number, WIDTH:Number, TYPE:CbType):Body
		{
			var sprite:BlankSprite = new BlankSprite ();
			sprite.kind = 'platform-reg';
			
			var texture:Texture = getTexture(WIDTH);
			var pfimage:Image = new Image(texture);
			sprite.addChild(pfimage);
			sprite.flatten();
			
			var mainBody:Body = new Body(BodyType.DYNAMIC,new Vec2(X,Y));
			mainBody.shapes.add(new Polygon(Polygon.rect(0,0,WIDTH,50),new Material(0.4)));
			mainBody.space = space;
			mainBody.graphic = sprite;
			mainBody.graphicUpdate = update;
			mainBody.allowRotation = true;
			mainBody.cbType = TYPE;
			parent.addChild(mainBody.graphic);
			trace(mainBody.bounds)
			return mainBody;
		}
		
		private function makeStatic(X:Number, Y:Number, WIDTH:Number, TYPE:CbType):Body
		{
			var sprite:BlankSprite = new BlankSprite ();
			var subsprite:Sprite = new Sprite();
			sprite.addChild(subsprite);
			sprite.kind = 'platform';
			
			var texture:Texture = getTexture(WIDTH);
			var pfimage:Image = new Image(texture);
			subsprite.addChild(pfimage);
			
			var mainBody:Body = new Body(BodyType.STATIC,new Vec2(X,Y));
			mainBody.shapes.add(new Polygon(Polygon.rect(0,0,WIDTH,50),new Material(0.4)));
			var thruster1:Image;
			var fire1:PDParticleSystem;
			//var fire1:MovieClip;
			
			if(pfimage.width<= 400)
			{
				thruster1 = new Image(ArtRegistry.thruster1Texture);
				thruster1.x = sprite.width/2 - (thruster1.width/2);
				thruster1.y =  -50;
				subsprite.addChild(thruster1);
				mainBody.shapes.add(new Polygon(Polygon.rect(WIDTH/2 - 23,50,46,78),new Material(0.4)));
				
				fire1 = ParticleManager.thruster(dude,sm);
				fire1.x = sprite.width/2;
				fire1.y = 139;
				sprite.addChild(fire1);
				
			}
			else
			{
				thruster1 = new Image(ArtRegistry.thruster2Texture);
				thruster1.x = 70;
				thruster1.y =  50;
				subsprite.addChild(thruster1);
				mainBody.shapes.add(new Polygon(Polygon.rect(thruster1.x,thruster1.y,thruster1.width,thruster1.height),new Material(0.4)));
				
				var thruster2:Image = new Image(ArtRegistry.thruster2Texture);
				thruster2.x = sprite.width - 70 - thruster2.width;
				thruster2.y =  50;
				subsprite.addChild(thruster2);
				mainBody.shapes.add(new Polygon(Polygon.rect(thruster2.x,thruster2.y,thruster2.width,thruster2.height),new Material(0.4)));
				
				fire1 = ParticleManager.thruster(dude,sm);
				fire1.x = thruster1.x + thruster1.width/2;
				fire1.y = 133;
				sprite.addChild(fire1);
				
				var fire2:PDParticleSystem = ParticleManager.thruster(dude,sm);
				//var fire2:MovieClip = ParticleManager.thruster();
				fire2.x = thruster2.x + thruster2.width/2;
				fire2.y = 133;
				sprite.addChild(fire2);
			}
			
			mainBody.space = space;
			mainBody.graphic = sprite;
			mainBody.graphicUpdate = update;
			mainBody.allowRotation = false;
			mainBody.cbType = TYPE;
			parent.addChild(mainBody.graphic);
			subsprite.flatten();
			return mainBody;
		}
		
		private function makeFloater(X:Number, Y:Number, WIDTH:Number, TYPE:CbType, DROP_AMOUNT:Number):Body
		{
			var sprite:BlankSprite = new BlankSprite ();
			var subsprite:Sprite = new Sprite();
			sprite.addChild(subsprite);
			sprite.kind = 'platform';
			
			var texture:Texture = getTexture(WIDTH);
			var pfimage:Image = new Image(texture);
			subsprite.addChild(pfimage);
			
			var mainBody:Body = new Body(BodyType.DYNAMIC,new Vec2(X,Y));
			mainBody.shapes.add(new Polygon(Polygon.rect(0,0,WIDTH,50),new Material(0.4)));
			var thruster1:Image;
			var fire1:PDParticleSystem;
			//var fire1:MovieClip;
			
			if(pfimage.width<= 400)
			{
				thruster1 = new Image(ArtRegistry.thruster1Texture);
				thruster1.x = sprite.width/2 - (thruster1.width/2);
				thruster1.y =  -50;
				subsprite.addChild(thruster1);
				mainBody.shapes.add(new Polygon(Polygon.rect(WIDTH/2 - 23,50,46,78),new Material(0.4)));
				
				
					fire1 = ParticleManager.thruster(dude,sm);
					fire1.x = sprite.width/2;
					fire1.y = 139;
					sprite.addChild(fire1);
					
			}
			else
			{
				thruster1 = new Image(ArtRegistry.thruster2Texture);
				thruster1.x = 70;
				thruster1.y =  50;
				subsprite.addChild(thruster1);
				mainBody.shapes.add(new Polygon(Polygon.rect(thruster1.x,thruster1.y,thruster1.width,thruster1.height),new Material(0.4)));
				
				var thruster2:Image = new Image(ArtRegistry.thruster2Texture);
				thruster2.x = sprite.width - 70 - thruster2.width;
				thruster2.y =  50;
				subsprite.addChild(thruster2);
				mainBody.shapes.add(new Polygon(Polygon.rect(thruster2.x,thruster2.y,thruster2.width,thruster2.height),new Material(0.4)));
				
				
					fire1 = ParticleManager.thruster(dude,sm);
					fire1.x = thruster1.x + thruster1.width/2;
					fire1.y = 133;
					sprite.addChild(fire1);
					
					var fire2:PDParticleSystem = ParticleManager.thruster(dude,sm);
					//var fire2:MovieClip = ParticleManager.thruster();
					fire2.x = thruster2.x + thruster2.width/2;
					fire2.y = 133;
					sprite.addChild(fire2);
			}
			
			mainBody.space = space;
			mainBody.graphic = sprite;
			mainBody.graphicUpdate = update;
			mainBody.allowRotation = false;
			mainBody.cbType = TYPE;
			parent.addChild(mainBody.graphic);
			mainBody.gravMass = -12;
			
			
			var box:Polygon = new Polygon(Polygon.rect(0,0,100,100));
			box.filter.collisionGroup = 0; //in group 0x00000002
			box.filter.collisionMask = 0;
			var staticBody:Body = new Body(BodyType.STATIC, new Vec2(X + (WIDTH/2),Y-200));
			box.body = staticBody;
			staticBody.space = space;

			var joint:LineJoint = new LineJoint(staticBody,mainBody,new Vec2(staticBody.bounds.width/2, staticBody.bounds.height),
				new Vec2(mainBody.bounds.width/2, 0),new Vec2(0,1),100,DROP_AMOUNT);
			joint.stiff = false;
			joint.frequency = 10;
			joint.damping = 1;
			joint.space = space;
			
			var TOPY:Number = Y+50;
			
			//add floating loop
			sprite.addEventListener(Event.ENTER_FRAME, function():void 
			{
				float(mainBody, TOPY, -6.5);
			});
			
			subsprite.flatten();
			return mainBody;
		}
		
		
		
		private function float(BODY:Body, TOPY:Number, GRAVMASS_START:Number):void
		{
			var dif:Number = Math.round((BODY.position.y - TOPY) / 20);
			
			if(BODY.arbiters.length > 0)
			{
				BODY.gravMass = GRAVMASS_START - dif - (BODY.arbiters.length/2);
			}
			else
			{
				if(BODY.position.y > TOPY+15) BODY.gravMass = -4;
				if(BODY.position.y < TOPY+15) BODY.gravMass = 0;
				if(BODY.position.y < TOPY) BODY.gravMass = 4;
			}
			
			//trace(BODY.gravMass);
		}
	}
}
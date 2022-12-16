package gameobjects
{
	import managers.ParticleManager;
	
	import nape.phys.Body;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	
	import statemachine.States;
	
	public class Pod extends Sprite
	{
		public var title:String;
		public var kind:String = 'pod';
		public var pickupable:Boolean = false;
		public var collectable:Boolean = false;
		public var body:Body;
		
		private var main:*;
		private var pm:ParticleManager;
		private var stars:PDParticleSystem;
		private var electric:PDParticleSystem;
		private var puff:PDParticleSystem;
		
		public function Pod()
		{
			addChild(new Image(ArtRegistry.podTexture));
			/*pivotX = width >> 1;
			pivotY = height >> 1;*/
			this.flatten();
		}
		
		public function set(MAIN:Sprite, NapeBody:Body):void 
		{
			main = MAIN;
			body = NapeBody;
			stars = null;
			electric= null;
			puff = null;
		}
		
		public function onCapture(b:Body = null):void 
		{
			if(b != null)
			{
				if(b.graphic.collectable)
				{
					if(main.flashroot.currentLevel == States.LEVEL1) main.caughtArray.push(b.graphic)
					else if(b.graphic.wanted && main.flashroot.currentLevel == States.LEVEL2) main.caughtArray.push(b.graphic);
					trace(main.caughtArray);
					
					if(b.graphic.wanted)
					{
						if(!stars) makeParticles('stars') else stars.start(.6);
						main.sound.wanted();
						main.space.bodies.remove(b);
						main.removeChild(b.graphic.tag,true);
						main.removeChild(b.graphic,true);
					}
					else 
					{
						if(main.flashroot.currentLevel == States.LEVEL1) 
							main.flashroot.gamemenu.onWrong(b.graphic.title.charAt(0) + b.graphic.title.substring(1).toLowerCase() + ' ' + b.graphic.feedback.charAt(0).toLowerCase() + b.graphic.feedback.substring(1)) else main.flashroot.gamemenu.onWrong(b.graphic.feedback);
						
						if(!electric) makeParticles('electric') else electric.start(.6);
						main.sound.unwanted();
						main.space.bodies.remove(b);
						main.removeChild(b.graphic.tag,true);
						main.removeChild(b.graphic,true);
					}
					
				}
				else
				{
					trace('get outta here!');
					b.velocity.x = 2000;
					if(!puff) makeParticles('puff') else puff.start(.6);
					main.sound.rejected();
				}
			}
		}
		
		private function makeParticles(KIND:String):void
		{
			trace('make ' + KIND);
			var index:int;
			
			for (var i:int=0; main.numChildren > i; i++) if (main.getChildAt(i) == this) index = i;
			
			switch (KIND)
			{
				case 'stars':
					stars = ParticleManager.starburst(.6);
					stars.x = body.position.x + 75;
					stars.y = body.position.y + 13;
					main.addChildAt(stars,index);
					break;
				case 'puff':
					puff = ParticleManager.puff(.6);
					puff.x = body.position.x + 75;
					puff.y = body.position.y + 16;
					main.addChildAt(puff,index);
					break;
				case 'electric':
					electric = ParticleManager.electric(.6);
					electric.x = body.position.x + 80;
					electric.y = body.position.y + 8;
					main.addChildAt(electric,index);
					break;
			}
		}
		
		
	}
}
package managers
{
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import nape.phys.Body;
	
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class ThrusterParticleDesigner extends PDParticleSystem
	{
		private var dude:Body;
		private var sound:SoundManager;
		private var st:SoundTransform;
		private var p:Number;
		private var direction:String;
		private var isPlaying:Boolean = false;
		
		public var channel:SoundChannel;
		
		public function ThrusterParticleDesigner(config:XML, texture:Texture, Player:Body, Sound:SoundManager)
		{
			super(config, texture);
			dude = Player;
			sound = Sound;
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Object):void 
		{
			var point1:Point = new Point(e.target.parent.x + e.target.x, e.target.parent.y + e.target.y);
			var point2:Point = new Point(dude.position.x, dude.position.y);
			//get distance of particle from player
			var dist:Number = Math.sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y)  * (point1.y - point2.y));
			/*var distX:Number = Math.sqrt((point1.x - point2.x));
			var distY:Number = Math.sqrt((point1.y - point2.y));*/
			
			//start particles if close to being on screen else stop particle from playing
			if(dist < 490) e.target.start() else e.target.stop();
			
			if(dist < 580) playSound() else stopSound();
			
			if(isPlaying)
			{
				if(point1.x < point2.x) direction = 'left' else direction = 'right';
				if(direction == 'left') { p = dist/1000 * -1; if(p < -1) p = -1};
				if(direction == 'right') { p = dist/1000; if(p > 1) p = 1};
				st.pan = p;
				st.volume = .5 - (dist/1160);
				//trace('thruster volume = ' + st.volume);
				//trace('thruster pan = ' + st.pan);
				if(channel) channel.soundTransform = st;
			}
		}
		
		public function playSound():void
		{
			if(!isPlaying)
			{
				isPlaying = true;
				st = new SoundTransform(0,0);
				channel = sound.thrusterSound.play(0,int.MAX_VALUE,st);
				sound.addThrusterChannel(this);
			}
		}
		
		public function stopSound():void
		{
			if(isPlaying)
			{
				isPlaying = false;
				if(channel) sound.stopThruster(this);
			}
		}
	}
}
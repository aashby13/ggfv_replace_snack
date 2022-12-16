package managers  
{
	import nape.phys.Body;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class ParticleManager
	{
		[Embed(source ='/assets/particles/starburst.pex', mimeType='application/octet-stream')]
		private static var StarXML:Class;
		
		[Embed(source ='/assets/particles/starTexture.png')]
		private static var StarTexure:Class;
		
		[Embed(source ='/assets/particles/puff.pex', mimeType='application/octet-stream')]
		private static var PuffXML:Class;
		
		[Embed(source ='/assets/particles/puffTexture.png')]
		private static var PuffTexure:Class;
		
		[Embed(source ='/assets/particles/electric.pex', mimeType='application/octet-stream')]
		private static var ElecXML:Class;
		
		[Embed(source ='/assets/particles/electricTexture.png')]
		private static var ElecTexure:Class;
		
		[Embed(source ='/assets/particles/thruster.pex', mimeType='application/octet-stream')]
		private static var ThrustXML:Class;
		
		[Embed(source ='/assets/particles/thrusterTexture.png')]
		private static var ThrustTexure:Class;
		
		[Embed(source ='/assets/particles/jet.pex', mimeType='application/octet-stream')]
		private static var JetXML:Class;
		
		[Embed(source ='/assets/particles/jetTexture.png')]
		private static var JetTexure:Class;
		
		/*[Embed(source="/assets/particles/thrusterFireSeq.xml", mimeType="application/octet-stream")]
		private static static var AtlsXML:Class;
		
		[Embed(source="/assets/particles/thrusterFireSeq.png")]
		private static static var AtlsTexture:Class;
		
		private static static static var atlas:TextureAtlas;*/
		
		/*public function ParticleManager()
		{
			var texture:Texture = Texture.fromBitmap(new AtlsTexture());
			var xml:XML = XML(new AtlsXML);
			atlas = new TextureAtlas(texture,xml);
		}*/
		
		public static function starburst(TIME:Number = Number.MAX_VALUE, ADDTOJUGGLER:Boolean = true):PDParticleSystem
		{
			var particles:PDParticleSystem = new PDParticleSystem(XML(new StarXML()), Texture.fromBitmap(new StarTexure()) );
			particles.start(TIME);
			if(ADDTOJUGGLER) Starling.juggler.add(particles);
			return particles;
		}
		
		public static function puff(TIME:Number = Number.MAX_VALUE, ADDTOJUGGLER:Boolean = true):PDParticleSystem
		{
			var particles:PDParticleSystem = new PDParticleSystem(XML(new PuffXML()), Texture.fromBitmap(new PuffTexure()) );
			particles.start(TIME)
			if(ADDTOJUGGLER) Starling.juggler.add(particles);
			return particles;
		}
		
		public static function thruster(Player:Body, Sound:SoundManager, TIME:Number = Number.MAX_VALUE, ADDTOJUGGLER:Boolean = true):ThrusterParticleDesigner
		{
			var particles:ThrusterParticleDesigner = new ThrusterParticleDesigner(XML(new ThrustXML()), Texture.fromBitmap(new ThrustTexure()), Player, Sound);
			particles.startSize = 30;
			particles.maxNumParticles = 100;
			particles.lifespanVariance = .4;
			particles.speedVariance = 20;
			//particles.start(TIME);
			if(ADDTOJUGGLER) Starling.juggler.add(particles);
			/*var frames:Vector.<Texture>;
			frames = atlas.getTextures( "thrusterFireSeq");
			trace(frames.length);
			var particles:MovieClip = new MovieClip(frames,60);
			particles.pivotX = particles.width/2;
			particles.pivotY= particles.height/2-12;
			if(ADDTOJUGGLER) Starling.juggler.add(particles);*/
			return particles;
		}
		
		public static function electric(TIME:Number = Number.MAX_VALUE, ADDTOJUGGLER:Boolean = true):PDParticleSystem
		{
			var particles:PDParticleSystem = new PDParticleSystem(XML(new ElecXML()), Texture.fromBitmap(new ElecTexure()) );
			//particles.startSize = 10;
			/*particles.emitAngle = -45;
			particles.emitAngleVariance = 100;
			particles.rotatePerSecond = 0;
			particles.radialAccelerationVariance = 0;*/
			particles.start(TIME);
			if(ADDTOJUGGLER) Starling.juggler.add(particles);
			return particles;
		}
		
		public static function jet(TIME:Number = Number.MAX_VALUE, ADDTOJUGGLER:Boolean = true):PDParticleSystem
		{
			var particles:PDParticleSystem = new PDParticleSystem(XML(new JetXML()), Texture.fromBitmap(new JetTexure()) );
			particles.maxNumParticles = 180;
			particles.endSize = 50;
			particles.speed = 160;
			particles.start(TIME);
			if(ADDTOJUGGLER) Starling.juggler.add(particles);
			return particles;
		}
	}
}
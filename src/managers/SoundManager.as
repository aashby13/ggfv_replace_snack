package managers
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import mx.core.SoundAsset;
	
	import nape.phys.Body;
	
	public class SoundManager
	{
		[Embed(source="/assets/sfx/menu_music.mp3")]
		private var MenuMusicSFX:Class;
		
		[Embed(source="/assets/sfx/sweep.mp3")]
		private var SweepSFX:Class;
		
		[Embed(source="/assets/sfx/roll.mp3")]
		private var RollSFX:Class;
		
		[Embed(source="/assets/sfx/rollend.mp3")]
		private var RollEndSFX:Class;
		
		[Embed(source="/assets/sfx/results.mp3")]
		private var ResultsSFX:Class;
		
		[Embed(source="/assets/sfx/bub_run.mp3")]
		private var BubRunSFX:Class;
		
		[Embed(source="/assets/sfx/bot_run.mp3")]
		private var BotRunSFX:Class;
		
		/*[Embed(source="/assets/sfx/bot_bump.mp3")]
		private var BotBumpSFX:Class;*/
		
		[Embed(source="/assets/sfx/jetpack2.mp3")]
		private var JetpackSFX:Class;
		
		[Embed(source="/assets/sfx/jetpackOff2.mp3")]
		private var JetpackOffSFX:Class;
		
		[Embed(source="/assets/sfx/bump.mp3")]
		private var BumpSFX:Class;
		
		[Embed(source="/assets/sfx/thump.mp3")]
		private var ThumpSFX:Class;
		
		[Embed(source="/assets/sfx/wanted.mp3")]
		private var WantedSFX:Class;
		
		[Embed(source="/assets/sfx/unwanted.mp3")]
		private var UnwantedSFX:Class;
		
		[Embed(source="/assets/sfx/whoops.mp3")]
		private var WhoopsSFX:Class;
		
		[Embed(source="/assets/sfx/tryagain.mp3")]
		private var TryagainSFX:Class;
		
		[Embed(source="/assets/sfx/allreplaced.mp3")]
		private var AllReplacedSFX:Class;
		
		[Embed(source="/assets/sfx/rejected.mp3")]
		private var RejectedSFX:Class;
		
		[Embed(source="/assets/sfx/rock1.mp3")]
		private var Rock1SFX:Class;
		
		[Embed(source="/assets/sfx/rock2.mp3")]
		private var Rock2SFX:Class;
		
		[Embed(source="/assets/sfx/rock3.mp3")]
		private var Rock3SFX:Class;
		
		[Embed(source="/assets/sfx/rock4.mp3")]
		private var Rock4SFX:Class;
		
		[Embed(source="/assets/sfx/throw.mp3")]
		private var ThrowSFX:Class;
		
		[Embed(source="/assets/sfx/block1.mp3")]
		private var Block1SFX:Class;
		
		[Embed(source="/assets/sfx/block2.mp3")]
		private var Block2SFX:Class;
		
		[Embed(source="/assets/sfx/block3.mp3")]
		private var Block3SFX:Class;
		
		[Embed(source="/assets/sfx/block4.mp3")]
		private var Block4SFX:Class;
		
		[Embed(source="/assets/sfx/hit.mp3")]
		private var HitSFX:Class;
		
		[Embed(source="/assets/sfx/pickup2.mp3")]
		private var PickupSFX:Class;
		
		[Embed(source="/assets/sfx/podhit1.mp3")]
		private var Podhit1SFX:Class;
		
		[Embed(source="/assets/sfx/podhit2.mp3")]
		private var Podhit2SFX:Class;
		
		[Embed(source="/assets/sfx/podhit3.mp3")]
		private var Podhit3SFX:Class;
		
		[Embed(source="/assets/sfx/podwalk1.mp3")]
		private var Podwalk1SFX:Class;
		
		[Embed(source="/assets/sfx/podwalk2.mp3")]
		private var Podwalk2SFX:Class;
		
		[Embed(source="/assets/sfx/podwalk3.mp3")]
		private var Podwalk3SFX:Class;
		
		[Embed(source="/assets/sfx/podwalk4.mp3")]
		private var Podwalk4SFX:Class;
		
		[Embed(source="/assets/sfx/foodhit1.mp3")]
		private var Foodhit1SFX:Class;
		
		[Embed(source="/assets/sfx/foodhit2.mp3")]
		private var Foodhit2SFX:Class;
		
		[Embed(source="/assets/sfx/foodhit3.mp3")]
		private var Foodhit3SFX:Class;
		
		[Embed(source="/assets/sfx/foodhit4.mp3")]
		private var Foodhit4SFX:Class;
		
		[Embed(source="/assets/sfx/foodhit5.mp3")]
		private var Foodhit5SFX:Class;
		
		[Embed(source="/assets/sfx/clock.mp3")]
		private var ClockSFX:Class;
		
		[Embed(source="/assets/sfx/buzzer.mp3")]
		private var BuzzerSFX:Class;
		
		[Embed(source="/assets/sfx/readySetGo.mp3")]
		private var ReadySFX:Class;
		
		[Embed(source="/assets/sfx/thruster.mp3")]
		private var ThrusterSFX:Class;
		
		private var menuMusicSound:Sound = new MenuMusicSFX() as SoundAsset;
		private var sweepSound:Sound = new SweepSFX() as SoundAsset;
		private var rollSound:Sound = new RollSFX() as SoundAsset;
		private var rollendSound:Sound = new RollEndSFX() as SoundAsset;
		private var resultsSound:Sound = new ResultsSFX() as SoundAsset;
		private var bubRunSound:Sound = new BubRunSFX() as SoundAsset;
		private var botRunSound:Sound = new BotRunSFX() as SoundAsset;
		//private var botBumpSound:Sound = new BotBumpSFX() as SoundAsset;
		private var jetpackSound:Sound = new JetpackSFX() as SoundAsset;
		private var jetpackOffSound:Sound = new JetpackOffSFX() as SoundAsset;
		private var bumpSound:Sound = new BumpSFX() as SoundAsset;
		private var thumpSound:Sound = new ThumpSFX() as SoundAsset;
		private var wantedSound:Sound = new WantedSFX() as SoundAsset;
		private var unwantedSound:Sound = new UnwantedSFX() as SoundAsset;
		private var rejectedSound:Sound = new RejectedSFX() as SoundAsset;
		private var whoopsSound:Sound = new WhoopsSFX() as SoundAsset;
		private var tryagainSound:Sound = new TryagainSFX() as SoundAsset;
		private var allReplacedSound:Sound = new AllReplacedSFX() as SoundAsset;
		private var rock1Sound:Sound = new Rock1SFX() as SoundAsset;
		private var rock2Sound:Sound = new Rock2SFX() as SoundAsset;
		private var rock3Sound:Sound = new Rock3SFX() as SoundAsset;
		private var rock4Sound:Sound = new Rock4SFX() as SoundAsset;
		private var throwSound:Sound = new ThrowSFX() as SoundAsset;
		private var block1Sound:Sound = new Block1SFX() as SoundAsset;
		private var block2Sound:Sound = new Block2SFX() as SoundAsset;
		private var block3Sound:Sound = new Block3SFX() as SoundAsset;
		private var block4Sound:Sound = new Block4SFX() as SoundAsset;
		private var hitSound:Sound = new HitSFX() as SoundAsset;
		private var pickupSound:Sound = new PickupSFX() as SoundAsset;
		private var podhit1Sound:Sound = new Podhit1SFX() as SoundAsset;
		private var podhit2Sound:Sound = new Podhit2SFX() as SoundAsset;
		private var podhit3Sound:Sound = new Podhit3SFX() as SoundAsset;
		private var podwalk1Sound:Sound = new Podwalk1SFX() as SoundAsset;
		private var podwalk2Sound:Sound = new Podwalk2SFX() as SoundAsset;
		private var podwalk3Sound:Sound = new Podwalk3SFX() as SoundAsset;
		private var podwalk4Sound:Sound = new Podwalk4SFX() as SoundAsset;
		private var foodhit1Sound:Sound = new Foodhit1SFX() as SoundAsset;
		private var foodhit2Sound:Sound = new Foodhit2SFX() as SoundAsset;
		private var foodhit3Sound:Sound = new Foodhit3SFX() as SoundAsset;
		private var foodhit4Sound:Sound = new Foodhit4SFX() as SoundAsset;
		private var foodhit5Sound:Sound = new Foodhit5SFX() as SoundAsset;
		private var clockSound:Sound = new ClockSFX() as SoundAsset;
		private var buzzerSound:Sound = new BuzzerSFX() as SoundAsset;
		private var readySound:Sound = new ReadySFX() as SoundAsset;
		//thusterSound handles in ThusterParticleDesigner.as
		public var thrusterSound:Sound = new ThrusterSFX() as SoundAsset;
		
		private var musicChannel:SoundChannel;
		private var rollChannel:SoundChannel;
		private var runChannel:SoundChannel;
		private var jetChannel:SoundChannel;
		private var clockChannel:SoundChannel;
		
		
		private var isRunning:Boolean = false;
		private var isJumping:Boolean = false;
		
		private var rockArray:Array = [rock1Sound,rock2Sound,rock3Sound,rock4Sound];
		private var blockArray:Array = [block1Sound,block2Sound,block3Sound,block4Sound];
		private var podhitArray:Array = [podhit1Sound,podhit2Sound,podhit3Sound];
		private var podwalkArray:Array = [podwalk1Sound,podwalk2Sound,podwalk3Sound,podwalk4Sound];
		private var foodhitArray:Array = [foodhit1Sound,foodhit2Sound,foodhit3Sound,foodhit4Sound,foodhit5Sound];
		
		public var soundArray:Array = new Array;
		public var clockStartTime:Number = 0;
		
		private var thrusterArray:Array = new Array;
		
		
		private var actor:String = '';
		
		public function SoundManager()
		{
			
		}
		
		public function reset():void 
		{
			for each(var channel:SoundChannel in soundArray) 
			{
				if(channel)
				{
					channel.stop();
					channel = null;
				}
			}
			
			for each(var thruster:ThrusterParticleDesigner in thrusterArray) 
			{
				if(thruster.channel)
				{
					thruster.channel.stop();
					thruster.channel = null;	
				}
			}
			
			soundArray = [];
			thrusterArray = [];
			clockStartTime = 0;
		}
		
		private function onSoundComplete(e:Event):void 
		{
			if(soundArray.indexOf(e.currentTarget))
			{
				soundArray.splice(soundArray.indexOf(e.currentTarget),1);
			}
		}
		
		private function emptyTo31():void // flash player only 32 sounds can play at simultaneaously
		{
			while (soundArray.length > 30) 
			{ trace('while');
				var channel:SoundChannel = soundArray.shift();
				if(channel) 	
				{
					switch (channel)
					{
						case runChannel:
							soundArray.push(channel);
							break;
						case jetChannel:
							soundArray.push(channel);
							break;
						case clockChannel:
							soundArray.push(channel);
							break;
						case rollChannel:
							soundArray.push(channel);
							break;
						default:
							channel.stop();
							break;
					}
				}
			}
		}
		
		public function allReplaced():void
		{
			//SoundMixer.stopAll();
			clockOff();
			emptyTo31();
			var channel:SoundChannel = allReplacedSound.play(0,1,new SoundTransform(.4,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		
		public function addThrusterChannel(Thruster:ThrusterParticleDesigner):void
		{
            thrusterArray.push(Thruster);
			soundArray.push(Thruster.channel);
		}
		
		public function stopThruster(Thruster:ThrusterParticleDesigner):void
		{
			Thruster.channel.stop(); 
			//thrusterArray.splice(thrusterArray.indexOf(Thruster),1);
			soundArray.splice(soundArray.indexOf(Thruster.channel),1);
		}
		
		public function stopAllThrusters(Dispose:Boolean = true):void
		{
			trace('stopAllThrusters');
			for each ( var thruster:ThrusterParticleDesigner in thrusterArray)
			{
				trace('thruster.channel = ' + thruster.channel);
				if(thruster.channel) 
				{
					thruster.stopSound();
					thruster.channel.stop();
					if(Dispose) thrusterArray.splice(thrusterArray.indexOf(thruster.channel),1);
				}
			}
		}
		
		public function restartThrusters():void
		{
			for each ( var thruster:ThrusterParticleDesigner in thrusterArray)
			{
				thruster.playSound();
			}
		}
		
		public function ready():void
		{
			var channel:SoundChannel = readySound.play(0,1,new SoundTransform(.16,0));
			
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function sweep():void
		{	
			emptyTo31();
			var channel:SoundChannel = sweepSound.play(0,1,new SoundTransform(.3,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function clock():void
		{	
			//SoundMixer.stopAll();
			emptyTo31();
			clockChannel = clockSound.play(clockStartTime,1,new SoundTransform(.4,0));
			if(clockChannel)
			{
				soundArray.push(clockChannel);
				clockChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			soundArray.push(clockChannel);
			clockChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		public function clockOff():void
		{
			if(clockChannel) 
			{
				clockChannel.stop();
				soundArray.splice(soundArray.indexOf(clockChannel),1);
				clockStartTime = 0;
			}
		}
		
		public function clockPause():void
		{
			if(clockChannel) 
			{
				clockStartTime = clockChannel.position;
				clockChannel.stop();
				soundArray.splice(soundArray.indexOf(clockChannel),1);
			}
		}
		
		public function buzzer():void
		{
			//SoundMixer.stopAll();
			emptyTo31();
			var channel:SoundChannel = buzzerSound.play(0,1,new SoundTransform(.4,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function roll(onCompleteFunction:Function):void
		{
			runStop();
			rollChannel = rollSound.play(0,1,new SoundTransform(.3,0));
			rollChannel.addEventListener(Event.SOUND_COMPLETE, onRollComplete);
			trace('roll play');
			
			function onRollComplete (e:Event):void 
			{ 
				trace('roll complete');
				rollChannel.removeEventListener(Event.SOUND_COMPLETE, onRollComplete);
				rollendSound.play(0,1,new SoundTransform(.3,0));
				trace('rollend play');
				results();
				if(onCompleteFunction != null) onCompleteFunction();
			}
			
		}
		
		public function results():void
		{
			var channel:SoundChannel;
			channel = resultsSound.play(0,1,new SoundTransform(.5,0));
			channel.addEventListener(Event.SOUND_COMPLETE, onResultComplete);
			
			function onResultComplete (e:Event):void 
			{ 
				channel.removeEventListener(Event.SOUND_COMPLETE, onResultComplete);
				musicStart() ;
			}
		}
		
		public function musicStart():void
		{
			if(!musicChannel) musicChannel = menuMusicSound.play(0,int.MAX_VALUE,new SoundTransform(.35,0));
		}
		
		public function musicStop():void
		{
			var st:SoundTransform = new SoundTransform(.35,0);
			var timer:Timer = new Timer(17);
			
			if(musicChannel != null) 
			{
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			}
			
			function onTimer(e:TimerEvent):void
			{
				st.volume -= .01;
				musicChannel.soundTransform = st;
				
				if(st.volume <= 0)
				{
					musicChannel.stop();
					musicChannel = null;
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
				}
			}
		}
		
		public function runStart(Actor:String):void
		{
			actor = Actor;
			
			if(!isRunning) 
			{
				isRunning = true;
				
				if(actor == 'bub') runChannel = bubRunSound.play(0,int.MAX_VALUE, new SoundTransform(.7,0))
				else runChannel = botRunSound.play(0,int.MAX_VALUE, new SoundTransform(.25,0));
				
				soundArray.push(runChannel);
			}
		}
		
		public function runStop():void
		{
			if(isRunning) 
			{
				isRunning = false;
				if(runChannel) {runChannel.stop(); soundArray.splice(soundArray.indexOf(runChannel),1);}
			}
		}
		
		public function jetStart():void
		{
			if(!isJumping) 
			{
				isJumping = true;
				jetChannel = jetpackSound.play(0,1, new SoundTransform(.65,0));
				soundArray.push(jetChannel);
			}
		}
		
		public function jetStop():void
		{
			if(isJumping) 
			{
				isJumping = false;
				if(jetChannel) {jetChannel.stop(); soundArray.splice(soundArray.indexOf(jetChannel),1);}
				jetpackOffSound.play(0,1, new SoundTransform(.65,0));
			}
		}
		
		public function bump():void
		{
			var channel:SoundChannel = bumpSound.play(0,1, new SoundTransform(.5,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
			
			if(actor == 'bot') 
			{
				var channel2:SoundChannel = podwalk2Sound.play(0,1, new SoundTransform(.04,0));
				if(channel2)
				{
					soundArray.push(channel2);
					channel2.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				}
			}
			
		}
		
		public function hit():void
		{
			var channel:SoundChannel = hitSound.play(0,1, new SoundTransform(.05,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function pickup():void
		{
			emptyTo31();
			var channel:SoundChannel = pickupSound.play(0,1, new SoundTransform(.1,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function wanted():void
		{
			emptyTo31();
			var channel:SoundChannel = wantedSound.play(0,1, new SoundTransform(.6,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function unwanted():void
		{
			emptyTo31();
			var channel:SoundChannel = unwantedSound.play(0,1, new SoundTransform(.7,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function rejected():void
		{
			emptyTo31();
			var channel:SoundChannel = rejectedSound.play(0,1, new SoundTransform(.5,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function whoops():void
		{
			emptyTo31();
			var channel:SoundChannel = whoopsSound.play(0,1, new SoundTransform(.6,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function tryagain():void
		{
			emptyTo31();
			var channel:SoundChannel = tryagainSound.play(0,1, new SoundTransform(.6,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function rock(Dude:Body, Obj:Body):void 
		{
			//var rockArray:Array = [new Rock1SFX() as SoundAsset, new Rock2SFX() as SoundAsset, new Rock3SFX() as SoundAsset];
			var d:Number;
			var st:SoundTransform = new SoundTransform(.8,0);
			var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
			if(Obj.position.x < Dude.position.x) { d = n/1000 * -1; if(d < -1) d = -1};
			if(Obj.position.x > Dude.position.x) { d = n/1000; if(d > 1) d = 1};
			st.pan = d;
			var num:Number = Math.floor(Math.random() * rockArray.length);
			var channel:SoundChannel = rockArray[num].play(0,1,st);
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);	
			}
		}
		
		public function foodhit(Dude:Body, Obj1:Body, Obj2:Body):void 
		{
			//trace('foodhit, ' + Obj1.graphic.kind);
			var Obj:Body;
			if(Obj1.graphic.kind == 'food') Obj = Obj1 else Obj = Obj2;
			var d:Number;
			var st:SoundTransform = new SoundTransform();
			var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
			if(Obj.position.x < Dude.position.x) { d = n/1000 * -1; if(d < -1) d = -1};
			if(Obj.position.x > Dude.position.x) { d = n/1000; if(d > 1) d = 1};
			st.pan = d;
			var num:Number = Math.floor(Math.random() * foodhitArray.length);
			var X:Number = Obj.velocity.x < 0 ? Obj.velocity.x * -1 : Obj.velocity.x;
			var Y:Number = Obj.velocity.y < 0 ? Obj.velocity.y * -1 : Obj.velocity.y;
			//trace(X + ', ' + Y);
			if(X > Y) st.volume = Math.round(X) / 8000 else st.volume = Math.round(Y) / 8000;
			if(st.volume > .7) st.volume = .7;
			
			var channel:SoundChannel = foodhitArray[num].play(0,1,st); 
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function podhit(Dude:Body, Obj:Body, Volume:Number = .3):void 
		{
			var d:Number;
			var st:SoundTransform = new SoundTransform(Volume,0);
			var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
			if(Obj.position.x < Dude.position.x) { d = n/1000 * -1; if(d < -1) d = -1};
			if(Obj.position.x > Dude.position.x) { d = n/1000; if(d > 1) d = 1};
			st.pan = d;
			var num:Number = Math.floor(Math.random() * podhitArray.length);
			var channel:SoundChannel = podhitArray[num].play(0,1,st);
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function podwalk():void 
		{
			var num:Number = Math.floor(Math.random() * podwalkArray.length);
			var channel:SoundChannel = podwalkArray[num].play(0,1,new SoundTransform(.2,0));
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function thump(Dude:Body, Obj:Body):void
		{
			var d:Number;
			var st:SoundTransform = new SoundTransform(.6,0);
			var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
			if(Obj.position.x < Dude.position.x) { d = n/1000 * -1; if(d < -1) d = -1};
			if(Obj.position.x > Dude.position.x) { d = n/1000; if(d > 1) d = 1};
			st.pan = d;
			//trace(st.pan);
			var channel:SoundChannel = thumpSound.play(0,1,st);
			soundArray.push(channel);
			if(channel)
			{
				soundArray.push(channel);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function block(Dude:Body, Obj:Body):void 
		{
			
			var d:Number;
			var st:SoundTransform = new SoundTransform(.3,0);
			var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
			if(Obj.position.x < Dude.position.x) { d = n/1000 * -1; if(d < -1) d = -1};
			if(Obj.position.x > Dude.position.x) { d = n/1000; if(d > 1) d = 1};
			st.pan = d;
			var num:Number = Math.floor(Math.random() * blockArray.length);
			var X:Number = Obj.velocity.x < 0 ? Obj.velocity.x * -1 : Obj.velocity.x;
			var Y:Number = Obj.velocity.y < 0 ? Obj.velocity.y * -1 : Obj.velocity.y;
			//trace(X + ', ' + Y);
			if(X > 5 || Y > 5 ) 
			{
				var channel:SoundChannel = blockArray[num].play(0,1,st);
				if(channel) 
				{
					soundArray.push(channel);
					channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				}
			}
		}
		
		public function blockThump(Dude:Body, Obj:Body):void 
		{
			block(Dude, Obj);
			thump(Dude, Obj)
		}
		
		public function toss(Direction:String, Dude:Body, Obj:Body):void
		{
			emptyTo31();
			var d:Number;
			var st:SoundTransform = new SoundTransform(.2,0);
			var timer:Timer = new Timer(17);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			var throwChannel:SoundChannel = throwSound.play(0,1);
			
			timer.start();
			if(throwChannel) {throwChannel.addEventListener(Event.SOUND_COMPLETE, onTossComplete); soundArray.push(throwChannel);}
			
			function onTimer(e:TimerEvent):void
			{
				var n:Number = Math.sqrt((Dude.position.x - Obj.position.x) * (Dude.position.x - Obj.position.x) + (Dude.position.y - Obj.position.y) * (Dude.position.y - Obj.position.y));
				if(Direction == 'left') { d = n/1000 * -1; if(d < -1) d = -1};
				if(Direction == 'right') { d = n/1000; if(d > 1) d = 1};
				st.pan = d;
				if(throwChannel) throwChannel.soundTransform = st;
			}
			
			function onTossComplete(e:Event):void
			{
				if(throwChannel) 
				{
					throwChannel.removeEventListener(Event.SOUND_COMPLETE, onTossComplete);
					onSoundComplete(e)
				}
				timer.stop();
				timer = null;
				throwChannel = null;
			}
		}
		
		
	}
}
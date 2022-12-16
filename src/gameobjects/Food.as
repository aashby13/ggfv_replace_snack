package gameobjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;

	public class Food extends Sprite
	{
		public var title:String;
		public var kind:String = 'food';
		public var feedback:String;
		public var collectable:Boolean = true;
		public var wanted:Boolean = false;
		public var pickupable:Boolean = false;
		private var _tag:Sprite;
		private var tween:Tween;
		private var main:*;
		
		
		public function Food(Img:Image, Title:String, Feedback:String, Wanted:Boolean, Main:*)
		{
			addChild(new Image(ArtRegistry.foodholderTexture));
			pivotX = width >> 1;
			pivotY = height >> 1;
			
			if(Img)
			{
				var foodImg:Image = Img;
				foodImg.x = pivotX - foodImg.width/2;
				foodImg.y = pivotY - foodImg.height/2;
				addChild(foodImg);
			}
			
			title = Title;
			feedback = Feedback;
			wanted = Wanted;
			main = Main;
			tag = makeTag(title);
				
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, distance);
			this.flatten();
		}
		
		public function set tag(sprite:Sprite):void 
		{
			_tag = sprite;
			_tag.visible = false;
			_tag.alpha = 0;
			
			
		}
		
		public function get tag():Sprite
		{
			return _tag;
		}
		
		private function start():void
		{
			//trace('food tag start');
			//trace(_tag.alpha);
			if(main.getChildIndex(_tag) != main.numChildren-1) main.setChildIndex(_tag, main.numChildren-1);
			
			if(_tag.alpha == 0)
			{
				_tag.visible = true;
				tween = new Tween(_tag, .6, Transitions.EASE_OUT);
				//tween.delay = 0;
				tween.fadeTo(1);
				Starling.juggler.add(tween);
			}

		}
		
		private function stop():void
		{
			//trace('food tag stop');
			//trace(_tag.alpha);
			if(_tag.alpha == 1)
			{
				tween = new Tween(_tag, .6, Transitions.EASE_OUT);
				tween.onComplete = function():void{if(_tag.alpha == 0)_tag.visible = false};
				//tween.delay = .5;
				tween.fadeTo(0);
				Starling.juggler.add(tween);
			}
		}
		
		private function distance(e:EnterFrameEvent):void 
		{
			var sprite:* = e.target;
			//trace(sprite.title);
			_tag.x = sprite.x; 
			_tag.y = sprite.y - 75;
			
			var point1:Point = new Point(sprite.x, sprite.y);
			var point2:Point = new Point(main.dude.position.x, main.dude.position.y);
			var dist:Number = Math.sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y)  * (point1.y - point2.y));
			
			if(dist < 250) start() else stop();

		}
		
		private function makeTag(Title:String):Sprite
		{
			var tagsprt:Sprite = new Sprite();
			var sprite:flash.display.Sprite = new flash.display.Sprite();
			
			var txt:TextField = new TextField();
			txt.embedFonts = true; 
			txt.multiline = true;
			txt.wordWrap = true;
			txt.antiAliasType = 'advanced';
			txt.styleSheet = main.flashroot.css;
			txt.width = 175; // set max width of txt
			txt.text = '<p class = "tag">' +Title+ '</p>';
			txt.autoSize = 'center';
			txt.width = txt.textWidth + 8; 
			txt.height = txt.textHeight + 4;
			
			var rect:flash.display.Sprite = new flash.display.Sprite;
			rect.graphics.lineStyle(2, 0xFFFFFF, 1, true, "normal");
			rect.graphics.beginFill(0x68789D,1);
			rect.graphics.drawRoundRect(0, 0, txt.width + 16, txt.height + 12, 20, 20);
			rect.graphics.endFill();
			
			txt.x = rect.width/2 - txt.width/2;
			txt.y = rect.height/2 - txt.height/2 - 2;
			rect.addChild(txt);
			
			var dsfilter:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, .6, 4, 4, 1, 1); //distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject
			rect.filters = [dsfilter];
			rect.cacheAsBitmap = true;
			
			rect.x = 3;
			rect.y = 3;
			sprite.addChild(rect);

			var bmd:BitmapData = new BitmapData(sprite.width+8,sprite.height+8,true,0x0000);
			bmd.draw(sprite);
			var img:Image = Image.fromBitmap(new Bitmap(bmd));
			
			tagsprt.addChild(img);
			tagsprt.pivotX = tagsprt.width/2;
			tagsprt.pivotY = tagsprt.height/2;
			
			main.addChild(tagsprt);
			return tagsprt;
		}
	}
}
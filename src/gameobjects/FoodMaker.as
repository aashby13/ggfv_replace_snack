package gameobjects
{
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.space.Space;
	
	import screens.Game;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import statemachine.States;
	
	public class FoodMaker
	{
		private var atlas:TextureAtlas;
		private var main:Game;
		private var space:Space;
		private var type:CbType;
		private var update:Function;
		private var wantedXML:XML;
		private var stealthXML:XML;
		
		private var wantedArray:Array = [];
		private var stealthArray:Array = [];
		private var allArray:Array = [];
		
		public function FoodMaker(Main:Game, Spce:Space, Type:CbType, UpdateGFX:Function)
		{
			main = Main;
			space = Spce;
			type = Type;
			update = UpdateGFX;
			atlas = ArtRegistry.foodAtlas;
			
			if(main.flashroot.currentLevel == States.LEVEL1)
			{
				wantedXML = ArtRegistry.fwl1XML;
				stealthXML = ArtRegistry.fsl1XML;
			}
			
			if(main.flashroot.currentLevel == States.LEVEL2)
			{
				main.flashroot.handoutObj = [];
				wantedXML = ArtRegistry.fwl2XML;
				stealthXML = ArtRegistry.fsl2XML;
			}
			
			parseXMLs();
		}
		
		
		private function parseXMLs():void
		{
			
			for each (var item:XML in wantedXML.item)
			{
				var obj:Object = new Object;
				obj.title = item.@title;
				obj.feedback = item.@feedback;
				obj.wanted = true;
				allArray.push(obj);
				//trace(obj.title + ': ' + obj.wanted);
				if(main.flashroot.currentLevel == States.LEVEL2) main.flashroot.handoutObj.push(obj.title);
				trace(main.flashroot.handoutObj);
			}
			
			for each (var item2:XML in stealthXML.item)
			{
				var obj2:Object = new Object;
				obj2.title = item2.@title;
				obj2.feedback = item2.@feedback;
				obj2.wanted = false;
				allArray.push(obj2);
				//trace(obj2.title + ': ' + obj2.wanted);
			}
		}
		
		public function make():Body 
		{
			var item:Object = getFoodItem();
			var arr:Array = item.title.split(' ');
			var name:String = '';
			
			for (var i:int=0; arr.length > i; i++) 
			{
				if(i != 0) name += '_';
				name += arr[i];
			}
			trace(name);
			var texture:Texture = atlas.getTexture(name);
			if(texture) var img:Image = new Image(texture) else trace("missing image: " + name);
			var food:Food = new Food(img,item.title,item.feedback,item.wanted,main);
			
			var body:Body = PhysicsData.createBody('foodholder', food);
			body.setShapeMaterials(new Material(1.2));
			body.space = space;
			body.graphicUpdate = update;
			body.cbType = type;
			main.addChild(body.graphic);
			
			return body;
		}
		
		private function getFoodItem():Object 
		{
			var num:int = getNum();
			var obj:Object = allArray[num];
			if(allArray[num].wanted) wantedArray.push(obj) else stealthArray.push(obj);
			allArray.splice(num,1);
			//trace(obj.title);
			return obj;
		}
		
		private function getNum():int 
		{
			//trace('allArray.length = ' + allArray.length);
			var num:int = Math.floor(Math.random() * allArray.length);
			//trace('random number = ' + num);
			
			if(allArray[num].wanted)
			{
				//trace('wantedArray.length = ' + wantedArray.length);
				if(wantedArray.length < 8) return num else return getNum();
				//return num;
				
			}
			else
			{
				//trace('stealthArray.length = ' + stealthArray.length);
				if(stealthArray.length < 5) return num else return getNum();	
				//return num;
				
			}
		}
	}
}
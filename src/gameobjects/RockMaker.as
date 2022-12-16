package gameobjects
{
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.space.Space;
	
	import screens.Game;
	
	public class RockMaker
	{
		private var main:Game;
		private var space:Space;
		private var type:CbType;
		private var update:Function;
		
		public function RockMaker(Main:Game, Spce:Space = null, Type:CbType = null, UpdateGFX:Function = null)
		{
			main = Main;
			space = main.space;
			type = main.pickuptype;
			update = main.updateGraphics;

		}
		
		public function make(Kind:Number = 1, Type:CbType = null):Body // 1, 2, or 3
		{
			var name:String = "rock" + Kind.toString(); //trace (name);
			var body:Body = PhysicsData.createBody(name, ObjectRegistry.getRock(Kind));
			body.setShapeMaterials(new Material(0.4));
			body.space = space;
			body.graphicUpdate = update;
			if(Type) body.cbType = Type else body.cbType = type;
			main.addChild(body.graphic);
			return body;
		}
	}
}
package gameobjects
{
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	
	import screens.Game;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;

	public class SceenMaker
	{
		private var main:Game;
		private var plat:Body;
		private var dude:Body;
		private var pfm:PlatformMaker;
		private var rm:RockMaker;
		private var fm:FoodMaker;
		private var functArray:Array;
		
		public function SceenMaker(Main:Game)
		{
			main = Main;
			dude = main.dude;
			//functArray = [makeSceen3];
			functArray = [makeSceen1, makeSceen2 , makeSceen3];
			fm = new FoodMaker(main,main.space,main.pickuptype,main.updateGraphics);
			pfm = new PlatformMaker(main.dude,main,main.space,main.sound,main.updateGraphics);
			rm = new RockMaker(main,main.space,main.pickuptype,main.updateGraphics);
		}
		
		public function makeSceen():void
		{
			var funct:Function;
			
			if(main.flashroot.tryAgain == true) 
			{
				trace('try again same scene ' + main.flashroot.prevGameSceen+1);
				funct = functArray[main.flashroot.prevGameSceen];
				funct();
			}
			else 
			{
				var num:Number = Math.floor(Math.random() * functArray.length);
				//trace(num);
				
				if(main.flashroot.prevGameSceen == num)
				{
					trace('redo makeSceen');
					makeSceen();
				}
				else
				{
					trace('new sceen ' + num+1);
					funct = functArray[num];
					funct();
					main.flashroot.prevGameSceen = num;
				}
			}

			//makeSceen3();
		}
		
		private function makeHangingFood(X:Number, Y:Number):void
		{
			var food:Body = fm.make();
			food.position = new Vec2(X,Y);
			
			
			var box:Polygon = new Polygon(Polygon.rect(0,0,100,100));
			box.filter.collisionGroup = 0; //in group 0x00000002
			box.filter.collisionMask = 0;
			var staticBody:Body = new Body(BodyType.STATIC, new Vec2(X,Y-200));
			box.body = staticBody;
			staticBody.space = main.space;
			/*staticBody.graphic = new Block();
			staticBody.graphicUpdate = main.updateGraphics;
			main.addChild(staticBody.graphic);*/
			
			var joint:PivotJoint = new PivotJoint(staticBody, food, new Vec2(staticBody.bounds.width/2, staticBody.bounds.height), new Vec2(food.bounds.width/2, -100));
			joint.stiff = false;
			joint.breakUnderForce = true;
			joint.removeOnBreak = true;
			joint.maxForce = 100000;
			joint.space = main.space;
		}
		
		private function makeFood(X:Number, Y:Number):void
		{
			var food:Body = fm.make();
			food.position = new Vec2(X,Y);
		}
		
		private function makeBlock(X:Number, Y:Number):void
		{
			var block:Body = new Body(BodyType.DYNAMIC, new Vec2(X,Y));
			block.shapes.add(new Polygon(Polygon.rect(-50,-50,100,100), new Material(.4)));
			block.space = main.space;
			block.graphic = ObjectRegistry.getBlock();
			block.graphicUpdate = main.updateGraphics;
			block.cbType = main.pickuptype;
			main.addChild(block.graphic);
		}
		
		private function makeRock(Kind:int, X:Number, Y:Number):void
		{
			var rock:Body = rm.make(Kind);
			rock.position = new Vec2(X,Y);
		}
		
		private function makeSceen1():void
		{
			trace('makeSceen1');
			
			makeBlock(1200,2200);
			makeBlock(6250,2750);
			makeBlock(6250,2850);
			makeBlock(6150,2750);
			makeBlock(6150,2850);
			makeBlock(5650,2750);
			makeBlock(5350,750);
			makeBlock(5450,750);
			makeBlock(3800,200);
			makeBlock(2000,400);
			makeBlock(2000,300);
			makeBlock(2000,200);

			
			makeRock(1,5600,750);
			makeRock(1,5000,750);
			makeRock(1,3600,200);
			makeRock(2,5100,750);
			makeRock(2,5100,600);
			makeRock(2,2500,1400);
			makeRock(1,2150,200);
			makeRock(3,2250,200);
			makeRock(2,2100,100);
			makeRock(1,2100,400);
			
			//Food max 13
			makeFood(1900, 2300);
			makeFood(2320, 1400);
			makeFood(2100, 200);
			makeHangingFood(1330, 2060);
			makeHangingFood(1000, 2120);
			makeHangingFood(6100,2000);
			makeHangingFood(200, 2300);
			makeHangingFood(5500,600);
			makeHangingFood(5200,600);
			makeHangingFood(3650,20);
			makeHangingFood(1700,200);
			makeHangingFood(1500,350);
			makeHangingFood(5700,2220);
			
			
			//pfm.make(Kind,X,Y,Width,CbType,DropAmount=100);
			plat = pfm.make('floater', 1000, 2300, 800, main.statictype, 450);
			plat = pfm.make('floater', 2000, 2100, 400, main.statictype, 700);
			plat = pfm.make('floater', 2700, 1900, 400, main.statictype, 700);
			plat = pfm.make('floater', 2200, 1450, 400, main.statictype, 700);
			plat = pfm.make('floater', 3300, 1650, 800, main.statictype, 700);
			plat = pfm.make('floater', 4300, 1600, 400, main.statictype, 700);
			plat = pfm.make('floater', 4900, 820, 800, main.statictype, 900);
			plat = pfm.make('floater', 4375, 530, 400, main.statictype, 700);
			plat = pfm.make('floater', 3400, 250, 800, main.statictype, 900);
			plat = pfm.make('floater', 2500, 200, 800, main.statictype, 700);
			plat = pfm.make('floater', 1900, 500, 400, main.statictype, 900);
		}
		
		private function makeSceen2():void
		{
			trace('makeSceen2');
			var startX:int = 1400;
			var startY:int = 2750;
			var base:int = 8;
			
			//make pyramid
			for (var n:int=0; base > n; n++)
			{
				var p:int = base - n;
				//trace(p);
				for(var i:int=0; p > i; i++)
				{
					if(i == 3 && p == 7) makeFood(startX + (i*100),startY)
					else if (i == 2 && p == 5) makeFood(startX + (i*100),startY)
					else makeBlock(startX + (i*100),startY);
					
					if(p == 1) makeHangingFood(startX + (i*100),startY - 450);
				}
				
				startX += 50; //trace(startX);
				startY -= 100; //trace(startY);
			}
			
			makeBlock(5800,2750);
			
			makeRock(1,4400,450);
			makeRock(1,4500,450);
			makeRock(1,4680,450);
			makeRock(2,4480,350);
			makeRock(2,4580,350);
			makeRock(2,4790,450);
			makeRock(2,4490,450);
			makeRock(1,4900,450);
			makeRock(1,4800,350);
			makeRock(1,4700,350);
			makeRock(2,4600,250);
			makeRock(2,4600,150);
			makeRock(3,4500,150);
			makeRock(3,2075,50);
			
			makeFood(1250,50);
			makeFood(1450,50);
			makeFood(1650,50);
			makeFood(1750,50);
			makeFood(1850,50);
			makeFood(1950,50);
			makeFood(3200,1285);
			makeHangingFood(750,120);
			makeHangingFood(5200,300);
			makeHangingFood(5800,2250);
			
			
			//pfm.make(Kind,X,Y,Width,CbType,DropAmount=100);
			plat = pfm.make('floater', 2050, 1800, 800, main.statictype, 700);
			plat = pfm.make('floater', 3000, 1385, 400, main.statictype, 700);
			plat = pfm.make('floater', 3600, 1250, 400, main.statictype, 700);
			plat = pfm.make('floater', 4200, 500, 800, main.statictype, 900);
			plat = pfm.make('floater', 3600, 350, 400, main.statictype, 700);
			plat = pfm.make('floater', 3050, 250, 400, main.statictype, 700);
			plat = pfm.make('floater', 2500, 250, 400, main.statictype, 700);
			plat = pfm.make('floater', 1150, 150, 1200, main.statictype, 700);
		}
		
		private function makeSceen3():void
		{
			trace('makeSceen3');
			
			makeBlock(3500,2750);
			makeBlock(3500,2650);
			makeBlock(3500,2550);
			makeBlock(3500,2450);
			
			makeBlock(3800,2750);
			
			makeBlock(4800,2750);
			makeBlock(5000,2750);
			
			makeRock(1,1850,2750);
			makeRock(1,1950,2750);
			makeRock(2,1925,2650);
			makeRock(1,5750,2750);
			makeRock(1,5350,1650);
			makeRock(1,5450,1650);
			makeRock(2,5400,1550);
			makeRock(1,4350,950);
			makeRock(1,4450,950);
			makeRock(1,4550,950);
			makeRock(1,4650,950);
			makeRock(1,4750,950);
			makeRock(2,4400,850);
			makeRock(2,4500,850);
			makeRock(2,4700,850);
			
			makeFood(3650,2750);
			makeFood(3650,2650);
			makeFood(3650,2550);
			
			makeFood(4900,2750);
			
			makeHangingFood(900,200);
			makeHangingFood(1100,200);
			makeHangingFood(1300,200);
			makeHangingFood(1500,200);
			makeHangingFood(1900,2200);
			makeHangingFood(3400,500);
			makeHangingFood(3300,500);
			makeHangingFood(3500,350);
			
			
			var startX:int = 2400;
			var startY:int = 2750;
			var base:int = 5;
			
			//make pyramid
			for (var n:int=0; base > n; n++)
			{
				var p:int = base - n;
				//trace(p);
				for(var i:int=0; p > i; i++)
				{
					if(p!=1) makeBlock(startX + (i*100),startY);
					makeBlock(startX + 800 + (i*100),startY + (base * -100));
					if(p == 1) makeHangingFood(startX + 800 + (i*100),startY + (base * -100) - 450);
					if(p==2 && i==1) 
					{ 
						plat = pfm.make('reg', startX-50, startY-100, 2048, main.statictype);
						plat = pfm.make('static', startX + 1600 + (i*100),startY-46, 400, main.statictype);
						
					}
					
				}
				
				startX += 50; //trace(startX);
				startY -= 100; //trace(startY);
			}
			
			plat = pfm.make('floater', 2200, 1500, 800, main.statictype, 620);
			plat = pfm.make('floater', 1650, 1300, 400, main.statictype, 700);
			plat = pfm.make('floater', 1100, 1050, 400, main.statictype, 700);
			plat = pfm.make('floater', 550, 820, 400, main.statictype, 700);
			plat = pfm.make('floater', 800, 400, 800, main.statictype, 700);
			plat = pfm.make('floater', 5840, 2300, 400, main.statictype, 700);
			plat = pfm.make('floater', 5260, 1800, 400, main.statictype, 900);
			plat = pfm.make('floater', 4200, 1000, 800, main.statictype, 900);
			plat = pfm.make('floater', 3500, 800, 400, main.statictype, 700);
			
		}
		
		private function makeSceen4():void
		{
			trace('makeSceen4');
		}
		
		
		
		
	}
}
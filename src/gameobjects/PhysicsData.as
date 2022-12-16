package gameobjects{

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.geom.Vec2;
import nape.dynamics.InteractionFilter;
import nape.phys.Material;
import nape.phys.FluidProperties;
import nape.callbacks.CbType;
import nape.geom.AABB;

import starling.display.DisplayObject;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class PhysicsData {

	public static function createBody(name:String,graphic:DisplayObject=null):Body {
		var xret:BodyPair = lookup(name);
		if(graphic==null) return xret.body.copy();

		var ret:Body = xret.body.copy();
		graphic.x = graphic.y = 0;
		graphic.rotation = 0;
		var bounds:Rectangle = graphic.getBounds(graphic);
		var offset:Vec2 = Vec2.get(bounds.x-xret.anchor.x, bounds.y-xret.anchor.y);

		ret.graphic = graphic;
		ret.graphicUpdate = function(b:Body):void {
			var gp:Vec2 = b.localToWorld(offset);
			graphic.x = gp.x;
			graphic.y = gp.y;
			graphic.rotation = (b.rotation*180/Math.PI)%360;
		}	

		return ret;
	}

	public static function registerMaterial(name:String,material:Material):void {
		if(materials==null) materials = new Dictionary();
		materials[name] = material;	
	}
	public static function registerFilter(name:String,filter:InteractionFilter):void {
		if(filters==null) filters = new Dictionary();
		filters[name] = filter;
	}
	public static function registerFluidProperties(name:String,properties:FluidProperties):void {
		if(fprops==null) fprops = new Dictionary();
		fprops[name] = properties;
	}
	public static function registerCbType(name:String,cbType:CbType):void {
		if(types==null) types = new Dictionary();
		types[name] = cbType;
	}

	//----------------------------------------------------------------------	

	private static var bodies   :Dictionary;
	private static var materials:Dictionary;
	private static var filters  :Dictionary;
	private static var fprops   :Dictionary;
	private static var types    :Dictionary;
	private static function material(name:String):Material {
		if(name=="default") return new Material();
		else {
			if(materials==null || materials[name] === undefined)
				throw "Error: Material with name '"+name+"' has not been registered";
			return materials[name] as Material;
		}
	}
	private static function filter(name:String):InteractionFilter {
		if(name=="default") return new InteractionFilter();
		else {
			if(filters==null || filters[name] === undefined)
				throw "Error: InteractionFilter with name '"+name+"' has not been registered";
			return filters[name] as InteractionFilter;
		}
	}
	private static function fprop(name:String):FluidProperties {
		if(name=="default") return new FluidProperties();
		else {
			if(fprops==null || fprops[name] === undefined)
				throw "Error: FluidProperties with name '"+name+"' has not been registered";
			return fprops[name] as FluidProperties;
		}
	}
	private static function cbtype(name:String):CbType {
		if(name=="null") return null;
		else {
			if(types==null || types[name] === undefined)
				throw "Error: CbType with name '"+name+"' has not been registered";
			return types[name] as CbType;
		}	
	}

	private static function lookup(name:String):BodyPair {
		if(bodies==null) init();
		if(bodies[name] === undefined) throw "Error: Body with name '"+name+"' does not exist";
		return bodies[name] as BodyPair;
	}

	//----------------------------------------------------------------------	

	private static function init():void {
		bodies = new Dictionary();

		var body:Body;
		var mat:Material;
		var filt:InteractionFilter;
		var prop:FluidProperties;
		var cbType:CbType;
		var s:Shape;
		var anchor:Vec2;

		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(666,379)   ,  Vec2.weak(666,358)   ,  Vec2.weak(276,240)   ,  Vec2.weak(587,358)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(4,343)   ,  Vec2.weak(19,358)   ,  Vec2.weak(587,358)   ,  Vec2.weak(276,240)   ,  Vec2.weak(150,239)   ,  Vec2.weak(52,287)   ,  Vec2.weak(33,298)   ,  Vec2.weak(1,330)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(297,70)   ,  Vec2.weak(265,57)   ,  Vec2.weak(234,52)   ,  Vec2.weak(208,57)   ,  Vec2.weak(150,137)   ,  Vec2.weak(320,120)   ,  Vec2.weak(317,100)   ,  Vec2.weak(315,90)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(345,134)   ,  Vec2.weak(320,120)   ,  Vec2.weak(150,137)   ,  Vec2.weak(343,137)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(45,232)   ,  Vec2.weak(52,287)   ,  Vec2.weak(150,239)   ,  Vec2.weak(82,154)   ,  Vec2.weak(66,181)   ,  Vec2.weak(54,204)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(250,53)   ,  Vec2.weak(234,52)   ,  Vec2.weak(265,57)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(208,57)   ,  Vec2.weak(175,71)   ,  Vec2.weak(141,93)   ,  Vec2.weak(118,111)   ,  Vec2.weak(102,126)   ,  Vec2.weak(82,154)   ,  Vec2.weak(150,137)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(150,137)   ,  Vec2.weak(82,154)   ,  Vec2.weak(150,239)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (false) ? body.localCOM.copy() : Vec2.get(230.00000184,189.99999969);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["pod"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(178,53)   ,  Vec2.weak(173,57)   ,  Vec2.weak(182,74)   ,  Vec2.weak(187,66)   ,  Vec2.weak(185,58)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(98,197)   ,  Vec2.weak(104,202)   ,  Vec2.weak(168,202)   ,  Vec2.weak(100,188)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(196,141)   ,  Vec2.weak(172,137)   ,  Vec2.weak(162,138)   ,  Vec2.weak(179,165)   ,  Vec2.weak(193,153)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(140,35)   ,  Vec2.weak(146,54)   ,  Vec2.weak(166,55)   ,  Vec2.weak(150,28)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(160,106)   ,  Vec2.weak(166,98)   ,  Vec2.weak(173,57)   ,  Vec2.weak(166,55)   ,  Vec2.weak(95,76)   ,  Vec2.weak(154,105)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(174,197)   ,  Vec2.weak(174,191)   ,  Vec2.weak(162,138)   ,  Vec2.weak(155,116)   ,  Vec2.weak(88,77)   ,  Vec2.weak(87,158)   ,  Vec2.weak(99,168)   ,  Vec2.weak(168,202)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(48,152)   ,  Vec2.weak(63,150)   ,  Vec2.weak(59,107)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(63,150)   ,  Vec2.weak(87,158)   ,  Vec2.weak(88,77)   ,  Vec2.weak(71,86)   ,  Vec2.weak(59,107)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(179,165)   ,  Vec2.weak(162,138)   ,  Vec2.weak(174,191)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(182,82)   ,  Vec2.weak(182,74)   ,  Vec2.weak(173,57)   ,  Vec2.weak(166,98)   ,  Vec2.weak(178,89)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(105,66)   ,  Vec2.weak(95,76)   ,  Vec2.weak(131,65)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(137,58)   ,  Vec2.weak(131,65)   ,  Vec2.weak(166,55)   ,  Vec2.weak(146,54)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(100,188)   ,  Vec2.weak(168,202)   ,  Vec2.weak(99,168)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(160,121)   ,  Vec2.weak(155,116)   ,  Vec2.weak(162,138)   ,  Vec2.weak(163,131)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(154,105)   ,  Vec2.weak(95,76)   ,  Vec2.weak(88,77)   ,  Vec2.weak(152,112)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(155,116)   ,  Vec2.weak(152,112)   ,  Vec2.weak(88,77)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,250);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["bot"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(158,212)   ,  Vec2.weak(158,205)   ,  Vec2.weak(150,201)   ,  Vec2.weak(102.5,215)   ,  Vec2.weak(150,215.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(51,135)   ,  Vec2.weak(58.5,139)   ,  Vec2.weak(77.5,107)   ,  Vec2.weak(51,129)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(51,161)   ,  Vec2.weak(53,164)   ,  Vec2.weak(62,176)   ,  Vec2.weak(69,176)   ,  Vec2.weak(77,171.5)   ,  Vec2.weak(57.5,155)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(150,201)   ,  Vec2.weak(154,156)   ,  Vec2.weak(152,136)   ,  Vec2.weak(121,31.5)   ,  Vec2.weak(120,31.5)   ,  Vec2.weak(101.5,207)   ,  Vec2.weak(102.5,215)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(57.5,155)   ,  Vec2.weak(77,171.5)   ,  Vec2.weak(92.5,176)   ,  Vec2.weak(88.764045715332,102.247192382812)   ,  Vec2.weak(77.5,107)   ,  Vec2.weak(58.5,139)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(79.5,69)   ,  Vec2.weak(82,89)   ,  Vec2.weak(88.764045715332,102.247192382812)   ,  Vec2.weak(120,31.5)   ,  Vec2.weak(105,36)   ,  Vec2.weak(93.5,43)   ,  Vec2.weak(85,55)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(172,127)   ,  Vec2.weak(181.5,107)   ,  Vec2.weak(185.5,83)   ,  Vec2.weak(181.5,68)   ,  Vec2.weak(160.5,44)   ,  Vec2.weak(121,31.5)   ,  Vec2.weak(152,136)   ,  Vec2.weak(160,135)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(141,33.5)   ,  Vec2.weak(121,31.5)   ,  Vec2.weak(160.5,44)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(173,54)   ,  Vec2.weak(160.5,44)   ,  Vec2.weak(181.5,68)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(88.764045715332,102.247192382812)   ,  Vec2.weak(92.5,176)   ,  Vec2.weak(101.5,207)   ,  Vec2.weak(120,31.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,250);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["bub"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(96,28)   ,  Vec2.weak(86,17)   ,  Vec2.weak(68,2.5)   ,  Vec2.weak(48,-0.5)   ,  Vec2.weak(65,96)   ,  Vec2.weak(78,92)   ,  Vec2.weak(93,74)   ,  Vec2.weak(98,45)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(33,1.5)   ,  Vec2.weak(20,13)   ,  Vec2.weak(4.5,38)   ,  Vec2.weak(-0.5,62)   ,  Vec2.weak(9,83)   ,  Vec2.weak(65,96)   ,  Vec2.weak(48,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(27,96)   ,  Vec2.weak(52,101)   ,  Vec2.weak(65,96)   ,  Vec2.weak(9,83)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(3,75)   ,  Vec2.weak(9,83)   ,  Vec2.weak(-0.5,62)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(68,2.5)   ,  Vec2.weak(59,0)   ,  Vec2.weak(48,-0.5)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,101);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["rock1"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(25,3)   ,  Vec2.weak(16.5,10)   ,  Vec2.weak(6,28)   ,  Vec2.weak(2,45)   ,  Vec2.weak(48,69)   ,  Vec2.weak(70,32)   ,  Vec2.weak(68,22)   ,  Vec2.weak(40,2)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(38,73)   ,  Vec2.weak(48,69)   ,  Vec2.weak(2,45)   ,  Vec2.weak(5,55)   ,  Vec2.weak(10,61)   ,  Vec2.weak(21,69)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(66,55)   ,  Vec2.weak(70,32)   ,  Vec2.weak(48,69)   ,  Vec2.weak(56,66)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(49.5,3)   ,  Vec2.weak(40,2)   ,  Vec2.weak(68,22)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,73);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["rock2"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(17,2)   ,  Vec2.weak(10,9)   ,  Vec2.weak(3.5,19)   ,  Vec2.weak(2,30)   ,  Vec2.weak(44,36)   ,  Vec2.weak(47,22)   ,  Vec2.weak(42,9)   ,  Vec2.weak(33,2)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(14,45)   ,  Vec2.weak(25,47)   ,  Vec2.weak(32,45)   ,  Vec2.weak(44,36)   ,  Vec2.weak(2,30)   ,  Vec2.weak(4,37)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(46,15)   ,  Vec2.weak(42,9)   ,  Vec2.weak(47,22)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(38,43)   ,  Vec2.weak(44,36)   ,  Vec2.weak(32,45)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,47);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["rock3"] = new BodyPair(body,anchor);
		
			body = new Body();
			body.cbType = cbtype("null");

			
				mat = material("default");
				filt = filter("default");
				prop = fprop("default");
				cbType = cbtype("null");

				
					
						s = new Polygon(
							[   Vec2.weak(37,97)   ,  Vec2.weak(48,98)   ,  Vec2.weak(31,3)   ,  Vec2.weak(13,14)   ,  Vec2.weak(2,52)   ,  Vec2.weak(5,65)   ,  Vec2.weak(18,85)   ,  Vec2.weak(28,93)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(6,23)   ,  Vec2.weak(3,32)   ,  Vec2.weak(1,42)   ,  Vec2.weak(2,52)   ,  Vec2.weak(13,14)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(10,76)   ,  Vec2.weak(18,85)   ,  Vec2.weak(5,65)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(99,45)   ,  Vec2.weak(96,35)   ,  Vec2.weak(90,24)   ,  Vec2.weak(83,17)   ,  Vec2.weak(83,87)   ,  Vec2.weak(89,81)   ,  Vec2.weak(97,67)   ,  Vec2.weak(99,57)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(68,96)   ,  Vec2.weak(76,92)   ,  Vec2.weak(83,87)   ,  Vec2.weak(83,17)   ,  Vec2.weak(76,11)   ,  Vec2.weak(67,6)   ,  Vec2.weak(48,98)   ,  Vec2.weak(58,98)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(20,8)   ,  Vec2.weak(13,14)   ,  Vec2.weak(31,3)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(55,2)   ,  Vec2.weak(42,1)   ,  Vec2.weak(31,3)   ,  Vec2.weak(48,98)   ,  Vec2.weak(67,6)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
						s = new Polygon(
							[   Vec2.weak(94,74)   ,  Vec2.weak(97,67)   ,  Vec2.weak(89,81)   ],
							mat,
							filt
						);
						s.body = body;
						s.fluidEnabled = false;
						s.fluidProperties = prop;
						s.cbType = cbType;
					
				
			

			anchor = (true) ? body.localCOM.copy() : Vec2.get(0,100);
			body.translateShapes(Vec2.weak(-anchor.x,-anchor.y));
			body.position.setxy(0,0);

			bodies["foodholder"] = new BodyPair(body,anchor);
		
	}
}
}

import nape.phys.Body;
import nape.geom.Vec2;

class BodyPair {
	public var body:Body;
	public var anchor:Vec2;
	public function BodyPair(body:Body,anchor:Vec2):void {
		this.body = body;
		this.anchor = anchor;
	}
}

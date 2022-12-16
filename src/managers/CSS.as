package managers
{
	import flash.text.StyleSheet;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	public class CSS extends StyleSheet
	{
		
		[Embed(source="/assets/menus/fonts.swf", symbol="Metro")]
		private static var MetroFont:Class;
		
		public var font:Font;
		public var format:TextFormat;
		
		public function CSS()
		{
			font = new MetroFont();
			format = new TextFormat(font.fontName);
			
			this.setStyle("p", { fontFamily: font.fontName, fontSize: 21, letterSpacing: 0.1, color: "#FFFFFF" } );
			this.setStyle(".results", { fontSize: 20, color: "#FFFFCC" , leading: -3 } );
			this.setStyle(".title", { fontSize: 22 , color: "#FFFFFF"});
			this.setStyle(".error", { fontSize: 20, color: "#700000" });
			this.setStyle(".whoops", { fontSize: 24, textAlign: "center" });
			this.setStyle(".tag", { fontSize: 16, textAlign: "center" });
		}
		
	}
}
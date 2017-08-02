package common
{
	import flash.display.Stage;
	
	import mx.core.UIComponent;
	
	import spark.components.TextInput;
	import spark.components.WindowedApplication;

	public class GameUIInstance
	{
		public function GameUIInstance()
		{
		}
		
		public static var stage:Stage;
		
		public static var application:WindowedApplication;
		
		public static var uiContainer:UIComponent;
		
		public static var layoutBottom:UIComponent;
		
		public static var layoutTop:UIComponent;
		
		//public static var txt:TextInput;
		
	}
}
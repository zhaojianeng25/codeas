package proxy.top.model
{
	public interface ISky
	{
		function set url(value:String):void;
		function set cubeMapUrl(value:String):void;
		function set scale(value:Number):void;
		
		function set visible(value:Boolean):void
		function get visible():Boolean;
	}
}
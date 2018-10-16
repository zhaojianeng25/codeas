package proxy.top.model
{
	import pack.Prefab;
	
	import textures.TextureBaseVo;

	public interface IModel
	{
//		function set id(value:int):void;
//		function get id():int;
		
		function set uid(value:String):void;
		function get uid():String;
		
		function set x(value:Number):void;
		function get x():Number;
		
		function set y(value:Number):void;
		function get y():Number;
		
		function set z(value:Number):void;
		function get z():Number;
		
		function set rotationX(value:Number):void;
		function get rotationX():Number;
		
		function set rotationY(value:Number):void;
		function get rotationY():Number;
		
		function set rotationZ(value:Number):void;
		function get rotationZ():Number;
		
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		
		function set scaleY(value:Number):void;
		function get scaleY():Number;
		
		function set scaleZ(value:Number):void;
		function get scaleZ():Number;

		function get readObject():Object
		function dele():void
		
		function set prefab($prefab:Prefab):void;
		
		function set select(value:Boolean):void
		function get select():Boolean;
		
		function set visible(value:Boolean):void
		function get visible():Boolean;
		
		function addStage():void;
		
		function removeStage():void;
		function reset():void
			
		function setEnvCubeMap($textVo:TextureBaseVo):void
			
	}
}
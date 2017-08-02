package _Pan3D.display3D.interfaces
{
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	
	/**
	 * 3D显示基础接口
	 * @see _Pan3D.display3D.Display3DSprite
	 * @author liuyanfei  QQ: 421537900
	 */
	public interface IDisplay3D extends IAbsolute3D
	{
		function update():void;
		function setMatrix(modelMatrix:Matrix3D):void;
		function updataPos():void;
		function setProgram3D(value:Program3D):void;
		
		function set x(value:Number):void;
		function get x():Number;
		
		function set y(value:Number):void;
		function get y():Number;
		
		function set z(value:Number):void;
		function get z():Number;
		
		function set rotationX(value:Number):void;
		function get rotationX():Number;
		
//		function set rotationY(value:Number):void;
//		function get rotationY():Number;
		
		function set rotationZ(value:Number):void;
		function get rotationZ():Number;
		
		function set scale(value:Number):void;
		function get scale():Number;
		
		function get parent():IDisplay3DContainer;
		function set parent(value:IDisplay3DContainer):void
			
//		function set absoluteX(value:Number):void;
//		function get absoluteX():Number;
//		
//		function set absoluteY(value:Number):void;
//		function get absoluteY():Number;
//		
//		function set absoluteZ(value:Number):void;
//		function get absoluteZ():Number;
		
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		
		function dispose():void
			
		function removeRender():void;
		
		function reload():void;
	}
}
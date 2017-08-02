package _Pan3D.display3D.interfaces
{
	/**
	 * 3D虚拟点接口 
	 * @see _Pan3D.display3D.Display3DSprite
	 * @see _Pan3D.skill.Skill3DPoint
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public interface IAbsolute3D
	{
		function set rotationY(value:Number):void;
		function get rotationY():Number;
		
		function set absoluteX(value:Number):void;
		function get absoluteX():Number;
		
		function set absoluteY(value:Number):void;
		function get absoluteY():Number;
		
		function set absoluteZ(value:Number):void;
		function get absoluteZ():Number;
	}
}
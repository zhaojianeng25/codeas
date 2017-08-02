package _Pan3D.display3D.interfaces
{
	import flash.geom.Matrix3D;
	/**
	 * 多重绑定接口 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public interface IMultipleBind extends IBind
	{
		function getPosMultipleMatrix(index:int):Vector.<Matrix3D>;
		function getFlag():int;
	}
	
}
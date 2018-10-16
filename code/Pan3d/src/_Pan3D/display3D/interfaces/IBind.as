package _Pan3D.display3D.interfaces
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * 绑定接口，如果需要其他物件绑定到此物件上面，被绑定的物件需实现此接口
	 * @author liuyanfei QQ:421537900
	 * 
	 * 
	 * 
	 */	
	public interface IBind
	{
		function getPosV3d(index:int,outVec:Vector3D):void;
		function getPosMatrix(index:int):Matrix3D;
		function getOffsetPos(v3d:Vector3D,index:int):Vector3D;
		function getRotation():Number;
		function getBindAlpha():Number;
		function getSocket(socketName:String,resultMatrix:Matrix3D):void;
	}
}
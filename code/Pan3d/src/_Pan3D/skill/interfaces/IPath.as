package _Pan3D.skill.interfaces
{
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.display3D.interfaces.IBind;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * 动态路径接口
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public interface IPath extends IBind
	{
		function start():void;
		function update(t:int):void;
		function setInfo(active:IAbsolute3D,target:IAbsolute3D,onComFun:Function=null,$startFun:Function=null):void;
		function reset():void;
		function get num():uint;
		function get baseHeight():int;
	}
}
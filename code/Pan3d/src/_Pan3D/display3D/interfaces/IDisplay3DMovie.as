package _Pan3D.display3D.interfaces
{
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public interface IDisplay3DMovie extends IDisplay3D
	{
		function addMesh(info:String,name:String):void;
		function addAnim(info:String,name:String):void;
		function play(action:String,completeState:int=0):Boolean;
	}
}
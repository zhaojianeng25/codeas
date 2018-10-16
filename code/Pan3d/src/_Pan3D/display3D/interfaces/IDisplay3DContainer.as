package _Pan3D.display3D.interfaces
{
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public interface IDisplay3DContainer extends IDisplay3D
	{
		function addChild(display3D:IDisplay3D):void;
		function removeChild(display3D:IDisplay3D):void;
//		function delChild(display3D:IDisplay3D):void;
		function removeAllChildren():void;
	}
}
package _Pan3D.skill.interfaces
{
	/**
	 * 技能时间轴的关键点接口
	 * 弹道控制类
	 * 技能特效类
	 * @author liuyanfei QQ:421537900
	 * @see _Pan3D.skill.traject.Trajectory
	 */	
	public interface ISkill
	{
		function update(t:int):void;
		function addToRender(t:int):void;
		function setInfo(obj:Object):void;
		function get frame():int;
		function set frame(value:int):void;
		function reset():void;
		function reload():void;
		function set used(value:Boolean):void;
		function get used():Boolean;
		function dispose():void;
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		function stop():void;
	}
}
package _Pan3D.skill.vo
{
	import _Pan3D.display3D.Display3DContainer;

	/**
	 * 关键帧模型数据 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillKeyVo
	{
		/**
		 * 关键帧类型（弹道/效果） 
		 * @see _Pan3D.skill.vo.EnumSkillKeyType
		 */		
		public var type:int;
		/**
		 * 帧数 
		 */		
		public var frame:int;
		
		public function SkillKeyVo()
		{
			
		}
		
		public function dispose():void{
			
		}
	}
}
package _Pan3D.skill.effect
{
	import flash.geom.Vector3D;

	/**
	 * 动态指定目标点 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class EffectDynamicSkill extends EffectSkill
	{
		/**
		 * 目标点 
		 */		
		public var targetV3d:Vector3D;
		
		public function EffectDynamicSkill()
		{
			super();
		}
		
		override public function addToRender(t:int):void{
			super.addToRender(t);
			particle.setPos(targetV3d.x,targetV3d.y,targetV3d.z);
		}
		
		override public function dispose():void{
			super.dispose();
			targetV3d = null;
		}
		
	}
}
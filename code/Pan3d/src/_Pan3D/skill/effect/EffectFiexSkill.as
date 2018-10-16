package _Pan3D.skill.effect
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.particle.ctrl.CombineParticle;

	/**
	 * 固定目标点技能效果类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class EffectFiexSkill extends EffectSkill
	{
		/**
		 * 效果的发起者对象（用于计算起始位置） 
		 */		
		public var active:IAbsolute3D;
		public function EffectFiexSkill()
		{
			super();
		}
		override public function addToRender(t:int):void{
			super.addToRender(t);
			
			var activeBind:IBind = active as IBind;
			
			if(activeBind && data.bindSocket){
				var target:IBind = Object(activeBind).bindTarget;
				if(target){
					particle.bindTarget = target;
				}else{
					particle.bindTarget = activeBind; 
				}
				
				particle.bindSocket = data.socket;
			}else{
				var ma:Matrix3D = new Matrix3D;
				
				ma.appendRotation(active.rotationY,Vector3D.Y_AXIS);
				var v3d:Vector3D = ma.transformVector(data.fiexPoint);
				v3d.x += active.absoluteX;
				v3d.y += active.absoluteY;
				v3d.z += active.absoluteZ;
				
				if(active is Display3DMovie){
					v3d.x += Display3DMovie(active).actionPos.x;
					v3d.y += Display3DMovie(active).actionPos.y;
					v3d.z += Display3DMovie(active).actionPos.z; 
				}
				
				particle.setPos(v3d.x,v3d.y,v3d.z);
				particle.setRotationNum(data.rotationInfo.x,data.rotationInfo.y,data.rotationInfo.z);
				
			}
			
		}
		
		override public function dispose():void{
			super.dispose();
			active = null;
		}
		
	}
}
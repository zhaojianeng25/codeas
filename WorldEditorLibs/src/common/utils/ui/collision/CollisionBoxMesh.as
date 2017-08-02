package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.txt.TextVec3Input;
	
	public class CollisionBoxMesh extends CollisionBaseMesh
	{

		private var _scaleTxt:TextVec3Input;
		public function CollisionBoxMesh()
		{
			super();
			
			_scaleTxt = new TextVec3Input;
			_scaleTxt.label="比例:"
			_scaleTxt.step=0.01
			this.addElement(_scaleTxt)
			_scaleTxt.y=50
			_scaleTxt.x=-20
				
			addEvents();
		
		}
		
		private function addEvents():void
		{

			_scaleTxt.addEventListener(Event.CHANGE,onScaleChange)
			
		}
		
		protected function onScaleChange(event:Event):void
		{
			_collisionVo.scale_x=_scaleTxt.ve3Data.x;
			_collisionVo.scale_y=_scaleTxt.ve3Data.y;
			_collisionVo.scale_z=_scaleTxt.ve3Data.z;
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
			
		}
		
	
		override public function set collisionVo(value:CollisionVo):void
		{
			super.collisionVo=value;
			_scaleTxt.ve3Data=new Vector3D(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_z)
		}
		
	}
}
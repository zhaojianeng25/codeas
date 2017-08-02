package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.frame.BaseComponent;
	import common.utils.ui.txt.TextVec3Input;
	
	public class CollisionBaseMesh extends BaseComponent
	{
		protected var _collisionVo:CollisionVo
		protected var _postionTxt:TextVec3Input;
		protected var _rotatioinTxt:TextVec3Input
		public function CollisionBaseMesh()
		{
			super();
			
			_postionTxt = new TextVec3Input;
			_postionTxt.label="坐标:"
			this.addElement(_postionTxt)
			_postionTxt.y=0
			_postionTxt.x=-20
				
			_rotatioinTxt = new TextVec3Input;
			_rotatioinTxt.label="旋转:"
			this.addElement(_rotatioinTxt)
			_rotatioinTxt.y=25
			_rotatioinTxt.x=-20
				
			addEvents();
			this.height=180
		}
		
		private function addEvents():void
		{
			_postionTxt.addEventListener(Event.CHANGE,onPosionChange)
			_rotatioinTxt.addEventListener(Event.CHANGE,onRoationChange)

		}
		
		protected function onRoationChange(event:Event):void
		{
			_collisionVo.rotationX=_rotatioinTxt.ve3Data.x;
			_collisionVo.rotationY=_rotatioinTxt.ve3Data.y;
			_collisionVo.rotationZ=_rotatioinTxt.ve3Data.z;
			//dispatchEvent(new Event(Event.CHANGE));
			
			
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
			
			
		}
		
		protected function onPosionChange(event:Event):void
		{
			_collisionVo.x=_postionTxt.ve3Data.x;
			_collisionVo.y=_postionTxt.ve3Data.y;
			_collisionVo.z=_postionTxt.ve3Data.z;
			//dispatchEvent(new Event(Event.CHANGE));


			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
	
			
			
		}
		
		public function get collisionVo():CollisionVo
		{
			return _collisionVo;
		}
		override public function refreshViewValue():void{
			if(_collisionVo){
				collisionVo=_collisionVo;
			}
		}

		public function set collisionVo(value:CollisionVo):void
		{
			_collisionVo = value;
			_postionTxt.ve3Data=new Vector3D(_collisionVo.x,_collisionVo.y,_collisionVo.z)
			_rotatioinTxt.ve3Data=new Vector3D(_collisionVo.rotationX,_collisionVo.rotationY,_collisionVo.rotationZ)
		
		}

	}
}
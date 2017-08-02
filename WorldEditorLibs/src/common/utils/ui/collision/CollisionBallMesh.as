package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	
	import _Pan3D.base.CollisionVo;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.txt.TextCtrlInput;
	
	
	public class CollisionBallMesh extends CollisionBaseMesh
	{

		private var _ballRadiusTxt:TextCtrlInput
		public function CollisionBallMesh()
		{
			super();

			_ballRadiusTxt = new TextCtrlInput;
			_ballRadiusTxt.height = 18;
			_ballRadiusTxt.center = true;
			_ballRadiusTxt.label = "半径:"
			_ballRadiusTxt.y=50
			_ballRadiusTxt.x=-20
			this.addChild(_ballRadiusTxt)
			addEvents()
		}
		
		private function addEvents():void
		{
			_ballRadiusTxt.addEventListener(Event.CHANGE,ballRadiusTxtChange)
			
		}
		
		protected function ballRadiusTxtChange(event:Event):void
		{
			_collisionVo.radius=Number(_ballRadiusTxt.text);
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
		}
		
		override public function set collisionVo(value:CollisionVo):void
		{
			super.collisionVo=value;
			
			_ballRadiusTxt.text=String(_collisionVo.radius);
		}
	
		
	}
}
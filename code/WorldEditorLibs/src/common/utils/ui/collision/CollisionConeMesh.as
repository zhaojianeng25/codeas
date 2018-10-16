package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	
	import _Pan3D.base.CollisionVo;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.txt.TextCtrlInput;

	public class CollisionConeMesh extends CollisionBaseMesh
	{
		private var _xcwdith:TextCtrlInput;
		private var _ycHeiht:TextCtrlInput;
		
		public function CollisionConeMesh()
		{
			super();
			
			_xcwdith = new TextCtrlInput;
			_xcwdith.height = 18;
			_xcwdith.center = true;
			_xcwdith.label = "宽度:"
			_xcwdith.y=50
			_xcwdith.x=-20
			_xcwdith.minNum=0.01
			_xcwdith.step=0.01
			
			this.addChild(_xcwdith)
			
			_ycHeiht = new TextCtrlInput;
			_ycHeiht.height = 18;
			_ycHeiht.center = true;
			_ycHeiht.label = "高度:"
			_ycHeiht.y=75
			_ycHeiht.x=-20
			_ycHeiht.minNum=0.01
			_ycHeiht.step=0.01
			this.addChild(_ycHeiht)
			addEvents()
		}
		
		private function addEvents():void
		{
			_xcwdith.addEventListener(Event.CHANGE,TxtChange)
			_ycHeiht.addEventListener(Event.CHANGE,TxtChange)
			
		}
		
		protected function TxtChange(event:Event):void
		{
			_collisionVo.scale_x=Number(_xcwdith.text);
			_collisionVo.scale_z=_collisionVo.scale_x
			
			_collisionVo.scale_y=Number(_ycHeiht.text);
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
		}
		
		override public function set collisionVo(value:CollisionVo):void
		{
			super.collisionVo=value;
			
			_xcwdith.text=String(_collisionVo.scale_x);
			_ycHeiht.text=String(_collisionVo.scale_y);
		}
		
		
	}
}




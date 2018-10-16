package common.msg.event.collision
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.collision.CollisionNode;
	
	public class MEvent_Collision extends ModuleEvent
	{
		//public static var DELE_COLLISION_VO:String = "DELE_COLLISION_VO";
		public static var SELECET_COLLISION_VO:String = "SELECET_COLLISION_VO";
		public static var CHANGE_COLLISION_POSTION:String= "CHANGE_COLLISION_POSTION";
		public static var CHANGE_COLLISION_PYOLYGONMODEL:String= "CHANGE_COLLISION_PYOLYGONMODEL";
		public static var SAVE_COLLISION_TO_OBJS:String= "SAVE_COLLISION_TO_OBJS";
		public static var SHOW_SCENE_COLLISTION:String="SHOW_SCENE_COLLISTION";
		public static var HIDE_SCENE_COLLISTION:String="HIDE_SCENE_COLLISTION";
		
		public var collisionNode:CollisionNode;
		
		public function MEvent_Collision($action:String=null)
		{
			super($action);
		}
	}
}
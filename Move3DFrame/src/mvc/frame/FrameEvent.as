package mvc.frame
{
	import com.zcp.frame.event.ModuleEvent;
	
	import common.utils.ui.file.FileNode;
	
	import mvc.libray.LibrayFildNode;
	
	import proxy.top.model.IModel;
	import mvc.frame.view.FrameFileNode;
	
	public class FrameEvent extends ModuleEvent
	{
		public static const SHOW_FRAME_UI:String = "SHOW_FRAME_UI";
		
		public static const SELECT_FRAME_MODEL:String = "SELECT_FRAME_MODEL";
		public static const DELE_FRAME_MODEL:String = "DELE_FRAME_MODEL";
		
		public static const COPY_FRAME_MODEL:String = "COPY_FRAME_MODEL";
		
		public static const REFRISH_FRAME_LINE_CAVANS:String = "REFRISH_FRAME_LINE_CAVANS";
		
		public static const REFRISH_TREE_DATA:String = "REFRISH_TREE_DATA";
		public static const REFRISH_TREE_NODE_NAME:String = "REFRISH_TREE_NODE_NAME";
		
		public static const OPEN_FRAME_FILE:String = "OPEN_FRAME_FILE";
		
		
		public static var MEVENT_FRAME_NODE_MOVENODE:String = "MEVENT_FRAME_NODE_MOVENODE";
		public var moveNode:FileNode
		public var toNode:FrameFileNode
		
		public var selectItem: Vector.<IModel>
		public var node:FrameFileNode;
		
		public function FrameEvent($action:String=null)
		{
			super($action);
		}
	}
}
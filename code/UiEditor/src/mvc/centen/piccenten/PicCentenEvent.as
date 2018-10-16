package   mvc.centen.piccenten
{
	import com.zcp.frame.event.ModuleEvent;
	
	import vo.H5UIFileNode;
	
	public class PicCentenEvent extends ModuleEvent
	{
		public static const SHOW_CENTEN:String = "SHOWCENTEN";
		public static const READ_UIFILE_DATA:String = "READUIFILEDATA";
		public static const REFRESH_SELECT_FILENODE:String="REFRESH_SELECT_FILENODE";
		public static const DELE_NODE_INFO_VO:String="DELE_NODE_INFO_VO";
		public static const DELE_SELECT_NODE:String="DELE_SELECT_NODE";
		
		
		//public static const OPEN_H5UI_PROJECT_FILE:String="OPEN_H5UI_PROJECT_FILE";
		public static const SAVE_H5UI_PROJECT_FILE:String="SAVE_H5UI_PROJECT_FILE";
		
		public static const SHOW_PIC_MESH:String="SHOW_PIC_MESH";
		
		

		
		public var h5UIFileNode:H5UIFileNode
		//public var url:String
		
		public var saveH5UIchangeFile:Boolean  
		
		

		

		
		public function PicCentenEvent($action:String=null)
		{
			super($action);
		}
	}
}
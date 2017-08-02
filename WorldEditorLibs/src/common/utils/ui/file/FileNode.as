package common.utils.ui.file
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class FileNode  extends EventDispatcher
	{
		public var id:uint
		public var name:String;
		public var path:String;
		public var url:String;
		public var extension:String;
		public  var children:ArrayCollection;
		public var rename:Boolean;
		public var parentNode:FileNode;
		public var data:Object
		public static var FILE_NODE:String = "fileNode"
		public function FileNode()
		{
		}
	}
}
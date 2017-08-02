package modules.brower.fileWin
{
	import flash.filesystem.File;
	
	import common.utils.ui.file.FileNode;
	
	public class FileWinData extends FileNode
	{
		public var file:File;

		public static var CSV:uint=0
		public static var US:uint=1
		public function FileWinData()
		{
			super();
		}
	}
}
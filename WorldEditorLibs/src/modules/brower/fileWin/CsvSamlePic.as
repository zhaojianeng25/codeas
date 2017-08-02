package modules.brower.fileWin
{
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.managers.DragManager;
	
	import common.utils.ui.file.FileNode;
	
	import interfaces.ITile;

	public class CsvSamlePic extends FolderSamplePic
	{
		public function CsvSamlePic()
		{
			super();
		}
		override protected function onMouseDown(event:MouseEvent):void
		{
			var dsragSource:DragSource = new DragSource();
			var node:FileNode =new FileNode
			if(_fileData.data as ITile ){
				node.data=_fileData.data
				dsragSource.addData(node, FileNode.FILE_NODE);
				DragManager.doDrag(this, dsragSource, event);
			}
			InFolderModelSprite(this.parent).mouseClik(this)
		}
	}
}
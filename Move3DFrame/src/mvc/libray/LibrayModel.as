package mvc.libray
{
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	
	import modules.scene.sceneSave.FilePathManager;

	public class LibrayModel
	{
		private static var instance:LibrayModel;
		public function LibrayModel()
		{
			this.librayArr=new ArrayCollection;
			this.initData()
		}
		public static function getInstance():LibrayModel{
			if(!instance){
				instance = new LibrayModel();
			}
			return instance;
		}
		public var librayTree:Tree;
		public var librayArr:ArrayCollection;
		public function initData():void
		{
			for(var i:Number=0;i<2;i++){
				var $tempA:LibrayFildNode = new LibrayFildNode;
				$tempA.type=LibrayFildNode.Folder_TYPE0
				$tempA.name = "id"+i;
				this.librayArr.addItem($tempA);
			}
		}
		public function initObj($arr:Array):void
		{
			while(	this.librayArr.length){
				this.librayArr.removeItemAt(0)
			}
			for(var i:Number=0;$arr&&i<$arr.length;i++){
				var $node:LibrayFildNode=new LibrayFildNode()
				$node.writeObject($arr[i])
				this.librayArr.addItem($node);
			}
		
		}
		public function getLibObject():Array
		{
		
				return 	this.wirteItem(this.librayArr);
		
		}
		
		private function wirteItem(childItem:ArrayCollection):Array
		{
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $FrameFileNode:LibrayFildNode=childItem[i] as LibrayFildNode
				$item.push($FrameFileNode.getObject())
			}
			if($item.length){
				return $item
			}
			return null
		}
		public function addfolder():void
		{
			var $tempA:LibrayFildNode = new LibrayFildNode;
			$tempA.type=LibrayFildNode.Folder_TYPE0
			$tempA.name = "新文件夹"
			this.librayArr.addItem($tempA);
		}
		public function addFiles():void
		{
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("Move3Dprefab"))
			var txtFilter:FileFilter = new FileFilter("Text", "*.prefab;*.lyf;*.zzw;");
			$file.browseForOpenMultiple("打开工程文件 ",[txtFilter]);
			$file.addEventListener(FileListEvent.SELECT_MULTIPLE, filesSelected);

		}
		protected function filesSelected(event:FileListEvent):void
		{
			for (var i:uint = 0; i < event.files.length; i++) {
				var $file:File=event.files[i]
				var $tempA:LibrayFildNode = new LibrayFildNode;
				$tempA.type=LibrayFildNode.Pefrab_TYPE1;
				var $kname:String=$file.name
				$kname=$kname.replace(".prefab","");
				$kname=$kname.replace(".lyf","");
				$kname=$kname.replace(".zzw","");
				$tempA.name =$kname
				$tempA.url=$file.url;
				this.librayArr.addItem($tempA);
			}
			
		}
	}
}
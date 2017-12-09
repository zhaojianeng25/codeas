package mvc.libray
{
	import mx.collections.ArrayCollection;
	
	import common.utils.ui.file.FileNode;
	
	public class LibrayFildNode extends FileNode
	{
		
		public static var Folder_TYPE0:Number=0;
		public static var Pefrab_TYPE1:Number=1;
		public var type:Number=0   //0为文件夹
		public function LibrayFildNode()
		{
			super();
		}
		
		public function getObject():Object{
			
			var $obj:Object=new Object;
			$obj.id=this.id;
			$obj.name=this.name;
			$obj.type=this.type;
			$obj.url=this.url;

			$obj.children=wirteItem(this.children);
			
	
			
			return $obj
		}
		private function wirteItem(childItem:ArrayCollection):Array
		{
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $FrameFileNode:LibrayFildNode=childItem[i] as LibrayFildNode
				var $obj:Object=$FrameFileNode.getObject()
				$item.push($obj)
			}
			if($item.length){
				return $item
			}
			return null
		}
		
		public function writeObject($obj:Object):void
		{
			
			this.id=$obj.id;
			this.name=$obj.name;
			this.type=$obj.type;
			this.url=$obj.url;
			
			if(this.type==LibrayFildNode.Folder_TYPE0){
				this.children=new ArrayCollection()
				for(var i:Number=0;$obj.children&&i<$obj.children.length;i++){
					var $node:LibrayFildNode=new LibrayFildNode()
					$node.writeObject($obj.children[i])
					$node.parentNode=this
					this.children.addItem($node)
				}	
			}
			
		}
	}
}
package mvc.left
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	
	import common.utils.frame.BasePanel;
	
	import modules.brower.fileWin.BrowerManage;
	import mvc.libray.LibraryFildNode;
	import mvc.libray.LibraryItemRender;
	
	public class DisLeftPanel extends BasePanel
	{
		private var _bg:UIComponent;
		private var _tree:Tree;

		public function DisLeftPanel()
		{
			super();
			this.addList()	;
			this.initDataList();
			
	
			this._libTree.dataProvider =this.librayArrayCollection;
		}
		private var librayArrayCollection:ArrayCollection
		private function initDataList():void
		{
			this.librayArrayCollection=new ArrayCollection;
			for(var i:Number=0;i<10;i++){
				var $tempA:LibraryFildNode = new LibraryFildNode;
				$tempA.type=0
				$tempA.name = "id"+i;
				this.librayArrayCollection.addItem($tempA);
		
			}
		}
		private var _libTree:Tree
		private function addList():void
		{
			var _tree:Tree = new Tree;
			_tree.setStyle("top",150);
			_tree.setStyle("bottom",5);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			
			//_tree.horizontalScrollPolicy = "off";
			//_tree.verticalScrollPolicy = "on";
			trace(_tree.horizontalScrollPolicy)
			trace(_tree.verticalScrollPolicy)
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(LibraryItemRender);
			_tree.iconFunction = tree_iconFunc;
			this._libTree=_tree
			
		}
		private function tree_iconFunc(item:LibraryFildNode):Class {  
			
			if(item.type==0){
				return BrowerManage.getIconClassByName("icon_FolderOpen_dark");
			}else{
				return BrowerManage.getIconClassByName("table_16");
			}
		}  

		override public function onSize(event:Event= null):void
		{
		
		}

		
		protected function addToStage(event:Event):void
		{

		}



	}
}
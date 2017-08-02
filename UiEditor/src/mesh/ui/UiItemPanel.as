package mesh.ui
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TextInput;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	
	import common.utils.frame.BasePanel;
	
	import vo.H5UIFileNode;
	
	public class UiItemPanel extends BasePanel
	{
		public var bFun:Function;
		private var _bg:UIComponent;
		private var _shape:UIComponent;
		private var _tree:Tree;

		public function UiItemPanel()
		{
			super();
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			addBack()
			addList();
			addSearch()
			addEvents()
			resetInfoArr()
		
		}
		private var _searchTxt:TextInput
		private function addSearch():void
		{
			_searchTxt=new TextInput
			_searchTxt.height=22
			_searchTxt.y=25
			_searchTxt.x=25
			
			_searchTxt.setStyle("contentBackgroundColor",0x404040);
			_searchTxt.setStyle("borderVisible",true);
			_searchTxt.setStyle("fontSize",11);
			_searchTxt.setStyle("fontFamily","Microsoft Yahei");
			_searchTxt.setStyle("color",0x9c9c9c);
			
			this.addChild(_searchTxt)

			_searchTxt.addEventListener(Event.CHANGE,onSecarchTextChange)
		}

		protected function onSecarchTextChange(event:Event):void
		{
			this.resetInfoArr()
		}
		
	
		private function addList():void
		{
			_tree = new Tree;

			_tree.setStyle("top",50);
			_tree.setStyle("bottom",0);
			_tree.setStyle("left",0);
			_tree.setStyle("right",0);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(NodeUiTreeItemRenderer);
			_tree.focusEnabled = false;
			_tree.iconFunction = tree_iconFunc;
			this.addChild(_tree);
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
		}
		private function tree_iconFunc(item:H5UIFileNode):Class {  
	
			return null;
	
		}
		protected function onItemClik(event:ListEvent):void
		{
			if(event.itemRenderer){
				var $H5UIFileNode:H5UIFileNode= event.itemRenderer.data as H5UIFileNode	;
				bFun($H5UIFileNode.name)
				
			}
		}
		public  function resetInfoArr():void
		{
			var findTxt:String=""
			if(_searchTxt.text.length>0){
				findTxt=_searchTxt.text.toUpperCase()	
			}
			if(findTxt.length){
				var fileITEM:ArrayCollection=new ArrayCollection
				for(var i:Number=0;i<UiData.nodeItem.length;i++)
				{
					 var $name:String=(UiData.nodeItem[i].name);
					 $name=$name.toUpperCase();
					 if($name.search(findTxt)!=-1){
						 fileITEM.addItem(UiData.nodeItem[i])
					 }
				}
				_tree.dataProvider =fileITEM;
			
			}else{
				_tree.dataProvider = UiData.nodeItem;
			}
			_tree.invalidateList();
			_tree.validateNow();
		}
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);

		}
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
			_shape = new UIComponent;
			this.addChild(_shape);
			
		}
		
		protected function onStage(event:Event):void
		{
			drawback();
		}
		
		private function drawback():void{
			_shape.graphics.clear();
			_shape.graphics.beginFill(0x303030,1);
			_shape.graphics.lineStyle(1,0x151515);
			
			_shape.graphics.drawRect(0,0,this.width,20);
			_shape.graphics.endFill();
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
	
		}
		
	}
}
package mvc.left.panelleft
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	import _me.Scene_data;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	
	import modules.hierarchy.HierarchyFileNode;
	
	import mvc.centen.panelcenten.PanelCentenEvent;
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	import vo.ListTreeItemRenderer;
	
	public class PanelLeftPanel extends BasePanel
	{
		private var _bg:UIComponent;
		private var _tree:Tree;
		
		private var _panelInfoTree:Tree
		private var _menuFile:NativeMenu;
		
		
		public function PanelLeftPanel()
		{
			super();
			addList();
			addInfoList()
			initMenuFile()
			addEvents();
		}
		protected function onRightClick(event:MouseEvent):void
		{
			if(event.target as ListBaseContentHolder){
				_menuFile.display(Scene_data.stage,Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			}
		

		}
		public function initMenuFile():void{
			
			
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;

			item = new NativeMenuItem("添加面板")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addNewNode);
			


			
		}
		
		protected function addNewNode(event:Event):void
		{
			PanelModel.getInstance().addNewPanelVo()
			resetInfoArr()
			
		}	

		public function set selectRectInfoItem(value:Vector.<PanelSkillMaskNode>):void
		{
			
			
			var tempItem:Array=new Array
			for(var i:uint=0;value&&i<value.length;i++){
				tempItem.push(value[i])
			}
			_panelInfoTree.selectedItems=tempItem;

			
		}
		

		private function addInfoList():void
		{
			_panelInfoTree = new Tree;
			_panelInfoTree.setStyle("top",300);
			_panelInfoTree.setStyle("bottom",0);
			_panelInfoTree.setStyle("left",0);
			_panelInfoTree.setStyle("right",0);
			_panelInfoTree.setStyle("contentBackgroundColor",0x505050);
			_panelInfoTree.setStyle("color",0x9f9f9f);
			_panelInfoTree.labelField="name";
			_panelInfoTree.itemRenderer = new ClassFactory(PanelInfoItemRender);
			_panelInfoTree.focusEnabled = false;
			this.addChild(_panelInfoTree);
		}
		
		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",0);
			_tree.setStyle("bottom",300);
			_tree.setStyle("left",0);
			_tree.setStyle("right",0);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(PanelListItemRenderer);
			_tree.focusEnabled = false;
			this.addChild(_tree);
			
		}
		
		override public function onSize(event:Event= null):void
		{
			if(this.height>30){
				_tree.setStyle("bottom",this.height/2+5);
				_panelInfoTree.setStyle("top",this.height/2);
			}
		
		}
		
		private function addEvents():void
		{
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			_tree.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			_panelInfoTree.addEventListener(ListEvent.ITEM_CLICK,panelInfoTreeClik);
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage)
		}
		
		protected function addToStage(event:Event):void
		{
	
			//ModuleEventManager.dispatchEvent( new PanelLeftEvent(PanelLeftEvent.SHOW_LEFT));
				
			var $PanelNodeVo:PanelNodeVo=_tree.selectedItem as PanelNodeVo;
			if($PanelNodeVo){
				var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
				$PanelLeftEvent.panelNodeVo=$PanelNodeVo;
				ModuleEventManager.dispatchEvent($PanelLeftEvent);
			}
			
	
		}
		
		protected function panelInfoTreeClik(event:ListEvent):void
		{
			if(event.itemRenderer){
			 	var $PanelRectInfoNode:PanelSkillMaskNode=event.itemRenderer.data as PanelSkillMaskNode	;
		
				var $CentenEvent:PanelCentenEvent=new PanelCentenEvent(PanelCentenEvent.SELECT_PANEL_INFO_NODE)
				$CentenEvent.panelRectInfoNode=$PanelRectInfoNode;
				$CentenEvent.ctrlKey=true
				ModuleEventManager.dispatchEvent($CentenEvent);
			}
			
		}
		public  function resetInfoArr():void
		{
			_tree.dataProvider =PanelModel.getInstance().item;
			_tree.invalidateList();
			_tree.validateNow();
			_tree.selectedIndex=0;
		}
		public function refreshView():void
		{
			_tree.invalidateList();
			_tree.validateNow();
			_panelInfoTree.invalidateList();
			_panelInfoTree.validateNow();
		}
	
		
		protected function onItemClik(event:ListEvent):void
		{
			if(event.itemRenderer){

				var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
				$PanelLeftEvent.panelNodeVo=event.itemRenderer.data as PanelNodeVo	;
				ModuleEventManager.dispatchEvent($PanelLeftEvent);
				
				_panelInfoTree.dataProvider =$PanelLeftEvent.panelNodeVo.item
				_panelInfoTree.invalidateList();
				_panelInfoTree.validateNow();
				
			}
			
		}
		

	}
}



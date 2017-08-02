package mvc.left.disleft
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	import common.utils.frame.BasePanel;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.scene.UiSceneEvent;
	
	import vo.H5UIFileNode;
	import vo.ListTreeItemRenderer;
	
	public class DisLeftPanel extends BasePanel
	{
		private var _bg:UIComponent;
		private var _tree:Tree;

		public function DisLeftPanel()
		{
			super();
			addList();

			addEvents();
			
		}
		

		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",0);
			_tree.setStyle("bottom",0);
			_tree.setStyle("left",0);
			_tree.setStyle("right",0);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(ListTreeItemRenderer);
			_tree.focusEnabled = false;
			this.addChild(_tree);
			
		}
		
		override public function onSize(event:Event= null):void
		{
		
		}
		private function addEvents():void
		{
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage)
		}
		
		protected function addToStage(event:Event):void
		{
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.SHOW_UI_SCENE));
			ModuleEventManager.dispatchEvent( new DisCentenEvent(DisCentenEvent.SHOW_CENTEN));
			UiData.selectArr=new Vector.<H5UIFileNode>
			ModuleEventManager.dispatchEvent(new DisCentenEvent(DisCentenEvent.REFRESH_SELECT_FILENODE));
			
		}
		protected function onItemClik(event:ListEvent):void
		{
			if(event.itemRenderer){
				var $H5UIFileNode:H5UIFileNode= event.itemRenderer.data as H5UIFileNode	;
			
				var $CentenEvent:UiSceneEvent=new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE)
				$CentenEvent.h5UIFileNode=$H5UIFileNode;
				$CentenEvent.ctrlKey=true
				ModuleEventManager.dispatchEvent($CentenEvent);

			}
			
		}
		public  function resetInfoArr():void
		{
			_tree.dataProvider = UiData.nodeItem;
			_tree.invalidateList();
			_tree.validateNow();
		}
		
		public function refreshSelect():void
		{
			var tempItem:Array=new Array
			for(var k:uint=0;UiData.selectArr&&k<UiData.selectArr.length;k++){
				tempItem.push(UiData.selectArr[k])
			}
			_tree.selectedItems=tempItem;
	
			
		}
	}
}
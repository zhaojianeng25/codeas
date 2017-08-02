package common.utils.ui.prefab
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.utils.getDefinitionByName;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import common.utils.ui.file.FileNode;
	import common.utils.ui.txt.TextCtrlInput;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	public class CaptureIdUi extends TextCtrlInput
	{

		public function CaptureIdUi()
		{
			super();
			addEvents();
		}
		protected var extensinonItem:Array;
		public function set extensinonStr(value:String):void
		{
			extensinonItem=value.split("|")
		}
		private function addEvents():void
		{
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
			
		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFile($fileNode)){

				var rnum:uint = $fileNode.id
				this.text = String(rnum);
				this.dispatchEvent(new TextEvent(Event.CHANGE));
				if(FunKey && target){
					target[FunKey] = text;
				}
				if(Boolean(changFun)){
					changFun(text);
				}
				this.dispatchEvent(new TextEvent(Event.CHANGE));
				
				
			}
			
		}
		
		override protected function onStageMouseMove(event:MouseEvent):void
		{
		
		}
		
		private function canInPutFile($fileNode:FileNode):Boolean
		{
			
			if($fileNode as HierarchyFileNode){
				//if(HierarchyFileNode($fileNode).type==HierarchyNodeType.Capture){
					
					for(var i:uint=0;i<extensinonItem.length;i++)
					{
						var $str:String=extensinonItem[i]
						var $cla:Class = getDefinitionByName($str) as Class;
						if($fileNode.data is $cla ){
							return true
						}
					}
			}
			return false;
		}
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFile($fileNode)){
				
				var ui:UIComponent = event.target as UIComponent;
				
				DragManager.acceptDragDrop(ui);
			}
		}
	}
}
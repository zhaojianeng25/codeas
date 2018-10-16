package  vo
{
	
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.events.FlexEvent;
	
	import spark.components.TextInput;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.scene.UiSceneEvent;
	



	public class ListTreeItemRenderer extends TreeItemRenderer
	{
		private var _txt:TextInput;	

		public function ListTreeItemRenderer()
		{
			super();
			addEvents();
			initMenuFile()
		}
	
		private function addEvents():void
		{

			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			
			this.addEventListener(FlexEvent.DATA_CHANGE,dataChange)
			
		}
		protected function dataChange(event:FlexEvent):void
		{
			var $selfNode:H5UIFileNode = this.data as H5UIFileNode;
			if($selfNode){
				
		
		
			}


		
			
		}


		
		
	


		
		private function SetLab(value:TreeListData):void{
			if(!value){
				return;
			}
			var node:H5UIFileNode = value.item as H5UIFileNode;
			if(node.rename){
				if(!_txt){
					_txt = new TextInput;
					
				}
				_txt.width = this.label.width;
				_txt.height = this.label.height;
				_txt.x = this.label.x;
				_txt.y = this.label.y;
				this.addChild(_txt);
				
				_txt.text = node.name.split(".")[0];
				_txt.addEventListener(FlexEvent.ENTER,onSureTxt);
				_txt.addEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
			
			}else{
				if(_txt && _txt.parent){
					_txt.parent.removeChild(_txt);
				}
				if(_txt){
					_txt.removeEventListener(FlexEvent.ENTER,onSureTxt);
					_txt.removeEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
				}
			}
		}
		
		protected function onSureTxt(event:Event):void
		{
			_txt.removeEventListener(FlexEvent.ENTER,onSureTxt);
			_txt.removeEventListener(FocusEvent.FOCUS_OUT,onSureTxt);
			var $selfNode:H5UIFileNode = this.data as H5UIFileNode;
			
			if($selfNode&&_txt.text.length>0){
				$selfNode.name=_txt.text
				$selfNode.rename=false
				BindingUtils.bindSetter(SetLab,this,"listData");
				this.label.text=$selfNode.name
		
			}
	

		
		}
		
		
		
		protected function onRightClick(event:MouseEvent):void
		{
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{
			

			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("重命名")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onRename);
			
			item = new NativeMenuItem("删除")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onDele);
			

			
		}
		
		protected function onDele(event:Event):void
		{
			var $selfNode:H5UIFileNode = this.data as H5UIFileNode;
			if($selfNode){
			//	ListPanel(this.parent.parent.parent).deleFileNode($selfNode)
				
				var $CentenEvent:DisCentenEvent=new DisCentenEvent(DisCentenEvent.DELE_NODE_INFO_VO)
				$CentenEvent.h5UIFileNode=$selfNode;

				ModuleEventManager.dispatchEvent( $CentenEvent);
			}
			
		}

		protected function onRename(event:Event):void
		{
			var $selfNode:H5UIFileNode = this.data as H5UIFileNode;
			if($selfNode){
				$selfNode.rename=true
				BindingUtils.bindSetter(SetLab,this,"listData");
			}
		}

	}
}




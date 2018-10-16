package mesh.ui
{
	import flash.display.BitmapData;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.TextInput;
	
	import common.utils.ui.prefab.PicBut;
	
	import vo.H5UIFileNode;
	
	public class NodeUiTreeItemRenderer extends TreeItemRenderer
	{
		protected var _labelTxt:Label;	
		protected var _iconBmp:PicBut;
		
		public function NodeUiTreeItemRenderer()
		{
			super();
			this.height=50
				
			_iconBmp=new PicBut
			_iconBmp.x=10
			this.addChild(_iconBmp)
				
				
			_labelTxt=new  Label
			this.addChild(_labelTxt)
			_labelTxt.x=70
			_labelTxt.y=20
			_labelTxt.width=150;
			_labelTxt.height=20;
			addEvents();

		}
		
		private function addEvents():void
		{

			this.addEventListener(FlexEvent.DATA_CHANGE,dataChange)
			
		}
		
		protected function dataChange(event:FlexEvent):void
		{
			var $selfNode:H5UIFileNode = this.data as H5UIFileNode;
			if($selfNode){
				var bmp:BitmapData=UiData.getUIBitmapDataByName($selfNode.name)
				if(bmp){
					_iconBmp.setBitmapdata(bmp,48,48)
				}
				_labelTxt.text=$selfNode.name

			}

			
		}	
		
		
		
		
		
		
		
		
		

		
	}
}





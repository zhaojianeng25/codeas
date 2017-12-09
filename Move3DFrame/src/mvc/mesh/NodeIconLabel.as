package  mvc.mesh
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.TextInput;
	
	import _me.Scene_data;
	
	import mvc.frame.FrameEvent;
	
	public class NodeIconLabel extends UIComponent
	{
		private var _iconBitmap:Bitmap;
		private var _txtLabel:Label;
		private var _target:Object
		private var _nodeNameTxt:TextInput;

		public function NodeIconLabel()
		{
			super();
			
			_iconBitmap = new Bitmap;
			_iconBitmap.smoothing = true;
			_iconBitmap.x = 10;
			this.addChild(_iconBitmap);
			
			
			
			_txtLabel = new Label;
			_txtLabel.setStyle("color",0x9f9f9f);
			_txtLabel.setStyle("paddingTop",4);
			_txtLabel.width = 50;
			_txtLabel.height = 20;
			_txtLabel.x =20;
			_txtLabel.text = "名字";
			this.addChild(_txtLabel);
			
			
			_nodeNameTxt = new TextInput;
			_nodeNameTxt.setStyle("contentBackgroundColor",0x404040);
			_nodeNameTxt.setStyle("borderVisible",true);
			_nodeNameTxt.setStyle("fontSize",11);
			_nodeNameTxt.setStyle("fontFamily","Microsoft Yahei");
			_nodeNameTxt.setStyle("color",0x9c9c9c);
			_nodeNameTxt.x=50
			_nodeNameTxt.width=130
			_nodeNameTxt.height=22
			this.addChild(_nodeNameTxt);
			
			_nodeNameTxt.addEventListener(FlexEvent.ENTER,onSureTxt);
	
		}
		
		protected function onSureTxt(event:FlexEvent):void
		{
			var newStr:String=_nodeNameTxt.text
			if(FrameNodeMesh(_target)){
				FrameNodeMesh(_target).frameFileNode.name=newStr;
				ModuleEventManager.dispatchEvent( new FrameEvent(FrameEvent.REFRISH_TREE_DATA));
			}
		}


		public function set target(value:Object):void
		{
			_target=value
	
		}
		
	
		public function set icon(bmp:BitmapData):void{
			_iconBitmap.bitmapData = bmp;
			_iconBitmap.scaleX = 36/bmp.width;
			_iconBitmap.scaleY = 36/bmp.height;
		}
		public function set label(value:String):void{
			
			_nodeNameTxt.text = value;

		}
	
		
		
	}

}
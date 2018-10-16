package mvc.scene
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.geom.Point;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.cbox.ComLabelBox;
	import common.utils.ui.color.ColorPickers;
	import common.utils.ui.txt.TextCtrlInput;
	
	public class UiScenePanel extends BasePanel
	{
		private var _colorPickers:ColorPickers;
		private var _xTxt:TextCtrlInput;
		private var _yTxt:TextCtrlInput;
		

		public function UiScenePanel()
		{
			super();
			addColor();
			addTexts();
			
			
			//var obj:Object={name:"64",type:0},{name:"128",type:1},{name:"256",type:2},{name:"512",type:3},{name:"1024",type:4}
			_sceneRectW=getComboxComponent("宽:","sizeW")
			_sceneRectW.y=60
			_sceneRectW.x=0
			this.addChild(_sceneRectW)
				
			_sceneRectH=getComboxComponent("宽:","sizeH")
			_sceneRectH.y=60
			_sceneRectH.x=80
			this.addChild(_sceneRectH)
			
		}

		private var _sceneRectW:ComLabelBox;
		private var _sceneRectH:ComLabelBox;

		public function get sizeW():Number
		{
			return UiData.sceneBmpRec.width;
		}
		
		public function set sizeW(value:Number):void
		{
			UiData.sceneBmpRec.width = value;
			changeUiSceneData()
		}
		public function get sizeH():Number
		{
			return UiData.sceneBmpRec.height;
		}
		
		public function set sizeH(value:Number):void
		{
			UiData.sceneBmpRec.height = value;
			changeUiSceneData()
		}

		public function getComboxComponent($label:String,$funkeyStr:String):ComLabelBox{
			var cb:ComLabelBox = new ComLabelBox;
			cb.label = $label
			cb.width = 100;
			cb.height = 18;
			cb.labelData = [{name:"64",data:64},{name:"128",data:128},{name:"256",data:256},{name:"512",data:512},{name:"1024",data:1024},{name:"2048",data:2048}]
			cb.FunKey=$funkeyStr
			cb.target=this;
			return cb;
		}
		
		private function addTexts():void
		{
			var bpos:Point=new Point(0,10)
			
			_xTxt = new TextCtrlInput;
			_xTxt.height = 18;
			_xTxt.width=100;
			_xTxt.center = true;
			_xTxt.label = "x:"
			_xTxt.y=20+bpos.y
			_xTxt.x=0+bpos.x
			_xTxt.FunKey="xData"
			_xTxt.target=this;
			
			this.addChild(_xTxt)
			
			
			_yTxt = new TextCtrlInput;
			_yTxt.height = 18;
			_yTxt.width=100;
			_yTxt.center = true;
			_yTxt.label = "y:"
			_yTxt.y=20+bpos.y
			_yTxt.x=80+bpos.x
			
			_yTxt.FunKey="yData"
			_yTxt.target=this;
			
			this.addChild(_yTxt)
			
			
			
			
			
		}
		
		public function set xData(value:String):void
		{
	
		}
		public function get xData():String
		{
			
				return  "0"
			
		}
		public function set yData(value:String):void
		{
			
		
		}
		public function get yData():String
		{
		
				return  "0"
			
			
		}

		private function changeUiSceneData():void
		{
			ModuleEventManager.dispatchEvent(new UiSceneEvent(UiSceneEvent.CHANGE_SCENE_COLOR));
			
		}
	
		private function addColor():void
		{
			_colorPickers = new ColorPickers;
		
			_colorPickers.label ="颜色"
			_colorPickers.width = 200
			_colorPickers.height = 18;
			
			_colorPickers.getFun =getColor;
			_colorPickers.changFun = setColor;

	
			
			this.addChild(_colorPickers)
			
		}
		private function setColor(value:uint):void
		{
			UiData.sceneColor=value;
			
			changeUiSceneData()
		}
		private function getColor():uint
		{
			if(!UiData.sceneColor){
				UiData.sceneColor=0x00ffffff
			}
			return UiData.sceneColor;
		}
		
		public function refreshSceneData():void
		{
			this.refreshViewValue()
		}
		public function refreshViewValue():void
		{
			_xTxt.refreshViewValue()
			_yTxt.refreshViewValue()

			_colorPickers.refreshViewValue();
			
			_sceneRectW.refreshViewValue()
			_sceneRectH.refreshViewValue()
		
		}
	}
}
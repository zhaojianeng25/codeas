

package  mvc.charview
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.AIREvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.cbox.ComLabelBox;
	
	import modules.hierarchy.FileSaveModel;
	
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.line.FrameLinePointVo;
	
	import proxy.pan3d.roles.ProxyPan3DRole;
	
	public class ChangeCharActionPanel extends BasePanel
	{	
		
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _tittleA:Label;
		
		public static function getInstance():ChangeCharActionPanel{
			if(!instance){
				var instance:ChangeCharActionPanel = new ChangeCharActionPanel();
			}
			return instance;
		}
		public function ChangeCharActionPanel()
		{
			super();
			this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			addBack();
			addQualityComboBox()
			addEvents();
		}
		private  var _win:Window;


		private  function winEnterFun(value:Object):void
		{
			if(_win){
				if(!_win.closed){
					_win.close()
				}
				_win=null
			}
	
		}
		private var selectFrameFileNode:FrameFileNode
		private var selectframeLinePointVo:FrameLinePointVo
		public  function initExpPanel($node:FrameFileNode,$frameLinePointVo:FrameLinePointVo):void
		{
		
			this.selectframeLinePointVo=$frameLinePointVo
			this.selectFrameFileNode=$node
			if(_win&&!_win.closed){
				_win.close()
			}
			//_changeCharActionPanel=new ChangeCharActionPanel
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 300;
			$win.height= 200;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			
			
			this.setStyle("left",0);
			this.setStyle("right",0);
			this.setStyle("top",0);
			this.setStyle("bottom",0);
			
			$win.addElement(this);
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)
			
			
			$win.open(true);
			_win=$win;
			_win.visible=false;

			
		}
		
		private  function windowComplete(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			this.initData()
			
		}
		

		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
		}

		private var qualityComboBox:ComLabelBox
		public function addQualityComboBox():void
		{
			this.qualityComboBox = new ComLabelBox;
			this.qualityComboBox.label = "选择动作 "
			this.qualityComboBox.width = 200;
			this.qualityComboBox.x=5
			this.qualityComboBox.y=5
			this.qualityComboBox.height = 18;
			this.qualityComboBox.changFun=changeQualityeComboBox
			this.addChild(this.qualityComboBox)
			
			qualityComboBox.selectIndex=1;
			FileSaveModel.expPicQualityType=75;
			
		}
		private function changeQualityeComboBox(value:Object):void
		{
			FileSaveModel.expPicQualityType=value.type;
			trace(FileSaveModel.expPicQualityType)
			
			this.selectframeLinePointVo.data.action=value.name
		}


		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
		}
		protected function onStage(event:Event):void
		{
			changeSize()
		}
		private function drawback():void{
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x282828,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();

			var $w:uint=Math.max(300,this.width)
			var $h:uint=Math.max(300,this.height)

		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		public function initData():void
		{
			 var $animNameList:Array=	ProxyPan3DRole(this.selectFrameFileNode.iModel).sprite.getAnimNameList()
			 var  $selectName:String
			 if(!this.selectframeLinePointVo.data){
				 this.selectframeLinePointVo.data=new Object;
			 }
			 if(this.selectframeLinePointVo.data.action){
				 $selectName=this.selectframeLinePointVo.data.action
			 }
			 var  $listarr:Array=new Array();
			for(var i:Number=0;i<$animNameList.length;i++){
				$listarr.push({name:$animNameList[i],type:i});
			}
			 qualityComboBox.data =$listarr;
			 qualityComboBox.selectItem=$selectName;

		}
	}
}







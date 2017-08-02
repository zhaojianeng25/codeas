package modules.sceneConfig
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.TextInput;
	
	import common.AppData;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.tab.TabButton;
	
	import modules.brower.fileTip.RadiostiyInfoEndBut;
	
	public class SceneConfigPanel extends BasePanel
	{	
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _socketUrlTxt:TextInput;
		private var _btnEnd:RadiostiyInfoEndBut;
		private var _workSpaceTittle:Label;
		private var _workSpaceUrl:Label;
		private var _expSpaceUrl:Label;
	



		

		
		
		public function SceneConfigPanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			addBack();
			addButs()
			addWorkSpace()
			addExpSpace()
			addInputTxt();
			addEvents();
			
		}
		private function addWorkSpace():void
		{
			
			_workSpaceTittle=new Label
			_workSpaceTittle.x=10
			_workSpaceTittle.y=70
			_workSpaceTittle.text="C++渲染地址";
			_workSpaceTittle.width=200
			_workSpaceTittle.height=20
			_workSpaceTittle.setStyle("color",0x9f9f9f);
			_workSpaceTittle.setStyle("size",14);
			this.addChild(_workSpaceTittle)

			_workSpaceUrl=new Label
			_workSpaceUrl.x=10
			_workSpaceUrl.y=20
			_workSpaceUrl.text="";
			_workSpaceUrl.width=300
			_workSpaceUrl.height=20
			_workSpaceUrl.setStyle("color",0x9f9f9f);
			_workSpaceUrl.setStyle("size",14);
			this.addChild(_workSpaceUrl)

		}
		
		
		private function addExpSpace():void
		{

			
			_expSpaceUrl=new Label
			_expSpaceUrl.x=10
			_expSpaceUrl.y=45
			_expSpaceUrl.text="";
			_expSpaceUrl.width=450
			_expSpaceUrl.height=20
			_expSpaceUrl.setStyle("color",0x9f9f9f);
			_expSpaceUrl.setStyle("size",14);
			this.addChild(_expSpaceUrl)
			
		}

		private function addButs():void
		{
			_btnEnd = new RadiostiyInfoEndBut;
			_btnEnd.label = "修改完成"
			_btnEnd.height = 30;
			_btnEnd.width = 130;
			_btnEnd.x=0
			_btnEnd.y=0
			this.addChild(_btnEnd)
			_btnEnd.refreshViewValue();
			
			
		}
		private function addInputTxt():void
		{
			_socketUrlTxt = new TextInput;
			_socketUrlTxt.setStyle("contentBackgroundColor",0x404040);
			_socketUrlTxt.setStyle("borderVisible",true);
			_socketUrlTxt.setStyle("color",0x9f9f9f);
			_socketUrlTxt.setStyle("paddingTop",4);
			_socketUrlTxt.x=10
			_socketUrlTxt.y=100
			_socketUrlTxt.width=200
			this.addChild(_socketUrlTxt);
			
		}
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
		}
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
			_workSpaceUrl.doubleClickEnabled=true
			_workSpaceUrl.addEventListener(MouseEvent.DOUBLE_CLICK,onWorkSpaceDoubleClik)
				
			_expSpaceUrl.doubleClickEnabled=true
			_expSpaceUrl.addEventListener(MouseEvent.DOUBLE_CLICK,onExpSpaceDoubleClik)
				
			_btnEnd.addEventListener(MouseEvent.CLICK,_btnEndClik)

		}
		
		protected function onExpSpaceDoubleClik(event:MouseEvent):void
		{
	
			
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
			function onFileWorkChg(event:Event):void
			{
				var $file:File = event.target as File;
				AppData.expSpaceUrl=$file.url
				ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE_CONFIG));
			}
			
		}
		
		protected function _btnEndClik(event:MouseEvent):void
		{
			AppData.RenderSocketUrl=_socketUrlTxt.text;
			
			ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_SAVE_CONFIG));
			
			ModuleEventManager.dispatchEvent(new SceneConfigEvent(SceneConfigEvent.CLOSE_CENEN_CONFIG_PANEL));
			
		}
		
		protected function onWorkSpaceDoubleClik(event:MouseEvent):void
		{
			
		
			ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_WORKSPACE_CHANGE));
			
		}

		
		protected function onStage(event:Event):void
		{
			drawback();
		}
		
		private function drawback():void{
			

			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x282828,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			
			
			
			var $w:uint=Math.max(300,this.width)
			var $h:uint=Math.max(300,this.height)
				
				
			_btnEnd.x=150
			_btnEnd.y=250
				
			
			_workSpaceUrl.text="工作空间=>"+AppData.workSpaceUrl;
			_expSpaceUrl.text="导出Res=>"+AppData.expSpaceUrl;
				
			_socketUrlTxt.text=AppData.RenderSocketUrl;
	
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
		
	}
}





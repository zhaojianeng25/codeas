package manager
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.GameUIInstance;
	import common.msg.event.engineConfig.MEventStageResize;
	import common.utils.frame.BasePanel;
	import common.utils.ui.layout.LayoutNode;
	import common.utils.ui.tab.TabPanel;

	public class LayerManager
	{
		private static var _instance:LayerManager;
		public static function getInstance():LayerManager{
			if(!_instance){
				_instance = new LayerManager;
			}
			return _instance;
		}
		
		
		private var _tabPanelList:Vector.<TabPanel>;
		
		private var rootNode:LayoutNode;
		
		public var dragPanel:BasePanel;
		public var dragTabPanel:TabPanel;
		
		public var mainTab:TabPanel;
		
		public function LayerManager()
		{
			_tabPanelList = new Vector.<TabPanel>;
		}
		
		public function testNodeTree():void{
			rootNode = new LayoutNode;
			rootNode.isRoot = true;
			//rootNode.initRootNode();
		}
		
		public function changeSize():void
		{
			if(Boolean(rootNode)){
				rootNode.draw();
			}
			dispatchSizeEvent();
		}		
		
		public function dispatchSizeEvent():void{
			if(!mainTab){
				return;
			}

			var evt:MEventStageResize = new MEventStageResize(MEventStageResize.MEVENT_STAGE_RESIZE);
			
			
			if(AppData.type==1){
				evt.xpos = mainTab.x;
				evt.ypos = mainTab.y + 60;
				evt.width = mainTab.width;
				evt.height = mainTab.height - 60;
			}else{
				evt.xpos = 0
				evt.ypos =0
				evt.width = Scene_data.stage.stageWidth
				evt.height = Scene_data.stage.stageHeight
			}
			
			
			
			
			ModuleEventManager.dispatchEvent(evt);
		}

		public function addPanel($panel:BasePanel,$isProp:Boolean=false):void{
			var _tabPanel:TabPanel = getIdlePanel($panel.defaultType);
			_tabPanel.addItem($panel.name,$panel);
			if($isProp){
				_propTablePanel = _tabPanel;
			}
			if(!_tabPanel.hasLayOut){
				if($panel.defaultType == 1){//主窗口
					rootNode.initRootNode(_tabPanel);
					mainTab = _tabPanel;
				}else if($panel.defaultType == 2){//属性窗口
					rootNode.addSunNode(LayoutNode.Right,_tabPanel,0.15);
				}else if($panel.defaultType == 0){//文件窗口
					if(rootNode.sun1Node){
						rootNode.sun1Node.addSunNode(LayoutNode.Bottom,_tabPanel,0.3);
					}
				}else if($panel.defaultType == 3){//浏览窗口
					if(rootNode.sun1Node && rootNode.sun1Node.sun1Node){
						rootNode.sun1Node.sun1Node.addSunNode(LayoutNode.Left,_tabPanel,0.85);
					}
				}else if($panel.defaultType == 4){//粒子属性窗口
					if(rootNode.sun1Node){
						rootNode.sun1Node.addSunNode(LayoutNode.Left,_tabPanel,0.8);
					}
				}else if($panel.defaultType == 5){//action属性窗口
					rootNode.sun1Node.sun1Node.addSunNode(LayoutNode.Bottom,_tabPanel,0.5);
				}else if($panel.defaultType == 6){//skill属性窗口
					rootNode.sun1Node.sun2Node.addSunNode(LayoutNode.Bottom,_tabPanel,0.3);
				}
				_tabPanel.hasLayOut = true;
			}
			
			_tabPanel.show(GameUIInstance.uiContainer);
		}
		
		private var _propTablePanel:TabPanel;
		public function showPropPanle($panel:BasePanel):void{
			_propTablePanel.addItem($panel.name,$panel);
		}
		
		public function getPanle():TabPanel{
			var _tabPanel:TabPanel = new TabPanel;
			_tabPanel.addItem(dragPanel.name,dragPanel);
			_tabPanel.hasLayOut = true;
			_tabPanel.show(GameUIInstance.uiContainer);
			return _tabPanel;
		}
		
		public function removeDragPanle():void{
			dragTabPanel.removeItem(dragPanel);
		}
		
		public function addWindowPanle():void{
			var _tabPanel:TabPanel = new TabPanel;
			_tabPanel.addItem(dragPanel.name,dragPanel);
			_tabPanel.hasLayOut = true;
			
			var win:Window = new Window;
			win.transparent=false;
			win.type=NativeWindowType.UTILITY;
			win.systemChrome=NativeWindowSystemChrome.STANDARD;
			win.width= 300;
			win.height= 800;
			win.showStatusBar = false;
			
			_tabPanel.setStyle("left",0);
			_tabPanel.setStyle("right",0);
			_tabPanel.setStyle("top",0);
			_tabPanel.setStyle("bottom",0);

			
			win.addElement(_tabPanel);
			
			//win.alwaysInFront = true;
			win.setStyle("backgroundColor",0x404040);
			//win.resizable = false;
			win.setStyle("fontFamily","Microsoft Yahei");
			win.setStyle("fontSize",11); 
			
			win.open(true);
		}
		
		public function delPanel($panel:TabPanel):void{
			if($panel.parent){
				$panel.parent.removeChild($panel);
			}
			
			var node:LayoutNode = rootNode.getNodeByPanle($panel);
			if(node){
				node.parentNode.removeNode(node);
			}
		}
		
		//type = 1 scene窗口 type = 2 属性窗口 type = 3 独立窗口
		public function getIdlePanel($type:int):TabPanel{
			for(var i:int;i<_tabPanelList.length;i++){
				if(_tabPanelList[i].type == $type){
					return _tabPanelList[i];
				}
			}
			
			var _tabPanel:TabPanel = new TabPanel;
//			if($type == 1){
//				_tabPanel.setStyle("left",0);
//				_tabPanel.setStyle("right",400);
//				_tabPanel.setStyle("top",0);
//				_tabPanel.setStyle("bottom",0);
//			}else if($type == 2){
//				_tabPanel.setStyle("left",1200);
//				_tabPanel.setStyle("right",0);
//				_tabPanel.setStyle("top",0);
//				_tabPanel.setStyle("bottom",0);
//			}
			_tabPanel.type = $type;
			_tabPanelList.push(_tabPanel);
			
			return _tabPanel;
		}
		
		public function getAllData():Object{
			var obj:Object = new Object;
			
			return obj;
		}
		
	}
}
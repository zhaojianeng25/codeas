package modules.materials
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.materials.MEvent_Material;
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	import common.vo.editmode.EditModeEnum;
	
	import materials.MaterialTree;
	
	import modules.materials.treedata.MaterialCompile;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.MaterialCtrl;
	import modules.materials.view.MaterialLineContainer;
	import modules.materials.view.MaterialViewBuildUtils;
	import modules.materials.view.TextureSampleNodeUI;
	import modules.materials.view.constnum.ConstFloatNodeUI;
	import modules.materials.view.constnum.ConstVec2NodeUI;
	import modules.materials.view.constnum.ConstVec3NodeUI;
	import modules.materials.view.constnum.FresnelNodeUI;
	import modules.materials.view.constnum.HeightInfoNodeUI;
	import modules.materials.view.constnum.PannerNodeUI;
	import modules.materials.view.constnum.ParticleColorNodeUI;
	import modules.materials.view.constnum.RefractionNodeUI;
	import modules.materials.view.constnum.TexCoordNodeUI;
	import modules.materials.view.constnum.TimeNodeUI;
	import modules.materials.view.constnum.VertexColorNodeUI;
	import modules.materials.view.dynamicNode.DynamicVec3NodeUI;
	import modules.materials.view.mathNode.MathAddNodeUI;
	import modules.materials.view.mathNode.MathCosNodeUI;
	import modules.materials.view.mathNode.MathDivNodeUI;
	import modules.materials.view.mathNode.MathLerpNodeUI;
	import modules.materials.view.mathNode.MathMinNodeUI;
	import modules.materials.view.mathNode.MathMulNodeUI;
	import modules.materials.view.mathNode.MathSinNodeUI;
	import modules.materials.view.mathNode.MathSubNodeUI;
	import modules.materials.view.preview.MaterialPreViewUI;
	import modules.materials.view.preview.MaterialToolMenuView;
	import modules.scene.SceneEditModeManager;
	
	public class MaterialPanel extends BasePanel
	{
		private var backUI:UIComponent;
		private var maskUI:UIComponent;
		private var nodeUI:UIComponent;
		
		private var backGraphics:UIComponent;
		public var lineContainer:MaterialLineContainer;
		
		private var _materialTree:MaterialTree;
		private var _materialCtrl:MaterialCtrl;
		private var _materialGLSLTree:MaterialTree;
		
		private var _materialPreView:MaterialPreViewUI;
		private var _materialToolMenuView:MaterialToolMenuView;
		public function MaterialPanel()
		{
			super();
			
			backUI = new UIComponent;
			this.addChild(backUI);
			maskUI = new UIComponent;
			this.addChild(maskUI);

			backUI.mask = maskUI;
			
			
			_materialPreView = new MaterialPreViewUI;
			this.addChild(_materialPreView);
			
			
			_materialToolMenuView = new MaterialToolMenuView;
			this.addChild(_materialToolMenuView);
			
			backGraphics = new UIComponent;
			backUI.addChild(backGraphics);
			
			drawBack();
			
			lineContainer = new MaterialLineContainer;
			backUI.addChild(lineContainer);
			
			nodeUI = new UIComponent;
			backUI.addChild(nodeUI);
			
		
			
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
			initMenuFile();
			//test();
			initDrag();
			
			addEvents();
			
	
			
			
		}
		
		private function addEvents():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)
			this.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMiddleDown);
			backGraphics.addEventListener(MouseEvent.RIGHT_CLICK,onMenu);
			backGraphics.addEventListener(MouseEvent.CLICK,onClick);
			
			
			_materialToolMenuView.comiplerBut.addEventListener(MouseEvent.CLICK,onComiplerButClik)
			_materialToolMenuView.saveBut.addEventListener(MouseEvent.CLICK,onSaveButButClik)
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			SceneEditModeManager.changeMode(EditModeEnum.EDIT_MATERIAL)
			
		}
		
		protected function onSaveButButClik(event:MouseEvent):void
		{
			saveMaterial()
			
		}
		
		protected function onComiplerButClik(event:MouseEvent):void
		{
			compileMaterial()
			
		}
		
		public function get materialPreView():MaterialPreViewUI
		{
			return _materialPreView;
		}

		protected function onClick(event:MouseEvent):void
		{
			this.setFocus();
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
		}
		
		protected function onKey(event:KeyboardEvent):void
		{
			if(!_materialTree){
				return;
			}
			if(event.keyCode == 83 && event.controlKey){
				saveMaterial()
			}else if(event.keyCode == 66 && event.controlKey){
				compileMaterial()
			}
		}
        private function saveMaterial():void
		{
			var obj:Object = _materialCtrl.getObj();
			_materialTree.data = obj;
			var evt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SAVE);
			evt.material = _materialTree;
			evt.glslMaterial = _materialGLSLTree;
			ModuleEventManager.dispatchEvent(evt);
		}
		
		private function  compileMaterial():void
		{
			var _compile:MaterialCompile = new MaterialCompile;
			_compile.compile(_materialCtrl.nodeList,_materialTree,_materialGLSLTree);
			
			_materialPreView.material = _materialTree
		}
		
		protected function onMenu(event:MouseEvent):void
		{
			if(!(event.target is BaseMaterialNodeUI)){
				_menuFile.display(this.stage,stage.mouseX,stage.mouseY);
			}
		}		
		
		private function initDrag():void{
			this.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
		}
		
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFile($fileNode.extension)){
				var simUI:TextureSampleNodeUI = new TextureSampleNodeUI;
				nodeUI.addChild(simUI);
				simUI.x = backUI.mouseX;
				simUI.y = backUI.mouseY;
				
				if(!_materialTree.hasMainTex()){
					simUI.isMain = true;
				}
				
				var relativeUrl:String = $fileNode.url.replace(Scene_data.fileRoot,"");
				simUI.addBitmpUrl(relativeUrl);
				_materialCtrl.addNodeUI(simUI);
			}
		}

		
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFile($fileNode.extension)){
				
				var ui:UIComponent = event.target as UIComponent;
				
				DragManager.acceptDragDrop(ui);
			}
		}
		
		protected var extensinonItem:Array = ["jpg","png","wdp"];
		protected function canInPutFile($extension:String):Boolean
		{
			for(var i:uint=0;i<extensinonItem.length;i++)
			{
				if(extensinonItem[i]==$extension){
					return true
				}
			}
			return false
		}
		
		public function showMaterial($material:MaterialTree):void{
			if(_materialCtrl){
				_materialCtrl.removeAllUI();
			}
			lineContainer.removeAll();
			
			_materialTree = $material;
			_materialCtrl = new MaterialCtrl;
			_materialGLSLTree = new MaterialTree();
			//addResultNode();
			buildMaterialView(_materialTree.data);
			var _compile:MaterialCompile = new MaterialCompile;
			_compile.compile(_materialCtrl.nodeList,$material,_materialGLSLTree);
			//_materialPreView.material = _materialTree
		}
		
		public function buildMaterialView(obj:Object):void{
			var buildUtil:MaterialViewBuildUtils = new MaterialViewBuildUtils;
			buildUtil.addFun = addNodeView;
			buildUtil.setData(obj as Array);
		}
		
		public function addNodeView($ui:BaseMaterialNodeUI):void{
			nodeUI.addChild($ui);
			_materialCtrl.addNodeUI($ui);
		}
		
		
		protected function onMiddleDown(event:MouseEvent):void
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			this.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onUp);
			_eX = this.stage.mouseX;
			_eY = this.stage.mouseY;
		}
		
		protected function onUp(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			this.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,onUp);
		}
		
		private var _eX:int;
		private var _eY:int;
		protected function onMove(event:MouseEvent):void
		{
			backUI.x -= _eX - this.stage.mouseX;
			backUI.y -= _eY - this.stage.mouseY;
			
			if(backUI.x >= 2048){
				backUI.x = 2048
			}
			
			if(backUI.y >= 2048){
				backUI.y = 2048
			}
			
			if(backUI.x < (this.width-2048)){
				backUI.x = this.width-2048
			}
			
			if(backUI.y < (this.height - 2048)){
				backUI.y = this.height - 2048
			}
			
			_eX = this.stage.mouseX;
			_eY = this.stage.mouseY;
			
		}
		
		override public function onSize(event:Event= null):void
		{
			drawMask();
			_materialToolMenuView.resetSize(this.width,this.height)
			_materialPreView.y=30
			_materialPreView.resetSize(0,this.height-30)
			
		}
		
		public function drawMask():void{
			maskUI.graphics.clear();
			maskUI.graphics.beginFill(0xff0000,1);
			maskUI.graphics.drawRect(0,0,this.width,this.height);
			maskUI.graphics.endFill();
		}
		
		public function drawBack():void{
			backGraphics.graphics.clear();
			backGraphics.graphics.beginFill(0x2a2a2a,1);
			backGraphics.graphics.drawRect(-2048,-2048,4096,4096);
			backGraphics.graphics.endFill();
			
			backGraphics.graphics.lineStyle(1,0x353535);
			for(i=-128;i<128;i++){
				backGraphics.graphics.moveTo(-2048,i*16);
				backGraphics.graphics.lineTo(2048,i*16);
			}
			for(i=-128;i<128;i++){
				backGraphics.graphics.moveTo(i*16,-2048);
				backGraphics.graphics.lineTo(i*16,2048);
			}
			
			backGraphics.graphics.lineStyle(1,0x1c1c1c);
			for(var i:int = -16;i<16;i++){
				backGraphics.graphics.moveTo(-2048,i*128);
				backGraphics.graphics.lineTo(2048,i*128);
			}
			for(i=-16;i<16;i++){
				backGraphics.graphics.moveTo(i*128,-2048);
				backGraphics.graphics.lineTo(i*128,2048);
			}
			

		}
		
		private var _menuFile:NativeMenu;54
		public function initMenuFile():void{
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("Add(+)")
			newtypefile.addItem(item);
			item.addEventListener(Event.SELECT,onAddNode);
			item = new NativeMenuItem("Sub(-)");
			item.addEventListener(Event.SELECT,onSubNode);
			newtypefile.addItem(item);
			item = new NativeMenuItem("Mul(*)");
			item.addEventListener(Event.SELECT,onMulNodd);
			newtypefile.addItem(item);
			item = new NativeMenuItem("Div(/)");
			item.addEventListener(Event.SELECT,onDivNode);
			newtypefile.addItem(item);
			item = new NativeMenuItem("sin");
			item.addEventListener(Event.SELECT,onSinNode);
			newtypefile.addItem(item);
			item = new NativeMenuItem("cos");
			item.addEventListener(Event.SELECT,onCosNode);
			newtypefile.addItem(item);
			item = new NativeMenuItem("lerp");
			item.addEventListener(Event.SELECT,onlerpNode);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("min");
			item.addEventListener(Event.SELECT,onMinNode);
			newtypefile.addItem(item);
			
			_menuFile.addSubmenu(newtypefile,"Math");
			
			newtypefile = new NativeMenu;
			item = new NativeMenuItem("vec3");
			item.addEventListener(Event.SELECT,onVec3Node);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("vec2");
			item.addEventListener(Event.SELECT,onVec2Node);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("float");
			item.addEventListener(Event.SELECT,onFloatNode);
			newtypefile.addItem(item);
			
			
			_menuFile.addSubmenu(newtypefile,"常数");
			
			_menuFile.addItem(new NativeMenuItem(null,true));
			
			newtypefile = new NativeMenu;
			item = new NativeMenuItem("纹理贴图");
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("纹理坐标");
			item.addEventListener(Event.SELECT,onTexCoord);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("纹理滚动");
			item.addEventListener(Event.SELECT,onTexPannerCoord);
			newtypefile.addItem(item);
			
			_menuFile.addSubmenu(newtypefile,"纹理");
			
			
			newtypefile = new NativeMenu;
			item = new NativeMenuItem("粒子颜色");
			item.addEventListener(Event.SELECT,onParticleColor);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("粒子时间");
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("顶点颜色");
			newtypefile.addItem(item);
			item.addEventListener(Event.SELECT,onVertexColor);
			
			_menuFile.addSubmenu(newtypefile,"粒子");
			
			item = new NativeMenuItem("time");
			item.addEventListener(Event.SELECT,onTime);
			_menuFile.addItem(item);
			
			newtypefile = new NativeMenu;
			item = new NativeMenuItem("高度");
			item.addEventListener(Event.SELECT,onHeightInfo);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("菲涅尔");
			item.addEventListener(Event.SELECT,onFresnel);
			newtypefile.addItem(item);
			
			item = new NativeMenuItem("折射");
			item.addEventListener(Event.SELECT,onRefraction);
			newtypefile.addItem(item);
			
			
			_menuFile.addSubmenu(newtypefile,"其他");
			
			
			
		}
		
		protected function onMinNode(event:Event):void
		{
			var addUI:MathMinNodeUI = new MathMinNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onTexPannerCoord(event:Event):void
		{
			var addUI:PannerNodeUI = new PannerNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onRefraction(event:Event):void
		{
			var addUI:RefractionNodeUI = new RefractionNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onFresnel(event:Event):void
		{
			var addUI:FresnelNodeUI = new FresnelNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onHeightInfo(event:Event):void
		{
			var addUI:HeightInfoNodeUI = new HeightInfoNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onVertexColor(event:Event):void
		{
			var addUI:VertexColorNodeUI = new VertexColorNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onParticleColor(event:Event):void
		{
			if(_materialCtrl.getNodeByCls(ParticleColorNodeUI)){
				Alert.show("一个材质只能有一个颜色");
				return;
			}
			var addUI:ParticleColorNodeUI = new ParticleColorNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onInputVec3(event:Event):void
		{
			var addUI:DynamicVec3NodeUI = new DynamicVec3NodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onlerpNode(event:Event):void
		{
			var addUI:MathLerpNodeUI = new MathLerpNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onTexCoord(event:Event):void
		{
			var addUI:TexCoordNodeUI = new TexCoordNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onTime(event:Event):void
		{
			var addUI:TimeNodeUI = new TimeNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onFloatNode(event:Event):void
		{
			var addUI:ConstFloatNodeUI = new ConstFloatNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onVec2Node(event:Event):void
		{
			var addUI:ConstVec2NodeUI = new ConstVec2NodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onVec3Node(event:Event):void
		{
			var addUI:ConstVec3NodeUI = new ConstVec3NodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onCosNode(event:Event):void
		{
			var addUI:MathCosNodeUI = new MathCosNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onSinNode(event:Event):void
		{
			var addUI:MathSinNodeUI = new MathSinNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onDivNode(event:Event):void
		{
			var addUI:MathDivNodeUI = new MathDivNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onMulNodd(event:Event):void
		{
			var addUI:MathMulNodeUI = new MathMulNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onSubNode(event:Event):void
		{
			var addUI:MathSubNodeUI = new MathSubNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
		protected function onAddNode(event:Event):void
		{
			var addUI:MathAddNodeUI = new MathAddNodeUI;
			nodeUI.addChild(addUI);
			addUI.x = backUI.mouseX;
			addUI.y = backUI.mouseY;
			_materialCtrl.addNodeUI(addUI);
		}
		
	}
}
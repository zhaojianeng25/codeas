package modules.terrain
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import _Pan3D.display3D.grass.GrassDisplay3DSprite;
	import _Pan3D.display3D.ground.GroundLevel;
	import _Pan3D.display3D.ground.quick.QuickModelMath;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_MainOperate;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.msg.event.terrain.MEvent_ShowTerrain;
	import common.msg.event.terrain.MEvent_Terrain_Exp;
	import common.msg.event.terrain.MEvent_init_Terrain;
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	import common.vo.editmode.EditModeEnum;
	
	import manager.LayerManager;
	
	import materials.MaterialTree;
	
	import modules.materials.view.MaterialTreeManager;
	import modules.scene.SceneEditModeManager;
	import modules.terrain.view.BrushContainer;
	
	import proxy.top.ground.IGround;
	
	import render.ground.GroundManager;
	import render.ground.GroundNrmModel;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	
	public class TerrainProcessor extends Processor
	{
		private var _terrainView:BaseReflectionView;
		
		private var _isTerrainTure:Boolean=false;
		
		public function TerrainProcessor($module:Module)
		{
			super($module);
		}
		public function set isTerrainTure(value:Boolean):void
		{
			_isTerrainTure = value;
			GroundData.showShaderHitPos=value
			GroundData.isEditNow=value

		}
		public function scanQuickTexture():void
		{
			if(isLoadBaseDataOk){
				for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
				{
					$IGround.scanQuickTexture()
				}
			}
		}

		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_ShowTerrain,
				MEvent_init_Terrain,
				MEvent_ProjectData,
				MEvent_MainOperate,
				MEvent_Terrain_Exp
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_ShowTerrain:
					//showHide($me as MEvent_ShowSceneCtrl);
					
					if(!_terrainView){
						_terrainView = new BaseReflectionView;
						_terrainView.creat(getView());
					}
					_terrainView.init(this,"地形",2);
					LayerManager.getInstance().addPanel(_terrainView);
					_terrainView.addEventListener("hide",onViewHide);
			
				
	
					break;
				case MEvent_init_Terrain:
					initTerrainData($me as MEvent_init_Terrain)
					break;
				case MEvent_ProjectData:
					if($me.action == MEvent_ProjectData.PROJECT_SAVE_GET_DATA){

						if(Boolean(AppData.terrain)){
							TerrainEditorData.workSpaceUrl=AppData.workSpaceUrl
							TerrainEditorData.fileRoot=(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/"
							TerrainEditorData.setObject(AppData.terrain)
							pushSixTeenFileToBurshPanel()
							loadNewTerrain();
						}else{
							TerrainEditorData.initData()
							pushSixTeenFileToBurshPanel()
							refreshGroundLevel()
						}
				
						_cellNumX=GroundData.cellNumX
						_cellNumZ=GroundData.cellNumZ
						_terrainMidu=GroundData.terrainMidu
						_cellScale=GroundData.cellScale
						_idMapScale=GroundData.idMapScale

						GrassDisplay3DSprite.groundWidthX=GroundData.cellNumX*GroundData.terrainMidu*GroundData.cellScale*4
						GrassDisplay3DSprite.groundHeightY=GroundData.cellNumZ*GroundData.terrainMidu*GroundData.cellScale*4
						_terrainView.refreshView()

					}else if($me.action == MEvent_ProjectData.PROJECT_SAVE_SET_DATA){
						
						TerrainEditorData.fileRoot = (AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/"
                        saveToSixTeenFileNodeArr()
						AppData.terrain = TerrainEditorData.getObject()
						saveTerrainBitmapData()
						Alert.show("场景保存完毕");
				
					}
					break;
				
				case MEvent_MainOperate:
					if($me.action == MEvent_MainOperate.TERRAIN_HEIGHT_OPERATE){
						isTerrainTure=true
						addEvets()
						
					}else if($me.action == MEvent_MainOperate.TERRAIN_GRASS_OPERATE){
						isTerrainTure=true
						addEvets()
						
					}else{
						isTerrainTure=false
						removeEvets()
					}
					
					break;
				case MEvent_Terrain_Exp:
					if($me.action == MEvent_Terrain_Exp.TERRAIN_EXP_OBJ){
						TerrainDataSaveToObj.terrainToObj(GroundManager.getInstance().terrainArr)
					}
					if($me.action == MEvent_Terrain_Exp.TERRAIN_EXP_BYTE){
						TerrainDataSaveToData.getInstance().saveTerrainData()
					}
					if($me.action == MEvent_Terrain_Exp.TERRAIN_EXP_A3D){
						var file:File=new File;
		
			
						file.browseForOpen("Open");

						file.addEventListener(Event.SELECT,onSelect);
						function onSelect(e:Event):void
						{
							TerrainDataSaveToA3D.getInstance().toDo(e.currentTarget.nativePath+"/")
						}
					}
					break;
			}
		}
		
		private function loadNewTerrain():void
		{
			
			TerrainDataModel.getInstance().loadBaseTerrainData(refreshGroundLevel)
			//refreshGroundLevel()
		}
		
		protected function onViewHide(event:Event):void
		{
			ModuleEventManager.dispatchEvent( new MEvent_MainOperate(MEvent_MainOperate.DEFAULT_OPERATE));
		}
		
		private function get isNoReady():Boolean
		{
			if(isLoadBaseDataOk){
				return false
			}
			return true
		}
	
		public static function saveTerrainBitmapData():void
		{
			var file:File;
			var by:ByteArray;
			var bd:BitmapData;
			var fs:FileStream = new FileStream();
			
			trace("saveTerrainBitmapData",TerrainEditorData.fileRoot)
			
			if(TerrainEditorData.sixteenUvBmp)
			{
				file = new File(TerrainEditorData.fileRoot+"terrain/"+"sixteenUvBmp.jpg");				
				fs.open(file,FileMode.WRITE);
				bd = TerrainEditorData.sixteenUvBmp;
				by = bd.getPixels(bd.rect);
				by.position = 0;
				fs.writeBytes(by);
				by.clear();
				by = null;
				fs.close();
			}
			if(TerrainEditorData.bigHeightBmp)
			{
				file = new File(TerrainEditorData.fileRoot+"terrain/"+"bigHeightBmp.jpg");				
				fs.open(file,FileMode.WRITE);
				bd = TerrainEditorData.bigHeightBmp;
				by = bd.getPixels(bd.rect);
				by.position = 0;
				fs.writeBytes(by);
				by.clear();
				by = null;
				fs.close();
			}
			if(TerrainEditorData.bigIdMapBmp)
			{
				file = new File(TerrainEditorData.fileRoot+"terrain/"+"bigIdMapBmp.jpg");				
				fs.open(file,FileMode.WRITE);
				bd = TerrainEditorData.bigIdMapBmp;
				by = bd.getPixels(bd.rect);
				by.position = 0;
				fs.writeBytes(by);
				by.clear();
				by = null;
				fs.close();
			}
			if(TerrainEditorData.bigInfoMapBmp)
			{
				file = new File(TerrainEditorData.fileRoot+"terrain/"+"bigInfoMapBmp.jpg");				
				fs.open(file,FileMode.WRITE);
				bd = TerrainEditorData.bigInfoMapBmp;
				by = bd.getPixels(bd.rect);
				by.position = 0;
				fs.writeBytes(by);
				by.clear();
				by = null;
				fs.close();
			}
			//saveOther()
			
		}
		private static function saveOther():void
		{
			var url:String=TerrainEditorData.fileRoot+"terrain/"+"bigInfoMapBmp_0.jpg"
			savePic(url,TerrainEditorData.bigInfoMapBmp)
		}
		private static var jpgEncoder:JPEGEncoder;
		private static function savePic($picUrl:String,$bmp:BitmapData):void
		{
			if(!jpgEncoder){
				jpgEncoder = new JPEGEncoder(50);
			}
			var by:ByteArray;
			var bd:BitmapData;
			var fs:FileStream = new FileStream();
			
			var file:File = new File($picUrl);			
			fs.open(file,FileMode.WRITE);
			by = jpgEncoder.encode($bmp);
			by.position = 0;
			fs.writeBytes(by);
			by.clear();
			by = null;
			fs.close();
		}
		
		private function addEvets():void
		{
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightMouseUp);
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown);
		}
		
		protected function onRightMouseDown(event:MouseEvent):void
		{
			_mouseRightDown=true
			
		}
		private var _mouseRightDown:Boolean=false
		protected function onRightMouseUp(event:MouseEvent):void
		{
			_mouseRightDown=false
			
		}
		private function removeEvets():void
		{
			Scene_data.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			Scene_data.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			Scene_data.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightMouseUp);
			Scene_data.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown);
		}
		
		private var _baseShape:Sprite = new Sprite;
		private var _shape:Sprite = new Sprite;
		private function addShape():void{

			/*
			_baseShape.addChild(_shape);
			_baseShape.graphics.beginFill(0,1);
			_baseShape.graphics.drawRect(0,0,300,300);
			_baseShape.graphics.endFill();
			*/
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			
			if((AppData.editMode==EditModeEnum.EDIT_WORLD||AppData.editMode==EditModeEnum.EDIT_TERRAIN_INFO||AppData.editMode==EditModeEnum.EDIT_TERRAIN_HEIGHT)&&!_mouseRightDown){
				if(event.keyCode==Keyboard.Q||event.keyCode==Keyboard.EXIT)
				{
					isTerrainTure=false
					scanQuickTexture()
					SceneEditModeManager.changeMode(EditModeEnum.EDIT_WORLD)
				}
				
				if(event.keyCode==219)
				{
					if(TerrainDrawHeightModel.brushSize>1){
						TerrainDrawHeightModel.brushSize--
						_terrainView.refreshView()
					}
				}
				if(event.keyCode==221)
				{
					if(TerrainDrawHeightModel.brushSize<50){
						TerrainDrawHeightModel.brushSize++
						_terrainView.refreshView()
					}
				}
				GroundManager.getInstance().changeBrushData()
				
			}

		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(isNoReady){
				return 
			}
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundPostion();
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_HEIGHT){
				
				TerrainDrawHeightModel.getInstance().mouseMove(hitPos,event.shiftKey)
			}
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_INFO){
				
				TerrainDrawGrassModel.getInstance().mouseMove(hitPos,burshPanel.selectedIndex)
			}
		
			
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(isNoReady){
				return 
			}
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundPostion();
			
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_HEIGHT){
				TerrainDrawHeightModel.getInstance().mouseUp(hitPos,event.shiftKey)
			}
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_INFO){
				TerrainDrawGrassModel.getInstance().mouseUp(hitPos,burshPanel.selectedIndex)
					
			}
		}
		//private var _isDrawTerrainType:uint=2
		protected function onMouseDown(event:MouseEvent):void
		{
			if(isNoReady){
				return 
			}
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundPostion();
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_HEIGHT){
				TerrainDrawHeightModel.getInstance().mouseDown(hitPos)
			
			}
			if(AppData.editMode==EditModeEnum.EDIT_TERRAIN_INFO){
				TerrainDrawGrassModel.getInstance().mouseDown(hitPos)
				
			}

			
		}
		protected function onKeyUp(event:KeyboardEvent):void
		{

		}
		private function initTerrainData(evt:MEvent_init_Terrain):void
		{


		
		}
		private var isLoadBaseDataOk:Boolean=false
		private function refreshGroundLevel():void
		{

			GroundManager.getInstance().changeGroundData(GroundData.cellNumX,GroundData.cellNumZ,GroundData.terrainMidu,GroundData.cellScale,GroundData.idMapScale)
			isLoadBaseDataOk=true
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.Vec2,Label:"宽高(x):",GetFun:getWidthHeight,SetFun:setWidthHeight,Category:"基础属性"},
					{Type:ReflectionData.Number,Label:"格子密度(e)",GetFun:getDensity,SetFun:setDensity,Category:"基础属性",MaxNum:20,MinNum:5},
					{Type:ReflectionData.Number,Label:"坐标比例(u)",GetFun:getScale,SetFun:setScale,Category:"基础属性",MaxNum:50,MinNum:1},
					{Type:ReflectionData.Number,Label:"索引比例(u)",GetFun:getImgScale,SetFun:setImgScale,Category:"基础属性",MaxNum:10,MinNum:1},

	
					{Type:ReflectionData.Btn,Label:"确认更改",SetFun:onSure,Category:"基础属性"},
					
					{Type:ReflectionData.UserView,GetView:getBrushView,Category:"地形纹理"},
					{Type:ReflectionData.Number,Label:"材质比例(u)",GetFun:getSixteenUvScale,SetFun:setSixteenUvScale,Category:"地形纹理",MaxNum:100,MinNum:1,Step:1},
					//{Type:ReflectionData.Number,Label:"材质尺寸(u)",GetFun:getSixteenSize,SetFun:setSixteenSize,Category:"地形纹理",MaxNum:512,MinNum:128,Step:1},
					{Type:ReflectionData.ComboBox,Label:"材质尺寸:",GetFun:getSixteenSize,SetFun:setSixteenSize,Category:"地形纹理",Data:getTextureSizeArr()},
					//{name:32,data:32}{name:64,data:64}{name:128,data:128}{name:256,data:256}{name:512,data:512}{name:1024,data:1024}
					{Type:ReflectionData.ComboBox,Label:"贴图尺寸:",GetFun:getlightMapSize,SetFun:setlightMapSize,Category:"地形纹理",Data:getTextureSizeArr()},
				
					{Type:ReflectionData.Number,Label:"笔刷大小:",GetFun:getBishuaSize,SetFun:changeBishuaSize,Category:"地形纹理",MaxNum:50,MinNum:1,Step:1,GetMaxNumFun:getMaxfun},
					{Type:ReflectionData.Number,Label:"笔刷扩散:",GetFun:getBishuaBluer,SetFun:changeBishuaBluer,Category:"地形纹理",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"笔刷强度:",GetFun:getbrushPow,SetFun:changebrushPow,Category:"地形纹理",MaxNum:1,MinNum:0,Step:0.01},
				
					
					{Type:ReflectionData.ComboBox,Label:"笔刷类型:",GetFun:getDrawType,SetFun:changeDrawType,Category:"地形笔刷",Data:[{name:"抬高",type:0},{name:"下陷",type:1},{name:"平滑",type:2},{name:"整平",type:3},{name:"斜坡",type:4}]},
					{Type:ReflectionData.Number,Label:"笔刷大小:",GetFun:getBishuaSize,SetFun:changeBishuaSize,Category:"地形笔刷",MaxNum:50,MinNum:1,Step:1,GetMaxNumFun:getMaxfun},
					{Type:ReflectionData.Number,Label:"笔刷扩散:",GetFun:getBishuaBluer,SetFun:changeBishuaBluer,Category:"地形笔刷",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"笔刷强度:",GetFun:getbrushPow,SetFun:changebrushPow,Category:"地形笔刷",MaxNum:1,MinNum:0,Step:0.01},
					
					{Type:ReflectionData.MaterialImg,Label:"显示材质:",key:"terrainMaterals",extensinonStr:"materials.Material",closeBut:1,target:this,Category:"材质"},
				]
			if(AppData.type==1){
				
				ary.push({Type:ReflectionData.Number,Label:"灯光模糊(l)",GetFun:getLightBlur,SetFun:setLightBlur,Category:"基础属性",MaxNum:20,MinNum:1})
				ary.push({Type:ReflectionData.ComboBox,Label:"渲染尺寸(s):",GetFun:getQuickScanSize,SetFun:setQuickScanSize,Category:"基础属性",Data:getTextureSizeArr()})
				ary.push({Type:ReflectionData.ComboBox,Label:"快速渲染(b):",GetFun:getIsQuick,SetFun:setIsQuick,Category:"基础属性",Data:[{name:"关闭",type:0},{name:"开起",type:1}]})
				ary.push({Type:ReflectionData.ComboBox,Label:"显示地形(e):",GetFun:getShowTerrain,SetFun:setShowTerrain,Category:"基础属性",Data:[{name:"关闭",type:0},{name:"开起",type:1}]})
				ary.push({Type:ReflectionData.ComboBox,Label:"材质光亮(e):",GetFun:getH5UseLight,SetFun:setH5UseLight,Category:"基础属性",Data:[{name:"关闭",type:0},{name:"开起",type:1}]})
			}
				
			
			
			return ary;
		}
		public function get terrainMaterals():MaterialTree
		{
			if(!MaterialTreeManager.getMaterial(Scene_data.fileRoot+GroundData.materialUrl)){
				GroundData.materialUrl="assets/terrain.material";
			}	
			QuickModelMath.getInstance().setmaterial( MaterialTreeManager.getMaterial(Scene_data.fileRoot+GroundData.materialUrl))
			return MaterialTreeManager.getMaterial(Scene_data.fileRoot+GroundData.materialUrl);
		}
		public var materialInfoArr:Object;
		public function set terrainMaterals(value:MaterialTree):void
		{
			if(value){
				GroundData.materialUrl=value.url
				QuickModelMath.getInstance().setmaterial( value);
			}
		}
		private function getShowTerrain():int
		{
			GroundLevel.showTerrain=GroundData.showTerrain;
			return GroundData.showTerrain?1:0
		}
		private function setShowTerrain(value:Object):void
		{
			GroundData.showTerrain=value.type==0?false:true
			GroundLevel.showTerrain=GroundData.showTerrain;
		}
		
		private function getH5UseLight():int
		{
			return GroundData.isH5UseLight?1:0
		}
		private function setH5UseLight(value:Object):void
		{
			GroundData.isH5UseLight=value.type==0?false:true
		}
		

		
		private function getIsQuick():int
		{
			return GroundData.isQuickScan?1:0
		}
		private function setIsQuick(value:Object):void
		{
			GroundData.isQuickScan=value.type==0?false:true
				
			if(GroundData.isQuickScan==true){
				isTerrainTure=false
			}
		}
		private function getQuickScanSize():int
		{
			return getTypeIdBySize(GroundData.quickScanSize);
			
		}
		private function setQuickScanSize(value:Object):void
		{
			GroundData.quickScanSize=uint(value.name)
			scanQuickTexture()
		}
		private function getTextureSizeArr():Array
		{
			return [{name:"64",type:0},{name:"128",type:1},{name:"256",type:2},{name:"512",type:3},{name:"1024",type:4},{name:"2048",type:4}]
		}
		private function getTypeIdBySize($num:uint):uint
		{
			var $arr:Array=getTextureSizeArr()
			for(var i:uint=0;i<$arr.length;i++){
				if(Number($arr[i].name)==$num){
					return Number($arr[i].type)
				}
			}
			return 0
				
		}
		
		private function getlightMapSize():int
		{
			return getTypeIdBySize(TerrainEditorData.lightMapSize)
			
		}
		private function setlightMapSize(value:Object):void
		{
			TerrainEditorData.lightMapSize=uint(value.name)
		}
		private function getSixteenSize():int
		{
			return getTypeIdBySize(TerrainEditorData.sixteenUvSize)
			
		}
		private function setSixteenSize(value:Object):void
		{
			TerrainEditorData.sixteenUvSize=uint(value.name)
			TerrainDataModel.getInstance().loadSixTeenMap();
		}
		public function getMaxfun():Number{
			return 20;
		}
		public function getBishuaBluer():Number{
	
			return TerrainDrawHeightModel.brushBluer
		}
		public function changeBishuaBluer(value:Number):void{
			TerrainDrawHeightModel.brushBluer=Math.max(value,0.01)
			GroundManager.getInstance().changeBrushData()
		}
		public function getbrushPow():Number{
			
			return TerrainDrawHeightModel.brushPow;
		}
		public function changebrushPow(value:Number):void{
			TerrainDrawHeightModel.brushPow=Math.min(Math.max(0,value),1)
			GroundManager.getInstance().changeBrushData()
		}
		public function getBishuaSize():Number{
			return TerrainDrawHeightModel.brushSize;
		}
		public function changeBishuaSize(value:Number):void{
			TerrainDrawHeightModel.brushSize=value;
			
			GroundManager.getInstance().changeBrushData()

		}
		
		public function draw1():void{
			_shape.graphics.clear();
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF0000, 0xff0000];
			var alphas:Array = [TerrainDrawHeightModel.brushPow, 0];
			var ratios:Array = [(1-TerrainDrawHeightModel.brushBluer )* 255, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(300* TerrainDrawHeightModel.brushSize/20, 300* TerrainDrawHeightModel.brushSize/20, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			_shape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod,InterpolationMethod.LINEAR_RGB,0);  
			_shape.graphics.drawRect(0,0,300 * TerrainDrawHeightModel.brushSize/20,300*TerrainDrawHeightModel.brushSize/20);
			//_shape.graphics.drawCircle(150,150,150);
			_shape.graphics.endFill();
		}
		
		public function getDrawType():int{

			return TerrainDrawHeightModel.drawType;
		}
		
		public function changeDrawType(value:Object):void{
			

				
			SceneEditModeManager.changeMode(EditModeEnum.EDIT_TERRAIN_HEIGHT)
			TerrainDrawHeightModel.drawType=value.type
			ModuleEventManager.dispatchEvent(new MEvent_MainOperate(MEvent_MainOperate.TERRAIN_HEIGHT_OPERATE));

		}
		public function onSure():void{

			GroundData.cellNumX=_cellNumX
			GroundData.cellNumZ=_cellNumZ
			GroundData.terrainMidu=_terrainMidu
			GroundData.cellScale=_cellScale
			GroundData.idMapScale=_idMapScale

			GroundNrmModel.getInstance().baseNrmBitmapData=null;
			refreshGroundLevel()

		}
		
	
		private var burshPanel:BrushContainer;

		public function getBrushView():BrushContainer{
			burshPanel = new BrushContainer;
			burshPanel.addEventListener(MouseEvent.CLICK,burshPanelOnClik)
			burshPanel.addEventListener(BrushContainer.LOAD_COMPLETE,onChange)

			return burshPanel;
		}
		
		protected function onChange(event:Event):void
		{

			saveToSixTeenFileNodeArr();
			GroundData.sixteenNum=Math.max(1,TerrainEditorData.sixTeenFileNodeArr.length)
			TerrainDataModel.getInstance().loadSixTeenMap();
			isTerrainTure=true
			scanQuickTexture()
	
		}
		/**
		 *将地面纹理图存放到笔刷 
		 * 
		 */
		private function pushSixTeenFileToBurshPanel():void
		{
			var $urlArr:Array=new Array
			for(var i:uint=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++)
			{
				if(String(TerrainEditorData.sixTeenFileNodeArr[i]).length){
		
					if( String(TerrainEditorData.sixTeenFileNodeArr[i]).search("file:///")==-1){
						$urlArr.push(AppData.workSpaceUrl+TerrainEditorData.sixTeenFileNodeArr[i])
					}else{
						$urlArr.push(TerrainEditorData.sixTeenFileNodeArr[i])
					}
					
				}
			}
			burshPanel.pushArr($urlArr)
		}
		/**
		 *改变笔刷图将士u
		 * 
		 */
		private function saveToSixTeenFileNodeArr():void
		{
			var urlArr:Array=new Array;
			TerrainEditorData.sixTeenFileNodeArr=new Array
			for(var i:uint=0;i<burshPanel.ary.source.length;i++){
				var urlStr:String=burshPanel.ary.source[i]
				urlStr=urlStr.substring(AppData.workSpaceUrl.length,urlStr.length)
				TerrainEditorData.sixTeenFileNodeArr.push(urlStr)
			}
			
		}
		protected function burshPanelOnClik(event:MouseEvent):void
		{

			SceneEditModeManager.changeMode(EditModeEnum.EDIT_TERRAIN_INFO)
			_terrainView.refreshView()
			ModuleEventManager.dispatchEvent(new MEvent_MainOperate(MEvent_MainOperate.TERRAIN_GRASS_OPERATE));
	
		}

		private var _cellNumX:uint=1
		private var _cellNumZ:uint=1
		private var _terrainMidu:uint=10
		private var _cellScale:uint=10
		private var _idMapScale:uint=5

	
	
			
		public function getWidthHeight():Point{
			return new Point(_cellNumX,_cellNumZ);
		}
		
		public function setWidthHeight(value:Point):void{
			_cellNumX=Math.max(uint(value.x),1)
			_cellNumZ=Math.max(uint(value.y),1)
		}
		public function getDensity():Number{
			return _terrainMidu;
		}
		public function setDensity(value:Number):void{
			_terrainMidu=Math.max(uint(value),1)
		}
		
		public function getScale():Number{
			return _cellScale;
		}
		public function setScale(value:Number):void{
			_cellScale=Math.max(Math.abs(value),1)
		}
		

		
		public function getImgScale():Number{
			return _idMapScale;
		}
		public function setImgScale(value:Number):void{
			_idMapScale=Math.min(Math.max(Math.abs(value),1),50)
		}
		
		public function getLightBlur():Number{
			return GroundData.lightBlur;
		}
		public function setLightBlur(value:Number):void{
			GroundData.lightBlur=value
		}

		public function getSixteenUvScale():Number{
			return uint(TerrainEditorData.sixteenUvMiduArr[burshPanel.selectedIndex])
		}
		
		public function setSixteenUvScale(value:Number):void{

				TerrainEditorData.sixteenUvMiduArr[burshPanel.selectedIndex]=Math.max(1,uint(value))
				TerrainEditorData.makeUvMiduTexture();
				//TerrainEditorData.sixteenUvScale=value
			
			
		}
		
	}
}
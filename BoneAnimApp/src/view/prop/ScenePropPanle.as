package view.prop
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.scene.postprocess.PostProcessManager;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import materials.MaterialCubeMap;
	
	import modules.materials.CubeMapManager;
	import modules.scene.sceneSave.FilePathManager;
	
	import renderLevel.levels.TittleLevel;
	
	public class ScenePropPanle extends BaseReflectionView
	{
		public var _sceneConfigData:Object = new Object;
		public function ScenePropPanle()
		{
			super();
			initData();
			this.creat(pan3dMenu());
			this.refreshView();
		}
		
		private static var instance:ScenePropPanle;
		public static function getInstance():ScenePropPanle{
			if(!instance){
				instance = new ScenePropPanle;
			}
			return instance;
		}
		
		private function initData():void{
			_sceneConfigData = new Object;
			_sceneConfigData.openLater = false;
			_sceneConfigData.highlightNum = 0.5;
			_sceneConfigData.highLightRang = 0.5;
			_sceneConfigData.usePs = false;
			_sceneConfigData.brightness = 0;
			_sceneConfigData.contrast = 1;
			_sceneConfigData.avaBrightness = 0.5;
			_sceneConfigData.saturation = 1;
			_sceneConfigData.distortion = false;
			//setEnvironment();
		}
		
		public function readObj():void{
			var file:File = new File(File.documentsDirectory.url + "/BoneAnimApp/sceneConfig.txt");
			if(file.exists){
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				_sceneConfigData = fs.readObject();
				fs.close();
				if(_sceneConfigData.skyUrl){
					this.skyUrl = _sceneConfigData.skyUrl;
				}
				
				Scene_data.light.Envscale= _sceneConfigData.Envscale;
				
				this.refreshView();
				setEnvironment();
			}else{
				initData();
			}
			
		}
		
		private function writeObj():void{
			var file:File = new File(File.documentsDirectory.url + "/BoneAnimApp/sceneConfig.txt");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeObject(_sceneConfigData);
			fs.close();
		}
		
		private function pan3dMenu():Array
		{
			var ary:Array =
				[
					{Type:ReflectionData.Number,Label:"整体比例:",GetFun:getScaleNum,SetFun:setScaleNum,Category:"基本属性",MaxNum:10,MinNum:0.01,Step:0.01},
					{Type:ReflectionData.CheckBox,Label:"显示名字位置:",GetFun:getShowTittleName,SetFun:setShowTittleName,Category:"基本属性"},
					{Type:ReflectionData.Number,Label:"模型名字高度:",GetFun:getTittleHeight,SetFun:setTittleHeight,Category:"基本属性",MaxNum:200,MinNum:0,Step:1},
					{Type:ReflectionData.Vec2,Label:"点击范围:",GetFun:getHitBox,SetFun:setHitBox,Category:"基本属性"},
		
					
					{Type:ReflectionData.PreFabImg,Label:"环境cubemap:",key:"skyUrl",extensinonStr:"cube",closeBut:1,donotDubleClik:0,target:this,Category:"环境"},
					
					{Type:ReflectionData.Number,Label:"环境反射系数:",GetFun:getEnvscale,SetFun:SetEnvscale,Category:"环境",MaxNum:10,MinNum:1,Step:0.01},
					
					
					
					{Type:ReflectionData.ColorPick,Label:"Ambient颜色:",GetFun:getAmbient,SetFun:setAmbient,Category:"灯光"},
					{Type:ReflectionData.Number,Label:"Ambient强度:",GetFun:getAmbientPow,SetFun:setAmbientPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.ColorPick,Label:"sun光颜色:",GetFun:getSunColor,SetFun:setSunColor,Category:"灯光"},
					
					{Type:ReflectionData.Number,Label:"sun强度:",GetFun:getSunPow,SetFun:setSunPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.Vec3,Label:"sun方向:",GetFun:getSunNrm,SetFun:setSunNrm,Category:"灯光"},
					{Type:ReflectionData.Btn,Label:"使用镜头法线",SetFun:onSure,Category:"灯光"},
					
					
					{Type:ReflectionData.ComboBox,Label:"开启后期:",GetFun:getOpenLater,SetFun:setOpenLater,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:0},
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.Number,Label:"高光范围:",GetFun:getHighlightRang,SetFun:setHighlightRang,Category:"后期",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"高光强度:",GetFun:getHighlightNum,SetFun:setHighlightNum,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Gap,Category:"后期"},
					
					{Type:ReflectionData.ComboBox,Label:"开启调色:",GetFun:getUsePs,SetFun:setUsePs,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"亮度:",GetFun:getBrightness,SetFun:setBrightness,Category:"后期",MaxNum:20,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"对比度:",GetFun:getContrast,SetFun:setContrast,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"平均亮度:",GetFun:getAvaBrightness,SetFun:setAvaBrightness,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"饱和度:",GetFun:getSaturation,SetFun:setSaturation,Category:"后期",MaxNum:5,MinNum:0,Step:0.01},
					{Type:ReflectionData.Gap,Category:"后期"},
					

					
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.ComboBox,Label:"开启扭曲:",GetFun:getDistortion,SetFun:setDistortion,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					
					{Type:ReflectionData.PreFabImg,Label:"背景图:",key:"backPic",extensinonStr:"jpg",closeBut:1,donotDubleClik:0,target:this,Category:"底图"},
					{Type:ReflectionData.Number,Label:"背景比例:",GetFun:getBackScale,SetFun:setBackScale,Category:"底图",MaxNum:5,MinNum:0.5,Step:0.01},
					{Type:ReflectionData.ComboBox,Label:"背景图开启:",GetFun:getIsBackPic,SetFun:setIsBackPic,Category:"底图",Data:[{name:"false"},{name:"true"}],SelectIndex:0},
				]
			
			return ary;
		}
		public function getHitBox():Point{
			
			
		
			return AppDataBone.hitBoxPoint
		}
		public function setHitBox(value:Point):void{


			AppDataBone.hitBoxPoint=value
			AppDataBone.role.hitBoxPoint = value;
			writeObj();
		}
		
		
		private var isBackPic:Boolean=true
		public function  getIsBackPic():int
		{
			return isBackPic?1:0
		}
		
		public function  setIsBackPic(value:Object):void
		{
			if(value.name=="true"){
				isBackPic=true
				AppDataBone.sceneLevel.drawLevel.setBackUrl(AppData.workSpaceUrl+FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl"))
			}else{
				isBackPic=false
				AppDataBone.sceneLevel.drawLevel.setBackUrl("")
			}
			
		}
		private var _backScale:Number=1
		public function getBackScale():Number{
			return _backScale;
		}
		public function setBackScale(value:Number):void{
			_backScale=value;
			AppDataBone.sceneLevel.drawLevel.setBackScale(_backScale)
	
		}
		public function get backPic():String
		{
			return FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl")
		}
		public function set backPic(value:String):void
		{
			FilePathManager.getInstance().setPathByUid("sceneBackBaseUrl",value)
			AppDataBone.sceneLevel.drawLevel.setBackUrl(AppData.workSpaceUrl+FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl"))
		}
		public function onSure():void{
			Scene_data.light.SunLigth.dircet=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			Scene_data.light.SunLigth.dircet.normalize()
				
			if(_sceneConfigData.SunLigth_dircet){
				_sceneConfigData.SunLigth_dircet=Scene_data.light.SunLigth.dircet
			}
				
			writeObj();
			this.refreshView();
			
		}
		public function getSunNrm():Vector3D{
			

				if(_sceneConfigData.SunLigth_dircet){
					Scene_data.light.SunLigth.dircet.x=_sceneConfigData.SunLigth_dircet.x
					Scene_data.light.SunLigth.dircet.y=_sceneConfigData.SunLigth_dircet.y
					Scene_data.light.SunLigth.dircet.z=_sceneConfigData.SunLigth_dircet.z
				
				}else{
					Scene_data.light.SunLigth.dircet=new Vector3D(0,1,0)
				}
					
		
			
			return Scene_data.light.SunLigth.dircet;
		}
		public function setSunNrm(value:Vector3D):void{
			if(Boolean(Scene_data.light.SunLigth.dircet)){
				Scene_data.light.SunLigth.dircet=new Vector3D(value.x,value.y,value.z)
				_sceneConfigData.SunLigth_dircet=Scene_data.light.SunLigth.dircet
					
			}
			
			
			writeObj();
		}
		
		public function getSunPow():Number{
			if(_sceneConfigData.SunLigth_intensity){
				Scene_data.light.SunLigth.intensity=_sceneConfigData.SunLigth_intensity
			}
				
			return Scene_data.light.SunLigth.intensity;
		}
		public function setSunPow(value:Number):void{
			
		
				
			Scene_data.light.SunLigth.intensity=value
				
			_sceneConfigData.SunLigth_intensity=Scene_data.light.SunLigth.intensity
				
			writeObj();
		}
		public function getAmbient():int{
			
			if(_sceneConfigData.AmbientLightColor){
				Scene_data.light.AmbientLight.color.x=_sceneConfigData.AmbientLightColor.x
				Scene_data.light.AmbientLight.color.y=_sceneConfigData.AmbientLightColor.y
				Scene_data.light.AmbientLight.color.z=_sceneConfigData.AmbientLightColor.z
			
			}
			
			return MathCore.argbToHex(0xff,Scene_data.light.AmbientLight.color.x,Scene_data.light.AmbientLight.color.y,Scene_data.light.AmbientLight.color.z)
			return 0xff00ff;
		}
		public function setAmbient(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.light.AmbientLight.color=p
				
			_sceneConfigData.AmbientLightColor=Scene_data.light.AmbientLight.color
				
			writeObj();
			
		}
		public function getAmbientPow():Number{
			if(_sceneConfigData.AmbientLight_intensity){
				Scene_data.light.AmbientLight.intensity=_sceneConfigData.AmbientLight_intensity
			}
			return Scene_data.light.AmbientLight.intensity;
		}
		public function setAmbientPow(value:Number):void{
			
			Scene_data.light.AmbientLight.intensity=value
				
			_sceneConfigData.AmbientLight_intensity=Scene_data.light.AmbientLight.intensity
			writeObj();
		}
		
		public function getSunColor():int{
			
			
			if(_sceneConfigData.SunLigth_color){
				Scene_data.light.SunLigth.color.x=_sceneConfigData.SunLigth_color.x
				Scene_data.light.SunLigth.color.y=_sceneConfigData.SunLigth_color.y
				Scene_data.light.SunLigth.color.z=_sceneConfigData.SunLigth_color.z
			}
			
			return MathCore.argbToHex(0xff,Scene_data.light.SunLigth.color.x,Scene_data.light.SunLigth.color.y,Scene_data.light.SunLigth.color.z)
			return 0xff00ff;
		}
		public function setSunColor(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.light.SunLigth.color=p
				
			_sceneConfigData.SunLigth_color=Scene_data.light.SunLigth.color
				
			writeObj();
		}
		
		
		
		public function getScaleNum():Number{
			return AppDataBone.fileScale;
		}
		public function setScaleNum(value:Number):void{
			if(value <= 0){
				value = 0.00001;
			}
			AppDataBone.fileScale = value;
			AppDataBone.role.fileScale = value;
			
			writeObj();
		}
		public function getTittleHeight():Number{
			
			return AppDataBone.tittleHeight
		}
		public function setTittleHeight(value:Number):void{
			AppDataBone.tittleHeight=value
			AppDataBone.role.tittleHeight = value;
			writeObj();
		}
	
		public function getShowTittleName():Boolean{
			return TittleLevel.visible;

		}
		public function setShowTittleName(value:Boolean):void{
			TittleLevel.visible=value
		}
		
		public function get skyUrl():String
		{
			//	return null
			if(Scene_data.light.SkyBoxUrl == ""){
				return "";
			}
			var DDD:MaterialCubeMap=CubeMapManager.getInstance().getCubeMapByUrl(Scene_data.fileRoot+Scene_data.light.SkyBoxUrl)
			if(DDD){
				return DDD.url;
			}else{
				return ""
			}
			
		}
		
		public function set skyUrl(value:String):void
		{
			Scene_data.light.SkyBoxUrl=value.replace(Scene_data.fileRoot,"");
			creatSky();
			_sceneConfigData.skyUrl = Scene_data.light.SkyBoxUrl;
			writeObj();
		}
		
		public function creatSky():void{
			loadCubeLut(AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl,"assets/brdf_ltu.jpg");
		}
		
		public function loadCubeLut($cubeUrl:String,$lutUrl:String):void{
			TextureManager.getInstance().addCubeTexture($cubeUrl,onCubeLoad,null);
			TextureManager.getInstance().addTexture($lutUrl,onLutTextureLoad,null);
		}
		
		private function onCubeLoad(textureVo:TextureCubeMapVo,info:Object):void{
			Scene_data.skyCubeMap = textureVo;
		}
		
		private function onLutTextureLoad(textureVo:TextureVo,info:Object):void{
			Scene_data.prbLutTexture = textureVo;
		}
		
		
		
		public function setEnvironment():void
		{
			writeObj();
			AppDataBone.usePostProcess = _sceneConfigData.openLater;
			PostProcessManager.getInstance().setHDRBloomScale(_sceneConfigData.highlightNum);
			PostProcessManager.getInstance().setUseHDR(false);
			PostProcessManager.getInstance().setHDRBloomRang(_sceneConfigData.highLightRang);
			PostProcessManager.getInstance().setPsData(_sceneConfigData);
		}
		
		public function SetEnvscale(value:Number):void{
			
			Scene_data.light.Envscale=value
			_sceneConfigData.Envscale = value;
			writeObj();
		}
		
		public function getEnvscale():Number{
			return Scene_data.light.Envscale;
		}
		
		public function  getOpenLater():int
		{
			return _sceneConfigData.openLater?1:0
		}
		
		public function  setOpenLater(value:Object):void
		{
			if(value.name=="true"){
				_sceneConfigData.openLater=true
			}else{
				_sceneConfigData.openLater=false
			}
			setEnvironment();
		}
		
		public function  getDistortion():int
		{
			return _sceneConfigData.distortion?1:0
		}
		
		public function  setDistortion(value:Object):void
		{
			if(value.name=="true"){
				_sceneConfigData.distortion=true
			}else{
				_sceneConfigData.distortion=false
			}
			setEnvironment();
		}
		
		public function getHighlightNum():Number{
			return _sceneConfigData.highlightNum;
		}
		public function setHighlightNum(value:Number):void{
			_sceneConfigData.highlightNum=value;
			setEnvironment();
		}
		
		public function getHighlightRang():Number{
			return _sceneConfigData.highLightRang;
		}
		public function setHighlightRang(value:Number):void{
			_sceneConfigData.highLightRang=value;
			setEnvironment();
		}
		
		public function  getUsePs():int
		{
			return _sceneConfigData.usePs?1:0
		}
		
		public function  setUsePs(value:Object):void
		{
			if(value.name=="true"){
				_sceneConfigData.usePs=true
			}else{
				_sceneConfigData.usePs=false
			}
			setEnvironment();
		}
		
		public function getBrightness():Number{
			return _sceneConfigData.brightness;
		}
		public function setBrightness(value:Number):void{
			_sceneConfigData.brightness=value;
			setEnvironment();
		}
		
		public function getContrast():Number{
			return _sceneConfigData.contrast;
		}
		public function setContrast(value:Number):void{
			_sceneConfigData.contrast=value;
			setEnvironment();
		}
		
		public function getAvaBrightness():Number{
			return _sceneConfigData.avaBrightness;
		}
		public function setAvaBrightness(value:Number):void{
			_sceneConfigData.avaBrightness=value;
			setEnvironment();
		}
		
		public function getSaturation():Number{
			return _sceneConfigData.saturation;
		}
		public function setSaturation(value:Number):void{
			_sceneConfigData.saturation=value;
			setEnvironment();
		}
		
		
		
		/**end***************/
	}
}
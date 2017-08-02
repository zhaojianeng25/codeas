package view.scene
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import _Pan3D.lineTri.LineTriGrildLevel;
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
	
	public class ScenePropView extends BaseReflectionView
	{
		public var obj:Object = new Object;
		public function ScenePropView()
		{
			super();
			initData();
			this.creat(pan3dMenu());
			this.refreshView();
		}
		
		private function initData():void{
			obj = new Object;
			obj.openLater = false;
			obj.highlightNum = 0.5;
			obj.highLightRang = 0.5;
			obj.usePs = false;
			obj.brightness = 0;
			obj.contrast = 1;
			obj.avaBrightness = 0.5;
			obj.saturation = 1;
			obj.distortion = false;
			//setEnvironment();
			
			
		}
		
		public function readObj():void{
			var file:File = new File(File.documentsDirectory.url + "/PaticleTool/sceneConfig.txt");
			if(file.exists){
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				obj = fs.readObject();
				fs.close();
				if(obj.skyUrl){
					this.skyUrl = obj.skyUrl;
				}
				
				Scene_data.light.Envscale= obj.Envscale;
				
				this.refreshView();
				setEnvironment();
			}else{
				initData();
			}
			
		}
		
		private function writeObj():void{
			var file:File = new File(File.documentsDirectory.url + "/PaticleTool/sceneConfig.txt");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
		}
		
		private function pan3dMenu():Array
		{
			var ary:Array =
				[
					
					{Type:ReflectionData.PreFabImg,Label:"环境cubemap:",key:"skyUrl",extensinonStr:"cube",closeBut:1,donotDubleClik:0,target:this,Category:"环境"},
					
					{Type:ReflectionData.Number,Label:"环境反射系数:",GetFun:getEnvscale,SetFun:SetEnvscale,Category:"环境",MaxNum:10,MinNum:1,Step:0.01},
					
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
					
//					{Type:ReflectionData.ComboBox,Label:"Vignett:",GetFun:getVignetteOpen,SetFun:setVignetteOpen,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
//					{Type:ReflectionData.Number,Label:"虚光半径 :",GetFun:getVignetteRadius,SetFun:setVignetteRadius,Category:"后期",MaxNum:2,MinNum:0,Step:0.01},
//					{Type:ReflectionData.Number,Label:"虚光模糊 :",GetFun:getVignetteBlur,SetFun:setVignetteBlur,Category:"后期",MaxNum:128,MinNum:0,Step:1},
//					{Type:ReflectionData.Number,Label:"虚光alpha :",GetFun:getVignetteAlpha,SetFun:setVignetteAlpha,Category:"后期",MaxNum:1,MinNum:0,Step:0.01},
					
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.ComboBox,Label:"开启扭曲:",GetFun:getDistortion,SetFun:setDistortion,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					
					{Type:ReflectionData.PreFabImg,Label:"背景图:",key:"backPic",extensinonStr:"jpg",closeBut:1,donotDubleClik:0,target:this,Category:"底图"},
					{Type:ReflectionData.Number,Label:"背景比例:",GetFun:getBackScale,SetFun:setBackScale,Category:"底图",MaxNum:5,MinNum:0.5,Step:0.01},
					{Type:ReflectionData.ComboBox,Label:"背景图开启:",GetFun:getIsBackPic,SetFun:setIsBackPic,Category:"底图",Data:[{name:"false"},{name:"true"}],SelectIndex:0},
					
					{Type:ReflectionData.ComboBox,Label:"特效显示等级:",GetFun:getEfLevel,SetFun:setEfLevel,Category:"底图",Data:[{name:"低配"},{name:"中配"},{name:"高配"}],SelectIndex:0},
				]
			
			return ary;
		}
		public function  getEfLevel():int
		{
			
			return Scene_data.effectsLev
		}
		public function  setEfLevel(value:Object):void
		{
			if(value.name=="高配"){
				Scene_data.effectsLev=2;
			}
			if(value.name=="中配"){
				Scene_data.effectsLev=1;
			}
			if(value.name=="低配"){
				Scene_data.effectsLev=0;
			}
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
				AppParticleData.sceneLevel.drawLevel.setBackUrl(AppData.workSpaceUrl+FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl"))
			}else{
				isBackPic=false
				AppParticleData.sceneLevel.drawLevel.setBackUrl("")
			}
			
		}
		private var _backScale:Number=1
		public function getBackScale():Number{
			return _backScale;
		}
		public function setBackScale(value:Number):void{
			_backScale=value;
			AppParticleData.sceneLevel.drawLevel.setBackScale(_backScale)
			
		}

		public function get backPic():String
		{
			return FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl")
		}
		public function set backPic(value:String):void
		{
		   FilePathManager.getInstance().setPathByUid("sceneBackBaseUrl",value)
		   AppParticleData.sceneLevel.drawLevel.setBackUrl(AppData.workSpaceUrl+FilePathManager.getInstance().getPathByUid("sceneBackBaseUrl"))
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
			obj.skyUrl = Scene_data.light.SkyBoxUrl;
			writeObj();
		}
		
		public function creatSky():void{
			loadCubeLut(Scene_data.fileRoot + Scene_data.light.SkyBoxUrl,"assets/brdf_ltu.jpg");
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
			AppParticleData.sceneLevel.usePostProcess = obj.openLater;
			PostProcessManager.getInstance().setHDRBloomScale(obj.highlightNum);
			PostProcessManager.getInstance().setUseHDR(false);
			PostProcessManager.getInstance().setHDRBloomRang(obj.highLightRang);
			PostProcessManager.getInstance().setPsData(obj);
		}
		
		public function SetEnvscale(value:Number):void{
			
			Scene_data.light.Envscale=value
			obj.Envscale = value;
			writeObj();
		}
		
		public function getEnvscale():Number{
			return Scene_data.light.Envscale;
		}
		
		public function  getOpenLater():int
		{
			return obj.openLater?1:0
		}
		
		public function  setOpenLater(value:Object):void
		{
			if(value.name=="true"){
				obj.openLater=true
			}else{
				obj.openLater=false
			}
			setEnvironment();
		}
		
		public function  getDistortion():int
		{
			return obj.distortion?1:0
		}
		
		public function  setDistortion(value:Object):void
		{
			if(value.name=="true"){
				obj.distortion=true
			}else{
				obj.distortion=false
			}
			setEnvironment();
		}
		
		public function getHighlightNum():Number{
			return obj.highlightNum;
		}
		public function setHighlightNum(value:Number):void{
			obj.highlightNum=value;
			setEnvironment();
		}
		
		public function getHighlightRang():Number{
			return obj.highLightRang;
		}
		public function setHighlightRang(value:Number):void{
			obj.highLightRang=value;
			setEnvironment();
		}
		
		public function  getUsePs():int
		{
			return obj.usePs?1:0
		}
		
		public function  setUsePs(value:Object):void
		{
			if(value.name=="true"){
				obj.usePs=true
			}else{
				obj.usePs=false
			}
			setEnvironment();
		}
		
		public function getBrightness():Number{
			return obj.brightness;
		}
		public function setBrightness(value:Number):void{
			obj.brightness=value;
			setEnvironment();
		}
		
		public function getContrast():Number{
			return obj.contrast;
		}
		public function setContrast(value:Number):void{
			obj.contrast=value;
			setEnvironment();
		}
		
		public function getAvaBrightness():Number{
			return obj.avaBrightness;
		}
		public function setAvaBrightness(value:Number):void{
			obj.avaBrightness=value;
			setEnvironment();
		}
		
		public function getSaturation():Number{
			return obj.saturation;
		}
		public function setSaturation(value:Number):void{
			obj.saturation=value;
			setEnvironment();
		}
		
		
		
		/**end***************/
	}
}
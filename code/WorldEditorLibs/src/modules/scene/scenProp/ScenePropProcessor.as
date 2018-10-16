package modules.scene.scenProp
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.flash_proxy;
	
	import PanV2.ConfigV2;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.light.LightVo;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_baseShowHidePanel;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.msg.event.scene.MEvent_ShowSceneProp;
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import manager.LayerManager;
	
	import materials.MaterialCubeMap;
	
	import modules.materials.CubeMapManager;
	import modules.scene.EnvironmentVo;
	
	import proxy.top.model.ISky;
	import proxy.top.render.Render;
	
	public class ScenePropProcessor extends Processor
	{
		private var _sceneProp:BaseReflectionView;
		public function ScenePropProcessor($module:Module)
		{
			super($module);
		}


		public function showHide($me:MEvent_baseShowHidePanel):void
		{
			if($me.action == MEvent_baseShowHidePanel.SHOW){
				
				if(!Scene_data.light){
					Scene_data.light=new LightVo;
				}
				//LayerManager.getInstance().addPanel(sceneCtrlView);
				if(!_sceneProp){
					
					_sceneProp = new BaseReflectionView;
					_sceneProp.creat(getView());
					
				}
				_sceneProp.init(this,"属性",2);
				LayerManager.getInstance().addPanel(_sceneProp,true);
		
				
				/*******test*******/
				
//				
//				var p2:BasePanel = new BasePanel;
//				p2.init(this,"文件",2);
//				LayerManager.getInstance().addPanel(p2);
				
//				var p3:BasePanel = new BasePanel;
//				p3.init(this,"地形",2);
//				LayerManager.getInstance().addPanel(p3);
				
			}
		}

		public function getGameAngle():int{
			return Scene_data.gameAngle;
		}
		public function setGameAngle(value:Number):void{
			Scene_data.gameAngle=value
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.ComboBox,Label:"抗锯齿:",GetFun:getAntiAlias,SetFun:SetAntiAlias,Category:"场景",Data:[{name:"0×"},{name:"2×"},{name:"4×"},{name:"16×"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"场景角度:",GetFun:getGameAngle,SetFun:setGameAngle,Category:"场景",MaxNum:360,MinNum:0,Step:1},
					{Type:ReflectionData.ColorPick,Label:"背景颜色:",GetFun:getClearColor,SetFun:setClearColor,Category:"场景"},
					
					{Type:ReflectionData.ColorPick,Label:"Ambient颜色:",GetFun:getAmbient,SetFun:setAmbient,Category:"灯光"},
					{Type:ReflectionData.Number,Label:"Ambient强度:",GetFun:getAmbientPow,SetFun:setAmbientPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.ColorPick,Label:"sun光颜色:",GetFun:getSunColor,SetFun:setSunColor,Category:"灯光"},
					
					{Type:ReflectionData.Number,Label:"sun强度:",GetFun:getSunPow,SetFun:setSunPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.Vec3,Label:"sun方向:",GetFun:getSunNrm,SetFun:setSunNrm,Category:"灯光"},
					{Type:ReflectionData.Btn,Label:"使用镜头法线",SetFun:onSure,Category:"灯光"},
			
				]

			ary=ary.concat(wuxiaoMenu());
			ary=ary.concat(sceneShowMenu());
			ary=ary.concat(pan3dMenu());
			ary=ary.concat(rayTraceMenu());
			
			return ary;
		}
		

		private function wuxiaoMenu():Array
		{
			var ary:Array =
				[
					
					//{Type:ReflectionData.Vec3,Label:"fogColor:",GetFun:getFogColor,SetFun:setFogColor,Category:"雾效"},
					
					{Type:ReflectionData.ColorPick,Label:"背景颜色:",GetFun:getFogColor,SetFun:setFogColor,Category:"雾效"},
					{Type:ReflectionData.CheckBox,Label:"关闭雾效:",GetFun:getShowFog,SetFun:setShowFog,Category:"雾效"},
					
					{Type:ReflectionData.Number,Label:"fogDistance:",GetFun:getFogDistance,SetFun:setFogDistance,Category:"雾效",MaxNum:5000,MinNum:0,Step:1},
				    {Type:ReflectionData.Number,Label:"fogAttenuation:",GetFun:getFogAttenuation,SetFun:setFogAttenuation,Category:"雾效",MaxNum:1,MinNum:0,Step:0.01},
					
					
					]
				
			return ary
		}
	
		public function setShowFog(value:Boolean):void{
			if(value){
			    if(!Scene_data.fogShowObj){
					Scene_data.fogShowObj=new Object
					Scene_data.fogShowObj.tempfogDistance=Scene_data.fogDistance
					Scene_data.fogShowObj.tempfogAttenuation=Scene_data.fogAttenuation
				}
				Scene_data.fogDistance=4000;
				Scene_data.fogAttenuation=0;
			}else{
				if(Scene_data.fogShowObj){
					Scene_data.fogDistance=Scene_data.fogShowObj.tempfogDistance
					Scene_data.fogAttenuation=Scene_data.fogShowObj.tempfogAttenuation
					Scene_data.fogShowObj=null;
				}
			}
		}
		
		public function getShowFog():Boolean{
			return true
		}
		
		private function sceneShowMenu():Array
		{
			var ary:Array =
				[
					
					//{Type:ReflectionData.Vec3,Label:"fogColor:",GetFun:getFogColor,SetFun:setFogColor,Category:"雾效"},
					
					{Type:ReflectionData.CheckBox,Label:"显示贴图:",GetFun:getShowTexture,SetFun:setShowTexture,Category:"显示"},
					{Type:ReflectionData.CheckBox,Label:"显示光照:",GetFun:getShowLightTexture,SetFun:setShowLightTexture,Category:"显示"},
					

				]
			
			return ary
		}
	
		
		private function rayTraceMenu():Array
		{
			var ary:Array =
				[
					
					//{Type:ReflectionData.Vec3,Label:"fogColor:",GetFun:getFogColor,SetFun:setFogColor,Category:"雾效"},
					//{Type:ReflectionData.Input,Label:"服务器:",GetFun:getServerUrl,SetFun:setServerUrl,Category:"光线追踪"},
					{Type:ReflectionData.PreFabImg,Label:"环境纹理:",key:"envImgUrl",extensinonStr:"jpg|png",target:this,Category:"光线追踪"},
					{Type:ReflectionData.CheckBox,Label:"使用环境色:",GetFun:getUseEnvTexture,SetFun:setUseEnvTexture,Category:"光线追踪"},
					{Type:ReflectionData.ColorPick,Label:"环境色:",GetFun:getEnvColor,SetFun:setEnvColor,Category:"光线追踪"},
					{Type:ReflectionData.CheckBox,Label:"pbr材质:",GetFun:getUseRayPbr,SetFun:setUseRayPbr,Category:"光线追踪"},
					{Type:ReflectionData.CheckBox,Label:"IBL光照:",GetFun:getUseRayIBL,SetFun:setUseRayIBL,Category:"光线追踪"},
					{Type:ReflectionData.CheckBox,Label:"抗锯齿:",GetFun:getUseRayAtlis,SetFun:setUseRayAtlis,Category:"光线追踪"},
					
					
				]
			
			return ary;
		}
		public function get envImgUrl():String
		{
			//	return null
			return Scene_data.rayTraceVo.envImg
		}
		
		public function set envImgUrl(value:String):void
		{
			Scene_data.rayTraceVo.envImg=value
		}
		
		public function getServerUrl():String
		{
			//	return null
			return  AppData.RenderSocketUrl;
		}
		
		public function setServerUrl(value:String):void
		{
			AppData.RenderSocketUrl=value;
		}
		
		

		
		public function setUseEnvTexture(tf:Boolean):void{
			Scene_data.rayTraceVo.useEnvColor = tf;
		}
		
		public function getUseEnvTexture():Boolean{
			return Scene_data.rayTraceVo.useEnvColor;
		}
		
		public function setEnvColor(value:Number):void{
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.rayTraceVo.envColor = p;
		}
		
		public function getEnvColor():Number{
			var p:Vector3D = Scene_data.rayTraceVo.envColor;
			return MathCore.argbToHex(0xff,p.x,p.y,p.z);
		}
		
		public function setUseRayPbr(tf:Boolean):void{
			Scene_data.rayTraceVo.usePbr = tf;
		}
		
		public function getUseRayPbr():Boolean{
			return Scene_data.rayTraceVo.usePbr;
		}
		
		public function setUseRayIBL(tf:Boolean):void{
			Scene_data.rayTraceVo.useIBL = tf;
		}
		
		public function getUseRayIBL():Boolean{
			return Scene_data.rayTraceVo.useIBL;
		}
		
		public function setUseRayAtlis(tf:Boolean):void{
			Scene_data.rayTraceVo.atlis = tf;
		}
		
		public function getUseRayAtlis():Boolean{
			return Scene_data.rayTraceVo.atlis;
		}
		
		
		public function setShowTexture(value:Boolean):void{
			Scene_data.showTexture = value;
		}
		
		public function getShowTexture():Boolean{
			return Scene_data.showTexture;
		}
		
		public function setShowLightTexture(value:Boolean):void{
			Scene_data.showLightmap = value;
		}
		
		public function getShowLightTexture():Boolean{
			return Scene_data.showLightmap;
		}
		
		public function setFogColor(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.fogColor=p
			
		}
		public function getFogColor():int{
			
			return MathCore.argbToHex(0xff,Scene_data.fogColor.x,Scene_data.fogColor.y,Scene_data.fogColor.z)
	
		}
		
		
		public function getFogDistance():Number{
			if(Scene_data.fogShowObj){
				return Scene_data.fogShowObj.tempfogDistance
			}
			return Scene_data.fogDistance
		}
		public function setFogDistance(value:Number):void{
			
			if(Scene_data.fogShowObj){
				Scene_data.fogDistance=Scene_data.fogShowObj.tempfogDistance
				Scene_data.fogAttenuation=Scene_data.fogShowObj.tempfogAttenuation
				Scene_data.fogShowObj=null;

			}else{
				Scene_data.fogDistance=value
				
			}
			
		

				
		}
		public function getFogAttenuation():Number{
			if(Scene_data.fogShowObj){
				return Scene_data.fogShowObj.tempfogAttenuation
			}
			return Scene_data.fogAttenuation
		}
		public function setFogAttenuation(value:Number):void{
	
			if(Scene_data.fogShowObj){
				Scene_data.fogDistance=Scene_data.fogShowObj.tempfogDistance
				Scene_data.fogAttenuation=Scene_data.fogShowObj.tempfogAttenuation
				Scene_data.fogShowObj=null;

				
			}else{
				
				Scene_data.fogAttenuation=value
				
			}

		}

		
		private function pan3dMenu():Array
		{
			var ary:Array =
				[

					{Type:ReflectionData.MaterialImg,Label:"环境cubemap:",key:"skyUrl",extensinonStr:"materials.MaterialCubeMap",closeBut:1,target:this,Category:"环境"},
					
					
					
					{Type:ReflectionData.ComboBox,Label:"显示天空盒:",GetFun:getUseSkyBox,SetFun:setUseSkyBox,Category:"环境",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"环境反射系数:",GetFun:getEnvscale,SetFun:SetEnvscale,Category:"环境",MaxNum:10,MinNum:1,Step:0.01},
					//{Type:ReflectionData.Number,Label:"环境衰减:",GetFun:getShuaijian,SetFun:setShuaijian,Category:"环境",MaxNum:1,MinNum:0,Step:0.01},
					//{Type:ReflectionData.Number,Label:"光传递增强:",GetFun:getZhenqiang,SetFun:setZhenqiang,Category:"环境",MaxNum:10,MinNum:0,Step:0.1},
					//{Type:ReflectionData.Number,Label:"颜色溢出:",GetFun:getYanseyichu,SetFun:setYanseyichu,Category:"环境",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"patch精细度:",GetFun:getPatchPrecision,SetFun:setPatchPrecision,Category:"环境",MaxNum:100,MinNum:1,Step:1},
					//{Type:ReflectionData.Number,Label:"光线传递次数:",GetFun:getLightPassNum,SetFun:setLightPassNum,Category:"环境",MaxNum:100,MinNum:1,Step:1},
					//{Type:ReflectionData.Number,Label:"阴影强度:",GetFun:getShadowIntensity,SetFun:setShadowIntensity,Category:"环境",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"AO强度:",GetFun:getAoIntensity,SetFun:setAoIntensity,Category:"环境",MaxNum:1,MinNum:0,Step:0.01},
					
					{Type:ReflectionData.ComboBox,Label:"开启后期:",GetFun:getOpenLater,SetFun:setOpenLater,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.Number,Label:"高光范围:",GetFun:getHighlightRang,SetFun:setHighlightRang,Category:"后期",MaxNum:1,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"高光强度:",GetFun:getHighlightNum,SetFun:setHighlightNum,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.ComboBox,Label:"开启HDR:",GetFun:getOpenHdr,SetFun:setOpenHdr,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"曝光比例:",GetFun:getExposureNum,SetFun:setExposureNum,Category:"后期",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.Number,Label:"白平衡:",GetFun:getWhiteBalance,SetFun:setWhiteBalance,Category:"后期",MaxNum:100,MinNum:0,Step:1},
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.ComboBox,Label:"开启调色:",GetFun:getUsePs,SetFun:setUsePs,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"亮度:",GetFun:getBrightness,SetFun:setBrightness,Category:"后期",MaxNum:20,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"对比度:",GetFun:getContrast,SetFun:setContrast,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"平均亮度:",GetFun:getAvaBrightness,SetFun:setAvaBrightness,Category:"后期",MaxNum:10,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"饱和度:",GetFun:getSaturation,SetFun:setSaturation,Category:"后期",MaxNum:5,MinNum:0,Step:0.01},
					{Type:ReflectionData.Gap,Category:"后期"},
					
					{Type:ReflectionData.ComboBox,Label:"Vignett:",GetFun:getVignetteOpen,SetFun:setVignetteOpen,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
					{Type:ReflectionData.Number,Label:"虚光半径 :",GetFun:getVignetteRadius,SetFun:setVignetteRadius,Category:"后期",MaxNum:2,MinNum:0,Step:0.01},
					{Type:ReflectionData.Number,Label:"虚光模糊 :",GetFun:getVignetteBlur,SetFun:setVignetteBlur,Category:"后期",MaxNum:128,MinNum:0,Step:1},
					{Type:ReflectionData.Number,Label:"虚光alpha :",GetFun:getVignetteAlpha,SetFun:setVignetteAlpha,Category:"后期",MaxNum:1,MinNum:0,Step:0.01},
					
					{Type:ReflectionData.Gap,Category:"后期"},
					{Type:ReflectionData.ComboBox,Label:"开启扭曲:",GetFun:getDistortion,SetFun:setDistortion,Category:"后期",Data:[{name:"false"},{name:"true"}],SelectIndex:1},
//					虚光半径 vignetteRadius 0-2
//					虚光模糊 vignetteBlur 0-128
//					虚光alpha vignetteAlpha 0-1
					
				]
			
			return ary;
		}
		
		public function  getDistortion():int
		{
			return EnvironmentVo.getInstance().distortion?1:0
		}
		
		public function  setDistortion(value:Object):void
		{
			if(value.name=="true"){
				EnvironmentVo.getInstance().distortion=true
			}else{
				EnvironmentVo.getInstance().distortion=false
			}
			//setEnvironment();
		}
		
		public function getVignetteRadius():Number{
			return EnvironmentVo.getInstance().vignetteRadius;
		}
		public function setVignetteRadius(value:Number):void{
			trace("vignetteRadius",value)
			EnvironmentVo.getInstance().vignetteRadius=value
		}
		public function getVignetteBlur():Number{
			return EnvironmentVo.getInstance().vignetteBlur;
		}
		public function setVignetteBlur(value:Number):void{
			
			EnvironmentVo.getInstance().vignetteBlur=value
		}
		public function getVignetteAlpha():Number{
			return EnvironmentVo.getInstance().vignetteAlpha;
		}
		public function setVignetteAlpha(value:Number):void{
			EnvironmentVo.getInstance().vignetteAlpha=value
		}
		
		public function  getVignetteOpen():int
		{
			return EnvironmentVo.getInstance().vignette?1:0
		}
		
		public function  setVignetteOpen(value:Object):void
		{
			if(value.name=="true"){
				EnvironmentVo.getInstance().vignette=true
			}else{
				EnvironmentVo.getInstance().vignette=false
			}
		}
		public function  getOpenLater():int
		{
			return EnvironmentVo.getInstance().openLater?1:0
		}
		
		public function  setOpenLater(value:Object):void
		{
			if(value.name=="true"){
				EnvironmentVo.getInstance().openLater=true
			}else{
				EnvironmentVo.getInstance().openLater=false
			}
		}
		public function  getOpenHdr():int
		{
			return EnvironmentVo.getInstance().openHdr?1:0
		}
		
		public function  setOpenHdr(value:Object):void
		{
			if(value.name=="true"){
				EnvironmentVo.getInstance().openHdr=true
			}else{
				EnvironmentVo.getInstance().openHdr=false
			}
		}
		public function getHighlightNum():Number{
			return EnvironmentVo.getInstance().highlightNum;
		}
		public function setHighlightNum(value:Number):void{
			
			EnvironmentVo.getInstance().highlightNum=value
		}
		
		public function getHighlightRang():Number{
			return EnvironmentVo.getInstance().highLightRang;
		}
		public function setHighlightRang(value:Number):void{
			
			EnvironmentVo.getInstance().highLightRang=value
		}
		
		public function getExposureNum():Number{
			return EnvironmentVo.getInstance().exposureNum;
		}
		public function setExposureNum(value:Number):void{
			
			EnvironmentVo.getInstance().exposureNum=value
		}
		public function getWhiteBalance():Number{
			return EnvironmentVo.getInstance().whiteBalance;
		}
		public function setWhiteBalance(value:Number):void{
			
			EnvironmentVo.getInstance().whiteBalance=value
		}
		
		
//		public function getUsePs():Boolean{
//			return EnvironmentVo.getInstance().usePs;
//		}
//		public function setUsePs(value:Boolean):void{
//			EnvironmentVo.getInstance().usePs=value;
//		}
//		
		public function  getUsePs():int
		{
			return EnvironmentVo.getInstance().usePs?1:0
		}
		
		public function  setUsePs(value:Object):void
		{
			if(value.name=="true"){
				EnvironmentVo.getInstance().usePs=true
			}else{
				EnvironmentVo.getInstance().usePs=false
			}
		}
		
		public function getBrightness():Number{
			return EnvironmentVo.getInstance().brightness;
		}
		public function setBrightness(value:Number):void{
			EnvironmentVo.getInstance().brightness=value
		}
		
		public function getContrast():Number{
			return EnvironmentVo.getInstance().contrast;
		}
		public function setContrast(value:Number):void{
			EnvironmentVo.getInstance().contrast=value
		}
		
		public function getAvaBrightness():Number{
			return EnvironmentVo.getInstance().avaBrightness;
		}
		public function setAvaBrightness(value:Number):void{
			EnvironmentVo.getInstance().avaBrightness=value
		}
		
		public function getSaturation():Number{
			return EnvironmentVo.getInstance().saturation;
		}
		public function setSaturation(value:Number):void{
			EnvironmentVo.getInstance().saturation=value
		}
		
//		obj.openLater=openLater
//		obj.highlightNum=highlightNum
//		obj.exposureNum=exposureNum
		public function getEnvscale():Number{
			return Scene_data.light.Envscale;
		}
		public function SetEnvscale(value:Number):void{
			
			Scene_data.light.Envscale=value
		}
		public function  getUseSkyBox():int
		{
			return Scene_data.light.ShowSkyBox?1:0
		}

		public function  setUseSkyBox(value:Object):void
		{
			if(value.name=="true"){
				Scene_data.light.ShowSkyBox=true
			}else{
				Scene_data.light.ShowSkyBox=false
			
			}
			_sky.visible=Scene_data.light.ShowSkyBox
		}

		
		public function get skyUrl():Object
		{
		//	return null
			return CubeMapManager.getInstance().getCubeMapByUrl(AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl);
		}
		
		public function set skyUrl(value:Object):void
		{
			Scene_data.light.SkyBoxUrl=CubeMapManager.getInstance().getUrlByCubeMap(MaterialCubeMap(value)).replace(AppData.workSpaceUrl,"")
			creatSky();
		}
		public function get vignetteUrl():String
		{
			return EnvironmentVo.getInstance().vignetteUrl
		}
		
		public function set vignetteUrl(value:String):void
		{
			EnvironmentVo.getInstance().vignetteUrl=value
		}
		
		
		private var _getSky:String
		public function onSure():void{
			Scene_data.light.SunLigth.dircet=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			Scene_data.light.SunLigth.dircet.normalize()
			_sceneProp.refreshView()

			
		}
		
		public function getSunNrm():Vector3D{
			
			if(!Boolean(Scene_data.light.SunLigth.dircet)){
				Scene_data.light.SunLigth.dircet=new Vector3D(0,1,0)
			}
			
			return Scene_data.light.SunLigth.dircet;
		}
		public function setSunNrm(value:Vector3D):void{
			if(Boolean(Scene_data.light.SunLigth.dircet)){
				Scene_data.light.SunLigth.dircet=new Vector3D(value.x,value.y,value.z)
			}
		}
		
		public function getV2d():Point{
			return new Point(200,-100);
		}
		
		public function getClearColor():int{
			
			return MathCore.argbToHex(0xff,Scene_data.light.ClearColor.x,Scene_data.light.ClearColor.y,Scene_data.light.ClearColor.z)
			return 0XFF00FF00;
		}
	
		
		public function getAmbientPow():Number{
			return Scene_data.light.AmbientLight.intensity;
		}
		public function setAmbientPow(value:Number):void{
			
			Scene_data.light.AmbientLight.intensity=value
		}
		public function getSunPow():Number{
			return Scene_data.light.SunLigth.intensity;
		}
		public function setSunPow(value:Number):void{
			
			Scene_data.light.SunLigth.intensity=value
		}
		public function getZhenqiang():Number{
			return Scene_data.light.Zhenqiang;
		}
		public function setZhenqiang(value:Number):void{
			
			Scene_data.light.Zhenqiang=value
		}
		public function getYanseyichu():Number{
			return Scene_data.light.Yanseyichu;
		}
		public function setYanseyichu(value:Number):void{
			
			Scene_data.light.Yanseyichu=value
		}
		public function getPatchPrecision():Number{
			return Scene_data.light.patchPrecision;
		}
		public function setPatchPrecision(value:Number):void{
			
			Scene_data.light.patchPrecision=value
		}
		public function getLightPassNum():Number{
			return Scene_data.light.lightPassNum;
		}
		public function setLightPassNum(value:Number):void{
			
			Scene_data.light.lightPassNum=value
		}
		public function getShadowIntensity():Number{
			return Scene_data.light.shadowIntensity;
		}
		public function setShadowIntensity(value:Number):void{
			
			Scene_data.light.shadowIntensity=value
		}
		
		public function getAoIntensity():Number{
			return AppData.Ao_strength;
		}
		public function setAoIntensity(value:Number):void{
			
			AppData.Ao_strength=value
		}
		
		public function getShuaijian():Number{
			return Scene_data.light.Shuaijian;
		}
		public function setShuaijian(value:Number):void{
			
			Scene_data.light.Shuaijian=value
		}
	
		
		public function getAntiAlias():int{
			return Scene_data.antiAlias;
		}

		
		public function getBool():Boolean{
			return true;
		}
		

		public function setClearColor(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.light.ClearColor=p

		}
		public function getAmbient():int{
			
			
			return MathCore.argbToHex(0xff,Scene_data.light.AmbientLight.color.x,Scene_data.light.AmbientLight.color.y,Scene_data.light.AmbientLight.color.z)
			return 0xff00ff;
		}
		public function setAmbient(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.light.AmbientLight.color=p
	
		}
		public function getSunColor():int{
			
			
			return MathCore.argbToHex(0xff,Scene_data.light.SunLigth.color.x,Scene_data.light.SunLigth.color.y,Scene_data.light.SunLigth.color.z)
			return 0xff00ff;
		}
		public function setSunColor(value:int):void{
			
			var p:Vector3D=MathCore.hexToArgb(value)
			Scene_data.light.SunLigth.color=p
		}
		
		public function SetAntiAlias(value:Object):void{

				
			switch(value.name)
			{
				case "0×":
					Scene_data.antiAlias=0
					break;
				case "2×":
					Scene_data.antiAlias=1
					break;
				case "4×":
					Scene_data.antiAlias=2
					break;
				case "16×":
					Scene_data.antiAlias=3
					break;
				default:
					Scene_data.antiAlias=0
					break;
			}
			LayerManager.getInstance().changeSize();
		}
		
		public function setLight(value:Boolean):void{
			
		}
		
		
		
		public function setPoint(pos:Point):void{
			
		}
		
		private var _sky:ISky;
		public function creatSky():void{
			if(AppData.type==1){
				if(!_sky){
					_sky = Render.creatSky("assets/obj/Sphere001.obj",AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl);
					_sky.scale = 70;
				}
				if(Scene_data.light.SkyBoxUrl){
					_sky.cubeMapUrl = AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl;
				}
			}
			
			Render.loadCubeLut(AppData.workSpaceUrl+Scene_data.light.SkyBoxUrl,"assets/brdf_ltu.jpg");
			
		}
		
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_ShowSceneProp,
				MEvent_ProjectData
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_ShowSceneProp:
					showHide($me as MEvent_ShowSceneProp);
					break;
				case MEvent_ProjectData:
					if($me.action == MEvent_ProjectData.PROJECT_SAVE_GET_DATA){
						Scene_data.light = new LightVo();
						Scene_data.light.writeObject(AppData.light);
						EnvironmentVo.getInstance().objToEnvironment(AppData.environment)
						
						if(AppData.type==1){
							creatSky();
							_sky.visible=Scene_data.light.ShowSkyBox
						}
						_sceneProp.refreshView();

					}else if($me.action == MEvent_ProjectData.PROJECT_SAVE_SET_DATA){
						AppData.light = Scene_data.light.readObject();
					}
					break;
			}
		}
		
	}
}
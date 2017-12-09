package mvc.project
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.light.LightVo;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_baseShowHidePanel;
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import manager.LayerManager;
	
	public class ProjectProcessor extends Processor
	{
		private var _sceneProp:BaseReflectionView;
		public function ProjectProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				ProjectEvent,

			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
	
				case ProjectEvent:
		
					if($me.action==ProjectEvent.SHOW_PROJECT_AMBIENT){
						this.showProject()
					}
					
					break;
			}
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.ComboBox,Label:"抗锯齿:",GetFun:getAntiAlias,SetFun:SetAntiAlias,Category:"场景",Data:[{name:"24fps"},{name:"30fps"},{name:"36fps"},{name:"60fps"}],SelectIndex:1},

					{Type:ReflectionData.ColorPick,Label:"背景颜色:",GetFun:getClearColor,SetFun:setClearColor,Category:"场景"},
					
					{Type:ReflectionData.ColorPick,Label:"Ambient颜色:",GetFun:getAmbient,SetFun:setAmbient,Category:"灯光"},
					{Type:ReflectionData.Number,Label:"Ambient强度:",GetFun:getAmbientPow,SetFun:setAmbientPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.ColorPick,Label:"sun光颜色:",GetFun:getSunColor,SetFun:setSunColor,Category:"灯光"},
					
					{Type:ReflectionData.Number,Label:"sun强度:",GetFun:getSunPow,SetFun:setSunPow,Category:"灯光",MaxNum:20,MinNum:0,Step:0.1},
					{Type:ReflectionData.Vec3,Label:"sun方向:",GetFun:getSunNrm,SetFun:setSunNrm,Category:"灯光"},
					{Type:ReflectionData.Btn,Label:"使用镜头法线",SetFun:onSure,Category:"灯光"},
					
				]
			

			
			return ary;
		}
		public function onSure():void{
			Scene_data.light.SunLigth.dircet=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			Scene_data.light.SunLigth.dircet.normalize()
			_sceneProp.refreshView()
			
			
		}
		public function SetAntiAlias(value:Object):void{
			
			
			switch(value.name)
			{
				case "24fps":
					AppDataFrame.frameSpeed=24
					break;
				case "30fps":
					AppDataFrame.frameSpeed=30
					break;
				case "36fps":
					AppDataFrame.frameSpeed=36
					break;
				case "60fps":
					AppDataFrame.frameSpeed=60
					break;
				default:
					AppDataFrame.frameSpeed=24
					break;
			}
			LayerManager.getInstance().changeSize();
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
			
			switch(AppDataFrame.frameSpeed)
			{
				case 24:
				{
					return 0;
					break;
				}
				case 30:
				{
					return 1;
					break;
				}
				case 36:
				{
					return 2;
					break;
				}
				case 60:
				{
					return 3;
					break;
				}
					
				default:
				{
					return 1;
					break;
				}
			}
			return 1;
	
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
		
		private function showProject():void
		{

			if(!Scene_data.light){
				Scene_data.light=new LightVo;
			}
			if(!_sceneProp){
				_sceneProp = new BaseReflectionView;
				_sceneProp.creat(getView());
			}
			_sceneProp.init(this,"属性",2);
			LayerManager.getInstance().addPanel(_sceneProp,true);
		
		}

		
	}
}
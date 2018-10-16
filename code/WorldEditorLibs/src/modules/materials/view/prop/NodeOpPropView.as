package modules.materials.view.prop
{
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.ResultNodeUI;
	
	public class NodeOpPropView extends BaseReflectionView
	{
		private var _ui:ResultNodeUI;
		public function NodeOpPropView()
		{
			super();
			this.creat(getView());
		}
		
		public function showProp($ui:ResultNodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.ComboBox,Label:"blendMode:",GetFun:getValue,SetFun:setValue,Category:"属性",Data:[{name:"0",type:0},{name:"1",type:1},{name:"2",type:2},{name:"3",type:3},{name:"4",type:4}]},
					{Type:ReflectionData.Number,Label:"kill:",GetFun:getKill,SetFun:setKill,Category:"属性",MaxNum:1,MinNum:0},
					{Type:ReflectionData.CheckBox,Label:"背面剔除:",GetFun:getBackCull,SetFun:setBackCull,Category:"属性"},
					{Type:ReflectionData.CheckBox,Label:"写入Zbuffer:",GetFun:getZbuffer,SetFun:setZbuffer,Category:"属性"},
					{Type:ReflectionData.CheckBox,Label:"动态IBL:",GetFun:getIBL,SetFun:setIBL,Category:"属性"},
					{Type:ReflectionData.Number,Label:"normalScale",GetFun:getNormalScale,SetFun:setNormalScale,Category:"属性",MaxNum:1,MinNum:0},
					{Type:ReflectionData.CheckBox,Label:"LightProbe:",GetFun:getLightProbe,SetFun:setLightProbe,Category:"属性"},
					{Type:ReflectionData.CheckBox,Label:"直接光照:",GetFun:getDirectLight,SetFun:setDirectLight,Category:"属性"},
					{Type:ReflectionData.CheckBox,Label:"无光照:",GetFun:getNoLight,SetFun:setNoLight,Category:"属性"},
					{Type:ReflectionData.CheckBox,Label:"光照缩放:",GetFun:getScaleLightMap,SetFun:setScaleLightMap,Category:"属性"},
					{Type:ReflectionData.ComboBox,Label:"雾模式:",GetFun:getFogValue,SetFun:setFogValue,Category:"属性",Data:[{name:"无",type:0},{name:"镜头距离",type:1},{name:"y模式",type:2}]},
					{Type:ReflectionData.CheckBox,Label:"HDR:",GetFun:getHdr,SetFun:setHdr,Category:"属性"},
				]
			
			return ary;
		}
		
		public function getValue():int{
			if(_ui){
				return _ui.blenderMode;
			}else{
				return 0;
			}
		}
		
		public function setValue(value:Object):void{
			if(_ui){
				_ui.blenderMode = value.type;
			}
		}
		
		public function getFogValue():int{
			if(_ui){
				return _ui.fogMode;
			}else{
				return 0;
			}
		}
		
		public function setFogValue(value:Object):void{
			if(_ui){
				_ui.fogMode = value.type;
			}
		}
		
		public function getKill():Number{
			if(_ui){
				return _ui.killNum;
			}else{
				return 0;
			}
		}
		
		public function setKill(value:Number):void{
			if(_ui){
				_ui.killNum = value;
			}
		}
		
		public function getBackCull():Boolean{
			if(_ui){
				return _ui.backCull;
			}else{
				return true;
			}
		}
		
		public function setBackCull(value:Boolean):void{
			if(_ui){
				_ui.backCull = value;
			}
		}
		
		public function getZbuffer():Boolean{
			if(_ui){
				return _ui.writeZbuffer;
			}else{
				return true;
			}
		}
		
		public function setZbuffer(value:Boolean):void{
			if(_ui){
				_ui.writeZbuffer = value;
			}
		}
		
		public function getIBL():Boolean{
			if(_ui){
				return _ui.useDynamicIBL;
			}else{
				return true;
			}
		}
		
		public function setIBL(value:Boolean):void{
			if(_ui){
				_ui.useDynamicIBL = value;
			}
		}
		
		public function getNormalScale():Number{
			if(_ui){
				return _ui.normalScale;
			}else{ 
				return 1;
			}
		}
		
		public function setNormalScale(value:Number):void{
			if(_ui){
				_ui.normalScale = value;
			}
		}
		
		public function getLightProbe():Boolean{
			if(_ui){
				return _ui.lightProbe;
			}else{
				return true;
			}
		}
		
		public function setLightProbe(value:Boolean):void{
			if(_ui){
				_ui.lightProbe = value;
			}
		}
		
		public function getDirectLight():Boolean{
			if(_ui){
				return _ui.directLight;
			}else{
				return true;
			}
		}
		
		public function setDirectLight(value:Boolean):void{
			if(_ui){
				_ui.directLight = value;
			}
		}
		
		public function getNoLight():Boolean{
			if(_ui){
				return _ui.noLight;
			}else{
				return true;
			}
		}
		
		public function setNoLight(value:Boolean):void{
			if(_ui){
				_ui.noLight = value;
			}
		}
		public function getScaleLightMap():Boolean{
			if(_ui){
				return _ui.scaleLightMap;
			}else{
				return true;
			}
		}
		
		public function setScaleLightMap(value:Boolean):void{
			if(_ui){
				_ui.scaleLightMap = value;
			}
		}
		
		public function getHdr():Boolean{
			if(_ui){
				return _ui.hdr;
			}else{
				return true;
			}
		}
		
		public function setHdr(value:Boolean):void{
			if(_ui){
				_ui.hdr = value;
			}
		}
		
		
	}
}
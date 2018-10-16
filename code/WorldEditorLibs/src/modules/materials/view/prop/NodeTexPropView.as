package modules.materials.view.prop
{
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.TextureSampleNodeUI;
	
	public class NodeTexPropView extends BaseReflectionView
	{
		private var _ui:TextureSampleNodeUI;
		public function NodeTexPropView()
		{
			super();
			this.creat(getView());
		}
		
		public function showProp($ui:TextureSampleNodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.PreFabImg,Label:"贴图:",key:"url",extensinonStr:"jpg|png",target:this,Category:"属性"},
					{Type:ReflectionData.ComboBox,Label:"Wrap:",GetFun:getValue,SetFun:setValue,Category:"属性",Data:[{name:"repeat",type:0},{name:"clamp",type:1}]},
					{Type:ReflectionData.ComboBox,Label:"Mipmap:",GetFun:getMipmapValue,SetFun:setMipmapValue,Category:"属性",Data:[{name:"no",type:0},{name:"mipnearest",type:1},{name:"miplinear",type:2}]},
					{Type:ReflectionData.ComboBox,Label:"filter:",GetFun:getFilterValue,SetFun:setFilterValue,Category:"属性",Data:[{name:"linear",type:0},{name:"nearest",type:1}]},
					{Type:ReflectionData.ComboBox,Label:"预乘:",GetFun:getPermulValue,SetFun:setPermulValue,Category:"属性",Data:[{name:"false",type:0},{name:"true",type:1}]},
				]
			return ary;
		}
		public function get url():String
		{
			//	return null
			return _ui.url
		}
		
		public function set url(value:String):void
		{
			_ui.url=value
		}
		
		public function getValue():int{
			if(_ui){
				return _ui.wrap;
			}else{
				return 0;
			}
		}
		
		public function setValue(value:Object):void{
			if(_ui){
				_ui.wrap = value.type;
			}
		}
		
		public function getMipmapValue():int{
			if(_ui){
				return _ui.mipmap;
			}else{
				return 0;
			}
		}
		
		public function setMipmapValue(value:Object):void{
			if(_ui){
				_ui.mipmap = value.type;
			}
		}
		
		public function getFilterValue():int{
			if(_ui){
				return _ui.filter;
			}else{
				return 0;
			}
		}
		
		public function setFilterValue(value:Object):void{
			if(_ui){
				_ui.filter = value.type;
			}
		}
		
		public function getPermulValue():int{
			if(_ui){
				if(_ui.permul){
					return 1;
				}else{
					return 0;
				}
			}else{
				return 0;
			}
		}
		
		public function setPermulValue(value:Object):void{
			if(_ui){
				_ui.permul = value.type;
			}
		}
		
		
	}
}
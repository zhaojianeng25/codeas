package modules.materials.view.prop
{
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.constnum.ConstVec3NodeUI;
	
	public class NodeVec3PropView extends BaseReflectionView
	{
		private var _ui:ConstVec3NodeUI;
		public function NodeVec3PropView()
		{
			super();
			this.creat(getView());
		}
		
		public function showProp($ui:ConstVec3NodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.Vec3Color,Label:"数值:",GetFun:getValue,SetFun:setValue,Category:"Vec属性",Step:0.01},
				]
			
			return ary;
		}
		
		public function getValue():Vector3D{
			if(_ui){
				return _ui.constValue; 
			}else{
				return new Vector3D;
			}
			
		} 
		
		public function setValue(value:Vector3D):void{
			if(_ui){
				_ui.constValue = value;
			}
		}
		
		
		
	}
}
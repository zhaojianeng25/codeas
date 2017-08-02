package modules.materials.view.prop
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.constnum.ConstVec2NodeUI;
	
	public class NodeVec2PropView extends BaseReflectionView
	{
		private var _ui:ConstVec2NodeUI;
		public function NodeVec2PropView()
		{
			super();
			this.creat(getView());
		}
		public function showProp($ui:ConstVec2NodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.Vec2,Label:"数值:",GetFun:getValue,SetFun:setValue,Category:"Vec2属性"},
				]
			
			return ary;
		}
		
		public function getValue():Point{
			if(_ui){
				return _ui.constValue;
			}else{
				return new Point;
			}
			
		}
		
		public function setValue(value:Point):void{
			if(_ui){
				_ui.constValue = value;
			}
		}
	}
}
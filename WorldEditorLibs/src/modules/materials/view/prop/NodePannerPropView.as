package modules.materials.view.prop
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.constnum.ConstVec2NodeUI;
	import modules.materials.view.constnum.PannerNodeUI;
	
	public class NodePannerPropView extends BaseReflectionView
	{
		private var _ui:PannerNodeUI;
		public function NodePannerPropView()
		{
			super();
			this.creat(getView());
		}
		public function showProp($ui:PannerNodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.Vec2,Label:"平铺:",GetFun:getCoordinateValue,SetFun:setCoordinateValue,Category:"属性"},
					{Type:ReflectionData.Vec2,Label:"速度:",GetFun:getSpeedValue,SetFun:setSpeedValue,Category:"属性"},
				]
			
			return ary;
		}
		
		public function getCoordinateValue():Point{
			if(_ui){
				return _ui.coordinate;
			}else{
				return new Point;
			}
			
		}
		
		public function setCoordinateValue(value:Point):void{
			if(_ui){
				_ui.coordinate = value;
			}
		}
		
		public function getSpeedValue():Point{
			if(_ui){
				return _ui.speed;
			}else{
				return new Point;
			}
			
		}
		
		public function setSpeedValue(value:Point):void{
			if(_ui){
				_ui.speed = value;
			}
		}
		
	}
}
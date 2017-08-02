package modules.materials.view.prop
{
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import modules.materials.view.constnum.TimeNodeUI;
	import modules.materials.view.mathNode.MathMinNodeUI;
	
	public class NodeMinPropView extends BaseReflectionView
	{
		private var _ui:MathMinNodeUI
		public function NodeMinPropView()
		{
			super();
			this.creat(getView());
		}
		
		public function showProp($ui:MathMinNodeUI):void{
			_ui = $ui;
			refreshView();
		}
		
		public function getView():Array{
			
			
			var ary:Array =
				[
					{Type:ReflectionData.Number,Label:"数值:",GetFun:getValue,Step:0.1,SetFun:setValue,Category:"Num属性"},
				]
			
			return ary;
		}
		
		public function getValue():Number{
			if(_ui){
				return _ui.value;
			}else{
				return 0;
			}
			
		}
		
		public function setValue(value:Number):void{
			if(_ui){
				_ui.value = value;
			}
		}
	}
}
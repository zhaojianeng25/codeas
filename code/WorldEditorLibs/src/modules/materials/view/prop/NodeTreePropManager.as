package modules.materials.view.prop
{
	import com.zcp.frame.Processor;
	
	import mx.core.UIComponent;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ResultNodeUI;
	import modules.materials.view.TextureSampleNodeUI;
	import modules.materials.view.constnum.ConstFloatNodeUI;
	import modules.materials.view.constnum.ConstVec2NodeUI;
	import modules.materials.view.constnum.ConstVec3NodeUI;
	import modules.materials.view.constnum.PannerNodeUI;
	import modules.materials.view.constnum.TimeNodeUI;
	import modules.materials.view.mathNode.MathMinNodeUI;

	public class NodeTreePropManager
	{
		private var _vec3Prop:NodeVec3PropView;
		private var _vec2Prop:NodeVec2PropView;
		private var _floatProp:NodeFloatPropView;
		private var _timeProp:NodeTimePropView;
		private var _opProp:NodeOpPropView;
		private var _texProp:NodeTexPropView;
		private var _pannerProp:NodePannerPropView;
		private var _minProp:NodeMinPropView;
		private var _process:Processor;
		
		public var container:UIComponent;
		private static var instance:NodeTreePropManager;
		
		public function NodeTreePropManager()
		{
			
		}
		
		public static function getInstance():NodeTreePropManager{
			if(!instance){
				instance = new NodeTreePropManager();
			}
			return instance;
		}
		
		public function init($process:Processor):void{
			_process = $process;
			
			_vec3Prop = new NodeVec3PropView;
			_vec3Prop.init(_process,"属性",2);
			
			_vec2Prop = new NodeVec2PropView;
			_vec2Prop.init(_process,"属性",2);
			
			_floatProp = new NodeFloatPropView;
			_floatProp.init(_process,"属性",2);
			
			_timeProp = new NodeTimePropView;
			_timeProp.init(_process,"属性",2);
			
			_opProp = new NodeOpPropView;
			_opProp.init(_process,"属性",2);
			
			_texProp = new NodeTexPropView;
			_texProp.init(_process,"属性",2);
			
			_pannerProp = new NodePannerPropView;
			_pannerProp.init(_process,"属性",2);
			
			
			_minProp = new NodeMinPropView;
			_minProp.init(_process,"属性",2);
		}
		
		public function showNode($ui:BaseMaterialNodeUI):void{
			
			while(container.numChildren){
				container.removeChildAt(0)
			}
			switch($ui.nodeTree.type){
				case NodeTree.VEC3:
					//LayerManager.getInstance().showPropPanle(_vec3Prop);
					container.addChild(_vec3Prop);
					_vec3Prop.showProp($ui as ConstVec3NodeUI);
					container.height=150;
					break;
				case NodeTree.VEC2:
					//LayerManager.getInstance().showPropPanle(_vec2Prop);
					container.addChild(_vec2Prop);
					_vec2Prop.showProp($ui as ConstVec2NodeUI);
					container.height=150;
					break;
				case NodeTree.FLOAT:
					//LayerManager.getInstance().showPropPanle(_floatProp);
					container.addChild(_floatProp);
					_floatProp.showProp($ui as ConstFloatNodeUI);
					container.height=150;
					break;
				case NodeTree.TIME:
					//LayerManager.getInstance().showPropPanle(_timeProp);
					container.addChild(_timeProp);
					_timeProp.showProp($ui as TimeNodeUI);
					container.height=150;
					break;
				case NodeTree.OP:
					//LayerManager.getInstance().showPropPanle(_opProp);
					container.addChild(_opProp);
					_opProp.showProp($ui as ResultNodeUI);
					container.height=350;
					break;
				case NodeTree.TEX:
					container.addChild(_texProp);
					_texProp.showProp($ui as TextureSampleNodeUI);
					container.height=280;
					break;
				case NodeTree.PANNER:
					container.addChild(_pannerProp);
					_pannerProp.showProp($ui as PannerNodeUI);
					container.height=200;
					break;
				case NodeTree.MIN:
					container.addChild(_minProp);
					_minProp.showProp($ui as MathMinNodeUI);
					container.height=200;
					break;
			}
			
		
		}
		
		
	}
}
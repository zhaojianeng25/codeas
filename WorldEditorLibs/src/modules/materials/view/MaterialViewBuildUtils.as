package modules.materials.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import common.msg.event.materials.MEvent_Material_Connect;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.view.constnum.ConstFloatNodeUI;
	import modules.materials.view.constnum.ConstVec2NodeUI;
	import modules.materials.view.constnum.ConstVec3NodeUI;
	import modules.materials.view.constnum.FresnelNodeUI;
	import modules.materials.view.constnum.HeightInfoNodeUI;
	import modules.materials.view.constnum.PannerNodeUI;
	import modules.materials.view.constnum.ParticleColorNodeUI;
	import modules.materials.view.constnum.RefractionNodeUI;
	import modules.materials.view.constnum.TexCoordNodeUI;
	import modules.materials.view.constnum.TimeNodeUI;
	import modules.materials.view.constnum.VertexColorNodeUI;
	import modules.materials.view.mathNode.MathAddNodeUI;
	import modules.materials.view.mathNode.MathCosNodeUI;
	import modules.materials.view.mathNode.MathDivNodeUI;
	import modules.materials.view.mathNode.MathLerpNodeUI;
	import modules.materials.view.mathNode.MathMinNodeUI;
	import modules.materials.view.mathNode.MathMulNodeUI;
	import modules.materials.view.mathNode.MathSinNodeUI;
	import modules.materials.view.mathNode.MathSubNodeUI;

	public class MaterialViewBuildUtils
	{
		public var addFun:Function;
		private var _dataAry:Array;
		private var _uiVec:Vector.<BaseMaterialNodeUI>;
		public function MaterialViewBuildUtils()
		{
		}
		
		public function setData(ary:Array):void{
			
			_uiVec = new Vector.<BaseMaterialNodeUI>;
			
			if(!ary){
				var ui:BaseMaterialNodeUI = getUI(NodeTree.OP);
				addFun(ui);
				_uiVec.push(ui);
				ui.x = 500;
				ui.y = 100;
			}else{
				for(var i:int;i<ary.length;i++){
					ui = getUI(ary[i].type);
					ui.setData(ary[i].data);
					ui.setInItemByData(ary[i].inAry);
					ui.setOutItemByData(ary[i].outAry);
					ui.nodeTree.id = ary[i].id;
					addFun(ui);
					_uiVec.push(ui);
				}
				_dataAry = ary;
				drawLine();
			}
			
			
			
		}
		
		public function drawLine():void{
			for(var i:int;i<_dataAry.length;i++){
				var inAry:Array = _dataAry[i].inAry;
				for(var j:int=0;j<inAry.length;j++){
					if(!inAry[j].parentObj){
						continue;
					}
					var endNode:ItemMaterialUI = getUIbyID(_dataAry[i].id,inAry[j].id,true);
					var startNode:ItemMaterialUI = getUIbyID(inAry[j].parentObj.pid,inAry[j].parentObj.id,false);
					if(endNode.type == MaterialItemType.UNDEFINE){
						endNode.changeType(startNode.type);
					}
					
					var evt:MEvent_Material_Connect = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_DOUBLUELINE);
					evt.startNode = startNode;
					evt.endNode = endNode;
					ModuleEventManager.dispatchEvent(evt);
					
				}
			}
		}
		
		public function getUIbyID($pid:int,$id:int,$inout:Boolean):ItemMaterialUI{
			var ui:BaseMaterialNodeUI = getNodeUI($pid);
			if($inout){
				return ui.getInItem($id);
			}else{
				return ui.getOutItem($id);
			}
		}
		
		private function getNodeUI($pid:int):BaseMaterialNodeUI{
			for(var i:int;i<_uiVec.length;i++){
				if(_uiVec[i].nodeTree.id == $pid){
					return _uiVec[i];
				}
			}
			return null;
		}
		
		public function getUI(type:String):BaseMaterialNodeUI{
			var ui:BaseMaterialNodeUI;
			switch(type){
				case NodeTree.OP:
					ui = new ResultNodeUI();
					break;
				case NodeTree.TEX:
					ui = new TextureSampleNodeUI();
					break;
				case NodeTree.ADD:
					ui = new MathAddNodeUI;
					break;
				case NodeTree.SUB:
					ui = new MathSubNodeUI;
					break;
				case NodeTree.MUL:
					ui = new MathMulNodeUI;
					break;
				case NodeTree.DIV:
					ui = new MathDivNodeUI;
					break;
				case NodeTree.LERP:
					ui = new MathLerpNodeUI;
					break;
				case NodeTree.SIN:
					ui = new MathSinNodeUI;
					break;
				case NodeTree.COS:
					ui = new MathCosNodeUI;
					break;
				case NodeTree.VEC3:
					ui = new ConstVec3NodeUI;
					break;
				case NodeTree.VEC2:
					ui = new ConstVec2NodeUI;
					break;
				case NodeTree.FLOAT:
					ui = new ConstFloatNodeUI;
					break;
				case NodeTree.TIME:
					ui = new TimeNodeUI;
					break;
				case NodeTree.TEXCOORD:
					ui = new TexCoordNodeUI;
					break;
				case NodeTree.PTCOLOR:
					ui = new ParticleColorNodeUI;
					break;
				case NodeTree.VERCOLOR:
					ui = new VertexColorNodeUI;
					break;
				case NodeTree.HEIGHTINFO:
					ui = new HeightInfoNodeUI;
					break;
				case NodeTree.FRESNEL:
					ui = new FresnelNodeUI;
					break;
				case NodeTree.REFRACTION:
					ui = new RefractionNodeUI;
					break;
				case NodeTree.PANNER:
					ui = new PannerNodeUI;
					break;
				case NodeTree.MIN:
					ui = new MathMinNodeUI;
					break;
			}
			
			return ui;
		}
	}
}
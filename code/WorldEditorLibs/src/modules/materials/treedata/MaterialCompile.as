package modules.materials.treedata
{
	import spark.components.Alert;
	
	import materials.MaterialTree;

	public class MaterialCompile
	{
		public var nodeList:Vector.<NodeTree>;
		
		public var priorityList:Vector.<Vector.<NodeTree>>;
		
		public var maxPriority:int;
		
		private var fragmentTempList:Vector.<RegisterItem>;
		private var fragmentTexList:Vector.<RegisterItem>;
		private var fragmentConstList:Vector.<RegisterItem>;
		
		private var _compileServer:CompileOne = new CompileOne;
		
		private var _compileGlslServer:CompileTwo = new CompileTwo;
		
		public function MaterialCompile()
		{
			
		}
		
		public function compile($list:Vector.<NodeTree>,$materialTree:MaterialTree,$materialGLSLTree:MaterialTree):void{
			nodeList = $list;
			resetCompile($list);
			resetPriority();
			var opNode:NodeTree = getOpNode();
			opNode.priority = 0;
			setPriority(opNode);
			
			priorityList = new Vector.<Vector.<NodeTree>>;
			for(var i:int;i<=maxPriority;i++){
				priorityList.push(new Vector.<NodeTree>);
			}
			
			for(i = 0;i<nodeList.length;i++){
				if(nodeList[i].priority < 0){
					continue;
				}
				if(!nodeList[i].checkInput()){
					Alert.show("不完整的输入" + nodeList[i].type);
					return;
				}
			}
			
			for(i = 0;i<nodeList.length;i++){
				if(nodeList[i].priority < 0){
					continue;
				}
				priorityList[nodeList[i].priority].push(nodeList[i]);
			}
			
			_compileServer.compile(priorityList,$materialTree);
			
			resetCompile($list);
			
			_compileGlslServer.compile(priorityList,$materialGLSLTree);
		}
		
		public function resetCompile($list:Vector.<NodeTree>):void{
			for(var i:int = 0;i<$list.length;i++){
				var inputVec:Vector.<NodeTreeInputItem> = $list[i].inputVec;
				for(var j:int=0;j<inputVec.length;j++){
					inputVec[j].hasCompiled = false;
				}
			}
		}
		
		
		
		public function traceInfo():void{
			for(var i:int;i<nodeList.length;i++){
				trace(nodeList[i]);
			}
		}
		
		public function setPriority($node:NodeTree):void{
			var inputVec:Vector.<NodeTreeInputItem> = $node.inputVec;
			for(var i:int;i<inputVec.length;i++){
				var parentNodeItem:NodeTreeOutoutItem = inputVec[i].parentNodeItem;
				if(parentNodeItem){
					var pNode:NodeTree = parentNodeItem.node;
					if(pNode.priority < ($node.priority + 1)){
						pNode.priority = ($node.priority + 1);
					}
					maxPriority = Math.max(maxPriority,pNode.priority);
					setPriority(pNode);
				}
			}
		}
		
		public function getOpNode():NodeTree{
			for(var i:int;i<nodeList.length;i++){
				if(nodeList[i].type == NodeTree.OP){
					return nodeList[i];
				}
			}
			return null;
		}
		
		public function resetPriority():void{
			for(var i:int;i<nodeList.length;i++){
				if(nodeList[i].type != NodeTree.OP){
					nodeList[i].priority = -1;
				}else{
					nodeList[i].priority = 0;
				}
			}
		}
		
	}
}
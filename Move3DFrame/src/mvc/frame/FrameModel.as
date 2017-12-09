package mvc.frame
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import mvc.frame.line.FrameLinePointSprite;
	import mvc.frame.line.FrameLinePointVo;
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.view.FramePanel;
	
	import proxy.top.model.IModel;

	public class FrameModel
	{
		private static var instance:FrameModel;
		public function FrameModel()
		{
		}
		public var  framePanel:FramePanel
		public static function getInstance():FrameModel{
			if(!instance){
				instance = new FrameModel();
			}
			return instance;
		}
		
		public  var ary:ArrayCollection
		public  var tree:Tree;
		
		public  function  clearScene():void
		{
			
			while(ary.length){
				var $frameEvent:FrameEvent=new FrameEvent(FrameEvent.DELE_FRAME_MODEL);
				$frameEvent.node=	ary.removeItemAt(0) as FrameFileNode
				ModuleEventManager.dispatchEvent($frameEvent) ;
			}
			
			
		}
		public function getTotalTime():Number
		{
			var $arr:Vector.<FrameFileNode>=	this.getAllFrameFileNode()
			var $max:Number=-1
			for(var i:Number=0;i<$arr.length;i++){
				$max=Math.max($max,	 $arr[i].getPintMaxTime())
			}
			return $max
		}
		public  function getNodeByImodel($imode:IModel):FrameFileNode
		{
			
			var $arr:Vector.<FileNode>=	FileNodeManage.getListAllFileNode(this.ary);
			for(var i:Number=0;i<$arr.length;i++){
				var $node:FrameFileNode=	 $arr[i] as FrameFileNode;
				if($node.iModel==$imode){
					
					return $node;
				}
			}
			
			return null
			
		}
		public  function getNodeById($id:Number):FrameFileNode
		{
			
			var $arr:Vector.<FileNode>=	FileNodeManage.getListAllFileNode(this.ary);
			for(var i:Number=0;i<$arr.length;i++){
				var $node:FrameFileNode=	 $arr[i] as FrameFileNode;
				if($node.id==$id){
					
					return $node;
				}
			}
			
			return null
			
		}
		public function getAllFrameFileNode():	Vector.<FrameFileNode>
		{
			var $backArr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
			var $arr:Vector.<FileNode>=	FileNodeManage.getListAllFileNode(this.ary);
			for(var i:Number=0;i<$arr.length;i++){
				$backArr.push($arr[i] as FrameFileNode)
			}
			return $backArr
		
		}
		public function getSelectNodeFileNode():	Vector.<FrameFileNode>
		{
			function getNodeChildFrameFileNode($node:FrameFileNode):Vector.<FrameFileNode>
			{
				var $tempArr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
				if($node.type==FrameFileNode.build1){
					$tempArr.push($node)
				}else{
					for(var j:Number=0;$node.children&&j<$node.children.length;j++){
						$tempArr=$tempArr.concat(getNodeChildFrameFileNode($node.children[j] as FrameFileNode))
					}
				}
				return $tempArr
				
			}
			var $backArr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
			for(var i:Number=0;i<this.tree.selectedItems.length;i++){
				$backArr=$backArr.concat(getNodeChildFrameFileNode(this.tree.selectedItems[i] as FrameFileNode))
			}
			return $backArr
		}

		
		public var  maxLength:Number
		public function getMaxLength():void{
			maxLength = FrameModel.getInstance().ary.length;
			var _tree:Tree=FrameModel.getInstance().tree
			var arr:Array = _tree.openItems as Array;
			for(var i:int;i<arr.length;i++){
				maxLength += arr[i].children.length
			}
			
		}
		
		public function findfileNodeFromListByImodel($childItem:ArrayCollection,$iModel:IModel):FrameFileNode{
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $frameFileNode:FrameFileNode=$childItem[i] as FrameFileNode
				if($frameFileNode.iModel==$iModel){
					return $frameFileNode
				}
				var $childFileNode:FrameFileNode=findfileNodeFromListByImodel($frameFileNode.children,$iModel)
				if($childFileNode){
					return $childFileNode
				}
			}
			return null
		}

		
		public function expandPerentNode($nod:FileNode):void
		{
			
			if($nod){
				FrameModel.getInstance().tree.expandItem($nod,true);
				this.expandPerentNode($nod.parentNode);
			}
		}
		public function getNoLockItem($arr:Array):Array
		{
			var $br:Array=new Array
			for(var i:Number=0;i<$arr.length;i++){
				var tempNode:FrameFileNode=	$arr[i] as FrameFileNode;
				if(!isPerentLock(tempNode)){
					$br.push(tempNode)
				}
			}
			return $br
		}
		public  function isPerentLock($node:FileNode):Boolean
		{
			var $frameFileNode:FrameFileNode=$node as FrameFileNode
			if($frameFileNode.lock){
				return true
			}else{
				if($node.parentNode){
					return isPerentLock($frameFileNode.parentNode);
				}
			}
			return false
		}
		public var baseW:int = 8;
		public function insetF5($shift:Boolean):void
		{
			var $arr:Vector.<FrameFileNode>=this.getSelectNodeFileNode()
			for(var i:uint=0;i<$arr.length;i++){
				if($arr[i].type==FrameFileNode.build1){
					if($shift){
						$arr[i].deleF5(Math.floor(AppDataFrame.frameNum))
					}else{
						$arr[i].insetF5(Math.floor(AppDataFrame.frameNum))
					}
				}
			}
		}
		public  function insetF6():void
		{
			var $frameNum:int=	Math.floor(AppDataFrame.frameNum)
			var $arr:Vector.<FrameFileNode>=this.getSelectNodeFileNode()
			for(var i:Number=0;i<$arr.length;i++){
				if($arr[i].type==FrameFileNode.build1){
					$arr[i].insetF6($frameNum);
				}
			}
			
		}
		public function slectImodelTriClear():void
		{
			var $arr:Vector.<FrameFileNode>=this.getAllFrameFileNode()
			for(var i:uint=0;i<$arr.length;i++){
				if($arr[i].iModel){
					$arr[i].iModel.select=false
				}
				
			}
		}
		
		public function selectPointKeyInRect($rect:Rectangle):void
		{
			var $arr:Vector.<FrameFileNode>=this.getAllFrameFileNode();
			this.selectPointVoItem=new Vector.<FrameLinePointVo>
			for(var i:uint=0;i<$arr.length;i++){
				var $node:FrameFileNode=$arr[i]
				if($node.frameLineMc.parent){
					for(var j:Number=0;j<$node.frameLineMc.pointSpriteArr.length;j++){
						var mc:FrameLinePointSprite=	$node.frameLineMc.pointSpriteArr[j]
						var $pos:Point=mc.localToGlobal(new Point);
						$pos.x+=5
						$pos.y+=10
						if($pos.x>$rect.x&&$pos.y>$rect.y&&$pos.x<($rect.x+$rect.width)&&$pos.y<($rect.y+$rect.height)){
							selectPointVoItem.push(mc.frameLinePointVo)
						}
					}
					
				}
			}
			
			this.selectFrameLinePointVoByArr();
			
		}
		public var selectPointVoItem:Vector.<FrameLinePointVo>;
		public function selectFrameLinePointVoByArr():void
		{
			var $arr:Vector.<FrameFileNode>=this.getAllFrameFileNode();
			for(var i:uint=0;i<$arr.length;i++){
				var $node:FrameFileNode=$arr[i]
				if($node.frameLineMc.parent){
					for(var j:Number=0;j<$node.frameLineMc.pointSpriteArr.length;j++){
						var mc:FrameLinePointSprite=$node.frameLineMc.pointSpriteArr[j]
						if(this.selectPointVoItem&&this.selectPointVoItem.indexOf(mc.frameLinePointVo)!=-1){
							mc.frameLinePointVo.slectFlag=true
						}else{
							mc.frameLinePointVo.slectFlag=false
						}
						mc.refrishDraw()
					}
				}
			}
		}
		public function deleFrameLinePointVoByArr():void
		{
			var $arr:Vector.<FrameFileNode>=this.getAllFrameFileNode();
			for(var i:uint=0;i<$arr.length;i++){
				var $node:FrameFileNode=$arr[i]
				for(var j:Number=0;j<$node.pointitem.length&&$node.pointitem.length>2;j++){
				
					if(this.selectPointVoItem.indexOf(	$node.pointitem[j])!=-1){
						$node.pointitem.splice(j,1)
						j--;

					}

				}
			}
		}
		
		public function moveFrameNodeUpOrDown(value:Boolean):void
		{
			if(this.tree.selectedItems.length==1){
				var $node:FrameFileNode=this.tree.selectedItems[0] as FrameFileNode;
				var $childre:ArrayCollection
				if($node.parentNode){
					 $childre=$node.parentNode.children;
				}else{
					 $childre=this.ary;
				}
				var $idx:Number=$childre.getItemIndex($node);
				if(value){
					$idx=$idx-1;
				}else{
					$idx=$idx+1;
				}
				$idx=Math.max($idx,0)
				$idx=Math.min($idx,$childre.length-1)
					
				$childre.removeItem($node); //删除
				$childre.addItemAt($node,$idx); //添加
				
				this.tree.selectedItems=[$node]
					
				FrameModel.getInstance().framePanel.refrishFrameList()
			}
		
		}
	
	}
}
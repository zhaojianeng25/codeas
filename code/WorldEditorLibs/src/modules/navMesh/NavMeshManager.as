package modules.navMesh
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	
	import _me.Scene_data;
	
	import common.utils.ui.navMesh.NavMeshNode;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import navMesh.NavMeshStaticMesh;
	
	import proxy.top.model.INavMesh;
	import proxy.top.render.Render;
	
	import xyz.draw.TooMathMoveUint;

	public class NavMeshManager
	{
		public function NavMeshManager()
		{
		}
		public var listArr:ArrayCollection
		private static var instance:NavMeshManager;
		public static function getInstance():NavMeshManager{
			if(!instance){
				instance = new NavMeshManager();
			}
			return instance;
		}
		public  function objToNavMesh($obj:Object):NavMeshStaticMesh
		{
			
			var $listData:Array=$obj.listData
			var $vecTri:Vector.<Object>=$obj.vecTri
			TooMathMoveUint.camPositon=new Vector3D(0,0,0)
			var $navMeshStaticMesh:NavMeshStaticMesh = new NavMeshStaticMesh();
			$navMeshStaticMesh.listData=new Array;
			
			
			for(var i:Number=0;i<$listData.length;i++)
			{
				var $navMeshNode:NavMeshNode=new NavMeshNode
				$navMeshNode.data=new Vector.<NavMeshPosVo>
				$navMeshNode.name=$listData[i].name
				$navMeshNode.isJumpRect=$listData[i].isJumpRect
				for(var j:Number=0;j<$listData[i].data.length;j++){
					
					var $NavMeshPosVo:NavMeshPosVo=new NavMeshPosVo(Scene_data.context3D);
					$NavMeshPosVo.x=$listData[i].data[j].x;
					$NavMeshPosVo.y=$listData[i].data[j].y;
				//	$NavMeshPosVo.y=0
					$NavMeshPosVo.z=$listData[i].data[j].z;
					$navMeshNode.data.push($NavMeshPosVo)
				}
				$navMeshStaticMesh.listData.push($navMeshNode)
			}
			
			$navMeshStaticMesh.vecTri=new Vector.<Vector3D>;
			var $jsItem:String=""
			var $jsIndex:String="";
			
			for(var k:Number=0;$vecTri&&k<$vecTri.length;k++)
			{
				$navMeshStaticMesh.vecTri.push(new Vector3D($vecTri[k].x,$vecTri[k].y,$vecTri[k].z));
				
				$jsItem+=String($vecTri[k].x/20)+","
				$jsItem+=String(0)+","
				$jsItem+=String($vecTri[k].z/20)+","
	
			
			}
			
			for(var L:Number=0;$vecTri&&L<$vecTri.length/3;L++)
			{
				$jsIndex+=String(2)+","
				$jsIndex+=String(L*3+0)+","
				$jsIndex+=String(L*3+1)+","
				$jsIndex+=String(L*3+2)+","
				$jsIndex+=String(0)+","

				
			}
			
			$navMeshStaticMesh.midu=$obj.midu
			$navMeshStaticMesh.astarItem=$obj.astarItem
			$navMeshStaticMesh.heightItem=$obj.heightItem
			$navMeshStaticMesh.jumpItem=$obj.jumpItem
			if($obj.aPos){
				$navMeshStaticMesh.aPos=new Vector3D($obj.aPos.x,$obj.aPos.y,$obj.aPos.z)
			}else{
				$navMeshStaticMesh.aPos=new Vector3D(0,0,0)
			}


	
			

			return $navMeshStaticMesh
		}
	
		public  function addNavMesh($id:uint):void
		{
			
			var $navMeshStaticMesh:NavMeshStaticMesh=makeBaseNavMesh()
		
			var $inavMesh:INavMesh=Render.creatNavMeshModel($navMeshStaticMesh,$id)
	
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name="NavMesh"
			$hierarchyFileNode.iModel=$inavMesh;
			$hierarchyFileNode.type=HierarchyNodeType.NavMesh
			$hierarchyFileNode.data=$navMeshStaticMesh;
			listArr.addItem($hierarchyFileNode)
	

			
		}
		private function makeBaseNavMesh():NavMeshStaticMesh
		{
			var $navMeshStaticMesh:NavMeshStaticMesh=new NavMeshStaticMesh;
			$navMeshStaticMesh.listData=new Array;
			$navMeshStaticMesh.listData.push(getTempRound(new Vector3D(0,1,0)));
			$navMeshStaticMesh.midu=10

			
			
			return $navMeshStaticMesh;
		}
		private function getTempRound($basePos:Vector3D):NavMeshNode
		{
			
			var node:NavMeshNode=new NavMeshNode()
			var $arr:Vector.<NavMeshPosVo>=new Vector.<NavMeshPosVo>
			var n:Number=4
			for(var i:Number=0;i<n;i++){
				var m:Matrix3D=new Matrix3D;
				m.appendRotation(i*360/n,Vector3D.Y_AXIS)
				var $pos:Vector3D=m.transformVector(new Vector3D(100,0,0));
				$pos=$pos.add($basePos)
				var $NavMeshPosVo:NavMeshPosVo=new NavMeshPosVo(Scene_data.context3D);

				$NavMeshPosVo.x=$pos.x;
				$NavMeshPosVo.y=$pos.y;
				$NavMeshPosVo.z=$pos.z;
				$arr.push($NavMeshPosVo)
			
			}
			node.data=$arr
			node.name="pan"
			return node
				
				
		
		}
	}
}
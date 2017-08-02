package terrain
{
	import flash.geom.Vector3D;

	public class GroundNode
	{
		public var maxLod:int;
		public var lod:int;
		public var centerPoint:Vector3D;
		public var id:int;
		
		public var leftNode:GroundNode;
		public var leftIndexVec:Vector.<Vector.<Vector.<int>>>;
		
		public var rightNode:GroundNode;
		public var rightIndexVec:Vector.<Vector.<Vector.<int>>>;
		
		public var topNode:GroundNode;
		public var topIndexVec:Vector.<Vector.<Vector.<int>>>;
		
		public var bottomNode:GroundNode;
		public var bottomIndexVec:Vector.<Vector.<Vector.<int>>>;
		
		public function GroundNode($id:int,$maxLod:int,$centerPoint:Vector3D,$cellNum:int = 10,$areaBitmapSize:int = 10)
		{
			id = $id;
			maxLod = $maxLod;
			centerPoint = $centerPoint;
			
			creatIndex($cellNum,$areaBitmapSize);
		}
		
		public function setLod($eyePos:Vector3D,$maxLod:int):void{
			var distance:Number=Vector3D.distance(centerPoint,$eyePos);
			lod = Math.min((maxLod/3*(300/distance)), $maxLod);
		}
		
		public function pushIndex(indexs:Vector.<uint>):void{
			addNode(leftNode,leftIndexVec,indexs);
			addNode(rightNode,rightIndexVec,indexs);
			addNode(topNode,topIndexVec,indexs);
			addNode(bottomNode,bottomIndexVec,indexs);
		}
		
		public function addNode(friendNode:GroundNode,indexVec:Vector.<Vector.<Vector.<int>>>,indexs:Vector.<uint>):void{
			var ary:Vector.<int>;
			if(friendNode){
				if(friendNode.lod < lod){
					ary = indexVec[lod][friendNode.lod];
				}else{
					ary = indexVec[lod][lod];
				}
			}else{
				ary = indexVec[lod][0];  //边缘默认为0
				ary = indexVec[lod][lod];
			}
			for(var i:int=0;i<ary.length;i++){
				indexs.push(ary[i]);
			}
			
		}
		
		
		
		public function creatIndex(cellNum:int,areaBitmapSize:int):void{
			var basePos:int=int(id/cellNum)*areaBitmapSize*4+int(id%cellNum)*4;
			
			var pointArr:Vector.<int> = new Vector.<int>;
			
			for(var i:int=0;i<5;i++){
				for(var j:int=0;j<5;j++){
					pointArr.push(basePos + j + i * areaBitmapSize);
				}
			}
			
			addLeft(pointArr);
			addRight(pointArr);
			addTop(pointArr);
			addBottom(pointArr);
		}
		
		public function getIndex(ary:Array):void{
			
			if(maxLod == 0){
				pushAryByVec(ary,leftIndexVec[0][0]);
				pushAryByVec(ary,rightIndexVec[0][0]);
			}else if(maxLod == 1){
				if(leftNode && leftNode.lod == 0){
					pushAryByVec(ary,leftIndexVec[1][0]);
				}else{
					pushAryByVec(ary,leftIndexVec[1][1]);
				}
				
				if(rightNode && rightNode.lod == 0){
					pushAryByVec(ary,rightIndexVec[1][0]);
				}else{
					pushAryByVec(ary,rightIndexVec[1][1]);
				}
				
				if(topNode && topNode.lod == 0){
					pushAryByVec(ary,topIndexVec[1][0]);
				}else{
					pushAryByVec(ary,topIndexVec[1][1]);
				}
				
				if(bottomNode && bottomNode.lod == 0){
					pushAryByVec(ary,bottomIndexVec[1][0]);
				}else{
					pushAryByVec(ary,bottomIndexVec[1][1]);
				}
			}else if(maxLod == 2){
				if(leftNode){
					pushAryByVec(ary,leftIndexVec[2][leftNode.lod]);
				}else{
					pushAryByVec(ary,leftIndexVec[2][2]);
				}
				
				if(rightNode){
					pushAryByVec(ary,rightIndexVec[2][rightNode.lod]);
				}else{
					pushAryByVec(ary,rightIndexVec[2][2]);
				}
				
				if(topNode){
					pushAryByVec(ary,topIndexVec[2][topNode.lod]);
				}else{
					pushAryByVec(ary,topIndexVec[2][2]);
				}
				
				if(bottomNode){
					pushAryByVec(ary,bottomIndexVec[2][bottomNode.lod]);
				}else{
					pushAryByVec(ary,bottomIndexVec[2][2]);
				}
			}
		}
		
		public function pushAryByVec(ary:Array,vec:Vector.<int>):void{
			for(var i:int;i<vec.length;i++){
				ary.push(vec[i]);
			}
		}
		
		private function addLeft(pointArr:Vector.<int>):void{
			leftIndexVec = new Vector.<Vector.<Vector.<int>>>;
			leftIndexVec[0] = new Vector.<Vector.<int>>;
			leftIndexVec[0][0] = new Vector.<int>;
			leftIndexVec[0][0].push(pointArr[0],pointArr[24],pointArr[20]);
			
			leftIndexVec[1] = new Vector.<Vector.<int>>;
			leftIndexVec[1][0] = new Vector.<int>;
			leftIndexVec[1][0].push(pointArr[0],pointArr[12],pointArr[20]);
			leftIndexVec[1][1] = new Vector.<int>;
			leftIndexVec[1][1].push(pointArr[0],pointArr[12],pointArr[10],pointArr[10],pointArr[12],pointArr[20]);
			
			leftIndexVec[2] = new Vector.<Vector.<int>>;
			leftIndexVec[2][0] = new Vector.<int>;
			leftIndexVec[2][1] = new Vector.<int>;
			leftIndexVec[2][2] = new Vector.<int>;
			leftIndexVec[2][0].push(pointArr[0],pointArr[6],pointArr[11],
									pointArr[11],pointArr[16],pointArr[20],
									pointArr[0],pointArr[11],pointArr[20],
									pointArr[6],pointArr[12],pointArr[11],
									pointArr[11],pointArr[12],pointArr[16]);
			leftIndexVec[2][1].push(pointArr[0],pointArr[6],pointArr[11],
									pointArr[0],pointArr[11],pointArr[10],
									pointArr[11],pointArr[16],pointArr[20],
									pointArr[10],pointArr[11],pointArr[20],
									pointArr[6],pointArr[12],pointArr[11],
									pointArr[11],pointArr[12],pointArr[16]);
			leftIndexVec[2][2].push(pointArr[0],pointArr[6],pointArr[5],
									pointArr[5],pointArr[6],pointArr[11],
									pointArr[5],pointArr[11],pointArr[10],
									pointArr[10],pointArr[11],pointArr[15],
									pointArr[11],pointArr[16],pointArr[15],
									pointArr[15],pointArr[16],pointArr[20],
									pointArr[6],pointArr[12],pointArr[11],
									pointArr[11],pointArr[12],pointArr[16]);
		}
		private function addRight(pointArr:Vector.<int>):void{
			rightIndexVec = new Vector.<Vector.<Vector.<int>>>;
			rightIndexVec[0] = new Vector.<Vector.<int>>;
			rightIndexVec[0][0] = new Vector.<int>;
			rightIndexVec[0][0].push(pointArr[0],pointArr[4],pointArr[24]);
			
			rightIndexVec[1] = new Vector.<Vector.<int>>;
			rightIndexVec[1][0] = new Vector.<int>;
			rightIndexVec[1][0].push(pointArr[4],pointArr[24],pointArr[12]);
			rightIndexVec[1][1] = new Vector.<int>;
			rightIndexVec[1][1].push(pointArr[4],pointArr[14],pointArr[12],pointArr[12],pointArr[14],pointArr[24]);
			
			rightIndexVec[2] = new Vector.<Vector.<int>>;
			rightIndexVec[2][0] = new Vector.<int>;
			rightIndexVec[2][1] = new Vector.<int>;
			rightIndexVec[2][2] = new Vector.<int>;
			rightIndexVec[2][0].push(pointArr[4],pointArr[13],pointArr[8],
									pointArr[13],pointArr[24],pointArr[18],
									pointArr[4],pointArr[24],pointArr[13],
									pointArr[8],pointArr[13],pointArr[12],
									pointArr[12],pointArr[13],pointArr[18]);
			rightIndexVec[2][1].push(pointArr[4],pointArr[13],pointArr[8],
									pointArr[4],pointArr[14],pointArr[13],
									pointArr[13],pointArr[14],pointArr[24],
									pointArr[13],pointArr[24],pointArr[18],
									pointArr[8],pointArr[13],pointArr[12],
									pointArr[12],pointArr[13],pointArr[18]);
			rightIndexVec[2][2].push(pointArr[4],pointArr[9],pointArr[8],
									pointArr[8],pointArr[9],pointArr[13],
									pointArr[9],pointArr[14],pointArr[13],
									pointArr[13],pointArr[14],pointArr[19],
									pointArr[13],pointArr[19],pointArr[18],
									pointArr[18],pointArr[19],pointArr[24],
									pointArr[8],pointArr[13],pointArr[12],
									pointArr[12],pointArr[13],pointArr[18]);
		}
		
		private function addTop(pointArr:Vector.<int>):void{
			topIndexVec = new Vector.<Vector.<Vector.<int>>>;
			topIndexVec[0] = new Vector.<Vector.<int>>;
			topIndexVec[0][0] = new Vector.<int>;
			//topIndexVec[0][0].push(pointArr[0],pointArr[4],pointArr[24]);
			
			topIndexVec[1] = new Vector.<Vector.<int>>;
			topIndexVec[1][0] = new Vector.<int>;
			topIndexVec[1][0].push(pointArr[0],pointArr[4],pointArr[12]);
			topIndexVec[1][1] = new Vector.<int>;
			topIndexVec[1][1].push(pointArr[0],pointArr[2],pointArr[12],pointArr[2],pointArr[4],pointArr[12]);
			
			topIndexVec[2] = new Vector.<Vector.<int>>;
			topIndexVec[2][0] = new Vector.<int>;
			topIndexVec[2][1] = new Vector.<int>;
			topIndexVec[2][2] = new Vector.<int>;
			topIndexVec[2][0].push(pointArr[0],pointArr[7],pointArr[6],
									pointArr[7],pointArr[4],pointArr[8],
									pointArr[0],pointArr[4],pointArr[7],
									pointArr[6],pointArr[7],pointArr[12],
									pointArr[7],pointArr[8],pointArr[12]);
			topIndexVec[2][1].push(pointArr[0],pointArr[7],pointArr[6],
									pointArr[0],pointArr[2],pointArr[7],
									pointArr[7],pointArr[4],pointArr[8],
									pointArr[2],pointArr[4],pointArr[7],
									pointArr[6],pointArr[7],pointArr[12],
									pointArr[7],pointArr[8],pointArr[12]);
			topIndexVec[2][2].push(pointArr[0],pointArr[1],pointArr[6],
									pointArr[1],pointArr[7],pointArr[6],
									pointArr[1],pointArr[2],pointArr[7],
									pointArr[2],pointArr[3],pointArr[7],
									pointArr[3],pointArr[8],pointArr[7],
									pointArr[3],pointArr[4],pointArr[8],
									pointArr[6],pointArr[7],pointArr[12],
									pointArr[7],pointArr[8],pointArr[12]);
		}
		
		private function addBottom(pointArr:Vector.<int>):void{
			bottomIndexVec = new Vector.<Vector.<Vector.<int>>>;
			bottomIndexVec[0] = new Vector.<Vector.<int>>;
			bottomIndexVec[0][0] = new Vector.<int>;
			//bottomIndexVec[0][0].push(pointArr[0],pointArr[4],pointArr[24]);
			
			bottomIndexVec[1] = new Vector.<Vector.<int>>;
			bottomIndexVec[1][0] = new Vector.<int>;
			bottomIndexVec[1][0].push(pointArr[20],pointArr[12],pointArr[24]);
			bottomIndexVec[1][1] = new Vector.<int>;
			bottomIndexVec[1][1].push(pointArr[20],pointArr[12],pointArr[22],pointArr[12],pointArr[24],pointArr[22]);
			
			bottomIndexVec[2] = new Vector.<Vector.<int>>;
			bottomIndexVec[2][0] = new Vector.<int>;
			bottomIndexVec[2][1] = new Vector.<int>;
			bottomIndexVec[2][2] = new Vector.<int>;
			bottomIndexVec[2][0].push(pointArr[20],pointArr[16],pointArr[17],
									pointArr[17],pointArr[18],pointArr[24],
									pointArr[20],pointArr[17],pointArr[24],
									pointArr[16],pointArr[12],pointArr[17],
									pointArr[12],pointArr[18],pointArr[17]);
			bottomIndexVec[2][1].push(pointArr[20],pointArr[16],pointArr[17],
									pointArr[20],pointArr[17],pointArr[22],
									pointArr[17],pointArr[18],pointArr[24],
									pointArr[17],pointArr[24],pointArr[22],
									pointArr[16],pointArr[12],pointArr[17],
									pointArr[12],pointArr[18],pointArr[17]);
			bottomIndexVec[2][2].push(pointArr[20],pointArr[16],pointArr[21],
									pointArr[16],pointArr[17],pointArr[21],
									pointArr[21],pointArr[17],pointArr[22],
									pointArr[22],pointArr[17],pointArr[23],
									pointArr[17],pointArr[18],pointArr[23],
									pointArr[18],pointArr[24],pointArr[23],
									pointArr[16],pointArr[12],pointArr[17],
									pointArr[12],pointArr[18],pointArr[17]);
		}
		
		
		
	}
}
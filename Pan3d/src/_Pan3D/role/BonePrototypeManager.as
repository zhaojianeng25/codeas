package _Pan3D.role
{
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	
	import _Pan3D.base.MeshDataSelect;

	public class BonePrototypeManager
	{
		private static var _instance:BonePrototypeManager;
		public function BonePrototypeManager()
		{
			init();
		}
		public static function getInstance():BonePrototypeManager{
			if(!_instance){
				_instance = new BonePrototypeManager;
			}
			return _instance;
		}
		private var uvItem:Vector.<ObjectUv>;
		private var weightItem:Vector.<ObjectWeight>;
		private var triItem:Vector.<ObjectTri>;
		public function init():void{
			setVert();
			setTri();
			setWeight();
		}
		private function setVert():void{
			uvItem = new Vector.<ObjectUv>;
			var ary:Array = SoureStr.vert.split("\n");
			for(var i:int;i<ary.length;i++){
				var tempAry:Array = String(ary[i]).split(" ");
				var objUv:ObjectUv = new ObjectUv();
				objUv.id = tempAry[0];
				objUv.x = tempAry[1];
				objUv.y = tempAry[2];
				objUv.a = tempAry[3];
				objUv.b = tempAry[4];
				uvItem.push(objUv);
			}
		}
		private function setTri():void{
			triItem = new Vector.<ObjectTri>;
			var ary:Array = SoureStr.tri.split("\n");
			for(var i:int;i<ary.length;i++){
				var tempAry:Array = String(ary[i]).split(" ");
				var objTri:ObjectTri = new ObjectTri();
				objTri.id = tempAry[0];
				objTri.t0 = tempAry[1];
				objTri.t1 = tempAry[2];
				objTri.t2 = tempAry[3];
				triItem.push(objTri);
			}
		}
		private function setWeight(num:Number=1):void{
			weightItem = new Vector.<ObjectWeight>;
			var ary:Array = SoureStr.weight.split("\n");
			for(var i:int;i<ary.length;i++){
				var tempAry:Array = String(ary[i]).split(" ");
				var objWeight:ObjectWeight = new ObjectWeight();
				objWeight.id = tempAry[0];
				objWeight.boneId = tempAry[1];
				objWeight.w = tempAry[2];
				objWeight.x = int(tempAry[3])*num;
				objWeight.y = int(tempAry[4])*num;
				objWeight.z = int(tempAry[5])*num;
				weightItem.push(objWeight);
			}
		}
		
		public function getLineMeshData(boneId:int,fatherID:int):MeshData{
			setWeight(0.2);
			for(var i:int;i<weightItem.length;i++){
				if(fatherID == -1){
					weightItem[i].boneId = boneId;
				}else{
					if(i == 0 || i == 3 || i == 4 || i == 5){
						weightItem[i].boneId = fatherID;
					}else{
						weightItem[i].boneId = boneId;
					}
				}
				
			}
			var meshData:MeshData = new MeshData();
			meshData.uvItem = uvItem;
			meshData.triItem = triItem;
			meshData.weightItem = weightItem;
			
			MeshDataManager.getInstance().processForAgal(meshData);
			return meshData;
		}
		
		public function getKeyMeshData(boneId:int):MeshDataSelect{
			setWeight(1);
			for(var i:int;i<weightItem.length;i++){
				weightItem[i].boneId = boneId;
			}
			var meshData:MeshDataSelect = new MeshDataSelect();
			meshData.uvItem = uvItem;
			meshData.triItem = triItem;
			meshData.weightItem = weightItem;
			
			MeshDataManager.getInstance().processForAgal(meshData);
			return meshData;
		} 
		
		
		
		
	}
}
class SoureStr
{
	public static var vert:String = 
		"0 1.0 1.0 0 1\n" +
		"1 1.0 0.0 1 1\n" +
		"2 0.0 0.0 2 1\n" +
		"3 0.0 1.0 3 1\n" +
		"4 0.0 1.0 4 1\n" +
		"5 1.0 1.0 5 1\n" +
		"6 1.0 0.0 6 1\n" +
		"7 0.0 0.0 7 1\n" +
		"8 0.0 1.0 0 1\n" +
		"9 1.0 1.0 3 1\n" +
		"10 1.0 0.0 5 1\n" +
		"11 0.0 0.0 4 1\n" +
		"12 1.0 1.0 2 1\n" +
		"13 0.0 0.0 5 1\n" +
		"14 0.0 1.0 2 1\n" +
		"15 1.0 1.0 1 1\n" +
		"16 1.0 0.0 7 1\n" +
		"17 0.0 0.0 6 1\n" +
		"18 0.0 1.0 1 1\n" +
		"19 1.0 0.0 4 1";
	
	public static var tri:String = 
		"0 0 2 1\n" +
		"1 2 0 3\n" +
		"2 4 6 5\n" +
		"3 6 4 7\n" +
		"4 8 10 9\n" +
		"5 10 8 11\n" +
		"6 3 6 12\n" +
		"7 6 3 13\n" +
		"8 14 16 15\n" +
		"9 16 14 17\n" +
		"10 18 19 0\n" +
		"11 19 18 7";
	public static var weight:String = 
		"0 1 1.0 2.0 -1.0 -1.0\n" +
		"1 1 1.0 -2.0 -1.0 -1.0\n" +
		"2 1 1.0 -2.0 1.0 -1.0\n" +
		"3 1 1.0 2.0 1.0 -1.0\n" +
		"4 1 1.0 2.0 -1.0 1.0\n" +
		"5 1 1.0 2.0 1.0 1.0\n" +
		"6 1 1.0 -2.0 1.0 1.0\n" +
		"7 1 1.0 -2.0 -1.0 1.0";
	public function SoureStr():void{
		
	}
}
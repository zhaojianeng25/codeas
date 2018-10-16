package _Pan3D.display3D.analysis
{
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class Md5ByteAnalysis
	{
		private var byte:ByteArray;
		private var meshData:MeshData;
		
		public function Md5ByteAnalysis()
		{
		}
		public function addMesh($byte:ByteArray):MeshData{
			var t:int = getTimer();
			byte = $byte;
			byte.uncompress();
			meshData = new MeshData;
			readUv();
			readTri();
			readWeight();
			//trace("解析mesh耗时：" + (getTimer()-t))
			return meshData;
		}
		/**
		 * 写入uv信息 
		 * 
		 */		
		private function readUv():void{
			var uvItemLength:int = byte.readInt();
			var uvItem:Vector.<ObjectUv> = meshData.uvItem;
			for(var i:int;i<uvItemLength;i++){
				var objUv:ObjectUv = new ObjectUv;
				objUv.x = byte.readFloat();
				objUv.y = byte.readFloat();
				
				objUv.a = byte.readInt();
				objUv.b = byte.readInt();
				uvItem.push(objUv);
			}
			
		}
		/**
		 * 写入index信息 
		 * 
		 */		
		private function readTri():void{
			var triItemLength:int = byte.readInt();
			var triItem:Vector.<ObjectTri> = meshData.triItem;
			for(var i:int;i<triItemLength;i++){
				var objTri:ObjectTri = new ObjectTri;
				objTri.t0 = byte.readInt();
				objTri.t1 = byte.readInt();
				objTri.t2 = byte.readInt();
				triItem.push(objTri);
			}
		}
		/**
		 * 写入权重信息 
		 * 
		 */		
		private function readWeight():void{
			var weightItemLength:int = byte.readInt();
			var weightItem:Vector.<ObjectWeight> = meshData.weightItem
			for(var i:int;i<weightItemLength;i++){
				var objWeight:ObjectWeight = new ObjectWeight;
				
				objWeight.boneId = byte.readInt();
				objWeight.w = byte.readFloat();
				
				objWeight.x = byte.readFloat();
				objWeight.y = byte.readFloat();
				objWeight.z = byte.readFloat();
				
				weightItem.push(objWeight);
			}
		}
		
		public function dispose():void{
			byte = null;
			meshData = null;
		}
		
	}
}
package utils.combine
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.utils.MeshToObjUtils;

	public class MeshCombineUtils
	{
		private var vertAry:Vector.<ObjectUv>;
		private var triAry:Vector.<ObjectTri>;
		private var weightAry:Vector.<ObjectWeight>;
		private static var SPACE:String = " ";
		private static var LEFT:String = "(";
		private static var RIGHT:String = ")";

		private var resultStr:String;
		
		private var reversAry:Array;
		public function MeshCombineUtils()
		{
			vertAry = new Vector.<ObjectUv>;
			triAry = new Vector.<ObjectTri>;
			weightAry = new Vector.<ObjectWeight>;
		}
		
		public function combineMesh(ary:Vector.<MeshData>):void{
			reversAry = getMapValue(ary[0].boneItem);
			for(var i:int;i<ary.length;i++){
				combineToAry(ary[i]);
			}
			
			resultStr = new String;
			var vertStr:String = new String;
			var triStr:String = new String;
			var weightStr:String = new String;
			var jointsStr:String = new String;
			
			var boneAry:Vector.<ObjectBone> = ary[0].boneItem;
			
			for(i=0;i<boneAry.length;i++){
				jointsStr += "\t\"" + boneAry[i].name + "\"\t" + boneAry[i].father + " ( " + boneAry[i].tx + " " + boneAry[i].ty + " " + boneAry[i].tz + " ) ( " + boneAry[i].qx + " " + boneAry[i].qy + " " + boneAry[i].qz + " )\t\t//\r\n "; //"Bip01"	-1 63 0	
			}
			
			for(i=0;i<vertAry.length;i++){
				vertStr += "\tvert" + SPACE + vertAry[i].id + SPACE 
							+ LEFT + SPACE + vertAry[i].x + SPACE + vertAry[i].y + SPACE + RIGHT + SPACE + vertAry[i].a + SPACE + vertAry[i].b + "\r\n";//vert 0 ( 1.0 1.0 ) 0 1
			}
			
			for(i=0;i<triAry.length;i++){
				triStr += "\ttri" + SPACE + triAry[i].id + SPACE + triAry[i].t0 + SPACE + triAry[i].t1 + SPACE + triAry[i].t2 + "\r\n";//tri 0 0 2 1
			}
			
			for(i=0;i<weightAry.length;i++){
				weightStr += "\tweight" + SPACE + weightAry[i].id + SPACE + weightAry[i].boneId + SPACE + weightAry[i].w 
										+ SPACE + LEFT + SPACE + weightAry[i].x + SPACE + weightAry[i].y + SPACE + weightAry[i].z + SPACE + RIGHT + "\r\n"//weight 0 0 1.0 ( 16.4771 -8.70046 8.20959 )
			}
			
			resultStr = "joints {\r\n" + jointsStr + "}\r\n";
			
			resultStr += "mesh {\r\n" 
			resultStr += "\tnumverts " + vertAry.length + "\r\n" + vertStr + "\r\n" ;
			resultStr += "\tnumtris " + triAry.length + "\r\n" + triStr + "\r\n";
			resultStr += "\tnumweights " + weightAry.length + "\r\n" +  weightStr + "}";
			trace(resultStr);
			var file:File = new File;
			file.addEventListener(Event.SELECT,onSave);
			file.browseForSave("保存");
			
		}
		
		protected function onSave(event:Event):void
		{
			var file:File = event.target as File;
			if(!(file.extension == "md5mesh")){
				file = new File(file.nativePath + ".md5mesh");
			}
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(resultStr);
			fs.close();
		}
		
		/**
		 * 将mesh添加入数组 
		 * @param meshData
		 * 
		 */		
		private function combineToAry(meshData:MeshData):void{
			var tempVertAry:Vector.<ObjectUv> = new Vector.<ObjectUv>;
			var tempTriAry:Vector.<ObjectTri> = new Vector.<ObjectTri>;
			var tempWeightAry:Vector.<ObjectWeight> = new Vector.<ObjectWeight>;
			
			for(var i:int=0;i<meshData.uvItem.length;i++){
				var objUV:ObjectUv = meshData.uvItem[i].clone();
				objUV.a += weightAry.length;
				objUV.id += vertAry.length;
				tempVertAry.push(objUV);
			}
			
			for(i=0;i<meshData.triItem.length;i++){
				var objTri:ObjectTri = meshData.triItem[i].clone();
				objTri.t0 += vertAry.length;
				objTri.t1 += vertAry.length;
				objTri.t2 += vertAry.length;
				objTri.id += triAry.length;
				tempTriAry.push(objTri);
			}
			
			for(i=0;i<meshData.weightItem.length;i++){
				var objWeight:ObjectWeight = meshData.weightItem[i].clone();
				objWeight.boneId = reversAry[objWeight.boneId];
				objWeight.id += weightAry.length;
				tempWeightAry.push(objWeight);
			}
			
			vertAry = vertAry.concat(tempVertAry);
			triAry = triAry.concat(tempTriAry);
			weightAry = weightAry.concat(tempWeightAry);
			
		}
		/**
		 * 将导入时已经翻转的骨骼再翻转回来（ 返回原始状态） 
		 * @param targetAry
		 * @return 
		 * 
		 */		
		public function getMapValue(targetAry:Vector.<ObjectBone>):Array{

			var newTargetAry:Vector.<ObjectBone> = MeshToObjUtils.getStorNewTargerArr(targetAry);
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(var i:int = 0;i<targetAry.length;i++){
				var index:int = newTargetAry.indexOf(targetAry[i]);
				mapkeyAry.push(index);
			}
			trace(mapkeyAry)
			
			var reversAry:Array = new Array(mapkeyAry.length);
			
			for(i=0;i<mapkeyAry.length;i++){
				reversAry[mapkeyAry[i]] = i;
			}
			trace(reversAry)
			return reversAry;
		}
		
	}
}
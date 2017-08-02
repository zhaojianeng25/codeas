package  _Pan3D.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.core.Quaternion;
	
	import _me.Scene_data;
	
	public class MeshToObjUtils
	{
		public function MeshToObjUtils()
		{
		}
		
		public function getObj(mesh:MeshData):ObjData{
			var objData:ObjData = new ObjData;
			objData.vertices = new Vector.<Number>;
			objData.uvs = new Vector.<Number>;
			objData.normals = new Vector.<Number>;
			objData.indexs = new Vector.<uint>;
			
			var bindPosAry:Array = new Array;
			
			var meshItemAry:Vector.<MeshItem> = new Vector.<MeshItem>;
			
			var boneItemAry:Vector.<ObjectBone> = processBoneNew(mesh.boneItem);
			
			for(var i:int =0;i<boneItemAry.length;i++){
				var objbone:ObjectBone = boneItemAry[i];
				
				var OldQ:Quaternion = new Quaternion(objbone.qx,objbone.qy,objbone.qz);
				OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
				var newM:Matrix3D=OldQ.toMatrix3D();
				newM.appendTranslation(objbone.tx,objbone.ty,objbone.tz);
				
				objbone.matrix  = newM;
				
				var inverMatrix:Matrix3D = newM.clone();
				var isInver:Boolean = inverMatrix.invert();
				
				
				bindPosAry.push(inverMatrix);
			}
			
			for(i=0;i<mesh.uvItem.length;i++){
				var objuv:ObjectUv = mesh.uvItem[i];
				var v3d:Vector3D = new Vector3D;
				
				var wAry:Array = new Array;
				
				for(var j:int=0;j<objuv.b;j++){
					var weightID:int = objuv.a + j;
					var objWeight:ObjectWeight = mesh.weightItem[weightID];
					var ma:Matrix3D = boneItemAry[objWeight.boneId].matrix;
					var tempV3d:Vector3D = new Vector3D(objWeight.x,objWeight.y,objWeight.z);
					tempV3d = ma.transformVector(tempV3d);
					tempV3d.scaleBy(objWeight.w);
					v3d = v3d.add(tempV3d);
					wAry.push(objWeight.w);
				}
				
				objData.vertices.push(v3d.x,v3d.y,v3d.z);
				objData.uvs.push(objuv.x,objuv.y);
				
				var meshitem:MeshItem = new MeshItem;
				meshitem.verts = new Vector3D(v3d.x,v3d.y,v3d.z);
				meshitem.uvInfo = objuv;
				
				meshItemAry.push(meshitem);
			}
			
			for(i=0;i<mesh.triItem.length;i++){
				objData.indexs.push(mesh.triItem[i].t0,mesh.triItem[i].t1,mesh.triItem[i].t2);
			}
			
			for(i=0;i<mesh.triItem.length;i++){
				
				var v0:Vector3D = meshItemAry[mesh.triItem[i].t0].verts;
				var v1:Vector3D = meshItemAry[mesh.triItem[i].t1].verts;
				var v2:Vector3D = meshItemAry[mesh.triItem[i].t2].verts;
				
				
				var v20:Vector3D = v2.subtract(v0);
				var v10:Vector3D = v2.subtract(v1);
				
				var normal:Vector3D = v20.crossProduct(v10);
				normal.normalize();
				normal.scaleBy(-1);
				
				meshItemAry[mesh.triItem[i].t0].normal = meshItemAry[mesh.triItem[i].t0].normal.add(normal);
				meshItemAry[mesh.triItem[i].t1].normal = meshItemAry[mesh.triItem[i].t1].normal.add(normal);
				meshItemAry[mesh.triItem[i].t2].normal = meshItemAry[mesh.triItem[i].t2].normal.add(normal);
				
				meshItemAry[mesh.triItem[i].t0].num++;
				meshItemAry[mesh.triItem[i].t1].num++;
				meshItemAry[mesh.triItem[i].t2].num++;
			}
			
			for(i=0;i<meshItemAry.length;i++){
				normal = meshItemAry[i].normal.clone();
				normal.normalize();
				objData.normals.push(normal.x,normal.y,normal.z,0);
			}
			
			//			var num3:int;
			//			var num2:int;
			//			var num1:int;
			//			for(i=0;i<meshItemAry.length;i++){
			//				if(meshItemAry[i].num == 3){
			//					num3++;
			//				}else if(meshItemAry[i].num == 2){
			//					num2++;
			//				}else if(meshItemAry[i].num == 1){
			//					num1++;
			//				}
			//			}
			
			//trace(num3,num2,num1)
			
			objData.vertexBuffer = Scene_data.context3D.createVertexBuffer(objData.vertices.length/3,3);
			objData.vertexBuffer.uploadFromVector(Vector.<Number>(objData.vertices),0,objData.vertices.length/3);
			
			objData.uvBuffer = Scene_data.context3D.createVertexBuffer(objData.uvs.length/2,2);
			objData.uvBuffer.uploadFromVector(Vector.<Number>(objData.uvs),0,objData.uvs.length/2);
			
			
			objData.normalsBuffer = Scene_data.context3D.createVertexBuffer(objData.normals.length/4,4);
			objData.normalsBuffer.uploadFromVector(Vector.<Number>(objData.normals),0,objData.normals.length/4);
			
			objData.indexBuffer = Scene_data.context3D.createIndexBuffer(objData.indexs.length);
			objData.indexBuffer.uploadFromVector(Vector.<uint>(objData.indexs),0,objData.indexs.length);
			
			objData.bindPosAry = bindPosAry;
			
			objData.bindPosBoneItems = boneItemAry;
			
			return objData;
		}
		
		private function getW(x:Number,y:Number,z:Number):Number{
			var t:Number = 1-(x*x + y*y + z*z);
			if(t<0){
				t=0
			}else{
				t = -Math.sqrt(t);
			}
			return t;
		}
		
		public function processBoneNew(targetAry:Vector.<ObjectBone>):Vector.<ObjectBone>{
			
			var newTargetAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;
			//添加bip骨骼到新数组
			for(var i:int;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("Bip") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加weapon骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("weapon") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加剩余的骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(newTargetAry.indexOf(targetAry[i]) == -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(i = 0;i<targetAry.length;i++){
				var index:int = newTargetAry.indexOf(targetAry[i]);
				mapkeyAry.push(index);
			}
			//trace(mapkeyAry);
			
			var resultAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;//最终更新的数据
			for(i = 0;i<newTargetAry.length;i++){//数据复制
				resultAry.push(newTargetAry[i].clone());
			}
			
			for(i=0;i<resultAry.length;i++){//从映射关系更新父级id
				index = resultAry[i].father;
				if(index != -1){
					resultAry[i].father = mapkeyAry[index];
				}
			}
			
			return resultAry;
			
		}
		
	}
}

import flash.geom.Vector3D;

import _Pan3D.base.ObjectUv;

class MeshItem{
	public var verts:Vector3D;
	public var normal:Vector3D = new Vector3D;
	public var uvInfo:ObjectUv;
	public var num:int;
}
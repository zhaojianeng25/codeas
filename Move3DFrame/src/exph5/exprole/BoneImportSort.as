package exph5.exprole
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjectBone;
	import _Pan3D.core.Quaternion;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.utils.MeshToObjUtils;

	/**
	 * 骨骼导入时的预处理 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class BoneImportSort
	{
		public function BoneImportSort()
		{
			
		}
		
		/**
		 * 处理一个骨骼 
		 * @param targetAry 基础骨骼数据
		 * @param action 动作骨骼数据
		 * 
		 */		
		public function processBoneNew(targetAry:Vector.<ObjectBone>,action:Object):Object{
			

			var newTargetAry:Vector.<ObjectBone> = MeshToObjUtils.getStorNewTargerArr(targetAry);
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(var i:Number = 0;i<targetAry.length;i++){
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
			
			
			var baseFrameAry:Array = getBaseFrameAry(getBaseFrameStr(action.strAry));//基础帧的数组
			
			//trace(resultAry.length,baseFrameAry.length);
			//trace(baseFrameAry);
			
			var newBaseFrameAry:Array = new Array(baseFrameAry.length);//根据映射关系更新基础帧的数据
			for(i=0;i<baseFrameAry.length;i++){
				//newBaseFrameAry.push(baseFrameAry[mapkeyAry[i]])
				newBaseFrameAry[mapkeyAry[i]] = baseFrameAry[i];
			}
			
			var hierarchy:String = getHierarchy(resultAry);//骨骼数据组合后的字符串
			var baseframeStr:String = getBaseFrame(newBaseFrameAry);//基础帧组合后的字符串
			
			var allStr:String = hierarchy + baseframeStr;
			var start:int = frameStartIndex(action.strAry);
			for(i=start;i<action.strAry.length;i++){
				var framestr:String = converFrame(action.strAry[i]);
				allStr += framestr + "\r\n";//action.strAry[i];
			}
//			trace(allStr);
//			allStr = "resort 1\r\n" + allStr;//写入字符串表示已经处理过排序（跳过备份）
//			
//			if(action.nameHeight){
//				allStr = "nameheight " + action.nameHeight  + "\r\n" + allStr;
//			}
//			
//			if(action.bound){//写入盒子信息
//				var boundstr:String = new String;
//				for(i=0;i<action.bound.length;i++){
//					boundstr += action.bound[i].x + "," + action.bound[i].y + "," + action.bound[i].z + ","
//				}
//				allStr = "mybounds " + boundstr  + "\r\n" + allStr;
//			}
//			
//			if(action.interAry ){//写入插帧值信息
//				var interStr:String = new String;
//				for(i=0;i<action.interAry.length;i++){
//					interStr += action.interAry[i]+",";
//				}
//				allStr = "inter " + interStr + "\r\n" + allStr;
//			}
//			
//			if(action.inLoop){//写入循环帧信息
//				allStr = "inLoop " + action.inLoop  + "\r\n" + allStr;
//			}
			
//			var file:File = new File(Scene_data.md5Root + action.url);
//			var readStream:FileStream = new FileStream;
//			readStream.open(file,FileMode.READ);
//			var soureStr:String = readStream.readUTFBytes(readStream.bytesAvailable);
//			readStream.close();
//			if(soureStr.indexOf("resort") == -1){//如果已经排序则不需要备份
//				var backUpFile:File = new File(backupUrl + action.url);
//				file.copyTo(backUpFile,true);
//			}
//			
//			var fs:FileStream = new FileStream();
//			fs.open(file,FileMode.WRITE);
//			fs.writeUTFBytes(allStr);
//			fs.close();
			
			return onAnimLoad(allStr);
		}
		
		private function onAnimLoad(str:String):Object{
			var resultObj:Object = AnalysisServer.getInstance().analysisAnim(str);
			var animAry:Array = resultObj.frames;

			var sourceData:Array = cloneAction(animAry);
			setFrameToMatrix(animAry);
			
			var obj:Object = new Object;
			
			obj.source = sourceData;
			obj.strAry = AnalysisServer.getInstance().getMd5StrAry();
			obj.hierarchy = AnalysisServer.getInstance().getHierarchy();
			obj.str = str;
			
			obj.animAry = animAry;
			return obj;
		}
		
		private function cloneAction(sourceAry:Array):Array{
			var resultAry:Array = new Array;
			for(var i:int;i<sourceAry.length;i++){
				var sourceTwo:Array = sourceAry[i];
				resultAry.push(new Array);
				for(var j:int=0;j<sourceTwo.length;j++){
					resultAry[i].push(sourceTwo[j].clone());
				}
			}
			return resultAry;
		}
		
		private function setFrameToMatrix(frameAry:Array):void{
			AnimDataManager.getInstance().setFrameToMatrix(frameAry);
			return 
			for(var j:int=0;j<frameAry.length;j++){
				var boneAry:Array = frameAry[j];
				
				var Q0:Quaternion=new Quaternion();
				//var Q1:Quaternion=new Quaternion();
				//var OldQ:Quaternion=new Quaternion();
				//var OldM:Matrix3D=new Matrix3D();
				var newM:Matrix3D=new Matrix3D();
				//var tempM:Matrix3D=new Matrix3D;
				//var tempObj:ObjectBone=new ObjectBone;
				
				for(var i:int=0;i<boneAry.length;i++){
					
					//var _M1:Matrix3D=new Matrix3D;
					
					var xyzfarme0:ObjectBone= boneAry[i];
					Q0=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
					Q0.w= getW(Q0.x,Q0.y,Q0.z);
					//var sonBone:ObjectBone=xyzfarme0;
					
					if(xyzfarme0.father==-1){
						//OldQ=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
						//OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
						newM=Q0.toMatrix3D();
						newM.appendTranslation(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						newM.appendRotation(-90,Vector3D.X_AXIS);
//						var fatherQ:Quaternion = new Quaternion();
//						fatherQ.fromMatrix(newM);
						
//						xyzfarme0.tx=newM.position.x;
//						xyzfarme0.ty=newM.position.y;
//						xyzfarme0.tz=newM.position.z;
//						xyzfarme0.tw=newM.position.w;
//						
//						xyzfarme0.qx=fatherQ.x;
//						xyzfarme0.qy=fatherQ.y;
//						xyzfarme0.qz=fatherQ.z;
//						xyzfarme0.qw=fatherQ.w;
						//newM.appendScale(-1,1,1);
						xyzfarme0.matrix = newM;
						
					}else {
						var fatherBone:ObjectBone=boneAry[xyzfarme0.father];
//						OldQ=new Quaternion(fatherBone.qx,fatherBone.qy,fatherBone.qz,fatherBone.qw);
//						OldM=OldQ.toMatrix3D();
//						OldM.appendTranslation(fatherBone.tx,fatherBone.ty,fatherBone.tz);
//						var  tempV:Vector3D=OldM.transformVector(new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz));
//						_M1.appendTranslation(tempV.x,tempV.y,tempV.z);
//						
//						Q1.multiply(OldQ,Q0);
//						newM=Q1.toMatrix3D();
//						newM.append(_M1);
//						tempM=newM;
						
						newM = Q0.toMatrix3D();
						newM.appendTranslation(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						newM.append(fatherBone.matrix);
						//tempM=newM;
						
//						xyzfarme0.qx=Q1.x;
//						xyzfarme0.qy=Q1.y;
//						xyzfarme0.qz=Q1.z;
//						xyzfarme0.qw=Q1.w;
//						
//						xyzfarme0.tx=tempV.x;
//						xyzfarme0.ty=tempV.y;
//						xyzfarme0.tz=tempV.z;
//						xyzfarme0.tw=tempV.w;
						
						//tempM.appendScale(-1,1,1);
						xyzfarme0.matrix = newM;
						
					}
					//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  tempM, true);
				}
				
				for(i=0;i<boneAry.length;i++){
					xyzfarme0= boneAry[i];
					xyzfarme0.matrix.appendScale(1,1,1);
				}
				
			}
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
		
		/**
		 * 从字符数组中找到baseframe所在的字符串 
		 * @param ary
		 * @return 
		 * 
		 */		
		private function getBaseFrameStr(ary:Array):String{
			for(var i:int;i<ary.length;i++){
				var str:String = ary[i];
				if(str.indexOf("baseframe") != -1){
					return str;
				}
			}
			return "";
		}
		
		private function getBaseFrameAry(str:String):Array{
			var ary:Array = str.split("\n\r");
			var newAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				var s:String = ary[i];
				if(s == "" || s.indexOf("{") != -1 || s.indexOf("}") != -1){
					continue;
				}
				newAry.push(ary[i]);
			}
			return newAry;
		}
		
		private function converFrame(str:String):String{
			var reg:RegExp = /\n\r/g;
			str = str.replace(reg,"\r\n");
			return str;
		}
		
		private function frameStartIndex(ary:Array):int{
			for(var i:int;i<ary.length;i++){
				var str:String = ary[i];
				if(str.indexOf("frame 0") != -1){
					return i;
				}
			}
			return 0;
		}
		
		private function getHierarchy(ary:Vector.<ObjectBone>):String{
			var str:String = new String;
			for(var i:int;i<ary.length;i++){
				str += "\t\"" + ary[i].name + "\"\t" + ary[i].father + " " + ary[i].changtype + " " + ary[i].startIndex + "\t//\r\n "; //"Bip01"	-1 63 0	
			}
			
			str = "hierarchy {\r\n" + str + "}\r\n"
			return str;
		}
		
		private function getBaseFrame(ary:Array):String{
			var str:String = new String;
			for(var i:int;i<ary.length;i++){
				str += ary[i] + "\r\n"
			}
			str = "baseframe {\r\n" + str + "}\r\n";
			return str;
		}
		
		
		
	}
}
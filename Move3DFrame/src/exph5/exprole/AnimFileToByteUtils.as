package  exph5.exprole
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.ObjectBone;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.utils.MeshToObjUtils;

	/**
	 * md5anim文件压缩 文本到二进制 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class AnimFileToByteUtils
	{
		private var frameAry:Array;
		private var hierarchyList:Vector.<ObjectBone>;
		/**
		 * 循环帧数 
		 */		
		private var inLoop:int;
		/**
		 * 插值帧 
		 */		
		private var inter:Array = new Array;
		/**
		 * 包围盒 
		 */		
		private var bounds:Vector.<Vector3D> = new Vector.<Vector3D>;
		/**
		 * 名字高度 
		 */		
		private var nameHeight:int;
		/**
		 * 字节 
		 */		
		private var byte:ByteArray = new ByteArray;
		
		/**
		 * 位置信息 
		 */		
		private var pos:Vector.<Vector3D> = new Vector.<Vector3D>;
		
		public function AnimFileToByteUtils()
		{
		}
		/**
		 * 处理文件 
		 * @param file
		 * 
		 */		
		public function process(file:File):void{
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable)
			fs.close();
				
			var resultObj:Object = AnalysisServer.getInstance().analysisAnim(str);
			
			var hierarchy:Object = AnalysisServer.getInstance().getHierarchy();

			hierarchyList = hierarchy as Vector.<ObjectBone>;
				
			var big:Array = AnalysisServer.getInstance().getMd5StrAry();
			
			var baseFrameAry:Array = getBaseFrameAry(getBaseFrameStr(big));
			
			getFrameNumAry(big);
			
			inLoop = resultObj.inLoop;
			inter = resultObj.inter;
			bounds = resultObj.bounds;
			nameHeight = resultObj.nameHeight;
			pos = resultObj.pos;
			
			writeInLoop();
			writeInter();
			writeBounds();
			writeHeight();
			writeHierarchyByte();
			writeFrame();
			writePos();
			
			writeScale();
			
			var newUrl:String = file.parent.url + "/" + file.name.split(".")[0] + ".txt";
			var newFile:File = new File(newUrl);
			fs = new FileStream();
			fs.open(newFile,FileMode.WRITE);
			fs.writeBytes(byte,0,byte.length);
			fs.close();
			
			file.deleteFile();
		}
		
		/**
		 * 处理文件 
		 * @param file
		 * 
		 */		
		public function processStr2Byte(str:String,$fileName:String=""):ByteArray{

			
			var resultObj:Object = AnalysisServer.getInstance().analysisAnim(str);
			
			var hierarchy:Object = AnalysisServer.getInstance().getHierarchy();
			
			hierarchyList = hierarchy as Vector.<ObjectBone>;
			
			var big:Array = AnalysisServer.getInstance().getMd5StrAry();
			
			var baseFrameAry:Array = getBaseFrameAry(getBaseFrameStr(big));
			
			getFrameNumAry(big);
			
			inLoop = resultObj.inLoop;
			inter = resultObj.inter;
			bounds = resultObj.bounds;
			nameHeight = resultObj.nameHeight;
			pos = resultObj.pos;
			
			writeInLoop();
			writeInter();
			writeBounds();
			writeHeight();
			writeHierarchyByte();

			writeFrame($fileName=="stand");
			writePos();
			
			//writeScale();
			
			return byte;
			
		}
		/**
		 * 写入循环帧
		 * 
		 */		
		private function writeInLoop():void{
			byte.writeInt(int(inLoop));
		}
		/**
		 * 写入插值数组 
		 * 
		 */		
		private function writeInter():void{
			if(!inter){
				byte.writeInt(0);
				return;
			}
			byte.writeInt(inter.length);
			for(var i:int;i<inter.length;i++){
				byte.writeInt(int(inter[i]));
			}
		}
		/**
		 * 写入包围盒 
		 * 
		 */		
		private function writeBounds():void{
			if(!bounds){
				byte.writeInt(0);
				return;
			}
			byte.writeInt(bounds.length);
			for(var i:int;i<bounds.length;i++){
				byte.writeFloat(bounds[i].x);
				byte.writeFloat(bounds[i].y);
				byte.writeFloat(bounds[i].z);
			}
		}
		/**
		 * 写入名字高度 
		 * 
		 */		
		private function writeHeight():void{
			byte.writeInt(int(nameHeight));
		}
		/**
		 * 写入基础骨骼信息 
		 * 
		 */		
		private function writeHierarchyByte():void{
			byte.writeInt(hierarchyList.length);
			for(var i:int;i<hierarchyList.length;i++){
				byte.writeInt(hierarchyList[i].father);
				byte.writeInt(hierarchyList[i].changtype);
				byte.writeInt(hierarchyList[i].startIndex);
				
				byte.writeFloat(hierarchyList[i].tx);
				byte.writeFloat(hierarchyList[i].ty);
				byte.writeFloat(hierarchyList[i].tz);
				
				byte.writeFloat(hierarchyList[i].qx);
				byte.writeFloat(hierarchyList[i].qy);
				byte.writeFloat(hierarchyList[i].qz);
			}
		}
		/**
		 * 写入帧数 
		 * 
		 */		
		private function writeFrame($isStand:Boolean=false):void{
	
			writeTwoByteFrame($isStand)
		}

		//写入Frame数组类型
		private function meshFrameType():Vector.<Boolean>
		{
			var $dic:Dictionary=new Dictionary;
			for(var i:Number=0;i<this.hierarchyList.length;i++){
				var k: Number = 0;
				if (hierarchyList[i].changtype & 1) {
					$dic[hierarchyList[i].startIndex + k]=true
					++k;
				} 
				if (hierarchyList[i].changtype & 2) {
					$dic[hierarchyList[i].startIndex + k]=true
					++k;
				} 
				if (hierarchyList[i].changtype & 4) {
					$dic[hierarchyList[i].startIndex + k]=true
					++k;
				} 
				
				if (hierarchyList[i].changtype & 8) {
					$dic[hierarchyList[i].startIndex + k]=false
					++k;
				} 
				
				if (hierarchyList[i].changtype & 16) {
					$dic[hierarchyList[i].startIndex + k]=false
					++k;
				} 
				if (hierarchyList[i].changtype & 32) {
					$dic[hierarchyList[i].startIndex + k]=false
					++k;
				} 

			}

			var arr:Vector.<Boolean>=new Vector.<Boolean>
			for each(var data:Number in $dic){
				arr.push(data)
			   if(arr[arr.length-1]!=$dic[arr.length-1]){
				   Alert.show("联系管理员，meshFrameType出错")
			   }
				
			}
			
			if(frameAry[0].length!=arr.length){
				Alert.show("联系管理员，meshFrameType出错")
			}
			
			
			byte.writeInt(arr.length);
			for(var j:Number=0;j<arr.length;j++){
				byte.writeBoolean(arr[j]);
			}
			return arr
	
		}
		private function writeTwoByteFrame($isStand:Boolean=false):void
		{
			

		
			var $frameTyeArr:Vector.<Boolean>=this.meshFrameType();
			
			var rgb127:Number=127
			var temp:Number=0;
			var intNum:int;
			var a:int;
			var b:int;
			
			for(var i:int;i<frameAry.length;i++){
				for(var j:int=0;j<frameAry[i].length;j++){
					if(Math.abs(temp)<Math.abs(frameAry[i][j])){
						temp=frameAry[i][j]
					}
				}
			}
			var $scaleNum:Number=rgb127*rgb127/temp;  //比例
			byte.writeBoolean($isStand) //是否为站立，这里特殊给站立的旋转设置其权重值不压缩
			byte.writeFloat($scaleNum)
			byte.writeInt(frameAry.length);
			for(var ii:int;ii<frameAry.length;ii++){
				byte.writeInt(frameAry[ii].length);
				for(var jj:int=0;jj<frameAry[ii].length;jj++){
					if($frameTyeArr[jj]){
						intNum=int(frameAry[ii][jj]*$scaleNum);
						byte.writeShort(intNum)
					}else{
						if($isStand){
							byte.writeFloat(frameAry[ii][jj])
						}else{
							byte.writeShort(int(frameAry[ii][jj]*32767))
						}
					
					
					}
				}
			}
			
		

		}
		
		private function writePos():void{
			if(!pos){
				byte.writeInt(0);
				return;
			}
			byte.writeInt(pos.length);
			for(var i:int;i<pos.length;i++){
				byte.writeFloat(pos[i].x);
				byte.writeFloat(pos[i].y);
				byte.writeFloat(pos[i].z);
			}
		}
		
		private function writeScale():void{
			byte.writeFloat(1);
		}
		
		/**
		 * 获取帧数数组 
		 * @param bigAry
		 * 
		 */		
		private function getFrameNumAry(bigAry:Array):void{
			frameAry = new Array;
			for(var i:int;i<bigAry.length;i++){
				if(isFrame(bigAry[i])){
					frameAry.push(getFrameItem(bigAry[i]));
				}
			}
		}
		
		
		
		private function getFrameItem(str:String):Array{
			var lineAry:Array = str.split("\n\r");
			var numAry:Array = new Array;
			for(var i:int;i<lineAry.length;i++){
				var s:String = lineAry[i];
				if(s.indexOf("\t") != -1){
					s = s.slice(1);
					var itemAry:Array = s.split(" ");
					if(itemAry[itemAry.length-1] == ""){
						itemAry.pop();
					}
					for(var j:int=0;j<itemAry.length;j++){
						if(isNaN(Number(itemAry[j]))){
						 trace("cccccc")
						}
						numAry.push(Number(itemAry[j]));
					}
				}
			}
			return numAry;
		}
		/**
		 * 验证是否为帧序列段 
		 * @param str 验证字符串
		 * @return 
		 * 
		 */		
		private function isFrame(str:String):Boolean{
			if(str.indexOf("baseframe") == -1 && str.indexOf("frame") != -1 && str.indexOf("BoneScale") == -1){
				return true;
			}else{
				return false;
			}
			
			
		}
			
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
			//var newAry:Array = new Array;
			var newNumAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				var s:String = ary[i];
				if(s == "" || s.indexOf("{") != -1 || s.indexOf("}") != -1){
					continue;
				}
				var numAry:Array = s.split(" ");
				newNumAry.push(Number(numAry[1]),Number(numAry[2]),Number(numAry[3]),Number(numAry[6]),Number(numAry[7]),Number(numAry[8]));
				//newAry.push(ary[i]);
			}
			return newNumAry;
		}
		
		public function processBoneNew(targetAry:Vector.<ObjectBone>):Vector.<ObjectBone>{
			
	
			var newTargetAry:Vector.<ObjectBone> = MeshToObjUtils.getStorNewTargerArr(targetAry);
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(var i:int = 0;i<targetAry.length;i++){
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
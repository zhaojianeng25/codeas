package view.exp
{
	import _Pan3D.base.ObjectBone;
	import _Pan3D.display3D.analysis.AnalysisServer;
	
	import com.maclema.mysql.Field;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

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
		public function process(file:File,newUrl:String):void{
			var newFile:File = new File(newUrl);
			file.copyTo(newFile,true);
			return;
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable)
			fs.close();
				
			var resultObj:Object = AnalysisServer.getInstance().analysisAnim(str);
			
			var hierarchy:Object = AnalysisServer.getInstance().getHierarchy()
				
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
			
			byte.compress();
			
			//var newUrl:String = file.parent.url + "/" + file.name.split(".")[0] + ".ab";
			newFile = new File(newUrl);
			fs = new FileStream();
			fs.open(newFile,FileMode.WRITE);
			fs.writeBytes(byte,0,byte.length);
			fs.close();
			
			//删除已经保存的md5anim文件
			//file.deleteFile();
			
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
		private function writeFrame():void{
			byte.writeInt(frameAry.length);
			for(var i:int;i<frameAry.length;i++){
				var frameItemAry:Array = frameAry[i];
				byte.writeInt(frameItemAry.length);
				for(var j:int=0;j<frameItemAry.length;j++){
					byte.writeFloat(frameItemAry[j]);
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
					itemAry.pop();
					for(var j:int=0;j<itemAry.length;j++){
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
			if(str.indexOf("baseframe") == -1 && str.indexOf("frame") != -1){
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
		
		
		
	}
}
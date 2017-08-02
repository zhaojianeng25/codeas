package _Pan3D.display3D.analysis
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import _Pan3D.base.ObjectBone;

	public class Md5ByteAnimAnalysis
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
		private var inter:Array;
		/**
		 * 包围盒 
		 */		
		private var bounds:Vector.<Vector3D>;
		/**
		 * 位置信息
		 */		
		private var pos:Vector.<Vector3D>;
		/**
		 * 名字高度 
		 */		
		private var nameHeight:int;
		
		private var byte:ByteArray;

		public var resultInfo:Object;

		private var newFrameAry:Array;
		
		private var scale:Number;
		public function Md5ByteAnimAnalysis()
		{
		}
		
		public function addAnim($byte:ByteArray):void{
			scale = 1;
			var t:int = getTimer();
			byte = $byte;
			byte.position = 0;
			byte.uncompress();
			readInLoop();
			readInter();
			readBounds();
			readHeight();
			readHierarchyByte();
			readFrame();
			coverFrame();
			readPos();
			readScale();
			
			setRestult();
			//trace("解析全部耗时：" + (getTimer()-t))
		}
		private function setRestult():void{
			resultInfo = new Object;
			resultInfo.frames = newFrameAry;
			resultInfo.inLoop = inLoop;
			resultInfo.bounds = bounds;
			resultInfo.nameHeight = nameHeight;
			resultInfo.inter = inter;
			resultInfo.pos = pos;
			resultInfo.scale = scale;
		}
		
		/**
		 * 读取循环帧
		 * 
		 */		
		private function readInLoop():void{
			inLoop = byte.readInt();
		}
		/**
		 * 读取插值数组 
		 * 
		 */		
		private function readInter():void{
			inter = new Array;
			var interLenght:int = byte.readInt();
			for(var i:int;i<interLenght;i++){
				inter.push(byte.readInt());
			}
		}
		/**
		 * 读取包围盒 
		 * 
		 */		
		private function readBounds():void{
			var boundLength:int = byte.readInt();
			bounds = new Vector.<Vector3D>;
			for(var i:int;i<boundLength;i++){
				bounds.push(new Vector3D(byte.readFloat(),byte.readFloat(),byte.readFloat()));
			}
		}
		/**
		 * 写入名字高度 
		 * 
		 */		
		private function readHeight():void{
			nameHeight = byte.readInt();
		}
		/**
		 * 写入基础骨骼信息 
		 * 
		 */		
		private function readHierarchyByte():void{
			var hierarchyLength:int = byte.readInt();
			hierarchyList = new Vector.<ObjectBone>;
			for(var i:int;i<hierarchyLength;i++){
				var objBone:ObjectBone = new ObjectBone;
				objBone.father = byte.readInt();
				objBone.changtype = byte.readInt();
				objBone.startIndex = byte.readInt();
				
				objBone.tx = byte.readFloat();
				objBone.ty = byte.readFloat();
				objBone.tz = byte.readFloat();
				
				objBone.qx = byte.readFloat();
				objBone.qy = byte.readFloat();
				objBone.qz = byte.readFloat();
				
				hierarchyList.push(objBone);
			}
		}
		/**
		 * 写入帧数 
		 * 
		 */		
		private function readFrame():void{
			var frameAryLength:int = byte.readInt();
			frameAry = new Array;
			
			for(var i:int;i<frameAryLength;i++){
				var frameItemAryLength:int = byte.readInt();
				var frameItemAry:Array = new Array;
				frameAry.push(frameItemAry);
				for(var j:int=0;j<frameItemAryLength;j++){
					frameItemAry.push(byte.readFloat());
				}
			}
		}
		private function readScale():void{
			if(!byte.bytesAvailable){
				return;
			}
			scale = byte.readFloat();
		}
		/**
		 * 读取位置
		 * 
		 */		
		private function readPos():void{
			if(!byte.bytesAvailable){
				return;
			}
			var boundLength:int = byte.readInt();
			pos = new Vector.<Vector3D>;
			for(var i:int;i<boundLength;i++){
				pos.push(new Vector3D(byte.readFloat(),byte.readFloat(),byte.readFloat()));
			}
		}
		/**
		 * 帧数转换 
		 * 
		 */		
		private function coverFrame():void{
			newFrameAry = new Array;
			for(var i:int;i<frameAry.length;i++){
				newFrameAry.push(frameToBone(frameAry[i]));
			}
		}
		
		public function frameToBone(frameData:Array):Array{
			var _arr:Array=new Array;
			
			for( var i:int=0;i<hierarchyList.length;i++){
				var _temp:ObjectBone=new ObjectBone();
				_temp.father = hierarchyList[i].father;
				_temp.name = hierarchyList[i].name;
				_temp.tx=hierarchyList[i].tx;
				_temp.ty=hierarchyList[i].ty;
				_temp.tz=hierarchyList[i].tz;
				_temp.qx=hierarchyList[i].qx;
				_temp.qy=hierarchyList[i].qy;
				_temp.qz=hierarchyList[i].qz;
				
				var k:int = 0;
				if (hierarchyList[i].changtype & 1){
					_temp.tx = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				if (hierarchyList[i].changtype & 2){
					_temp.ty = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				if (hierarchyList[i].changtype & 4){
					_temp.tz = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				if (hierarchyList[i].changtype & 8){
					_temp.qx = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				if (hierarchyList[i].changtype & 16){
					_temp.qy = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				if (hierarchyList[i].changtype & 32){
					_temp.qz = frameData[hierarchyList[i].startIndex + k];
					++k;
				}
				_arr.push(_temp);
			}
			return _arr;
		}
		
		public function dispose():void{
			frameAry = null;
			hierarchyList = null;
			inter = null;
			bounds = null;
			byte = null;
			resultInfo = null;
			newFrameAry = null;
		}
		
	}
}
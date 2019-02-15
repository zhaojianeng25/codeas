package out
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import spark.components.Alert;

	public class ResetRoleResVo  extends ResetResVo
	{
		public function ResetRoleResVo($byte:ByteArray)
		{
			super($byte);
			
			this.version=  baseByte.readInt();
			this.fileurl  = baseByte.readUTF();
	
			if (this.version <35) { //环境参数
			    return 
			}
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.baseByte.readFloat();
			this.meshDataManagerReaData()
			this.readAction()
			
	
		}
		private function meshDataManagerReaData():void
		{
	 
			var fileScale:Number = baseByte.readFloat();
			var tittleHeight:Number = baseByte.readFloat();
			var hitBox:Point=new Point
			hitBox.x = baseByte.readFloat();
			hitBox.y = baseByte.readFloat();
			
			var meshNum: Number = baseByte.readInt();
	 
			
			for (var i: Number = 0; i < meshNum; i++) {
			    	this.readBindPosByte(this.baseByte);
					this.readMesh2OneBuffer(this.baseByte);
					var materialUrl:String = this.baseByte.readUTF();
					
					ResetRoleResVo.readMaterialParamData(this.baseByte);
					var particleNum: Number = this.baseByte.readInt();
			 
					for (var j: Number = 0; j < particleNum; j++) {
						this.baseByte.readUTF();
						this.baseByte.readUTF();
					}
					
			}
			
			var sokcetLenght: Number = this.baseByte.readInt();
			for (var k: Number = 0; k< sokcetLenght; k++) {
				this.baseByte.readUTF();
				this.baseByte.readUTF();
				this.baseByte.readInt();
				this.baseByte.readFloat();
				this.baseByte.readFloat();
				this.baseByte.readFloat();
				this.baseByte.readFloat();
				this.baseByte.readFloat();
				this.baseByte.readFloat();
			}
	 
		
		
		}
		private function readAction(): void {
		     this. getZipByte(this.baseByte)
		}
		
		public function getZipByte($byte: ByteArray): void {
			var zipLen: Number = $byte.readInt();
			$byte.position+=zipLen
		}
	 
		public function readMesh2OneBuffer(byte: ByteArray): void {
			var len: Number = byte.readInt()
			
			var typeItem: Vector.<Boolean> = new Vector.<Boolean> ;
			var dataWidth: Number = 0;
			for (var i: Number = 0; i < 5; i++) {
				var tf: Boolean = byte.readBoolean();
				typeItem.push(tf);
				if (tf) {
					if (i == 1) {
						dataWidth += 2;
					} else {
						dataWidth += 3;
					}
				}
			}
			
			dataWidth += 8;
			
			len *= dataWidth * 4;
			
			var uvsOffsets: Number = 3; // 1
			var normalsOffsets: Number = uvsOffsets + 2; // 2
			var tangentsOffsets: Number = normalsOffsets + 3; //3
			var bitangentsOffsets: Number = tangentsOffsets + 3; //4
			var boneIDOffsets: Number;
			if (typeItem[2]) {//normal
				if (typeItem[4]) {
					boneIDOffsets = bitangentsOffsets + 3;
				} else {
					boneIDOffsets = normalsOffsets + 3;
				}
			} else {
				boneIDOffsets = uvsOffsets + 2;
			}
			var boneWeightOffsets: Number = boneIDOffsets + 4;
			
			
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  3, 0, dataWidth);//vertices
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  2, uvsOffsets, dataWidth);//uvs
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  3, normalsOffsets, dataWidth);//normals
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  3, tangentsOffsets, dataWidth);//tangents
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  3, bitangentsOffsets, dataWidth);//bitangents
			
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  4, boneIDOffsets, dataWidth, 2);//boneIDAry
			ResetRoleResVo.readBytes2ArrayBuffer(byte,  4, boneWeightOffsets, dataWidth, 1);//boneWeightAry
			
			ResetRoleResVo.readIntForTwoByte(byte);
			ResetRoleResVo.readIntForTwoByte(byte);
			
			
			
		}
		//读取材质参数
		public static function readMaterialParamData(byte: ByteArray): void {
			var mpNum: Number = byte.readInt();
			if (mpNum > 0) {
		 
				for (var j: Number = 0; j < mpNum; j++) {
					var obj: Object ={}
					obj.name = byte.readUTF();
					obj.type = byte.readByte();
					if (obj.type == 0) {
					  	byte.readUTF();
					} else if (obj.type == 1) {
					 	 byte.readFloat();
					} else if (obj.type == 2) {
						  byte.readFloat();
						 byte.readFloat();
					} else if (obj.type == 3) {
						  byte.readFloat();
						  byte.readFloat();
						  byte.readFloat();
					}
		 
				}
		 
			}
 
		}
		public static function readIntForTwoByte(byte: ByteArray): void {
			var iLen: Number = byte.readInt();
 
			
			for (var i: Number = 0; i < iLen; i++) {
				 byte.readShort()
			}
		}
		public static function readBytes2ArrayBuffer($byte: ByteArray, $dataWidth: Number, $offset: Number, $stride: Number, $readType: Number = 0): void {
			var verLength: Number = $byte.readInt();
			
			if (verLength <= 0) {
				return;
			}
			
			var scaleNum: Number;
			if ($readType == 0) {
				scaleNum = $byte.readFloat();
			}
			
			var readNum: Number = verLength / $dataWidth;
			for (var i: Number = 0; i < readNum; i++) {
				var pos: Number = $stride * i + $offset;
				for (var j: Number = 0; j < $dataWidth; j++) {
					
					if ($readType == 0) {
					    $byte.readShort()
					} else if ($readType == 1) {
						 $byte.readByte()
					} else if ($readType == 2) {
					 $byte.readByte()
					} else if ($readType == 3) {
						$byte.readByte()
					} else if ($readType == 4) {
						 $byte.readFloat()
					}
					
					
				}
				
			}
			
			
			
		}
		private function readBindPosByte(byte: ByteArray):void  {
			var bindPosLength: Number = byte.readInt();
			var bindPosAry: Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
			for (var j: Number = 0; j < bindPosLength; j++) {
				  byte.readFloat(), byte.readFloat(), byte.readFloat(),
					byte.readFloat(), byte.readFloat(), byte.readFloat();
		 
			}
	
			
		}
 
		
		public static function chuangeFileByFile($file:File ):void
		{
			
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.READ);
			var _byte:ByteArray=new ByteArray;
			$fs.readBytes(_byte,0,$fs.bytesAvailable)
			$fs.close();
			
 			var $ResetResRoleVo:ResetRoleResVo=new ResetRoleResVo(_byte);
			if($ResetResRoleVo.version>=35){
				$ResetResRoleVo.read();
				$ResetResRoleVo.read();
				$ResetResRoleVo.read();
				$ResetResRoleVo.saveFile($file)
			}else{
			    trace("版本过度",$ResetResRoleVo.version,$ResetResRoleVo.fileurl)
				ResetResVo.nofileItem.push("版本过度"+$ResetResRoleVo.version+$ResetResRoleVo.fileurl);
			}

		}
        public static var  finishFun:Function
		public static  function oneByOne():void
		{
			
			if(ResetResVo.outFileItem.length){
				var temp:File= ResetResVo.outFileItem.pop();
				trace("准备处理文件",temp.name)
     			ResetRoleResVo.chuangeFileByFile(temp)
 				setTimeout(oneByOne,100)
			}else{
				if(Boolean(ResetRoleResVo.finishFun)){
					ResetRoleResVo.finishFun()
					return;
				}
				if(ResetResVo.nofileItem.length){
					var $tipStr:String="";
					for(var i:Number=0;i<ResetResVo.nofileItem.length&&i<10;i++){
						$tipStr+=ResetResVo.nofileItem[i] +"\n";
					}
					if(ResetResVo.nofileItem.length>10){
						$tipStr+="\n---共有"+ResetResVo.nofileItem.length+"文件需要补充";
					}
					Alert.show($tipStr,"缺省文件");
				}else{
					Alert.show("转换完成","完成");
				}
			}
			
		}
	}
}
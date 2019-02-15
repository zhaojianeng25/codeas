package out
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import spark.components.Alert;

	public class ResetResVo
	{
		public static var IMG_TYPE: Number = 1;
		public static var  OBJS_TYPE: Number = 2;
		public static var  MATERIAL_TYPE: Number = 3;
		public static var  PARTICLE_TYPE: Number = 4;
		public static var  SCENE_TYPE: Number = 5;
		public static var  ZIP_OBJS_TYPE: Number = 6;
		public static var  PREFAB_TYPE: Number = 1;
		public static var  SCENE_PARTICLE_TYPE: Number = 11;

		
		public static var resRootFile:String
		public static var outFileItem:Vector.<File>
		public static var nofileItem:Array=[]
			
		public var version:Number
		public var fileurl:String
		
		public function ResetResVo($byte:ByteArray)
		{
			this.baseByte=$byte;

 
	 
		}

		public var baseByte:ByteArray

		public  function read(): void {

			var fileType: Number = this.baseByte.readInt();
			
			switch(fileType)
			{
				case ResetResVo.IMG_TYPE:
				{
					this.readAndChuange();
					break;
				}
				case ResetResVo.MATERIAL_TYPE:
				{
					this.readAndChuange();
					break;
				}
				case ResetResVo.PARTICLE_TYPE:
				{
					this.readAndChuange();
					break;
				}
				case ResetResVo.OBJS_TYPE:
				{
					this.readObj();
					break;
				}
				case ResetResVo.ZIP_OBJS_TYPE:
				{
 
					trace("obj模型暂不处理")
					this.readZipObj()
					break;
				}
					
				default:
				{
					Alert.show("缺少类型");
					break;
				}
			}
			

		}
		public function readObj(): void {
			var objNum: Number = this.baseByte.readInt();
			for (var i: Number = 0; i < objNum; i++) {
				var url: String =   this.baseByte.readUTF();
				var size: Number = this.baseByte.readInt();
				this.baseByte.position+=size
				trace(url)
		 
			}
	 
			
		}
		private function readZipObj(): void {
			var zipLen: Number = this.baseByte.readInt();
			this.baseByte.position += zipLen;
		 
		}
		private function addNotFileByurl($url:String):void
		{
			
			if(ResetResVo.nofileItem.indexOf($url)==-1){
				ResetResVo.nofileItem.push($url);
			}
		}
		private function  readAndChuange(): void {

			var imgNum:Number = this.baseByte.readInt();
			var $imgSartPos:Number=this.baseByte.position;
			var _basePicBype:ByteArray=new ByteArray;
			for (var i: Number = 0; i < imgNum; i++) {
				var url: String =  this.baseByte.readUTF();
				var imgSize:Number = this.baseByte.readInt();
		        var $imgByte:ByteArray=new ByteArray;
				this.baseByte.readBytes($imgByte,0,imgSize);
				var $imgFile:File=new File(ResetResVo.resRootFile+url)
				if($imgFile.exists){
					var $fs:FileStream = new FileStream;
					$fs.open($imgFile,FileMode.READ);
					var $byte:ByteArray=new ByteArray;
					$fs.readBytes($byte,0,$fs.bytesAvailable);
					_basePicBype.writeUTF(url);
					_basePicBype.writeInt($byte.length);
					_basePicBype.writeBytes($byte,0,$byte.length);
					$fs.close();
					trace("更新了文件",url)
				
				}else{
		 
				
					  this.addNotFileByurl(url)
					  _basePicBype.writeUTF(url);
					  _basePicBype.writeInt($imgByte.length);
					  _basePicBype.writeBytes($imgByte,0,$imgByte.length);
				}
				
			}
			var $imgEndPos:Number=this.baseByte.position;
			

			
			var $a:ByteArray=new ByteArray();
			var $b:ByteArray=new ByteArray();
			var $c:ByteArray=new ByteArray();
			
			$a.writeBytes(this.baseByte,0,$imgSartPos);//前面部分
			$b.writeBytes(this.baseByte,$imgSartPos,$imgEndPos-$imgSartPos); //图片部分
			$c.writeBytes(this.baseByte,$imgEndPos,this.baseByte.length-$imgEndPos); //后面部分
			
			$b=_basePicBype;
 
			var $outFileByte:ByteArray=new ByteArray();
			$outFileByte.writeBytes($a,0,$a.length)
			$outFileByte.writeBytes($b,0,$b.length)
			$outFileByte.writeBytes($c,0,$c.length)
				
		 
		     this.baseByte=$outFileByte;
			 this.baseByte.position=$imgSartPos+_basePicBype.length;
				
	 
			
		}
 
 
		
		public function saveFile($file:File):void
		{
			var fs:FileStream = new FileStream;
			fs.open( $file,FileMode.WRITE);
			fs.writeBytes(this.baseByte,0,this.baseByte.length);
			fs.close();

		
	
			
		}
	}
}
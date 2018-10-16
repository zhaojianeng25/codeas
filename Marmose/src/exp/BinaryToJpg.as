package exp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import modules.hierarchy.FileSaveModel;

	public class BinaryToJpg
	{
		private static var instance:BinaryToJpg;
		public function BinaryToJpg()
		{
			jpgEncoder = new JPEGEncoder(100);
		}
		public static function getInstance():BinaryToJpg{
			if(!instance){
				instance = new BinaryToJpg();
			}
			return instance;
		}
		


		public function toPaly(value:Boolean=true):void
		{
	
			var $file:File=new File;
			//var txtFilter:FileFilter = new FileFilter("Text", ".xml;*.xml;");
			var txtFilter:FileFilter = new FileFilter("Text",".txt;*.TXT;");
			$file.browseForOpen("程序列表 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				if(value){
					showDic($file.parent)
				}else{
					expOneFile($file);
				}

				
			}

		}
		private function expOneFile($file:File):void
		{
			this.allFileItem=new Vector.<File>
			this.allFileItem.push($file)
			this.totalNum=this.allFileItem.length
			this.oneByone()
		}
			
	
		private function showDic($perentFile:File):void
		{
			this.allFileItem=new Vector.<File>
			var $list:Array=$perentFile.getDirectoryListing();
			for(var i:Number=0;i<$list.length;i++){
				var $one:File=$list[i];
				if($one.extension=="txt"){
	
					if($one.url.search("1008")==-1){
						this.allFileItem.push($one)
					}
			
				}
			}
			this.totalNum=this.allFileItem.length
			this.oneByone()
		}
		private var totalNum:Number
		
		private function oneByone():void
		{
			if(this.allFileItem.length<1){
				trace("结束了");
			}
			while(this.allFileItem.length){
				trace("进度", 	this.totalNum-this.allFileItem.length, 	"/",this.totalNum);
				var $file:File=	this.allFileItem.pop();
				this.readFile($file)
			}
		}
			
		private var allFileItem:Vector.<File>
		private var jpgEncoder:JPEGEncoder;
		private function readFile($file:File):void
		{
	
			var $fs:FileStream = new FileStream();   
			$fs.open($file,FileMode.READ);    
			var  $baseStr:String=$fs.readUTFBytes($fs.bytesAvailable);
			$fs.close();
			var $arr:Array= $baseStr.split(",")
			var $textByte:ByteArray=new ByteArray()
			
			trace("$arr.length",$arr.length)

			
			var $bitmapdata:BitmapData=new BitmapData($arr.shift(),$arr.shift())
			trace($bitmapdata.width,$bitmapdata.height)
	
			for(var i:Number=0;i<$bitmapdata.width;i++){
				for(var j:Number=0;j<$bitmapdata.height;j++){

					var $color:Vector3D=new Vector3D(Math.floor(Math.random()*255),Math.floor(Math.random()*255),Math.floor(Math.random()*255),255);
					var $sort:Number=(j*$bitmapdata.width+i)*4;
					$color.x=$arr[$sort+0]
					$color.y=$arr[$sort+1]
					$color.z=$arr[$sort+2]
					var $colorUint:uint=MathCore.argbToHex($color.w,$color.x,$color.y,$color.z);
					$bitmapdata.setPixel32(i,($bitmapdata.height-j)-1,$colorUint);
				}
			}
			
		
			var $jpgFileUrl:String=$file.url
			$jpgFileUrl=$jpgFileUrl.replace(".txt",".jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg($bitmapdata,$jpgFileUrl);
//			var $bmp:Bitmap=new Bitmap($bitmapdata);
//			Scene_data.stage.addChild($bmp);
			$bitmapdata.dispose()
			trace($jpgFileUrl)
	
				setTimeout(oneByone,2000)//可能没有加载完成，特再1秒后重刷新一下
		}
	
	}
}
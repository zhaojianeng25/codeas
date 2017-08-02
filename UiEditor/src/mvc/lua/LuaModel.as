package mvc.lua
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	

	public class LuaModel
	{
		private static var instance:LuaModel;
		public function LuaModel()
		{
		}
		public static function getInstance():LuaModel{
			if(!instance){
				instance = new LuaModel();
			}
			return instance;
		}
		private var selectFile:File
		public function luaExpCsv():void	
		{
			
			selectFile=new File
			var txtFilter:FileFilter = new FileFilter("Text", ".lua;*.lua;");
			selectFile.browseForOpen("打开工程文件 ",[txtFilter]);
			selectFile.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				var loaderinfo : LoadInfo = new LoadInfo(selectFile.url, LoadInfo.XML, onObjLoad,0);
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}
			
		}
		
		private const LINE_FEED:String = String.fromCharCode(10);
		protected function onObjLoad($str : String) : void {

			parseLineByStr($str)
		}
		private function parseLineByStr($str:String):void
		{
		
			this.chinaStr=""
			var lines:Array = $str.split(LINE_FEED);
			var loop:uint = lines.length;
			for(var i:uint = 0; i < loop; ++i)
			{

				this.getTittleName(lines[i])
				this.parseLine(lines[i])
			}

			var $file:File=new File(File.desktopDirectory.url+"/"+selectFile.name.replace(".lua",".csv"));
			this.writeToXml($file,this.outStr)
			
		    Alert.show(decodeURI($file.url),"导出Csv成功")
		}
		private var chinaStr:String;
		private function getTittleName($str:String):void
		{
			var id:Number=$str.search("--")

			if(id!=-1){
			
				var a:Array=$str.split(SPACE);
				var b:Array=String(a.pop()).split(":");
				//trace(b[0])
				var $ets:String=b.pop();
			
				var c:Array=$ets.split(String.fromCharCode(9));
				
				var $ends:String=c.pop()
				if($ends.length){
					var kkstr:String=""
					for(var i:Number=0;i<$ends.length;i++){
						var ascCode:int = unicodeToAnsi($ends.charAt(i));
					    if(ascCode==13){
						   i=$ends.length
						}else{
							kkstr+=$ends.charAt(i)
						}
					}
					//trace($ends,$ends.length,$ends.charAt($ends.length-1))
					trace(kkstr)
					this.chinaStr+=kkstr+","
				}
			}
		
		}
		private const SPACE:String = String.fromCharCode(32);
		private static function unicodeToAnsi(str:String):int{
			var byte:ByteArray =new ByteArray();
			byte.writeMultiByte(str,"gbk");
			byte.position = 0;
			if (byte.length>1){
				return byte.readUnsignedShort();
			}else{
				return byte.readUnsignedByte();
			}
		}
		public static function removeBlank(char:String):String
		{
			if (char == null)
			{
				return null;
			}
			var pattern:RegExp = /^\s*|\s*$/;
			return char.replace(pattern, "");
		} 
		private function Trim(ostr:String):String 
		{
			return ostr.replace(/([ ]{1})/g,"");
		}
	
		private function parseLine($str:String):void
		{
		    var $obj:Object=new Object
            var $index:int=$str.search("]")
			if($index>0){
				var $begin:int=$str.search("{")
				var $end:int=$str.search("}")
				var datastr:String=$str.substring($begin,$str.length)
				datastr=Trim(datastr)
				var aa:Array=datastr.split("=");
				var needChangeArr:Array=new Array
				for(var i:Number=0;i<aa.length;i++)
				{
					var bb:Array=String(aa[i]).split(",")
					var tabStr:String=String(bb[bb.length-1]).replace("{","")
					needChangeArr.push(tabStr)
				}
				for(var j:Number=0;j<needChangeArr.length;j++){
					needChangeArr[j]=Trim(needChangeArr[j])
					needChangeArr[j]=removeBlank(needChangeArr[j])
					if(String(needChangeArr[j]).length){
						var $valname:String=needChangeArr[j]
						$obj[$valname]=this.fineValData($valname,datastr)
					}
				}
				if(!this.outStr){
					this.saveBaseStr(needChangeArr)
				}
				this.saveValData(needChangeArr,datastr)
			}
		
		}	
		private function  saveBaseStr(needChangeArr:Array):void
		{
			this.outStr=""
			for(var j:Number=0;j<needChangeArr.length;j++){
				if(String(needChangeArr[j]).length){
					this.outStr+=needChangeArr[j]+","
				}
			}
			this.outStr+="\n";
			this.outStr+=this.chinaStr+"\n"
		}
		private function  saveValData(needChangeArr:Array,datastr:String):void
		{
			for(var j:Number=0;j<needChangeArr.length;j++){
				if(String(needChangeArr[j]).length){
					var $valname:String=needChangeArr[j]

					this.outStr+=this.fineValData($valname,datastr)+","
				}
			}
			this.outStr+="\n"
		}
		private var outStr:String
		private  function writeToXml($file:File,str:String):void
		{

			
			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);
			for(var i:int = 0; i < str.length; i++)
			{
				fs.writeMultiByte(str.substr(i,1),"gbk");
			}
			fs.close();
			
		}
		private function fineValData($val:String,$str:String):String
		{
		   //trace($val,$str);
		   var $i:Number
		   $i=$str.search($val);
		   if($i==-1){
			   trace("1")
		   }
		   var $a:String=$str.substring($i,$str.length);
		   //trace($a)
		   $i= $a.search("=")
		   if($i==-1){
			   trace("2")
		   }
		  // trace("$i",$i)
		   var $bstr:String="";
		   var $knum:Number=0
		   while($i<$str.length){
			   $i++
			   var tempStr:String=$a.substr($i,1);
			   if(tempStr=="{"){
				   $knum++
			   }
			   if(tempStr=="}"){
				   $knum--
			   }
			   if(tempStr==","){
				   if($knum==0){
					   $i=$str.length
					   return $bstr
				   }else{
					   $bstr+="|"
				   }
			   }else{
				   $bstr+=tempStr;
			   }
		
		   }
		   trace("这是有错的")
		   return null
		   
		}
		
	}
}
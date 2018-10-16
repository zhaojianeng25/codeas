package modules.expres
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import modules.terrain.TerrainDataSaveToA3D;
	

	public class ExpResModel
	{
		private static var instance:ExpResModel;
		public static var expArpg:Boolean=true;//是否连接表导出
		public static function getInstance():ExpResModel{
			if(!instance){
				instance = new ExpResModel();
			}
			return instance;
		}
		public function ExpResModel()
		{
			
		}
		
		private var beakFun:Function;
		public function initData(bFun:Function,$url:String=null):void
		{
			this.beakFun=bFun
			if(tb){
				this.beakFun();
			}else{
			//	var rootUrl:String="http://192.168.88.25/net/res/"
			//	this.loadDataByUrl("http://192.168.88.5:8818/static/data/tb.txt?x="+String(Math.random()))
				this.loadConfigFile();
			}
		}

		private function loadConfigFile():void
		{
			var directory:File = File.applicationDirectory; 
			var $configFile:File=new File(directory.nativePath+"/config.txt");
			if($configFile.exists){
				var fs:FileStream = new FileStream;
				fs.open($configFile,FileMode.READ);
				var $str:String = fs.readUTFBytes(fs.bytesAvailable)
				fs.close();
				var $item:Object=JSON.parse($str);
				if($item.type=="xiaodou"){
					this.loadXiaoDouBin($item.tburl)
				}
				if($item.type=="panjiazhi"){
					this.loadPanjiazhiTabBin($item.tburl)
				}
			}else{
				Alert.show($configFile.nativePath,"没有文件")
			}
		
		}
		private function loadPanjiazhiTabBin($url:String,$needBfun:Boolean=true):void
		{
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.XML, onLoadXiaoDouFinish,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			this.hasTbData=true
			tb=new Dictionary()
			function onLoadXiaoDouFinish(str:String):void{
				var $item:Object=JSON.parse(str).tabels;
				for(var j:Number=0;j<$item.length;j++){
					var $name:String=$item[j].name
					var $tbRes:Array=$item[j].list
					var vo:ResTabelVo=new ResTabelVo();
					vo.data=new Vector.<Vector.<String>>
					for(var i:Number=0;i< $tbRes.length;i++){
						if($tbRes[i]){
							if(vo.field){
							}else{
								vo.field=new Array();
								for(var $fieldName:* in $tbRes[i]){
									vo.field.push($fieldName);
								}
								
							}
							var $dataArray:Vector.<String>=new Vector.<String>
							for(var $keyValue:* in $tbRes[i]){
								$dataArray.push($tbRes[i][$keyValue]);
							}
							vo.data.push($dataArray);
						}
						
					}
					
					tb[$name]=vo;
				}
				if($needBfun){
					beakFun();
				}
			
			}
			
		}
		
		
		public function changeTbData():void
		{
			Alert.show("请选择本次将要导出的数据库(每次重启都需要设置)","警告",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
			{
				if(evt.detail == Alert.YES){
					
					var $file:File=new File;
					$file.browseForOpen("Open");
					$file.addEventListener(Event.SELECT,onSelect);
					function onSelect(e:Event):void
					{
						
						var fs:FileStream = new FileStream;
						fs.open($file,FileMode.READ);
						var $str:String = fs.readUTFBytes(fs.bytesAvailable)
						fs.close();
						var $item:Object=JSON.parse($str);
						if($item.type=="xiaodou"){
							loadXiaoDouBin($item.tburl,false)
							
							Alert.show("小逗游戏路径配置成功")
						}
				
					}
					
				}
			});
			/*
			Alert.show("请选择本次将要导出的数据库(每次重启都需要设置)","警告",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
			{
				if(evt.detail == Alert.YES){
					
					var $file:File=new File;
					$file.browseForOpen("Open");
					$file.addEventListener(Event.SELECT,onSelect);
					function onSelect(e:Event):void
					{
						
						var $fs:FileStream = new FileStream;
						$fs.open($file,FileMode.READ);
						var $byte:ByteArray=new ByteArray;
						$fs.readBytes($byte,0,$fs.bytesAvailable);
						
						
						$fs.close();
						
						$byte.endian = Endian.LITTLE_ENDIAN;
						var $len:int = $byte.readUnsignedInt();
						var $outByte: ByteArray = new ByteArray();
						$outByte.length = $len;
						$byte.readBytes($outByte, 0, $len);
						$outByte.uncompress();
						var $outStr:String = $outByte.readUTFBytes($outByte.length);
						var $item:Object=JSON.parse($outStr);
						
			
						tb=new Dictionary()
						for(var $name:* in $item){
							var $tbRes:Array=$item[$name]
							
							trace($name)
							
							var vo:ResTabelVo=new ResTabelVo();
							vo.data=new Vector.<Vector.<String>>
							for(var i:Number=0;i< $tbRes.length;i++){
								if(vo.field){
								}else{
									vo.field=new Array();
									for(var $fieldName:* in $tbRes[i]){
										vo.field.push($fieldName);
									}
									
								}
								var $dataArray:Vector.<String>=new Vector.<String>
								for(var $keyValue:* in $tbRes[i]){
									$dataArray.push($tbRes[i][$keyValue]);
								}
								vo.data.push($dataArray);
							}
							
							tb[$name]=vo;
						}
					
					}
					
				}
			});
			*/
		
		}
		private function loadXiaoDouBin($url:String,$needBfun:Boolean=true):void
		{
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.BYTE, onLoadXiaoDouFinish,10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			this.hasTbData=true
			 tb=new Dictionary()
			function onLoadXiaoDouFinish($byte:ByteArray):void{
				$byte.endian = Endian.LITTLE_ENDIAN;
				var $len:int = $byte.readUnsignedInt();
				var $outByte: ByteArray = new ByteArray();
				$outByte.length = $len;
				$byte.readBytes($outByte, 0, $len);
				$outByte.uncompress();
				var $outStr:String = $outByte.readUTFBytes($outByte.length);
				var $item:Object=JSON.parse($outStr);
				for(var $name:* in $item){
					var $tbRes:Array=$item[$name]
						
					if("tb_skills"==$name){
						trace($tbRes)
					}
					var vo:ResTabelVo=new ResTabelVo();
					vo.data=new Vector.<Vector.<String>>
					for(var i:Number=0;i< $tbRes.length;i++){
						if($tbRes[i]){
							if(vo.field){
							}else{
								vo.field=new Array();
								for(var $fieldName:* in $tbRes[i]){
									vo.field.push($fieldName);
								}
								
							}
							var $dataArray:Vector.<String>=new Vector.<String>
							for(var $keyValue:* in $tbRes[i]){
								$dataArray.push($tbRes[i][$keyValue]);
							}
							vo.data.push($dataArray);
						}
						
					}
					
					tb[$name]=vo;
				}
				if($needBfun){
					beakFun();
				}
				
			}
			
		}
		
		public function loadDataByUrl(value:String):void
		{
			var loaderinfo : LoadInfo = new LoadInfo(value, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		
		}
		protected function onObjLoad($str : String) : void {
			this.parseLineByStr($str)
		}
        private var tb:Dictionary;
		private function parseLineByStr($str:String):void
		{
			this.hasTbData=true
				
			this.tb=new Dictionary;
			var lines:Array = $str.split(String.fromCharCode(13));
			var loop:uint = lines.length/4;
			for(var i:uint = 0; i < loop; ++i)
			{
				var $name:String=lines[i*4+0];
				var $field:String=lines[i*4+1];
				var $type:String=lines[i*4+2];
				var $data:String=lines[i*4+3];
				var vo:ResTabelVo=new ResTabelVo();
				vo.parseTable($name,$field,$data);
				trace("表",$name)
				tb[$name]=vo;
				
			}
			
			this.beakFun();
		}
		public var hasTbData:Boolean=false
			
		public function getListByTabelAndfield($tbName:String,$fieldName:String):Vector.<String>
		{
			if(this.tb.hasOwnProperty($tbName)){
				var vo:ResTabelVo=this.tb[$tbName];
				return vo.getlistByField($fieldName)
			}else{
				trace("没有表")
			}
		
			return null;
		}
		public function getTableField($tbName:String):Array
		{
			if(this.tb.hasOwnProperty($tbName)){
				var vo:ResTabelVo=this.tb[$tbName];
				return vo.field
			}else{
				trace("没有表")
			}
			return null
		}
		public function getTablList():Array
		{
			var arr:Array=new Array
			for each(var vo:ResTabelVo in this.tb){
				arr.push(vo.name)
			}
			return arr
		}
			

		
	}
}

package mvc.top
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Alert;

	public class MakeJsBagModel
	{
		private static var instance:MakeJsBagModel;
		public function MakeJsBagModel()
		{
		}
		public static function getInstance():MakeJsBagModel{
			if(!instance){
				instance = new MakeJsBagModel();
			}
			return instance;
		}
		private function countVal():void
		{

			keyDis=new Dictionary
			makeSystemVal()
			//var htmlFile:File=new File(JsBagRootUrl+"dest/sss.js");
			var htmlFile:File=new File(JsBagRootUrl+"dest/h5web.js");
			var $fsScene:FileStream = new FileStream;
			$fsScene.open(htmlFile,FileMode.READ);
			var $str:String = $fsScene.readUTFBytes($fsScene.bytesAvailable)
			$fsScene.close()
		
	        var  j:uint;
			for(j=65;j<=90;j++){
			
				keyArr.push(String.fromCharCode(j))
				keyArr.push(String.fromCharCode(j+(97-65)))

				
			}

//			$str="base/cube/e"
//			trace($str)
			var lines:Array=	ERT($str)
			_jsFileItem=new Vector.<String>;
			for(var i:uint = 0; i < lines.length; i++){
				meshLineStr(lines[i])
			}
	
			var tempArr:Array=new Array;
			for(var k:Object in keyDis)
			{
				var tempObj:Object=new Object;
				tempObj.name=k;
				tempObj.num=keyDis[k]
				tempArr.push(tempObj)
			}
			tempArr.sortOn(["num"],[Array.NUMERIC]);
			canChangeValDic=new Dictionary
			var testDic:Dictionary=new Dictionary
			
			for(var w:uint=0;w<tempArr.length;w++){
				
				if("B_money_icon"==tempArr[w].name){
				
					trace(tempArr[w].name)
				}
				
				tempArr[w].val=tempArr[w].name
				
				if(tempArr[w].num>=240){//287
					tempArr[w].val="idccav0001_"+String(w);
					canChangeValDic[tempArr[w].name]=tempArr[w];
					trace("-")
				}
				trace(tempArr[w].name,tempArr[w].num,tempArr[w].val);
				
			}
			trace("----------")
			for each(var disobj:Object in canChangeValDic){
			
				trace(disobj.name)
			}
			trace("共=>",tempArr.length);
			outStr=""
			for( i = 0; i < lines.length; i++){
		
				replayValMath(lines[i])
			}

			writeToXml(new File(JsBagRootUrl+"dest/out.js"),outStr)
			
			Alert.show("over")
	
		}
		private function meshLineStr($str:String):void
		{
			
			var lll:String=$str;
			if($str.indexOf("//")!=-1){
				var anum:uint=$str.indexOf("//");
				$str=  $str.substring(0,anum);
			}
			
			
			
			var strVal:String=""
			var lastId:uint=0
			for(var i:uint=0;i<$str.length;i++)
			{
				var $tempstr:String=$str.substr(i,1)
				if(isValStr($tempstr)){
					strVal+=$tempstr
				}else{
					
					
			
					if(isValByString(strVal,$str.substr(lastId,1))){
						
						if(strVal=="e"){
						
						
							trace($str.substr(lastId,1))
							trace($str)
							trace("---------------")
							
						}
						pushTemValToItem(strVal)
					}
					strVal=""
					lastId=i;
				}
			}
			
			
		}
		private function isValByString(strVal:String,eeee:String):Boolean
		{
			if(strVal.length && eeee!=String.fromCharCode(92)&& eeee!=String.fromCharCode(47)&& eeee!="\""){
				return true
			}else{
			
				return false
			}
		
		}
		private function makeSystemVal():void
		{
			
			
			
			
			systemVal=new Array;
			
			systemVal.push("null");
			systemVal.push("EVENT");
			systemVal.push("prototype");
			
			systemVal.push("x");
			systemVal.push("y");
			systemVal.push("z");
			systemVal.push("w");
			systemVal.push("true");
			systemVal.push("length");
			systemVal.push("push");
			systemVal.push("Object");
			systemVal.push("getInstance");
			systemVal.push("value");

			systemVal.push("Math");
		
		

			
			systemVal.push("hasOwnProperty");
			
			
			systemVal.push("break");
			systemVal.push("do");
			systemVal.push("instanceof");
			systemVal.push("typeof"); 
			
			systemVal.push("case");
			systemVal.push("else");
			systemVal.push("new");
			systemVal.push("var"); 
			
			systemVal.push("catch"); 
			
			systemVal.push("finally");
			systemVal.push("return");
			systemVal.push("void");
			systemVal.push("continue");
			systemVal.push("for ");
			systemVal.push("switch ");
			systemVal.push("while"); 
			
			systemVal.push("debugger"); 
			systemVal.push("function");
			systemVal.push("this");
			systemVal.push("with"); 
			systemVal.push("default");
			systemVal.push("if"); 
			systemVal.push("throw"); 
			systemVal.push("delete"); 
			systemVal.push("in");
			systemVal.push("try"); 
			
			
			systemVal.push("break");
			systemVal.push("case");
			systemVal.push("catch");
			systemVal.push("continue");
			systemVal.push("default");
			systemVal.push("delete");
			systemVal.push("do");
			systemVal.push("else");
			systemVal.push("finally");
			systemVal.push("for");
			systemVal.push("function");
			systemVal.push("if");
			systemVal.push("in");
			systemVal.push("instanceof");
			systemVal.push("new");
			systemVal.push("return");
			systemVal.push("switch");
			systemVal.push("this");
			systemVal.push("throw");
			systemVal.push("try");
			systemVal.push("typeof");
			systemVal.push("var");
			systemVal.push("void");
			systemVal.push("while");
			systemVal.push("with");
			
			
			
			systemVal.push("abstract");
			systemVal.push("boolean");
			systemVal.push("byte");
			systemVal.push("char");
			systemVal.push("class");
			systemVal.push("const");
			systemVal.push("debugger");
			systemVal.push("double");
			systemVal.push("enum");
			systemVal.push("export");
			systemVal.push("extends");
			systemVal.push("fimal");
			systemVal.push("float");
			systemVal.push("goto");
			systemVal.push("implements");
			systemVal.push("import");
			systemVal.push("int");
			systemVal.push("interface");
			systemVal.push("long");
			systemVal.push("mative");
			systemVal.push("package");
			systemVal.push("private");
			systemVal.push("protected");
			systemVal.push("public");
			systemVal.push("short");
			systemVal.push("static");
			systemVal.push("super");
			systemVal.push("synchronized");
			systemVal.push("throws");
			systemVal.push("transient");
			systemVal.push("volatile");	
			
			
			
		}
		private var canChangeValDic:Dictionary
		private var outStr:String;
		private function replayValMath($str:String):void
		{
	
	
			var tempobj:Point=new Point(0,0)
			var strVal:String=""
			var arr: Vector.<Point>=new Vector.<Point>
			var lastId:uint=0
			for(var i:uint=0;i<$str.length;i++)
			{
				var $tempstr:String=$str.substr(i,1)
				if(isValStr($tempstr)){
					strVal+=$tempstr
				}else{
					if(isValByString(strVal,$str.substr(lastId,1))){
						tempobj.y=i;
						arr.push(tempobj)
						
					}
					tempobj=new Point
					tempobj.x=(i+1)
					strVal=""
					lastId=i;
						
				}
			}
			
			var kstr:String=""
				
				
			for(var j:uint=0;j<arr.length;j++){
				if(j==0){
					kstr+=($str.substring(0,arr[j].x))
				}
				var tempVar:String=$str.substring(arr[j].x,arr[j].y)
				kstr+=changeValMash(tempVar);
				
				if(j<(arr.length-1)){
					kstr+=($str.substring(arr[j].y,arr[j+1].x))
				}else{
					kstr+=($str.substring(arr[j].y,$str.length))
				}
			}
			if(arr.length<1){
				kstr=$str
			}
		
			outStr+=kstr

			
		
		}
		private function changeValMash($str:String):String
		{
		
			if(canChangeValDic.hasOwnProperty($str)){
				return canChangeValDic[$str].val	
			}

			return $str
		}

		private var keyDis:Dictionary
		private var keyArr:Array=["0","1","2","3","4","5","6","7","8","9","_","$"];
	
		private var nk:Number=0
		private function pushTemValToItem($str:String):void
		{
			if(isNaN(Number($str))&&testIsSystem($str)){
			
				
				if(keyDis.hasOwnProperty($str)){
					keyDis[$str]=keyDis[$str]+1
				}else{
					keyDis[$str]=1
				}
				
			}
		
		}
		private function testIsSystem($str:String):Boolean
		{
			for(var i:uint=0;i<systemVal.length;i++){
			
				 if(systemVal[i]==$str){
				 
					 return false
				 }
			}
		
			return true
		}
		
		private var systemVal:Array
		private function isValStr($key:String):Boolean
		{
			for(var i:uint=0;i<keyArr.length;i++)
			{
				if(keyArr[i]==$key){
					return true
				}
			
			
			}
		
			return false
			
		}
	
		//private var ProjectUrl:String="file:///E:/codets/game/arpg/arpg/";
		//private var ProjectUrl:String="file:///E:/codets/game/arpglocal/arpglocal/";
		private var ProjectUrl:String="file:///E:/codets/game/arpg/arpg/";
		private var JsBagRootUrl:String="file:///f:/jsbag/";
		
		public function run():void
		{
			var file:File=new File()
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
		
			//Alert.show("文件生成完成")
	
		}
		
		protected function onFileWorkChg(event:Event):void
		{
			var $selectFile:File=event.target as File
			ProjectUrl=$selectFile.url+"/"
			trace($selectFile.url)
			this.selectFileIndex()
			
		}
		private function selectFileIndex():void
		{
			var htmlFile:File=new File(ProjectUrl+"index.html");
			
			if(htmlFile.exists){
				var $fsScene:FileStream = new FileStream;
				$fsScene.open(htmlFile,FileMode.READ);
				var $str:String = $fsScene.readUTFBytes($fsScene.bytesAvailable)
				$fsScene.close()
				var lines:Array=	ERT($str)
				_jsFileItem=new Vector.<String>;
				for(var i:uint = 0; i < lines.length; i++){
					parseLine(lines[i]);
				}
				moveJsToBagRoot();
				buildGruntfile();
				
				
				runComand();
				
				moveResFile();
				
			}else{
				
				
				Alert.show(htmlFile.url)
			}
			
		}
		
		private var resFileItem:Vector.<File>
		private function moveResFile():void
		{
			OutTxtModel.getInstance().initSceneConfigPanel("");
			resFileItem=getInFolderFile(new File(ProjectUrl+"res"));
			writemanifest();
	
			fileID=0
			myTimer = new Timer(10, 0);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.start();
		}
		private function writemanifest():void
		{
			var str:String="";
			str+="CACHE MANIFEST\n";
			str+="#v1.0.0\n";
			str+="CACHE:\n";
			

			
			
			str+="res/map/slg_city.txt\n";
			str+="res/map/slg_map.txt\n";
	
		
			
			str+="NETWORK:\n";
			str+="*\n";
			str+="FALLBACK:\n";
			str+="index.html\n";
				
				
			writeToXml(new File(JsBagRootUrl+"dest/cache.manifest"),str)

		
		}
		private var myTimer:Timer;
		private var fileID:Number
		protected function timerHandler(event:TimerEvent):void
		{
			if(fileID<resFileItem.length){
				var url:String=resFileItem[fileID].url.replace(ProjectUrl,"")
				
				moveFile(resFileItem[fileID],JsBagRootUrl+"dest/"+url)

				
				fileID++
					OutTxtModel.getInstance().addLine(String(fileID)+"/"+String(resFileItem.length)+"->"+url);
			}else{
				Alert.show("文件生成完成")
					
				myTimer.stop()
			
			}
		}
		private function getInFolderFile($sonFile:File):Vector.<File>
		{
			
			var $fileItem:Vector.<File>=new Vector.<File>
			
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					if($tempFile.isDirectory){
						
						
						$fileItem=$fileItem.concat(getInFolderFile($tempFile))
						
						
					}else{
						
						$fileItem.push($tempFile)
					}
					
				}
			}else{
				
				$fileItem.push($sonFile)
				
			}
			
			return $fileItem
		}
		
		private function buildGruntfile():void
		{
			var str:String="";
			str+="module.exports = function(grunt){\n"
			str+="grunt.initConfig({\n"
			str+="pkg: grunt.file.readJSON('package.json'),\n"
			str+="concat: {\n"
			str+="domop: {\n"
			str+="src: [\n"
				
			for(var i:uint=0;i<_jsFileItem.length;i++){
				str+="'src/"+_jsFileItem[i]+"',\n";
			}
				
				
				
			str+="],\n"
			str+="dest: 'dest/h5web.js'\n"
			str+="}\n"
			str+="},\n"
			str+="uglify: {\n"
			str+="options: {\n"
			
			str+="banner:"+"'"+String.fromCharCode(92)+"n'\n";
				
			
				
				
		//	banner: '\n'
				
			str+="	},\n"
			str+="bulid: {\n"
			str+="	src: 'dest/h5web.js',\n"
			str+="		dest: 'dest/h5web.min.js'\n"
			str+="	}\n"
			str+="	}\n"
			str+="});\n"


			str+="grunt.loadNpmTasks('grunt-contrib-concat');\n"
			str+="grunt.loadNpmTasks('grunt-contrib-uglify');\n"


			str+="grunt.registerTask('default', ['concat', 'uglify']);\n"

			str+="};\n"
				
				
				
			writeToXml(new File(JsBagRootUrl+"Gruntfile.js"),str)
			
			
			
		}
		private  function writeToXml($file:File,str:String):void
		{
			

			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);
			
			for(var i:int = 0; i < str.length; i++)
			{
				fs.writeMultiByte(str.substr(i,1),"utf-8");
			}
			
			fs.close();
			
		}
		
		
		private function moveJsToBagRoot():void
		{
			for(var i:uint=0;i<_jsFileItem.length;i++){
			
			     var jsFile:File= new File(ProjectUrl+_jsFileItem[i]);
				 if(jsFile.exists){
					 
					 if(jsFile.name=="UiStage.js"){
					
						 changeFpsFile(_jsFileItem[i])
					 }else{
					 
						 moveFile(jsFile,JsBagRootUrl+"src/"+_jsFileItem[i])
					 }
					 
			
				 
				 }else{
				 
				 
				 }
				
				
				
			}
			
		}
		private function changeFpsFile(fpsUrl:String):void
		{
			var jsFile:File= new File(ProjectUrl+fpsUrl);
			var $fsScene:FileStream = new FileStream;
			$fsScene.open(jsFile,FileMode.READ);
			var $str:String = $fsScene.readUTFBytes($fsScene.bytesAvailable)
			$fsScene.close();
			$str=$str.replace("FpsMc.addFps = 0","FpsMc.addFps = 2.5")
				
				
		
				
			writeToXml(new File(JsBagRootUrl+"src/"+fpsUrl),$str)
		
				
		}
		
		public function moveFile($file:File,$toUrl:String):void
		{
			if($file.exists){
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($toUrl);
				$file.copyTo(destination, true);
			}
			
		}
		
		private var _jsFileItem:Vector.<String>
		private function parseLine($line:String):void
		{

			if($line.indexOf("<script src")>-1&&$line.indexOf(".js")>-1){
				var arr:Array=$line.split("\"");
				_jsFileItem.push(arr[1])
			}
		}
		private const LINE_FEED:String = String.fromCharCode(10);
		private function ERT($str:String):Array
		{
			var lines:Array = $str.split(LINE_FEED);
			var endArr:Array=new Array
			var isNotWiat:Boolean=true
			var tempStr:String=""
			for(var i:uint = 0; i < lines.length; i++){
				
				var tabStr:String=lines[i]
				var a:Number=tabStr.indexOf("(")
				var b:Number=tabStr.indexOf(")")
				
				if(isNotWiat){
					tempStr=tabStr
					
				}else{
					tempStr+=tabStr
				}
				
				if(a==-1&&b==-1){
					
					
				}else{
					
					if(a!=-1&&b!=-1){
						
					}else{
						
						if(a!=-1){
							isNotWiat=false
						}
						if(b!=-1){
							isNotWiat=true
						}
						
						
					}
				}
				if(isNotWiat){
					
					endArr.push(tempStr);
				}
				
			}
			
			return endArr
			
		}
	
		private function runComand():void
		{
			var exePath:String = "C:/Windows/System32/cmd.exe";//exe路径，经过测试，直接从system32下复制到程序的目录下也是没有问题的，前提是你的程序都是默认安装的。环境变量也没变
			
			var shellPath:String = "F:/a.bat"
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();//启动参数
			info.executable = new File(exePath);
			var processArg:Vector.<String> = new Vector.<String>();
			processArg[0] = "/c";//加上/c，是cmd的参数
			processArg[1] = shellPath;//shellPath是你的bat的路径，建议用绝对路径，如果是相对的，可以用File转一下
			
			info.arguments= processArg;
			var process:NativeProcess = new NativeProcess();
			process.addEventListener(NativeProcessExitEvent.EXIT,packageOverHandler);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,outputHandler);
			process.start(info);
			
			
		//	Alert.show("文件生成完成")
				
		
		}
		
		protected function packageOverHandler(event:NativeProcessExitEvent):void
		{
				//Alert.show("11111")
			
		}
		
		protected function outputHandler(event:ProgressEvent):void
		{
			//Alert.show("3333")
			
		}
		
	}
}
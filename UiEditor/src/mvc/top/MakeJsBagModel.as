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
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
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
		private var outStr:String;
		private var ProjectUrl:String="file:///E:/codets/game/arpg/arpg/";
		private var JsBagRootUrl:String="file:///f:/jsbag/";
		
		public function run():void
		{
			var file:File=new File()
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
		}
		
		protected function onFileWorkChg(event:Event):void
		{
			var $selectFile:File=event.target as File
			ProjectUrl=$selectFile.url+"/"
			this.selectFileIndex()
			
		}
		private function selectFileIndex():void
		{
			var htmlFile:File=new File(ProjectUrl+"index.html");
			
			if(htmlFile.exists){
				this.clearOldMinFile();
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
			//	moveResFile();
				
			}else{
				Alert.show(htmlFile.url)
			}
			
		}
		private function clearOldMinFile():void
		{
			OutTxtModel.getInstance().initSceneConfigPanel("");
			//JsBagRootUrl
			var $arr:Array=new Array();
			$arr.push("h5web.js");
			$arr.push("h5web.min.js");
			$arr.push("h5web.zip.js");
			for(var i:Number=0;i<$arr.length;i++)
			{
				var $file:File=new File(JsBagRootUrl+"dest/"+$arr[i])
				if($file.exists)
				{
					trace("删除文件",decodeURI($file.url));
					
					OutTxtModel.getInstance().addLine("删除文件"+$file.url);
					$file.deleteFile();
				}
			}
			
		}
		
		private var resFileItem:Vector.<File>
		private function moveResFile():void
		{
			OutTxtModel.getInstance().initSceneConfigPanel("");
			resFileItem=getInFolderFile(new File(ProjectUrl+"res"));

			fileID=0
			myTimer = new Timer(10, 0);
			myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			myTimer.start();
		}
		private var myTimer:Timer;
		private var fileID:Number;
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
			str+="	dest: 'dest/h5web.min.js'\n"
			str+="	}\n"
			str+="	}\n"
			str+="});\n"


			str+="grunt.loadNpmTasks('grunt-contrib-concat');\n"
			str+="grunt.loadNpmTasks('grunt-contrib-uglify');\n"


			str+="grunt.registerTask('default', ['concat', 'uglify']);\n"

			str+="};\n"
				

				
			writeToXml(new File(JsBagRootUrl+"Gruntfile.js"),str)

			OutTxtModel.getInstance().addLine("生存--->Gruntfile.js");
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
				 if(jsFile.exists ){
					 /*
					 if(jsFile.name=="UiStage.js"){
						 changeFpsFile(_jsFileItem[i])
					 }else{
						 moveFile(jsFile,JsBagRootUrl+"src/"+_jsFileItem[i])
					 }
					 */
					 moveFile(jsFile,JsBagRootUrl+"src/"+_jsFileItem[i])
		
				 }else{
					 OutTxtModel.getInstance().addLine("!!!!没有文件->"+jsFile.url);
				 }
			}
			OutTxtModel.getInstance().addLine("移动文件Js文件数量=>"+_jsFileItem.length.toString());
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
			OutTxtModel.getInstance().addLine("执行--->"+shellPath);
			OutTxtModel.getInstance().addLine("正在生成min.js--->"+getTimer().toString());
			
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
		protected function packageOverHandler(event:NativeProcessExitEvent=null):void
		{
			var $minfile:File=new  File(JsBagRootUrl+"dest/h5web.min.js");
			OutTxtModel.getInstance().addLine("正在生成--->zip.js");
			if($minfile.exists){
				ZipMinJsModel.getInstance().changeZipByFile($minfile)
			}else{
				setTimeout(packageOverHandler,1000);
			}
			
		}
		
		protected function outputHandler(event:ProgressEvent):void
		{
	
		
		}
		
	}
}
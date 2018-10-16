package view.menu
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexNativeMenuEvent;
	
	import spark.components.WindowedApplication;
	
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.GameUIInstance;
	
	import guiji.GuijiLevel;
	
	import modules.hierarchy.h5.ExpLyfTxtToByteFile;
	
	import user.UserConfig;
	
	import utils.FileConfigUtils;
	
	import view.AllAttributePanle;
	import view.ControlCenterView;
	import view.FileToolBar;
	import view.authorize.AuthorizePanle;
	import view.config.ConfigPanle;
	import view.dbSel.DbSelPanle;
	import view.groupview.GroupPanel;
	import view.roleView.RolePanle;

	public class MainProcess
	{
		
		private var filetoolBar:FileToolBar;
		private var cfg:ConfigPanle;
		private var _app:WindowedApplication;
		private var _menu:MenuView;
		public function MainProcess()
		{
			filetoolBar = new FileToolBar;
			cfg = new ConfigPanle;
			filetoolBar.init();
			_menu = new MenuView;
			setTimeout(autoOpen,1000);

			
		}
		
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(event.ctrlKey){
				if(event.keyCode==Keyboard.S){
					save(null)
				}
			}
			
		}
		
		public function processEvent(event:FlexNativeMenuEvent):void{
			var actionId:int=int(event.item.@action);
			switch(actionId)
			{
				case 1:
					newProject(null);
					break;
				case 2:
					open(null);
					break;
				case 3:
					save(null);
					break;
				case 4:
					saveAsNewFile(null);
					break;
				case 5:
					onExp(null);
					break;
				case 6:
					filetoolBar.closeHandler(null);
					break;
				case 7:
					filetoolBar.configBitmap();
					break;
				case 8:
					RolePanle.getInstance().show();
					break;
				case 9:
					showDb();
					break;
				case 10:
					showAuthorize();
					break;
				case 11:
					GroupPanel.getInstance().show();
					break;
				default:
					break;
			}
			
			if(actionId >= 20){
				var userID:int = actionId - 20;
				if(AppParticleData.userList.length > userID){
					new UserConfig(AppParticleData.userList[userID].user,AppParticleData.userList[userID].psd);
				}
			}
		}
		
		public function setApp($app:WindowedApplication):void{
			_app = $app;
			GameUIInstance.uiContainer.addChild(cfg);
			cfg.visible = false;
			//_app.menu = _menu;
			_menu.showMenu(this);
			
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown)	;
		}
		
		/**
		 * 新建项目工程
		 * */
		private function newProject(event:Event):void{
			Alert.show("新建将清空工作空间的内容，请确认保存","警告",3,null,sureNew); 
		}
		
		private function sureNew(evt:CloseEvent):void{
			if(evt.detail == 1){
				clear();
			}
		}
		/**
		 * 清空当前所有内存
		 * */
		private function clear():void{
			ControlCenterView.getInstance().delAll();
			AppData.appTitle = "Particle";
			AllAttributePanle.getInstance().removeAll();
			GuijiLevel.Instance().hide();
		}
		
		private var lastFileOpenUrl:String;
		/**
		 * 数据打开
		 * */
		private function open(event:Event):void{
			_app.status="";
			
			var folderUrl:String = FileConfigUtils.readConfig().folderUrl;
			var file:File = new File(folderUrl);
			var txtFilter:FileFilter = new FileFilter("Text", ".lyf;*.lyf;");
			file.browseForOpen("打开粒子",[txtFilter]);
			file.addEventListener(Event.SELECT,onOpenSel);
		}
		private function autoOpen():void{
			var folderUrl:String = FileConfigUtils.readConfig().openFileUrl;
			if(!folderUrl){
				return;
			}
			var file:File = new File(folderUrl);
			file.addEventListener(Event.SELECT,onOpenSel);
			file.dispatchEvent(new Event(Event.SELECT));
		}
		private function onOpenSel(event:Event):void{
			clear();
			var file:File = event.target as File;
			if(!file.exists){
				return ;
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			var converObj:Object;
			if(fs.bytesAvailable){
				converObj = fs.readObject();
			}
			
			fs.close();
			
			ControlCenterView.getInstance().buildStateByFile(obj as Array);
			if(converObj){
				filetoolBar.converBitmapPanel.setAllInfo(converObj);
			}else{
				filetoolBar.converBitmapPanel.setAllInfo(null);
			}
			
			
			AppData.appTitle = "Particle -" + file.name;
			
			GuijiLevel.Instance().hide();
			
			if(obj[0]){
				var overallScale:Number = obj[0].display.overAllScale;
				if(overallScale){
					cfg.setScale(overallScale);
				}else{
					cfg.setScale(1);
				}
			}
			
			AppParticleData.lyfUrl = file.nativePath;
			
			FileConfigUtils.writeConfig("openFileUrl",file.url);
			FileConfigUtils.writeConfig("folderUrl",file.parent.url);
			
		}
		
		/**        
		 * 数据保存  直接在文件里写就行
		 * */
		private function save(event:Event):void{
			var appdataTitle:String=AppData.appTitle;
			if(appdataTitle.lastIndexOf(".lyf")!=-1){
				_app.status="正在保存";
				_app.alpha=0.3;
				_app.mouseEnabled=false;
				_app.mouseChildren=false;
				var filePath:String=AppParticleData.lyfUrl;
				var file:File=new File(filePath);  
				var fs:FileStream=new FileStream();
				fs.open(file,FileMode.WRITE);
				var allInfoObj:Object = ControlCenterView.getInstance().getAllInfo();
				fs.writeObject(allInfoObj);
				var converObj:Object = filetoolBar.converBitmapPanel.getAllInfo();
				if(converObj){
					fs.writeObject(converObj);
				}
				fs.close();
				saveParticleTxt(file,allInfoObj);
	
				var id:uint=setTimeout(function():void{
					_app.mouseEnabled=true;
					_app.mouseChildren=true;
					_app.alpha=1;
					clearTimeout(id);
					_app.status = "保存完成 ";
				},300);
				
			}
			else{
				//------------------------
				//registerClassAlias("_Pan3D.base.Object3D",Object3D);
				var files:File = new File();
				files.addEventListener(Event.SELECT,onSel);
				files.browseForSave("保存信息");
			}
		}
		private function onSel(event:Event):void{
			var file:File = event.target as File;
			if(!(file.extension == "lyf")){
				file = new File(file.nativePath + ".lyf");
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			var allInfoObj:Object = ControlCenterView.getInstance().getAllInfo();
			fs.writeObject(allInfoObj);
			var converObj:Object = filetoolBar.converBitmapPanel.getAllInfo();
			if(converObj){
				fs.writeObject(converObj);
			}
			fs.close();
			saveParticleTxt(file,allInfoObj);
			AppData.appTitle = "Particle--" + file.name;
			AppParticleData.lyfUrl = file.nativePath;
		}
		
		private function saveParticleTxt($baseFile:File,obj:Object):void{
			var tempUrl:String = $baseFile.parent.url;
			var nameUrl:String = $baseFile.name.split(".")[0];
			//nameUrl = Cn2en.toPinyin(nameUrl);
			var newUrl:String = tempUrl + "/" + nameUrl + ".txt";
			//newUrl = newUrl.replace($baseFile.type,"_lyf.txt");
			processBaseValue(obj);
			processMaterialParamUrl(obj);
			processMaterialExtends(obj);
			
			//newUrl = "file:///d:/workweb/WebGLEngine/WebGLEngine/assets/img/test/a_lyf.txt";
			
			/*  
			//保存最简XML粒子文件
			var file:File = new File(newUrl);
			var str:String = JSON.stringify(obj);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			
			*/
			
			ExpLyfTxtToByteFile.getInstance().saveParticleByte($baseFile,obj);
			
		}
		
		
		private function processMaterialParamUrl(obj:Object):void{
			var ary:Array = obj as Array;
			for(var i:int=0;i<ary.length;i++){
				var display:Object = ary[i].display;
				var texAry:Array = display.materialParam.texAry;
				
				if(texAry){
					for(var j:int = 0;j<texAry.length;j++){
						if(!texAry[j].isParticleColor){
							texAry[j].url = Cn2en.toPinyin(decodeURI(texAry[j].url));
						}
					}
				}
			}
		}
		
		private function processMaterialExtends(obj:Object):void{
			var ary:Array = obj as Array;
			for(var i:int=0;i<ary.length;i++){
				var display:Object = ary[i].display;
				var str:String = display.materialUrl;
				display.materialUrl = String(display.materialUrl).replace(".material",".txt");
				display.materialUrl = Cn2en.toPinyin(decodeURI(display.materialUrl));
			}
		}
		
		private function processBaseValue(obj:Object):void{
			var ary:Array = obj as Array;
			for(var i:int=0;i<ary.length;i++){
				var itemAry:Array = ary[i].timeline;
				for(var j:int=0;j<itemAry.length;j++){
					var baseValueAry:Array = itemAry[j].baseValue;
					
					if(baseValueAry){
						for(var k:int=0;k<baseValueAry.length;k++){
							if(!baseValueAry[k]){
								baseValueAry[k] = 0;
							}
						}
					}
					
				}
			}
		}
		
		/**
		 *  把文件另存为一个新的文件
		 * */
		private function saveAsNewFile(event:Event):void{
			//registerClassAlias("_Pan3D.base.Object3D",Object3D);
			//var obj:Object = center.getAllInfo();
			var file:File = new File();
			file.addEventListener(Event.SELECT,onSel);
			file.browseForSave("保存信息");
		}
		
		private function onExp(event:Event):void{
			return;
			var file:File = new File();
			file.addEventListener(Event.SELECT,onExpSel);
			file.browseForSave("导出粒子");
		}
		private function onExpSel(event:Event):void{
			var file:File = event.target as File;
			var obj:Object = ControlCenterView.getInstance().getAllInfo();
			
			var sourceFile:File;
			var ary:Array = obj as Array;
			for(var i:int;i<ary.length;i++){
				var p:Object = ary[i].display;
				
				sourceFile = new File(Scene_data.particleRoot + p.textureUrl);
				if(sourceFile.exists){
					if(sourceFile.isDirectory){
						continue;
					}
					var newFile:File = new File(file.parent.url + "/texture/" + sourceFile.name);
					sourceFile.copyTo(newFile,true);
					p.textureUrl = newFile.name;
				}
				
				sourceFile = new File(Scene_data.particleRoot + p.objUrl);
				if(sourceFile.exists){
					if(sourceFile.isDirectory){
						continue;
					}
					newFile = new File(file.parent.url + "/texture/" + sourceFile.name);
					sourceFile.copyTo(newFile,true);
					p.objUrl = newFile.name;
				}
				
			}
			
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
			
		}
		
		private function showDb():void{
			var dbPanle:DbSelPanle = new DbSelPanle;
			_app.addElement(dbPanle);  
			
			dbPanle.x = (_app.width - dbPanle.width)/2;
			dbPanle.y = (_app.height - dbPanle.height)/2;
		}
		
		private function showAuthorize():void{
			var authorizePanle:AuthorizePanle = new AuthorizePanle;
			_app.addChild(authorizePanle);
			
			authorizePanle.x = (_app.width - authorizePanle.width)/2;
			authorizePanle.y = (_app.height - authorizePanle.height)/2;
		}
		
		
		
		
	}
}
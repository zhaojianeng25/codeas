package modules.brower.fileWin
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	
	import mx.core.UIComponent;
	import mx.events.FileEvent;
	import mx.managers.BrowserManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	public class InFolderModelSprite extends UIComponent
	{

		private var _spriteHeight:Number;
		private var _spriteWidth:Number;
		private var _picSize:Number=80
		private var _backMc:UIComponent
		public function InFolderModelSprite()
		{
			super();
			
	
			_backMc=new UIComponent
			this.addChild(_backMc)
	
		}
		

		public function get backMc():UIComponent
		{
			return _backMc;
		}

		public function mouseClik(kk:FolderSamplePic):void
		{

			for(var i:uint=0;i<mcItem.length;i++){
				var $folderSamplePic:FolderSamplePic=mcItem[i]
				if($folderSamplePic==kk){
					$folderSamplePic.select=true
				}else{
					$folderSamplePic.select=false
				}
			}
			Scene_data.stage.focus=this
		}
		public function slectFolderByFile($file:File):void
		{
			for(var i:uint=0;i<mcItem.length;i++){
				var $folderSamplePic:FolderSamplePic=mcItem[i]
				if($folderSamplePic.fileData.file.url==$file.url){
				
					mouseClik($folderSamplePic)
				}
			}
		}
		public function selectFile($data:Object):void
		{
			for(var i:uint=0;i<mcItem.length;i++){
				var $folderSamplePic:FolderSamplePic=mcItem[i]
		
					if($folderSamplePic.fileData.data){
						if($folderSamplePic.fileData.data==$data){
							$folderSamplePic.select=true
						}else{
							$folderSamplePic.select=false
						}
					}
					if($data is String){
				
						if(decodeURI($folderSamplePic.fileData.file.url).search(decodeURI(String($data)))!=-1){
							$folderSamplePic.select=true
						}else{
							$folderSamplePic.select=false
						}
					}
					
			
				
			}
		}
		

		public function get picSize():Number
		{
			return _picSize;
		}

		public function set picSize(value:Number):void
		{
			_picSize = value;
		}
		public function changeSize():void
		{
		    var $arr:Vector.<FolderSamplePic>=getListItem();
			
				
			var $n:int=int(_spriteWidth/_picSize)
			for(var i:uint=0;i<$arr.length;i++){
				var $folderSamplePic:FolderSamplePic=$arr[i]
					$folderSamplePic.picSize=_picSize
					$folderSamplePic.y=int(i/$n)*(_picSize+2)
					$folderSamplePic.x=int(i%$n)*(_picSize+2)
			}
			this.height =Math.ceil($arr.length/$n)*(_picSize+2)+(AppData.type==0?100:30)
				
			_backMc.graphics.clear()
			_backMc.graphics.beginFill(0xff0000,0)
			_backMc.graphics.drawRect(0,0,_spriteWidth,Math.max(this.height,_spriteHeight))
			_backMc.graphics.endFill()
			this.width =0
		}
		public function getListItem():Vector.<FolderSamplePic>
		{
			var $arr:Vector.<FolderSamplePic>=new Vector.<FolderSamplePic>
			for(var i:uint=0;i<mcItem.length;i++){
				var $folderSamplePic:FolderSamplePic=mcItem[i]
				$folderSamplePic.visible=true
				if($folderSamplePic.fileData.file.extension=="objs"){
                   if(!BrowerManage.isObjsCanShow($folderSamplePic.fileData.file)){
					   $folderSamplePic.visible=false
				   }
				}
				if($folderSamplePic.visible){
					$arr.push($folderSamplePic)
				}
				
			}
			return $arr;
		}
	

		public var  fileWindows:FileWindows
		public function setItem($fileItem:Vector.<FileWinData>):void
		{
			clear();
			if(AppData.type==1){
				$fileItem.sort(upperCaseFunc);
				function upperCaseFunc(a:FileWinData,b:FileWinData):int{
					var strA:String=a.file.name.toLocaleUpperCase();
					var strB:String=b.file.name.toLocaleUpperCase();
					if(AppData.fileSort){
						return strB.charCodeAt(0)-strA.charCodeAt(0);
						
					}else{
						return strA.charCodeAt(0)-strB.charCodeAt(0);
					}
					
				}
			}
			for(var i:uint=0;i<$fileItem.length;i++)
			{
				var $folderSamplePic:FolderSamplePic
				if($fileItem[i].file){
					 $folderSamplePic=new FolderSamplePic;
			
				}else{
					$folderSamplePic=new CsvSamlePic;
				}
				$folderSamplePic.setData($fileItem[i])
				$folderSamplePic.fileWindows=fileWindows
				this.addChild($folderSamplePic)
				$folderSamplePic.useHandCursor=true
				mcItem.push($folderSamplePic)
			}
			changeSize()
	
		}
		private var mcItem:Vector.<FolderSamplePic>=new Vector.<FolderSamplePic>

		
		
		
		private function clear():void
		{

		
		
			while(mcItem&&mcItem.length){
			
				this.removeChild(	mcItem.pop())
			}
	

		}
		public function chageSize($w:uint,$h:uint):void
		{
			_spriteHeight=Math.max(int($h),100)
			_spriteWidth=Math.max(int($w),100)
			changeSize()
		

		}
		public  function doubleClik($file:File):void
		{
			var $fileEvent:FileEvent=new FileEvent(FileEvent.FILE_CHOOSE)
			$fileEvent.file=$file
			this.dispatchEvent($fileEvent);
		}
		public  function selectCell($bmp:BitmapData,$file:File):void
		{
			_chooseFile=$file
		}
		private var _chooseFile:File
	}
}
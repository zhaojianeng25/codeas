package modules.brower.fileWin
{
	import flash.events.TextEvent;
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	import common.AppData;
	
	public class FileWinTitle extends UIComponent
	{
		private var _backSprte:FileWindowBack;
		private var _txt:TextField=new TextField
		public function FileWinTitle()
		{
			super();
			addBack();
			addText();
		}
		
		private function addText():void
		{
			
			var _txtform:TextFormat=new TextFormat();
	

			_txt=new TextField
			_txt.setTextFormat(_txtform)
			_txt.type = TextFieldType.DYNAMIC; 
			_txt.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(_txt)
			_txt.selectable=true
			_txt.y=2
		
			_txt.addEventListener(TextEvent.LINK,link);

			
		}		

		
		public function resetSize($w:uint,$h:uint,$colorV:Vector3D=null):void
		{
			_backSprte.resetSize($w,24)
			//_txt.width=$w
			_txt.height=20;
		}
		public function setFileUrl($file:File):void
		{

			var spaceFile:File=new File(AppData.workSpaceUrl)
			var ccav:String=(AppData.workSpaceUrl.substring(0,AppData.workSpaceUrl.length-spaceFile.name.length-1))
			var $url:String=decodeURI($file.url.substring(ccav.length,$file.url.length))
	
			var str:String=""
			_urlArr= $url.split(String.fromCharCode(47));
			for(var i:uint=0;i<_urlArr.length;i++){
                if(_urlArr[i].length>0){
					//str+= "<font color='#9c9c9c' >></font>"+"<font color='#9c9c9c' face='宋体'>"+"<a href='event:"+String(i)+"'>"+_urlArr[i]+"</a>"+ "</font>"
					str+= "<font color='#9c9c9c' ></font>"+"<font color='#9c9c9c' face='Microsoft Yahei'>"+"<a href='event:"+String(i)+"'>"+"><u>"+_urlArr[i]+"</a>"+ "</u></font>"
				}
			}
			_txt.htmlText=str;
		
			this.width=_txt.width

		}
		private var _urlArr:Array
		protected function link(event:TextEvent):void
		{
			var spaceFile:File=new File(AppData.workSpaceUrl)
			var ccav:String=(AppData.workSpaceUrl.substring(0,AppData.workSpaceUrl.length-spaceFile.name.length-1))
			var $str:String=ccav
			for(var i:uint=0;i<=Number(event.text);i++)
			{
				if(_urlArr[i].length>0){
					$str+="/"+_urlArr[i];
				}
			}
			var $file:File = new File($str);
		
			FileWindows(this.parent).sleteFile($file)
				
			
		}
		private function addBack():void
		{
			_backSprte=new FileWindowBack()
			this.addChild(_backSprte)
			_backSprte.resetSize(100,24,new Vector3D(0xff,0,0))
			
			
		}
	}
}
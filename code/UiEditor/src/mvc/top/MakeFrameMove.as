package mvc.top
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	
	import mx.controls.Alert;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import common.AppData;
	
	import modules.hierarchy.FileSaveModel;
	
	import mvc.scene.UiSceneEvent;
	
	import vo.FileDataVo;

	public class MakeFrameMove
	{
		private static var instance:MakeFrameMove;
		private var selectFile:File;
		public function MakeFrameMove()
		{
		}
		public static function getInstance():MakeFrameMove{
			if(!instance){
				instance = new MakeFrameMove();
			}
			return instance;
		}
		public function run():void
		{
			selectFile=new File
			var txtFilter:FileFilter = new FileFilter("Text", ".png;*.png;");
			selectFile.browseForOpenMultiple("Select Files",[txtFilter]);
			selectFile.addEventListener(FileListEvent.SELECT_MULTIPLE, filesSelected);
			
		}
		private var picFileItem:Vector.<File>
		protected function filesSelected(event:FileListEvent):void
		{
			picFileItem=new Vector.<File>
			for (var i:uint = 0; i < event.files.length; i++) 
			{
			      if( File(event.files[i]).extension=="png"){
					  picFileItem.push(File(event.files[i]))
				  }
			}
			bitmapdataItem=new Vector.<BitmapData>
			loadId=0
			this.oneByoneLoad()
			
		}
		private var loadId:uint;
		private var bitmapdataItem:Vector.<BitmapData>
		private function oneByoneLoad():void
		{
			if(loadId<picFileItem.length){
				var loaderinfo:LoadInfo = new LoadInfo(picFileItem[loadId].url,LoadInfo.BITMAP,function onImgLoad($bitmap:Bitmap):void
				{
					bitmapdataItem.push($bitmap.bitmapData);
					loadId=loadId+1
					oneByoneLoad()
					
				},0);
				
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}else{
			
				if(bitmapdataItem.length>1){
					testBmp()
					makeBigBitmapData()
				}else{
					Alert.show("至少两张图")
				}
			
			}
		}	
		private function testBmp():void
		{
			var w:Number=bitmapdataItem[0].width
			var h:Number=bitmapdataItem[0].height
			for(var i:uint=0;i<bitmapdataItem.length;i++){
				if(bitmapdataItem[0].width!=w||bitmapdataItem[1].width!=h){
					Alert.show("图片转换尺寸不统一")
				}
			}
		
			
		}
		private function makeBigBitmapData():void
		{
			
			if(false){
				make512Pic();
			}else{
				makeBasePic();
			}

		}
		private function makeBasePic():void
		{
			var tempbmp:BitmapData=new BitmapData(bitmapdataItem[0].width*bitmapdataItem.length,bitmapdataItem[0].height,true,0)
			
			for(var i:uint=0;i<bitmapdataItem.length;i++){
				var m:Matrix=new Matrix;
				m.tx=i*bitmapdataItem[i].width
				tempbmp.draw(bitmapdataItem[i],m)
				
				
			}
			var url:String=File.desktopDirectory.url+"/"+"frame"+int(Math.random()*9999)+".png"
			
			FileSaveModel.getInstance().saveBitmapdataToPng(tempbmp,url);
			
			Alert.show("保存完毕"+url)
		}
		private function make512Pic():void
		{
			if(bitmapdataItem[0].width>2048/12){
				Alert.show("图片过大")
				
			}
			trace((512/12-bitmapdataItem[0].width))
			
			var tempbmp:BitmapData=new BitmapData(512,bitmapdataItem[0].height,true,0)
			
			for(var i:uint=0;i<bitmapdataItem.length;i++){
				var m:Matrix=new Matrix;
				m.tx=i*512/12+(512/12-bitmapdataItem[0].width)
				tempbmp.draw(bitmapdataItem[i],m)
				
				
			}
			var url:String=File.desktopDirectory.url+"/"+"frame"+int(Math.random()*9999)+".png"
			
			FileSaveModel.getInstance().saveBitmapdataToPng(tempbmp,url);
			
			Alert.show("保存完毕"+url)
		}
		
		
		
	}
}
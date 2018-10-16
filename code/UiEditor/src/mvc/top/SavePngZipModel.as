package mvc.top
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import _Pan3D.core.MathCore;
	
	import modules.hierarchy.FileSaveModel;
	
	import vo.FileDataVo;
	

	public class SavePngZipModel
	{
		public function SavePngZipModel()
		{
		}
		private static var instance:SavePngZipModel;
		
		public static function getInstance():SavePngZipModel{
			if(!instance){
				instance = new SavePngZipModel();
			}
			return instance;
		}
	    public function saveJpngBy():void
		{
			if(UiData.bmpitem.length){
	
				var $vo:FileDataVo=UiData.bmpitem[0]
				var $file:File=new File($vo.url)
				var $toUrl:String=	$file.url.replace(".png",".jpg")
				if($file.exists&&$file.extension=="png"){
					FileSaveModel.getInstance().initJpgQuality(80);
					
					FileSaveModel.getInstance().saveBitmapdataToJpg($vo.bmp,$toUrl.replace(".jpg","_1.jpg"));
					
					 var  $alphaBmp:BitmapData=new BitmapData($vo.bmp.width,$vo.bmp.height,false);
				     for(var i:Number=0;i<$alphaBmp.width;i++){
						 for(var j:Number=0;j<$alphaBmp.height;j++){
							 var $temp:Number=$vo.bmp.getPixel32(i,j);
							 var $colorV:Vector3D=MathCore.hexToArgb($vo.bmp.getPixel32(i,j))
							 $alphaBmp.setPixel(i,j,	 MathCore.argbToHex16($colorV.w,$colorV.w,$colorV.w));
						 }
					 }
					 FileSaveModel.getInstance().initJpgQuality(20);
					 FileSaveModel.getInstance().saveBitmapdataToJpg($alphaBmp,$toUrl.replace(".jpg","_2.jpg"));
					
				}
				

				
			}
		}
	}
}
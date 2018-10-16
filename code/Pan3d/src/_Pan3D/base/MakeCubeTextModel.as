package _Pan3D.base
{
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MakeCubeTextModel
	{
		public function MakeCubeTextModel()
		{
		}
		public static function MakeCube(arr:Array,backFun:Function,fileRoot:String=""):void
		{
			//暂时进进行512的运算
			if(arr.length==6){
				var $loadId:uint=0
				var $cubeTexture:CubeTexture=Scene_data.context3D.createCubeTexture(512, Context3DTextureFormat.BGRA,false)
				loadSkyPics(0)
				function loadSkyPics(num:uint):void
				{
					if(num<arr.length){
						var urlStr:String=fileRoot+arr[num]+".jpg"
						LoadManager.getInstance().addSingleLoad(new LoadInfo(urlStr,LoadInfo.BITMAP,function onTextureLoad(bitmap:Bitmap,url:String):void{
							var bmp:BitmapData=bitmap.bitmapData;
							cubeUpBitmapData($cubeTexture,bmp,num)
							num=num+1
							loadSkyPics(num);
						},0,urlStr));
					}else{
						backFun($cubeTexture)
					}
				}
				function cubeUpBitmapData(_cube:CubeTexture,bmp:BitmapData,i:uint):void
				{
					for(var j:uint=0;j<10;j++)
					{
						$cubeTexture.uploadFromBitmapData(bmp,i,j)
					}
				}

			}else{
				throw new Error("天空球面数不对")
			}
		}
	
	}
}
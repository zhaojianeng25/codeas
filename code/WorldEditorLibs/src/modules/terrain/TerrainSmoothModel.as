package modules.terrain
{
	import com.adobe.air.gaming.MagnetometerEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import modules.hierarchy.FileSaveModel;
	
	import proxy.top.ground.IGround;
	import proxy.top.render.Render;
	
	import render.ground.GroundManager;
	
	import terrain.GroundData;

	public class TerrainSmoothModel
	{
		private static var instance:TerrainSmoothModel;
		public function TerrainSmoothModel()
		{
		}
		
		public static function getInstance():TerrainSmoothModel
		{
			
			if(!instance){
				instance=new TerrainSmoothModel()
			}
			return instance;
		}
		public function  smoothLightPic():void
		{
			
			if(GroundData.showTerrain){
				this.groundpicItem=new Vector.<BitmapData>;
				this.loadUVpIC()
			
			}else{
				Alert.show("本场景无地面，")
			}
		
		}
		private var groundpicItem:Vector.<BitmapData>;
		private function  loadUVpIC():void
		{
          if(this.groundpicItem.length< GroundManager.getInstance().groundItem.length){
			  var $url:String=Render.lightUvRoot+"ground"+this.groundpicItem.length+".jpg"
			  BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
			  		groundpicItem.push($bitmap.bitmapData);
					loadUVpIC();
			  },{})
		  }else{
		     trace("加载完成",this.groundpicItem.length);
			 this.makeBigBitmapdata();
		  }
		}
		private var tempBitmapDataSize:Number;
		private function makeBigBitmapdata():void
		{
			
			this.tempBitmapDataSize=this.groundpicItem[0].height
			bigBitMapData=new BitmapData(GroundData.cellNumX*this.tempBitmapDataSize,GroundData.cellNumZ*this.tempBitmapDataSize)
			for (var j:uint=0;j< GroundManager.getInstance().groundItem.length;j++)
			{
				var $imode:IGround=GroundManager.getInstance().groundItem[j];
				var $bmp:BitmapData=this.groundpicItem[j];
		
				if(j==4){
					this.drawRoundLineBitmpa($bmp);
				}
				this.drawToBigLightBmp($bmp,$imode.cellX,$imode.cellZ);
				
				
				$imode.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bmp);
				var $url:String=Render.lightUvRoot+"ground"+j+".jpg"
				FileSaveModel.getInstance().useWorkerSaveBmp($bmp,$url,"jpg");
			}

		//	ShowMc.getInstance().setBitMapData(bigBitMapData);
		}
		private var bigBitMapData:BitmapData
		private function drawToBigLightBmp($bmp:BitmapData,cellX:uint,cellZ:uint):void
		{
			var $m:Matrix=new Matrix;
			$m.tx=cellX*this.tempBitmapDataSize;
			$m.ty=cellZ*this.tempBitmapDataSize;
			bigBitMapData.draw($bmp,$m);
			
		
		}
		private function drawRoundLineBitmpa($bmp:BitmapData):void
		{
			 for(var i:Number=0;i<$bmp.width;i++){
				
				 /*
				 $bmp.setPixel32(i,0, $bmp.getPixel32(i,1));
				 $bmp.setPixel32(i,$bmp.height-1, $bmp.getPixel32(i,$bmp.height-2));
				 $bmp.setPixel32(0,i,$bmp.getPixel32(1,i));
				 $bmp.setPixel32($bmp.width-1,i,$bmp.getPixel32($bmp.width-2,i));
				 
				 */
				 
				 var $colorUint:Number= MathCore.vecToHex(new Vector3D(255,255,255,255))
				 $bmp.setPixel32(i,0, $colorUint);
				 $bmp.setPixel32(i,$bmp.height-1,$colorUint);
				 $bmp.setPixel32(0,i,$colorUint);
				 $bmp.setPixel32($bmp.width-1,i,$colorUint);
			 }
			 
		
		}

		
	}
}
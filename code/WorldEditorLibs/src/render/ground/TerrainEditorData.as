package render.ground
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Vector3D;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.core.MathCore;
	
	import terrain.GroundData;
	import terrain.GroundMath;

	public class TerrainEditorData
	{
		public static var fileRoot:String=""
		public static var workSpaceUrl:String=""
			
//		public static var cellNumX:uint=2;
//		public static var cellNumZ:uint=2;
//		public static var terrainMidu:uint=10;      //每个地块的密度
//		public static var cellScale:Number=10;      //地块对应的世界比例
//		public static var idMapScale:Number=5;      //贴图ID比例
//		public static var sixteenNum:uint=6
			
		public static var sixteenUvSize:uint=128;   //贴图的单位张大小
		public static var lightMapSize:uint=128

		
		public static var bigHeightBmp:BitmapData;    //最大的那张高度图
		public static var bigIdMapBmp:BitmapData;     //最大的索引图
		public static var bigInfoMapBmp:BitmapData;     //最大的索引图
		
		public static var sixteenBmpArr:Vector.<BitmapData>;
		public static var sixteenslotBmpArr:Vector.<BitmapData>;
		public static var sixteenUvBmp:BitmapData;    //颜色材质
		public static var sixteenUvTexture:RectangleTexture;    
		
		public static var sixTeenFileNodeArr:Array=new Array
		public static var sixteenUvMiduArr:Array=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];  //存入材质的密度
		//public static var uvMiduTexture:RectangleTexture;
		
//		public static var groundHitPos:Vector3D=new Vector3D;
//		public static var showShaderHitPos:Boolean=false
	
		public function TerrainEditorData()
		{
			
		}
		/**
		 *新场景初始信息
		 * 
		 */
		public static function initData():void
		{

			 GroundData.cellNumX=2;
			 GroundData.cellNumZ=2;
			 GroundData.terrainMidu=10;
			 GroundData.cellScale=10;
			 GroundData.idMapScale=5;
			 sixteenUvSize=128;   //贴图的单位张大小
			 lightMapSize=128;   //贴图的单位张大小

			 GroundData.sixteenNum=6
			 sixTeenFileNodeArr=new Array
			 sixteenUvMiduArr=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];  //存入材质的密度
			 
			
			 var $tempH:Number=10000
				 
			 TerrainEditorData.sixteenUvBmp=new BitmapData(128,128*GroundData.sixteenNum,false,MathCore.argbToHex16(100,100,100))
			 TerrainEditorData.sixteenUvTexture=TextureCreate.getInstance().bitmapToRectangleTexture(TerrainEditorData.sixteenUvBmp)
			 TerrainEditorData.bigHeightBmp=new BitmapData(1,1,false,MathCore.argbToHex16($tempH%250,int($tempH/250),0))
			 TerrainEditorData.bigIdMapBmp=new BitmapData(1,1,false,MathCore.argbToHex16(0,1,2))
			 TerrainEditorData.bigInfoMapBmp=new BitmapData(1,1,false,MathCore.argbToHex16(255,0,0))
			
			 GroundNrmModel.getInstance().baseNrmBitmapData=null

		}
		public static function setObject(obj:Object):void{
			
			GroundData.cellNumX=obj.cellX
			GroundData.cellNumZ=obj.cellZ
			GroundData.terrainMidu=obj.terrainMidu
			GroundData.cellScale=obj.cellScale
			GroundData.idMapScale=obj.idMapScale
			GroundData.isQuickScan=obj.isQuickScan
			GroundData.showTerrain=obj.showTerrain
			GroundData.isH5UseLight=obj.isH5UseLight
			
				
			if(obj.quickScanSize)	{
				GroundData.quickScanSize=obj.quickScanSize
			}else{
				GroundData.quickScanSize=256
			}
				
			if(obj.lightBlur){
				GroundData.lightBlur=obj.lightBlur
			}else{
				GroundData.lightBlur=3
			}
			
			if(obj.materialUrl){
				GroundData.materialUrl=obj.materialUrl
			}else{
				GroundData.materialUrl="assets/terraincopy.material"
			}
			

				
			if(obj.sixteenUvMiduArr){
				sixteenUvMiduArr=obj.sixteenUvMiduArr
			}
			if(obj.sixteenUvSize){
				sixteenUvSize=obj.sixteenUvSize
			}else{
				sixteenUvSize=128
			}
			if(obj.lightMapSize){
				lightMapSize=obj.lightMapSize
			}else{
				lightMapSize=128
			}
	
			if(obj.sixTeenFileNodeArr){
				sixTeenFileNodeArr=obj.sixTeenFileNodeArr;
				GroundData.sixteenNum=Math.max(1,sixTeenFileNodeArr.length);
			}else{
				sixTeenFileNodeArr=new Array
				GroundData.sixteenNum=1
			}
			makeUvMiduTexture();
		}
		public static function makeUvMiduTexture():void
		{
			var bmp:BitmapData=new BitmapData(1,16,false,0x000000)
			for(var i:uint=0;i<sixteenUvMiduArr.length;i++){
				bmp.setPixel(0,i,MathCore.argbToHex16(sixteenUvMiduArr[i],0,0))
			}
			if(GroundData.uvMiduTexture){
				GroundData.uvMiduTexture.uploadFromBitmapData(bmp)
			}else{
				GroundData.uvMiduTexture=TextureCreate.getInstance().bitmapToRectangleTexture(bmp)
			}
			
		}
		public static function getObject():Object{
			
			var obj:Object=new Object;
			obj.cellX=GroundData.cellNumX;
			obj.cellZ=GroundData.cellNumZ;
			obj.terrainMidu=GroundData.terrainMidu;
			obj.cellScale=GroundData.cellScale;
			obj.idMapScale=GroundData.idMapScale;
			obj.lightBlur=GroundData.lightBlur;
			obj.quickScanSize=GroundData.quickScanSize;
			obj.isQuickScan=GroundData.isQuickScan;
			obj.showTerrain=GroundData.showTerrain;
			obj.isH5UseLight=GroundData.isH5UseLight;
			obj.materialUrl=GroundData.materialUrl;
			obj.sixteenUvSize=sixteenUvSize;
			obj.lightMapSize=lightMapSize;
		
			obj.sixTeenFileNodeArr=sixTeenFileNodeArr
			obj.sixteenUvMiduArr=sixteenUvMiduArr
			return obj;
		}
		public static function getTerrainHeight($x:Number,$z:Number):Number
		{
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var Area_Size:uint=Area_Cell_Num*GroundData.cellScale

			var $tempScale:Number=Area_Size/Area_Cell_Num
			$x=$x+Area_Size*GroundData.cellNumX/2
			$z=$z+Area_Size*GroundData.cellNumZ/2
				
			var $XZ:Vector3D=new Vector3D($x/$tempScale,0/$tempScale,$z/$tempScale)	

			if(TerrainEditorData.bigHeightBmp){
				return GroundMath.getInstance().getBaseHeightByBitmapdata($XZ.x,$XZ.z,TerrainEditorData.bigHeightBmp)
			}else
			{
				return 0
			}
			return 0
		}
		
		
//		public static function set cellNumX(value:uint):void
//		{
//			GroundData.cellNumX = value;
//		}
//		public static function get cellNumX():uint
//		{
//			return GroundData.cellNumX;
//		}
//		public static function set cellNumZ(value:uint):void
//		{
//			GroundData.cellNumZ = value;
//		}
//		public static function get cellNumZ():uint
//		{
//			return GroundData.cellNumZ;
//		}
//		public static function set cellScale(value:Number):void
//		{
//			GroundData.cellScale = value;
//		}
//		public static function get cellScale():Number
//		{
//			return GroundData.cellScale;
//		}
//		public static function set terrainMidu(value:uint):void
//		{
//			GroundData.terrainMidu = value;
//		}
//		public static function get terrainMidu():uint
//		{
//			return GroundData.terrainMidu;
//		}
//		public static function set idMapScale(value:Number):void
//		{
//			GroundData.idMapScale = value;
//		}
//		public static function get idMapScale():Number
//		{
//			return GroundData.idMapScale;
//		}
//		public static function set sixteenNum(value:uint):void
//		{
//			GroundData.sixteenNum = value;
//		}
//		public static function get sixteenNum():uint
//		{
//			return GroundData.sixteenNum;
//		}
//		public static function set uvMiduTexture(value:RectangleTexture):void
//		{
//			GroundData.uvMiduTexture = value;
//		}
//		public static function get uvMiduTexture():RectangleTexture
//		{
//			return GroundData.uvMiduTexture;
//		}
//		public static function set groundHitPos(value:Vector3D):void
//		{
//			GroundData.groundHitPos = value;
//		}
//		public static function get groundHitPos():Vector3D
//		{
//			return GroundData.groundHitPos;
//		}
//		public static function set showShaderHitPos(value:Boolean):void
//		{
//			GroundData.showShaderHitPos = value;
//		}
//		public static function get showShaderHitPos():Boolean
//		{
//			return GroundData.showShaderHitPos;
//		}
		
		
	}
}
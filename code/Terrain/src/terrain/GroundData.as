package terrain
{
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Vector3D;

	public class GroundData
	{
		public function GroundData()
		{
		}
		public static var cellNumX:uint=2;
		public static var cellNumZ:uint=2;
		public static var terrainMidu:uint=10;      //每个地块的密度
		public static var cellScale:Number=10;      //地块对应的世界比例
		public static var idMapScale:Number=5;      //贴图ID比例
		public static var quickScanSize:uint=256;      //贴图ID比例
		public static var lightBlur:uint=3;
		public static var sixteenNum:uint=6;
		public static var uvMiduTexture:RectangleTexture;
		public static var groundHitPos:Vector3D=new Vector3D;
		public static var showShaderHitPos:Boolean=false;
			
		//public static var  canQuickScan:Boolean=false;
		public static var  isQuickScan:Boolean=false;
		public static var  isEditNow:Boolean=false;
		public static var  showTerrain:Boolean=true ; //是否显示
		public static var  isH5UseLight:Boolean=false; //j是否有直接光照
		
		public static var materialUrl:String
			

	}
}
package modules.terrain
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import PanV2.TextureCreate;
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import proxy.top.render.Render;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	

	public class TerrainDataModel
	{
		private static var instance:TerrainDataModel;
		private var _loadIdMapJpg:Bitmap;
		private var _loadHeightJpg:Bitmap;
		
		private var _backFun:Function;
		
		

		public function TerrainDataModel()
		{
		
		}
	
		public static function getInstance():TerrainDataModel
		{
			
			if(!instance){
				instance=new TerrainDataModel()
			}
			return instance;
		}
	
		public  function loadBaseTerrainData($bfun:Function):void
		{
			_backFun=$bfun
			loadHightMap()
			loadSixTeenMap();
			loadBigIdMap();
			loadBigInfoMap();
		}

		public var amaniSixtee:Vector.<BitmapData>=new Vector.<BitmapData>
		public function loadSixTeenMap():void
		{
			TerrainEditorData.sixteenBmpArr=new Vector.<BitmapData>;
			amaniSixtee.length=0
		
			Render.setSixteenBmp(amaniSixtee)
			TerrainEditorData.sixteenUvBmp=new BitmapData(TerrainEditorData.sixteenUvSize,TerrainEditorData.sixteenUvSize*GroundData.sixteenNum,false,0x808080)
			if(TerrainEditorData.sixteenUvTexture){
				TerrainEditorData.sixteenUvTexture.dispose()
			}
			TerrainEditorData.sixteenUvTexture=TextureCreate.getInstance().bitmapToRectangleTexture(TerrainEditorData.sixteenUvBmp)
				
			for(var i:uint=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++){
				amaniSixtee.push(null)
				var $url:String=TerrainEditorData.workSpaceUrl+TerrainEditorData.sixTeenFileNodeArr[i];
				
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					var $m:Matrix=new Matrix
					$m.scale(TerrainEditorData.sixteenUvSize/$bitmap.bitmapData.width,TerrainEditorData.sixteenUvSize/$bitmap.bitmapData.height)
					$m.ty=$obj.id*TerrainEditorData.sixteenUvSize
	
					TerrainEditorData.sixteenUvBmp.draw($bitmap.bitmapData,$m)
					TerrainEditorData.sixteenUvTexture=TextureCreate.getInstance().bitmapToRectangleTexture(TerrainEditorData.sixteenUvBmp)
			
					TerrainEditorData.sixteenBmpArr.push($bitmap.bitmapData);
					amaniSixtee[$obj.id]=$bitmap.bitmapData;  
					GroundManager.getInstance().refreshSixteenUvMap()
					//ShowMc.getInstance().setBitMapData(TerrainData.sixteenUvBmp)
				
				},{id:i})
			}
			
			TerrainEditorData.sixteenslotBmpArr=amaniSixtee
		
		}
		private function loadHightMap():void
		{
			var loaderinfo:LoadInfo = new LoadInfo(TerrainEditorData.fileRoot+"terrain/bigHeightBmp.jpg",	LoadInfo.BYTE, onHeightMapLoad, 10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onHeightMapLoad(byte:ByteArray):void
			{
				var by:ByteArray = new ByteArray();
				byte.readBytes(by);
				TerrainEditorData.bigHeightBmp = new BitmapData(GroundData.cellNumX*GroundData.terrainMidu*4+1, GroundData.cellNumZ*GroundData.terrainMidu*4+1,false, 0x808080);
				
				TerrainEditorData.bigHeightBmp.setPixels(TerrainEditorData.bigHeightBmp.rect, by);
				by.position = 0;
				by.clear();

				_backFun()

			}
		}
		private function loadBigIdMap():void
		{
			
			var loaderinfo:LoadInfo = new LoadInfo(TerrainEditorData.fileRoot+"terrain/bigIdMapBmp.jpg",	LoadInfo.BYTE, onHeightMapLoad, 10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onHeightMapLoad(byte:ByteArray):void
			{
				var by:ByteArray = new ByteArray();
				byte.readBytes(by);

				TerrainEditorData.bigIdMapBmp = new BitmapData(GroundData.cellNumX*GroundData.terrainMidu*4*GroundData.idMapScale, GroundData.cellNumZ*GroundData.terrainMidu*4*GroundData.idMapScale,false, 0x808080);
				TerrainEditorData.bigIdMapBmp.setPixels(TerrainEditorData.bigIdMapBmp.rect, by);
				by.position = 0;
				by.clear();
				GroundManager.getInstance().upAllidMap()
			}
		}
		private function loadBigInfoMap():void
		{
			var loaderinfo:LoadInfo = new LoadInfo(TerrainEditorData.fileRoot+"terrain/bigInfoMapBmp.jpg",	LoadInfo.BYTE, onHeightMapLoad, 10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onHeightMapLoad(byte:ByteArray):void
			{
				var by:ByteArray = new ByteArray();
				byte.readBytes(by);
				TerrainEditorData.bigInfoMapBmp = new BitmapData(GroundData.cellNumX*GroundData.terrainMidu*4*GroundData.idMapScale, GroundData.cellNumZ*GroundData.terrainMidu*4*GroundData.idMapScale,false, 0x808080);
				TerrainEditorData.bigInfoMapBmp.setPixels(TerrainEditorData.bigInfoMapBmp.rect, by);
				by.position = 0;
				by.clear();
				GroundManager.getInstance().upAllidMap()
			}
		}
		
	


	
	}
}
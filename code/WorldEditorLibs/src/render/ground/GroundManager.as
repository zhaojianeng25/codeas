package  render.ground
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import PanV2.Stage3DVO;
	import PanV2.TextureCreate;
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.base.BaseLevel;
	import _Pan3D.core.MathCore;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import modules.terrain.TerrainDrawHeightModel;
	
	import proxy.top.ground.IGround;
	import proxy.top.render.Render;
	
	import terrain.GroundData;
	import terrain.GroundMath;
	import terrain.TerrainData;
	
	import xyz.draw.TooMathMoveUint;
	
	public class GroundManager extends BaseLevel
	{
		private static var instance:GroundManager;
		//private var _groundItem:Vector.<GroundEditorSprite>
		

		public function GroundManager()
		{
			super();
		}
		public function get groundItem():Vector.<IGround>
		{
			return _groundItem;
		}
		public static function getInstance():GroundManager
		{
			
			if(!instance){
				instance=new GroundManager()
			}
			return instance;
		}

		override protected function initData():void
		{
			clear()
		}
		public function drawPointToIdmap($pos:Vector3D):void
		{
			
			var Area_Size:uint=GroundData.terrainMidu*4*GroundData.cellScale
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var ID_MAP_SCALE:uint=GroundData.idMapScale;
			
	
			var $tempScale:Number=Area_Cell_Num*ID_MAP_SCALE/Area_Size
				
				
			TerrainEditorData.bigIdMapBmp.setPixel($pos.x*$tempScale,$pos.z*$tempScale,MathCore.argbToHex16(1,0,0))
				
	
			upAllidMap()
			//ShowMc.getInstance().setBitMapData(_bigIdMapBmp)
		}
		public function upAllidMap($rect:Rectangle=null):void
		{
			var Area_Size:uint=GroundData.terrainMidu*4*GroundData.cellScale
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var ID_MAP_SCALE:uint=GroundData.idMapScale;
			
			var $changeRect:Rectangle;
			if(TerrainEditorData.bigIdMapBmp&&TerrainEditorData.bigInfoMapBmp){
				if($rect){
					$changeRect=new Rectangle($rect.x-1,$rect.y-1,$rect.width+2,$rect.height+2)
				}else{
					$changeRect=new Rectangle(0,0,TerrainEditorData.bigIdMapBmp.width,TerrainEditorData.bigIdMapBmp.height);
				}
				for each(var $IGround:IGround in _groundItem)
				{
					
					var i:uint=$IGround.cellX
					var j:uint=$IGround.cellZ
					var w:Number=ID_MAP_SCALE*Area_Cell_Num
					var $groundRect:Rectangle=new Rectangle(i*w,j*w,w,w)
					if($changeRect.intersects($groundRect)){
						upIdMapToGroundSprite($IGround.cellX,$IGround.cellZ,$IGround)  //上传信息索引图
						
					}
				}
				

			}
		

		}
		
		public function changeBrushData():void
		{
			for each(var $IGround:IGround in _groundItem)
			{
				var $vet:Vector3D=new Vector3D
				$vet.x=TerrainDrawHeightModel.brushSize
				$vet.y=TerrainDrawHeightModel.brushPow
				$vet.z=TerrainDrawHeightModel.brushBluer
				$IGround.brushData=$vet
			}
		}


		private function testBase():void
		{
			var $tempH:Number=GroundMath.getInstance().Num1000
				
			if(!Boolean(TerrainEditorData.sixteenUvBmp)){
				TerrainEditorData.sixteenUvBmp=new BitmapData(128,128*GroundData.sixteenNum,false,MathCore.argbToHex16(100,100,100))
				TerrainEditorData.sixteenUvTexture=TextureCreate.getInstance().bitmapToRectangleTexture(TerrainEditorData.sixteenUvBmp)
			}
			if(!Boolean(TerrainEditorData.bigHeightBmp)){
				TerrainEditorData.bigHeightBmp=new BitmapData(1,1,false,MathCore.argbToHex16($tempH%250,int($tempH/250),0))
			}
			if(!Boolean(TerrainEditorData.bigIdMapBmp)){
				TerrainEditorData.bigIdMapBmp=new BitmapData(1,1,false,MathCore.argbToHex16(0,1,2))
			}
			if(!Boolean(TerrainEditorData.bigInfoMapBmp)){
				TerrainEditorData.bigInfoMapBmp=new BitmapData(1,1,false,MathCore.argbToHex16(255,0,0))
			}
			
		}
		
		/**
		 *创建地面模型 
		 * @param cellNumX  x轴方向地块数量
		 * @param cellNumZ  z轴方向地块数量
		 * @param cellMidu  每个区分地块的密度，每个密度由4个像素，为一个最小单位，作为可以生存 0,1,2三个级别的lod
		 * @param cellScale  像素比例，通过这比例算出每个地块在世界坐标中的位置
		 * @param heightScale  高度比例，
		 * @param idMapScale   相对地面信息比例。 这个和地形高度系数有关系
		 *  */
		public function changeGroundData(cellNumX:uint,cellNumZ:uint,cellMidu:uint,cellScale:Number,idMapScale:uint):void
		{
		
			testBase()
			clear()
			var _Area_Size:int=cellMidu*4*cellScale   //单位模块的坐标   400*400
			var _Area_Cell_Num:int=cellMidu*4            //高度图信息像素  40*40
			var _ID_MAP_SCALE:Number=Math.max(idMapScale,1)             //地表信息图比例   原来写成400*400

			GroundMath.getInstance().cellNumX=cellNumX      
			GroundMath.getInstance().cellNumZ=cellNumZ
			GroundMath.getInstance().Area_Size=_Area_Size;   
			GroundMath.getInstance().Area_Cell_Num=_Area_Cell_Num;
			GroundMath.getInstance().ID_MAP_SCALE=_ID_MAP_SCALE;
			
			var $tempH:Number=GroundMath.getInstance().Num1000
			var $tempHight:BitmapData=new BitmapData(cellNumX*_Area_Cell_Num+1,cellNumZ*_Area_Cell_Num+1,false,MathCore.argbToHex16($tempH%250,int($tempH/250),0))
			var hightMapNoChange:Boolean=Boolean(TerrainEditorData.bigHeightBmp.width==$tempHight.width&&TerrainEditorData.bigHeightBmp.height==$tempHight.height)
			$tempHight.draw(TerrainEditorData.bigHeightBmp)
			TerrainEditorData.bigHeightBmp=$tempHight

			var $tempIdMap:BitmapData=new BitmapData(_Area_Cell_Num*_ID_MAP_SCALE*cellNumX,_Area_Cell_Num*_ID_MAP_SCALE*cellNumZ,false,MathCore.argbToHex16(0,1,2))
			var $tempInfoMap:BitmapData=new BitmapData(_Area_Cell_Num*_ID_MAP_SCALE*cellNumX,_Area_Cell_Num*_ID_MAP_SCALE*cellNumZ,false,MathCore.argbToHex16(255,0,0))
			var $m:Matrix=new Matrix
			if(hightMapNoChange){  //如果没有改变地形，将只会更新信息图，并同比变化，
				$m.scale($tempIdMap.width/TerrainEditorData.bigIdMapBmp.width,$tempIdMap.height/TerrainEditorData.bigIdMapBmp.height)
			}
			$tempIdMap.draw(TerrainEditorData.bigIdMapBmp,$m);
			TerrainEditorData.bigIdMapBmp=$tempIdMap;
			$tempInfoMap.draw(TerrainEditorData.bigInfoMapBmp,$m);
			TerrainEditorData.bigInfoMapBmp=$tempInfoMap;
			 
			//GroundNrmModel.getInstance().setBitmapdata(TerrainEditorData.bigHeightBmp);  创建的时候是否需要更新全部法线
			makeTerrainDataList()
			_groundItem=new Vector.<IGround>
			for(var k:uint=0;k<terrainArr.length;k++){
				
				var Area_Cell_Num:uint=GroundData.terrainMidu*4
				var ID_MAP_SCALE:uint=GroundData.idMapScale;
				
				var $idMapBmp:BitmapData=new BitmapData(Area_Cell_Num*ID_MAP_SCALE,Area_Cell_Num*ID_MAP_SCALE,false,MathCore.argbToHex16(0,0,0))
				var $infoBmp:BitmapData=new BitmapData(Area_Cell_Num*ID_MAP_SCALE,Area_Cell_Num*ID_MAP_SCALE,false,MathCore.argbToHex16(255/3,255/3,255/3))
					
				var $proxyGound:IGround=Render.creaGround(terrainArr[k],TerrainEditorData.sixteenUvTexture,$idMapBmp,$infoBmp)
				_groundItem.push($proxyGound);
				
				
				loadLightUv($proxyGound,"ground"+k)
				
				upIdMapToGroundSprite($proxyGound.cellX,$proxyGound.cellZ,$proxyGound)
			}
		}
		private function loadLightUv($proxyGound:IGround,uid:String):void
		{

			var $url:String=Render.lightUvRoot+uid+".jpg"
			BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
				$proxyGound.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bitmap.bitmapData)
			},{})	
		}
		private var _groundItem:Vector.<IGround>;
			
		public var terrainArr:Vector.<TerrainData>
		private function makeTerrainDataList():void
		{
			var $bitmapdata:BitmapData=TerrainEditorData.bigHeightBmp
			var $xNum:uint=GroundData.cellNumX
			var $zNum:uint=GroundData.cellNumZ
			var $area_Size:Number=GroundData.cellScale*GroundData.terrainMidu*4
			var $area_Cell_Num:int=GroundData.terrainMidu*4
			terrainArr=GroundMath.getInstance().getTerrainDataList($bitmapdata,$xNum,$zNum,$area_Size,$area_Cell_Num)
		}
		public function refreshSixteenUvMap():void
		{
			for each(var $GroundEditorSprite:IGround in _groundItem)
			{
				$GroundEditorSprite.sixteenUvTexture=TerrainEditorData.sixteenUvTexture//上传16张图
			}
		}
		public function refreshHightMap($rect:Rectangle=null):void
		{
			GroundNrmModel.getInstance().setBitmapdata(TerrainEditorData.bigHeightBmp,$rect);
			var $changeRect:Rectangle;
			if($rect){
				$changeRect=new Rectangle($rect.x-1,$rect.y-1,$rect.width+2,$rect.height+2)
			}else{
				$changeRect=new Rectangle(0,0,TerrainEditorData.bigHeightBmp.width,TerrainEditorData.bigHeightBmp.height);
			}
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			//var Area_Cell_Num:uint=GroundMath.getInstance().Area_Cell_Num
		
			for each(var $GroundEditorSprite:IGround in _groundItem)
			{
					var i:uint=$GroundEditorSprite.terrainData.cellX
					var j:uint=$GroundEditorSprite.terrainData.cellZ
					var $groundRect:Rectangle=new Rectangle(i*Area_Cell_Num,j*Area_Cell_Num,Area_Cell_Num,Area_Cell_Num)
					if($changeRect.intersects($groundRect)){
						upHightToGroundSprite(i,j,$GroundEditorSprite)  //上传高图图
						upNrmToGroundSprite(i,j,$GroundEditorSprite)    //上传法线贴图
					}
			}

		}

		private function upIdMapToGroundSprite(i:uint,j:uint,$GroundEditorSprite:IGround):void
		{
		
		
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var ID_MAP_SCALE:uint=GroundData.idMapScale;
			var $idMapBmp:BitmapData=new BitmapData(Area_Cell_Num*ID_MAP_SCALE,Area_Cell_Num*ID_MAP_SCALE,false,MathCore.argbToHex16(2,1,1))
			var $infoBmp:BitmapData=new BitmapData(Area_Cell_Num*ID_MAP_SCALE,Area_Cell_Num*ID_MAP_SCALE,false,MathCore.argbToHex16(255/3,255/3,255/3))

			$idMapBmp.copyPixels(TerrainEditorData.bigIdMapBmp,new Rectangle((i*Area_Cell_Num*ID_MAP_SCALE),(j*Area_Cell_Num*ID_MAP_SCALE),$idMapBmp.width,$idMapBmp.height),new Point)
			$infoBmp.copyPixels(TerrainEditorData.bigInfoMapBmp,new Rectangle((i*Area_Cell_Num*ID_MAP_SCALE),(j*Area_Cell_Num*ID_MAP_SCALE),$idMapBmp.width,$idMapBmp.height),new Point)
				
			$GroundEditorSprite.idInfoBitmapData=$idMapBmp
			$GroundEditorSprite.grassInfoBitmapData=$infoBmp
				
		}
		private function upNrmToGroundSprite(i:uint,j:uint,$GroundEditorSprite:IGround):void
		{
	
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var $nrmBmp:BitmapData=new BitmapData(Area_Cell_Num+1,Area_Cell_Num+1,false,MathCore.argbToHex16(128,128,128))
			$nrmBmp.copyPixels(GroundNrmModel.getInstance().nrmBitmapData,new Rectangle(i*Area_Cell_Num,j*Area_Cell_Num,$nrmBmp.width,$nrmBmp.height),new Point)
			$GroundEditorSprite.normalMap=$nrmBmp
	
				
				
		}
		private function upHightToGroundSprite(i:uint,j:uint,$GroundEditorSprite:IGround):void
		{
			var $area_Size:Number=GroundData.cellScale*GroundData.terrainMidu*4
			var $area_Cell_Num:int=GroundData.terrainMidu*4
			var $bmp:BitmapData= new BitmapData($area_Cell_Num+1,$area_Cell_Num+1,false,MathCore.argbToHex16(128,128,128))
			$bmp.copyPixels(TerrainEditorData.bigHeightBmp,new Rectangle(i*$area_Cell_Num,j*$area_Cell_Num,$bmp.width,$bmp.height),new Point)
			var p:Vector3D=new Vector3D($GroundEditorSprite.x,$GroundEditorSprite.y,$GroundEditorSprite.z)
			GroundMath.getInstance().getTerrainData($bmp,p,$area_Size,$area_Cell_Num,$GroundEditorSprite.terrainData)
			$GroundEditorSprite.upLodAndToIndex();
			if(isShowLine){
				$GroundEditorSprite.showTriLine(true);
			}
		}
		
		private function clear():void
		{
			//SceneContext.sceneRender.groundlevel.clear()
			Render.clearGroundAll()
		}
		
		private function drawRoundLine(fx:uint,fz:uint):void
		{
			/*
			var $num400:uint=GroundMath.getInstance().Area_Size
			LineShowTestSprite.getInstance().clear()
			LineShowTestSprite.getInstance().colorVector3d=new Vector3D(0,1,0);
			LineShowTestSprite.getInstance().makeLineMode(new Vector3D(0,0,0),new Vector3D(+fx*$num400,0,0));
			LineShowTestSprite.getInstance().makeLineMode(new Vector3D(0,0,0),new Vector3D(0,0,+fz*$num400));
			LineShowTestSprite.getInstance().makeLineMode(new Vector3D(+fx*$num400,0,+fz*$num400),new Vector3D(+fx*$num400,0,0));
			LineShowTestSprite.getInstance().makeLineMode(new Vector3D(+fx*$num400,0,+fz*$num400),new Vector3D(0,0,+fz*$num400));
			LineShowTestSprite.getInstance().reSetUplodToGpu()
			*/
		}
		private var isShowLine:Boolean=false
		public function showGroundModelLine():void
		{
			isShowLine=!isShowLine
			for each(var $IGround:IGround in _groundItem)
			{
				$IGround.showTriLine(isShowLine)
			}
			
		}
		



		/**
		 * 
		 * @return 返回鼠标在地面模型上的坐标  这个是还没有减去地形起点。
		 * 
		 */
		public function getMouseHitGroundPostion():Vector3D
		{
			var pos:Vector3D=mathDisplay2Dto3DWorldPos(Scene_data.stage3DVO,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY),500)
			var triItem:Vector.<Vector3D>=new Vector.<Vector3D>
			triItem.push(new Vector3D(0,0,0))
			triItem.push(new Vector3D(-100,0,100))
			triItem.push(new Vector3D(+100,0,100))
			var camPos:Vector3D=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z)
			var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triItem);
			
			if(camPos.y>D.y&&TerrainEditorData.bigHeightBmp){
				return getHitGroundAndBuildAtoB(camPos,D,TerrainEditorData.bigHeightBmp)
			}else{
				return null
			}

		}
		/**
		 * 2D坐标转换成3D坐标，当然要给一个相离镜头的深度
		 * @param $stage3DVO 为stage3d的坐标信息
		 * @param $point  2d位置是场景的坐标，
		 * @param $depht  默认深度为500,
		 * @return  3D的坐标
		 * 
		 */
		public static function mathDisplay2Dto3DWorldPos($stage3DVO:Stage3DVO,$point:Point,$depht:Number=500):Vector3D
		{
			var cameraMatrixInvert:Matrix3D=Scene_data.cam3D.cameraMatrix.clone()
			var viewMatrx3DInvert:Matrix3D=Scene_data.viewMatrx3D.clone()
			cameraMatrixInvert.invert();
			viewMatrx3DInvert.invert();
			var a:Vector3D=new Vector3D()	
			a.x=$point.x-$stage3DVO.x
			a.y=$point.y-$stage3DVO.y
			
			a.x=a.x*2/$stage3DVO.width-1
			a.y=1-a.y*2/$stage3DVO.height
			a.w=$depht
			a.x = a.x*a.w
			a.y = a.y*a.w
			a=viewMatrx3DInvert.transformVector(a)
			a.z=$depht
			a=cameraMatrixInvert.transformVector(a)
			
			return a;
			
		}

		/**
		 *得到真实的世界坐标
		 * @return 
		 * 
		 */
		public function getMouseHitGroundWorldPos():Vector3D
		{
			var $pos:Vector3D=getMouseHitGroundPostion()
			if($pos){
				var tw:Number=GroundData.cellNumX*GroundData.cellScale*GroundData.terrainMidu*4
				var th:Number=GroundData.cellNumZ*GroundData.cellScale*GroundData.terrainMidu*4
				$pos.x=$pos.x-tw/2
				$pos.z=$pos.z-th/2
			}else{
				$pos=new Vector3D()
			}
				
			return $pos
		}
		public function getLookAtGroundCentenPos():Vector3D
		{
			var $P:Point=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
				
			$P.x=Scene_data.stage3DVO.x+Scene_data.stage3DVO.width/2
			$P.y=Scene_data.stage3DVO.y+Scene_data.stage3DVO.height/2
			
			var $rec:Rectangle=new Rectangle
			$rec.x=Scene_data.stage3DVO.x
			$rec.y=Scene_data.stage3DVO.y
			$rec.width=Scene_data.stage3DVO.width
			$rec.height=Scene_data.stage3DVO.height
				
				
				
			var pos:Vector3D=TooMathMoveUint.mathDisplay2Dto3DWorldPos($rec,$P,500)
			var triItem:Vector.<Vector3D>=new Vector.<Vector3D>
			triItem.push(new Vector3D(0,0,0))
			triItem.push(new Vector3D(-100,0,100))
			triItem.push(new Vector3D(+100,0,100))
			var camPos:Vector3D=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z)
			var D:Vector3D=TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triItem);
			
			var backPos:Vector3D;
			if(camPos.y>D.y&&TerrainEditorData.bigHeightBmp){
				backPos=getHitGroundAndBuildAtoB(camPos,D,TerrainEditorData.bigHeightBmp)
				if(backPos){
					var tw:Number=GroundData.cellNumX*GroundData.cellScale*GroundData.terrainMidu*4
					var th:Number=GroundData.cellNumZ*GroundData.cellScale*GroundData.terrainMidu*4
					backPos.x=backPos.x-tw/2
					backPos.z=backPos.z-th/2
				}
					
			}
            return backPos
		}

		private  function getHitGroundAndBuildAtoB($cam3D:Vector3D,$hit3D:Vector3D,_bigHeightBmp:BitmapData):Vector3D
		{
			var backB:Vector3D;
			
			var $dis:Number=Vector3D.distance($cam3D,$hit3D)
			var $m:Matrix3D=new Matrix3D
			$m.pointAt(new Vector3D($hit3D.x-$cam3D.x,$hit3D.y-$cam3D.y,$hit3D.z-$cam3D.z),Vector3D.X_AXIS, Vector3D.Y_AXIS);
			$m.appendTranslation($cam3D.x,$cam3D.y,$cam3D.z)
				
				
				
			var Area_Size:uint=GroundData.terrainMidu*4*GroundData.cellScale
			var Area_Cell_Num:uint=GroundData.terrainMidu*4
			var ID_MAP_SCALE:uint=GroundData.idMapScale;

			var cellNumX:uint=GroundData.cellNumX;
			var cellNumZ:uint=GroundData.cellNumZ;

	
			var $tempScale:Number=Area_Size/Area_Cell_Num
			
			$dis=0
			while(true){
				$dis++
				var $testPos:Vector3D=$m.transformVector(new Vector3D($dis,0,0))
				$testPos.x=$testPos.x+(Area_Size*cellNumX)/2
				$testPos.z=$testPos.z+(Area_Size*cellNumZ)/2
					
				var $XZ:Vector3D=new Vector3D($testPos.x/$tempScale,$testPos.y/$tempScale,$testPos.z/$tempScale)	
					
				var $y:Number=0
				if($XZ.x>=0&&$XZ.z>=0&&$XZ.x<_bigHeightBmp.width&&$XZ.y<_bigHeightBmp.height){
					$y=GroundMath.getInstance().getBaseHeightByBitmapdata($XZ.x,$XZ.z,_bigHeightBmp)
				}
			
			    if($y>$testPos.y){
					backB= $testPos
					break
				}
				if($dis > 4000)  //当向前1000都还没找到。就退出
				{
					backB=null
					break;
				}
			}
			return backB
		}

		override public function upData():void
		{
			
	

			changeLod()
			
		}

		
		private function changeLod():void
		{
			var $camPos:Vector3D=new Vector3D
			$camPos.x=Scene_data.cam3D.x
			$camPos.y=Scene_data.cam3D.y
			$camPos.z=Scene_data.cam3D.z
			var $arr:Array=new Array
			for each(var $groundDisplaySprite:IGround in _groundItem)
			{
				var $dis:Number=Vector3D.distance(new Vector3D($groundDisplaySprite.x+200,$groundDisplaySprite.y,$groundDisplaySprite.z+200),$camPos)
				$arr.push({mc:$groundDisplaySprite,dis:$dis})
			}
			$arr.sortOn("dis", Array.NUMERIC );
			for(var i:uint=0;i<$arr.length;i++){
				var $tempGround:IGround=$arr[i].mc
				var d:Number=Vector3D.distance($tempGround.lastLodPos,$camPos)
				if(d>200){
					$tempGround.lastLodPos=$camPos.clone()
					$tempGround.upLodAndToIndex();
					$tempGround.showTriLine(isShowLine)
					if(GroundData.isQuickScan){
						$tempGround.changeQuickTextureLod()
					}
					return ;
				}
			}

			
		}
	}
}
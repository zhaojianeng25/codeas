package terrain
{
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class GroundMath
	{
		private  var _Area_Size:int;				//小地块400*400
		
		private  var _Area_Cell_Num:uint ;           //用40*40
		private  var _Area_idMap_Scale:Number
		
		private var _cellNumX:uint
		private var _cellNumZ:uint
		
		public var _H_NUM:Number=0.05;
		
		
		/**
		 *单位区块地形信息像素 
		 */
		private  var AreaBitmapSize:uint;              //41*41
		/**
		 *单位像素所代表的宽度 
		 */
		private  var CellNum10:uint ;                //10*10
		
		private var groundNormalUtils:GroundNormal;
		
		public function GroundMath()
		{
			_Area_Size=400
			Area_Cell_Num=4*10
			changeCellData();
			groundNormalUtils = new GroundNormal;
		}
		public function get cellNumZ():uint
		{
			return _cellNumZ;
		}

		public function set cellNumZ(value:uint):void
		{
			_cellNumZ = value;
		}

		public function get cellNumX():uint
		{
			return _cellNumX;
		}

		public function set cellNumX(value:uint):void
		{
			_cellNumX = value;
		}

		public function get ID_MAP_SCALE():Number
		{
			return _Area_idMap_Scale;
		}

		public function set ID_MAP_SCALE(value:Number):void
		{
			_Area_idMap_Scale = value;
		}

		private function changeCellData():void
		{
			AreaBitmapSize=_Area_Cell_Num+1
			CellNum10=_Area_Cell_Num/4
		}
	
		public function get Area_Cell_Num():uint
		{
			return _Area_Cell_Num;
		}
		public function set Area_Cell_Num(value:uint):void
		{
			if(_Area_Cell_Num%4!==0){
				throw new Error("请输入4倍数。确保可以用来计算Lod")
			}
			
			_Area_Cell_Num = value;
			changeCellData()
		}
		public function get Area_Size():int
		{
			return _Area_Size;
		}
		public function set Area_Size(value:int):void
		{
			_Area_Size = value;
			changeCellData()
		}

		public static function getInstance():GroundMath
		{
			
			if(!instance){
				instance=new GroundMath()
			}
			return instance;
		}
		
		public function getTerrainData($bitmapdata:BitmapData,$basePos:Vector3D,$area_Size:Number=400,$area_Cell_Num:int=40,terrainData:TerrainData=null):TerrainData{
			_Area_Size = $area_Size;
			Area_Cell_Num = $area_Cell_Num;
			if(!Boolean(terrainData)){
				terrainData=new TerrainData
			}
			getVerticesItem(terrainData,$bitmapdata);
			makeUvBuffer(terrainData);
			makeLodLevelArr(terrainData,$basePos);
			return terrainData;
		}
		
		public function getTerrainDataList($bitmapdata:BitmapData,$xNum:int,$zNum:int,$area_Size:Number=400,$area_Cell_Num:int=40):Vector.<TerrainData>{
			
			_Area_Size = $area_Size;
			Area_Cell_Num = $area_Cell_Num;
			
			var ary:Vector.<TerrainData> = new Vector.<TerrainData>;
			var nrmBmp:BitmapData=groundNormalUtils.getHightMapToNrm($bitmapdata)
			for(var i:int=0;i<$xNum;i++){
				for(var j:int=0;j<$zNum;j++){
					var terrainData:TerrainData = new TerrainData;
					terrainData.cellX=i
					terrainData.cellZ=j
					terrainData.area_Size=$area_Size
					terrainData.area_Cell_Num=$area_Cell_Num
					var $bmp:BitmapData= new BitmapData(Area_Cell_Num+1,Area_Cell_Num+1,false,0xff)
					$bmp.copyPixels($bitmapdata,new Rectangle(i*Area_Cell_Num,j*Area_Cell_Num,$bmp.width,$bmp.height),new Point)
						
					getVerticesItem(terrainData,$bmp);
					makeUvBuffer(terrainData);
					
					terrainData.normalMap=new BitmapData(Area_Cell_Num+1,Area_Cell_Num+1,false,0xff0000)
					terrainData.normalMap.copyPixels(nrmBmp,new Rectangle(i*Area_Cell_Num,j*Area_Cell_Num,nrmBmp.width,nrmBmp.height),new Point)

					terrainData.positon=new Vector3D(i*_Area_Size-(_Area_Size*$xNum)/2,0,j*_Area_Size-(_Area_Size*$zNum)/2)
					makeLodLevelArr(terrainData,terrainData.positon);
					ary.push(terrainData);
				}
			}
			
			return ary;
		}

		public function getTerrainIndex($tdata:TerrainData,$eyePos:Vector3D,$maxLod:int=2):void{
			mathIndexNode($tdata,$maxLod,$eyePos);
		}
		
		private function makeUvBuffer(objData:TerrainData,density:int= 1):void
		{
			//注因为地形的UV，有别于模型，他的原本UV是用顶点坐标来表示
			objData.uvs=new Vector.<Number>;
			for(var i:int=0;i<objData.vertices.length/3;i++)
			{
				objData.uvs.push(objData.vertices[i*3+0]/_Area_Size * density,objData.vertices[i*3+2]/_Area_Size * density);
			}
		}
		private function makeLodLevelArr($objData:TerrainData,$basePos:Vector3D):void
		{
			//$objData.lodLevelArr=[];
			//$objData.posArr=[];
			$objData.nodeList = new Vector.<Vector.<GroundNode>>;
			
			for(var u:int=0;u<(_Area_Cell_Num/4)*(_Area_Cell_Num/4);u++)
			{
				var $obj:Object=isRoundHight(u,$objData)	//return {level:e,pos:$oV}
				//$objData.lodLevelArr.push($obj.level);
				//$objData.posArr.push($basePos.add($obj.pos));
				
				var node:GroundNode = new GroundNode(u,$obj.level,$basePos.add($obj.pos),CellNum10,AreaBitmapSize);
				var i:int = u/CellNum10;
				var j:int = u%CellNum10;
				if(j == 0){
					$objData.nodeList.push(new Vector.<GroundNode>);
				}
				$objData.nodeList[i][j] = node;
			}
			buildNode($objData.nodeList);
			
		}
		
		private function buildNode(list:Vector.<Vector.<GroundNode>>):void{
			for(var i:int;i<list.length;i++){
				for(var j:int=0;j<list[i].length;j++){
					if(i != 0){
						list[i][j].topNode = list[i-1][j];
					}
					if(i != list.length-1){
						list[i][j].bottomNode = list[i+1][j];
					}
					
					if(j != 0){
						list[i][j].leftNode = list[i][j-1];
					}
					
					if(j != list[i].length - 1){
						list[i][j].rightNode = list[i][j+1]
					}
				}
			}
		}
		
		/**
		 * 根据图片生成默认顶点信息 
		 * @param objData
		 * @param hightInfoBitmapData
		 * 
		 */		
		private  function getVerticesItem(objData:TerrainData, hightInfoBitmapData:BitmapData):void
		{
			objData.vertices = new Vector.<Number>();
			objData.normals = new Vector.<Number>();
			//生存原始基础的坐标顶点信息， 这将会是将所有可用的顶点都存在顶点着色器里，100*100，将会是1W个顶点数据，可能以后可优化，但这过程将消耗不少CPU
			var w:Number = (_Area_Size/_Area_Cell_Num);
			var i:int = 0;
			var j:int = 0;
			var norm3D:Vector3D;
			for( i=0; i<AreaBitmapSize; i++)
			{
				for( j=0; j<AreaBitmapSize; j++)
				{
					var hx:Number = i*w;
					var hy:Number = 0;
					var hz:Number = j*w;
					var ky:Number=getBitmapDataHight(hightInfoBitmapData,i, j);
					objData.vertices.push(hx, ky, hz);
					objData.normals.push(0,0,0);
				
				}
			}
			
			
		}
		public function getBitmapDataHight(_bmp:BitmapData,i:Number,j:Number):Number
		{
			var p:Vector3D=hexToArgb(_bmp.getPixel32(i, j))
			var cc:Number=(p.x+p.y*250)-Num1000;
			return cc*_H_NUM;
		}
		

		public function setBitmapDataHight(_bmp:BitmapData,i:Number,j:Number,heigh:Number):void
		{
			
			heigh=int(heigh/_H_NUM)+Num1000;
			_bmp.setPixel(i,j,argbToHex16(uint(heigh%250),uint(heigh/250),0))
		}
		public var Num1000:Number=10000;   //存放离度0以下
	
		/**
		 *地面相对的地面坐标
		 */

		private static var instance:GroundMath;
			
		/**
		 * 
		 * @param $objData
		 * @param $maxLod
		 * @param eyePos
		 * @param $compelLod  强制级别， 如果为3就认为是没有强制作
		 * 
		 */
		public function mathIndexNode($objData:TerrainData, $maxLod:int,eyePos:Vector3D,$compelLod:uint=3):void{
			

			$objData.indexs=new Vector.<uint>;
			
			var nodelist:Vector.<Vector.<GroundNode>> = $objData.nodeList;
			//var eyePos:Vector3D = new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);
			for(var i:int=0;i<nodelist.length;i++){
				for(var j:int=0;j<nodelist[i].length;j++){
					if($compelLod>=3){
						nodelist[i][j].setLod(eyePos,$maxLod);
					}else{
						nodelist[i][j].lod=$compelLod
					}
					if(i==0||j==0||i==nodelist.length-1||j==nodelist[i].length-1){
						nodelist[i][j].lod=Math.min(2,nodelist[i][j].lod+1)//特殊将边缘的密度加一个组别，
					}
					
				}
			}
			
			for(i=0;i<nodelist.length;i++){
				for(j=0;j<nodelist[i].length;j++){
					nodelist[i][j].pushIndex($objData.indexs);
				}
			}
			
		}
		
		/**
		 * 
		 * @param idNum 编号
		 * @param $objData
		 * @return  返回中心坐标和lod基数， 
		 * 
		 */
		private  function isRoundHight(idNum:int, $objData:TerrainData):Object
		{
		
			var i:int = int(idNum/CellNum10)*4;
			var j:int = int(idNum%CellNum10)*4;
			
			var $num:uint=i*AreaBitmapSize+j
			var $pos:Vector3D=new Vector3D($objData.vertices[$num*3+0],$objData.vertices[$num*3+1],$objData.vertices[$num*3+2])
			
			var $pointItem:Vector.<Vector3D>=new Vector.<Vector3D>;
			
			var $index:uint;
			for(var h:int;h<5;h++){
				$index=$num +h*AreaBitmapSize;
				for(var s:int=0;s<5;s++){
					$pointItem.push(new Vector3D($objData.vertices[$index*3+0],$objData.vertices[$index*3+1],$objData.vertices[$index*3+2]));
					$index++;
				}
			}
			
			var a:Vector3D=$pointItem[0];
			var b:Vector3D=$pointItem[4];
			var c:Vector3D=$pointItem[$pointItem.length-5];
			var d:Vector3D=$pointItem[$pointItem.length-1];
			
			
			var $rotationZ:Number=(Math.atan2(c.y-a.y,c.x-a.x)+Math.atan2(d.y-b.y,d.x-b.x))/2*180/Math.PI
			var $rotationX:Number=(Math.atan2(b.y-a.y,b.z-a.z)+Math.atan2(d.y-c.y,d.z-c.z))/2*180/Math.PI
			
			var $m:Matrix3D=new Matrix3D();
			$m.appendRotation(-$rotationZ,Vector3D.Z_AXIS)
			$m.appendRotation($rotationX,Vector3D.X_AXIS)
				

			var $min:Number;
			var $max:Number;
			for(var k:uint=0;k<$pointItem.length;k++)
			{
				var $tempc:Vector3D=$m.transformVector($pointItem[k])
				if(k==0){
					$min=$tempc.y
					$max=$tempc.y
				}else{
					$min=Math.min($min,$tempc.y)
					$max=Math.max($max,$tempc.y)
				}
			}

			return {level:$max-$min,pos:$pointItem[12]}
		}
	
		
		/**
		 *从位图中获取高度 
		 * @param $xpos
		 * @param $ypos
		 * @param $bitmapdata
		 * @return 
		 * 
		 */
		public function getBaseHeightByBitmapdata($xpos:Number,$ypos:Number,$bitmapdata:BitmapData):Number{
			var perX:Number = $xpos - int($xpos);
			var perY:Number = $ypos - int($ypos);
			
			var zero_zero:Number=  getBitmapDataHight($bitmapdata,int($xpos),int($ypos))
			var zero_one:Number =  getBitmapDataHight($bitmapdata,int($xpos),Math.ceil($ypos))
			var one_zero:Number =  getBitmapDataHight($bitmapdata,Math.ceil($xpos),int($ypos))
			var one_one:Number =  getBitmapDataHight($bitmapdata,Math.ceil($xpos),Math.ceil($ypos))
			
			var dis1:Number = (1-perX) * (1-perY);
			var dis2:Number = (1-perX) * perY;
			var dis3:Number = perX * (1-perY);
			var dis4:Number = perX * perY;
			
			var num:Number = (dis1 * zero_zero + dis2 * zero_one + dis3 * one_zero + dis4 * one_one) ;
			
			return num;
		}
		
		private function hexToArgb(expColor:uint,is32:Boolean=true,color:Vector3D = null):Vector3D
		{
			if(!color)
			{
				color = new Vector3D();
			}
			color.w =is32? (expColor>>24) & 0xFF:0;
			color.x= (expColor>>16) & 0xFF;
			color.y = (expColor>>8) & 0xFF;
			color.z = (expColor) & 0xFF;
			return color;
		}
		
		private function argbToHex16( r:uint, g:uint, b:uint):uint
		{
			// 转换颜色
			var color:uint= r << 16 | g << 8 | b;
			return color;
		}

	}
}
package  PanV2.loadV2
{
	import flash.display3D.Context3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import collision.CollisionType;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class ObjsLoad
	{
		public function ObjsLoad()
		{
		}
		public static function getInstance():ObjsLoad{
			if(!_instance){
				_instance = new ObjsLoad();
			}
			return _instance;
		}
		private var _infoDic:Dictionary=new Dictionary;
		private var _funDic:Dictionary=new Dictionary;
		private static var _instance:ObjsLoad;
		
		public function addSingleLoad($url:String,$fun:Function):void{
			
			
			if(_infoDic[$url]){
				if(_infoDic[$url].isFinish){
					$fun(_infoDic[$url].data)
				}else{
					addPushFun($url,$fun)
				}
				
			}else{
				addPushFun($url,$fun)
				tempLoad($url);
				
				
			}
		}
		private function addPushFun($url:String,$fun:Function):void
		{
			if(!Boolean(_funDic[$url])){
				_funDic[$url]=new Array
			}
			_funDic[$url].push($fun)
		}
		private function tempLoad($url:String):void
		{
			if($url.search(".objs")==-1){
				return ;
			}
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.BYTE, onObjByteLoad,10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			_infoDic[$url]={isFinish:false}
			function onObjByteLoad(byte:ByteArray):void{

				var obj:Object = byte.readObject();

				_infoDic[$url].isFinish=true
				_infoDic[$url].data=uplodToGpu(obj)
				
				backFun($url);
			}
			
		}
		public  static function getCollisionItem($dataitem:Array):Array{
			
			var $arr:Array=new Array;
			if($dataitem){
				for(var i:uint=0;i<$dataitem.length;i++)
				{
					var $obj:Object=$dataitem[i];
					var $collisionVo:CollisionVo=new CollisionVo;
					$collisionVo.type=$obj.type
					$collisionVo.x=$obj.x
					$collisionVo.y=$obj.y
					$collisionVo.z=$obj.z
					
					$collisionVo.rotationX=$obj.rotationX
					$collisionVo.rotationY=$obj.rotationY
					$collisionVo.rotationZ=$obj.rotationZ

					$collisionVo.name=$obj.name;
					$collisionVo.colorInt=$obj.colorInt;

					if($obj.scale_x<=0){
						$obj.scale_x=1
							continue;
					}
					if($obj.scale_y<=0){
						$obj.scale_y=1
						continue;
					}
					if($obj.scale_z<=0){
						$obj.scale_z=1
						continue;
					}
					
					switch($collisionVo.type)
					{
						case CollisionType.BALL:
						{
							$collisionVo.radius=$obj.radius;
							break;
						}
						case CollisionType.Cylinder:
						{
							$collisionVo.scale_x=$obj.scale_x
							$collisionVo.scale_y=$obj.scale_y
							$collisionVo.scale_z=$obj.scale_z
							break;
						}
						case CollisionType.BOX:
						{
							$collisionVo.scale_x=$obj.scale_x
							$collisionVo.scale_y=$obj.scale_y
							$collisionVo.scale_z=$obj.scale_z
							break;
						}
						case CollisionType.Cone:
						{
							$collisionVo.scale_x=$obj.scale_x
							$collisionVo.scale_y=$obj.scale_y
							$collisionVo.scale_z=$obj.scale_z
							break;
						}
						case CollisionType.Polygon:
						{
							$collisionVo.scale_x=$obj.scale_x
							$collisionVo.scale_y=$obj.scale_y
							$collisionVo.scale_z=$obj.scale_z
							$collisionVo.polygonUrl=$obj.polygonUrl;
							$collisionVo.data=$obj.data;
							break;
						}
						default:
						{
							break;
						}
					}
					
					$arr.push($collisionVo);
					
				}
				
			}
			
			
			return $arr;
			
		
		}
		//强制将lightUV限制在256中，
		private function getLightUvsByte($arr:Vector.<Number>):Vector.<Number>
		{
		
			var lightArr:Vector.<Number>=new Vector.<Number>
			for(var i:Number=0;i<$arr.length;i++)
			{
				lightArr.push(int($arr[i]*256)/256)
			}
			return lightArr
		}
		protected function uplodToGpu($obj:Object) : ObjData
		{
			var $objData:ObjData=new ObjData
			var $context3D:Context3D=Scene_data.context3D
//			$objData.normals=new Vector.<Number>
//			for(var i:uint=0;i<$obj.vertices.length/3;i++){
//				$objData.normals.push($obj.normals[i*3+0],-$obj.normals[i*3+2],$obj.normals[i*3+1])
//			}
			$objData.vertices=$obj.vertices
			$objData.normals=$obj.normals
			$objData.uvs=$obj.uvs
			$objData.lightUvs=this.getLightUvsByte($obj.lightUvs)
			$objData.indexs=$obj.indexs
			var collistionItem:Array=ObjsLoad.getCollisionItem($obj.item)
			if(collistionItem.length){
				$objData.collisionItem=new Vector.<CollisionVo>
				$objData.friction=Number($obj.friction)
				$objData.restitution=Number($obj.restitution)
				$objData.isField=Boolean($obj.isField)
				for(var k:uint=0;k<collistionItem.length;k++){
					$objData.collisionItem.push(collistionItem[k])
				}
			}
			//$objData.collisionItem=ObjsLoad.getCollisionItem($obj.item);
			$objData.vertexBuffer = $context3D.createVertexBuffer($objData.vertices.length / 3, 3);
			$objData.vertexBuffer.uploadFromVector(Vector.<Number>($objData.vertices), 0, $objData.vertices.length / 3);
			
			$objData.uvBuffer = $context3D.createVertexBuffer($objData.uvs.length / 2, 2);
			$objData.uvBuffer.uploadFromVector(Vector.<Number>($objData.uvs), 0, $objData.uvs.length / 2);
			if($objData.lightUvs){
				$objData.lightUvsBuffer = $context3D.createVertexBuffer($objData.lightUvs.length / 2, 2);
				$objData.lightUvsBuffer.uploadFromVector(Vector.<Number>($objData.lightUvs), 0, $objData.lightUvs.length / 2);
			}
			if($objData.normals){
				$objData.normalsBuffer = $context3D.createVertexBuffer($objData.normals.length / 3, 3);
				$objData.normalsBuffer.uploadFromVector(Vector.<Number>($objData.normals), 0, $objData.normals.length / 3);
			}
			$objData.indexBuffer = $context3D.createIndexBuffer($objData.indexs.length);
			$objData.indexBuffer.uploadFromVector(Vector.<uint>($objData.indexs), 0, $objData.indexs.length);
			
			
			
			return $objData
		}
		
		private function backFun($url:String):void
		{
			var $arr:Array=_funDic[$url]
			for(var i:uint=0;i<$arr.length;i++){
				var $fun:Function=$arr[i]
				$fun(_infoDic[$url].data)
			}
		}
		public function getObjsMaxAndMinByUrl($url:String,$bFun:Function):void
		{
			addSingleLoad($url,function ($objData:ObjData):void
			{
				var $MaxAndMinObj:Object=MathUint.mathObjDataRound($objData)
				$bFun($MaxAndMinObj)
			})
		}
	
	}
}



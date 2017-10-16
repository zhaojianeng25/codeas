package  
{

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.core.base.IMaterialOwner;
	import away3d.core.base.SubMesh;
	import away3d.core.math.Quaternion;
	import away3d.events.ParserEvent;
	import away3d.loaders.parsers.DAEParser;
	import away3d.materials.MaterialBase;

	public class DaeMeshModel
	{
		private var _dAEParser:DAEParser;
		private var _bFun:Function
		private static var instance:DaeMeshModel;
		public function DaeMeshModel()
		{
		}
		public static function getInstance():DaeMeshModel{
			if(!instance){
				instance = new DaeMeshModel();
			}
			return instance;
		}
		public function setData($str:String,$fun:Function):void
		{
			_bFun=$fun
			_dAEParser=new DAEParser()
				
			_dAEParser.parseAsync($str)
			_dAEParser.addEventListener(ParserEvent.PARSE_COMPLETE,onComeee)
				
		
		}
		
		protected function onComeee(event:ParserEvent):void
		{
			var $idNum:uint=0
			var $objsItem:Array=new Array
			for each(var bb:Object in _dAEParser.effects){
				var $MaterialBase:MaterialBase=(MaterialBase(bb.material))
				var $owners:Vector.<IMaterialOwner>=$MaterialBase._owners
				var $scaleNum40:Number=1/0.0254/50
					
				$scaleNum40=1
					
				if($owners.length){
					var arr: Vector.<Object>=new Vector.<Object>
					for(var k:uint=0;k<$owners.length;k++)
					{
						
						var tempData:Object=new Object
						tempData.vertices=new Vector.<Number>
						tempData.normals=new Vector.<Number>
						tempData.uvs=new Vector.<Number>
						tempData.lightUvs=new Vector.<Number>
						tempData.indexs=new Vector.<uint>
						
						var tempSub:SubMesh=SubMesh($owners[k])
						var $m:Matrix3D=tempSub.inverseSceneTransform.clone()
			
						
				
							
						$m.invert()
						var $mNrm:Matrix3D=$m.clone()
						var $nrmQ:Quaternion=new Quaternion()	
						$nrmQ.fromMatrix($mNrm)
						$nrmQ.toMatrix3D($mNrm)
						var $anglea:Vector3D= $nrmQ.toEulerAngles()
						$anglea.scaleBy(180/Math.PI)
						trace($anglea)
					
							
						$m.appendScale($scaleNum40,$scaleNum40,$scaleNum40)
						for(var i:uint=0;i<tempSub.vertexData.length/13;i++){
							var $p:Vector3D=new Vector3D(tempSub.vertexData[i*13+0],tempSub.vertexData[i*13+1],tempSub.vertexData[i*13+2])
							//$p.scaleBy($scaleNum40)
							$p=$m.transformVector($p)
							
						
							
							var $n:Vector3D=new Vector3D(tempSub.vertexData[i*13+3],tempSub.vertexData[i*13+4],tempSub.vertexData[i*13+5])
							$n=$mNrm.transformVector($n)


							tempData.vertices.push($p.x,$p.y,$p.z);
							tempData.normals.push($n.x,$n.y,$n.z);  //编辑器导入时法线不是正确的，
						//	tempData.normals.push($n.x,$n.z,$n.y*-1);  //编辑器导入时法线不是正
				
							
							//tempData.normals.push(tempSub.vertexData[i*13+3],tempSub.vertexData[i*13+4],tempSub.vertexData[i*13+5])
							tempData.uvs.push(tempSub.vertexData[i*13+9],tempSub.vertexData[i*13+10])
							tempData.lightUvs.push(tempSub.vertexData[i*13+11],tempSub.vertexData[i*13+12])
						}
						tempData.indexs=tempSub.indexData
						arr.push(tempData)
						
					}
					$objsItem.push(endWirteFun(arr,$idNum++))
				}
				
			}
			_bFun($objsItem)
			
		}
		private function endWirteFun($arr:Vector.<Object>,$id:uint=0):Object
		{
			var wirteObjData:Object=new Object
			wirteObjData.vertices=new Vector.<Number>
			wirteObjData.normals=new Vector.<Number>
			wirteObjData.uvs=new Vector.<Number>
			wirteObjData.lightUvs=new Vector.<Number>
			wirteObjData.indexs=new Vector.<uint>
			var indexNum:uint=0
			for(var i:uint=0;i<$arr.length;i++){
				var $tempData:Object=$arr[i];
				wirteObjData.vertices=wirteObjData.vertices.concat($tempData.vertices)
				wirteObjData.normals=wirteObjData.normals.concat($tempData.normals)
				wirteObjData.uvs=wirteObjData.uvs.concat($tempData.uvs)
				wirteObjData.lightUvs=wirteObjData.lightUvs.concat($tempData.lightUvs)
				
				for(var j:uint=0;j<$tempData.indexs.length;j++)
				{
					wirteObjData.indexs.push($tempData.indexs[j]+indexNum)
				}
				indexNum+=$tempData.vertices.length/3
			}

			return wirteObjData
			
		}
		
		
	}
}
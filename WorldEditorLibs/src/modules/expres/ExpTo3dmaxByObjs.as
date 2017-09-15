package modules.expres
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	
	import terrain.GroundMath;
	import terrain.TerrainData;
	

	public class ExpTo3dmaxByObjs
	{


		public static function getInstance():ExpTo3dmaxByObjs{
			if(!instance){
				instance = new ExpTo3dmaxByObjs();
			}
			return instance;
		}
		
		public function expByUrl($fileurl:String):void
		{

			 ObjsLoad.getInstance().addSingleLoad($fileurl,objsFun)

		}
		protected function objsFun($objData:ObjData):void
		{
			var file:File=new File;
			file.browseForSave("保存文件");
			file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				
				var saveFiledic:File = e.target as File;
				if(!(saveFiledic.extension=="obj")){
					saveFiledic=new File(saveFiledic.nativePath+".obj");
				}
				
				_data = [];
				makeObjData($objData);
				writeGroundObj(saveFiledic)
				
				Alert.show(saveFiledic.name+"保存完成")
				
			}
	
		}

		private  var OBJ_TITLE:String = "# object $0\r\n";
		private  var OBJ_VERTEX:String = "v  $0.0000 $1.0000 $2.0000\r\n";
		private  var OBJ_VERTEX_END:String = "# $0 vertices\r\n";
		private  var OBJ_NORMAL:String = "vn $0.0000 $1.0000 $2.0000\r\n";
		private  var OBJ_NORMAL_END:String = "# $0 vertex normals\r\n";
		private  var OBJ_UV:String = "vt $0 $1 0.0000\r\n";
		private  var OBJ_UV_END:String = "# $0 texture coords\r\n";
		private  var OBJ_INDEX_TITLE:String = "g $0\ns1 \r\n";
		private  var OBJ_INDEX:String = "f $0/$0/$0 $1/$1/$1 $2/$2/$2\r\n";
		private  var OBJ_INDEX_END:String = "# $0 faces\r\n";
		
		
		private  var _data:Array;

		private static var instance:ExpTo3dmaxByObjs;
		


		private  function makeObjData($objData:ObjData):void
		{
			var objName:String = "aaa";
			_data.push(setInfo(OBJ_TITLE, [objName]));
			makeVertexData($objData.vertices);
			makeNormalData($objData.normals)
			makeUVData($objData.uvs);
			makeIndexData($objData.indexs, objName);
			
			

		}

		private  function makeVertexData(vertices:Vector.<Number>):void
		{
			var len:int = vertices.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_VERTEX, [vertices[i+0] , vertices[i + 1], vertices[i + 2]]));
			}
			_data.push(setInfo(OBJ_VERTEX_END, [(len / 3)]));
		}
		
		
		private  function makeNormalData(normals:Vector.<Number>):void
		{
			var len:int = normals.length;
			for(var i:int = 0; i < len; i+=3)
			{
				var  $nrm:Vector3D=new Vector3D(normals[i+0], normals[i + 1], normals[i + 2])
				_data.push(setInfo(OBJ_NORMAL, [$nrm.x,$nrm.y,$nrm.z]));
			}
			_data.push(setInfo(OBJ_NORMAL_END, [(len / 3)]));
		}
		
		private  function makeUVData(uvs:Vector.<Number>):void
		{
			var len:int = uvs.length;
			for(var i:int = 0; i < len; i+=2)
			{
				_data.push(setInfo(OBJ_UV, [uvs[i+0], 1-uvs[i + 1]]));
			}
			_data.push(setInfo(OBJ_UV_END, [len / 2]));
		}
		
		private  function makeIndexData(indexs:Vector.<uint>, objName:String):void
		{
			_data.push(setInfo(OBJ_INDEX_TITLE, [objName]));
			var len:int = indexs.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_INDEX, [indexs[i+0]+1, indexs[i+1]+1 , indexs[i+2]+1 ]));
			}
			_data.push(setInfo(OBJ_INDEX_END, [len/3]));
		}
		
		public  function writeGroundObj($file:File):void
		{
			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);
			var len:int = _data.length;
			for(var i:int = 0; i < len; i++)
			{
				fs.writeMultiByte(_data[i],"utf-8");
			}
			fs.close();
		}
		
		private  function setInfo(template:String, data:Array):String
		{
			var len:int = data.length;
			var ret:String = template;
			for(var i:int = 0; i < len; i++)
			{
				ret = ret.split("$" + i).join(data[i]);
				
			}
			return ret;
		}

	}
}
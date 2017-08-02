package  modules.terrain
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	
	import terrain.GroundMath;
	import terrain.TerrainData;
	


	public class TerrainDataSaveToObj
	{
		private static const OBJ_TITLE:String = "# object $0\r\n";
		private static const OBJ_VERTEX:String = "v  $0.0000 $1.0000 $2.0000\r\n";
		private static const OBJ_VERTEX_END:String = "# $0 vertices\r\n";
		private static const OBJ_NORMAL:String = "vn $0.0000 $1.0000 $0.0000\r\n";
		private static const OBJ_NORMAL_END:String = "# $0 vertex normals\r\n";
		private static const OBJ_UV:String = "vt $0 $1 0.0000\r\n";
		private static const OBJ_UV_END:String = "# $0 texture coords\r\n";
		private static const OBJ_INDEX_TITLE:String = "g $0\ns1 \r\n";
		private static const OBJ_INDEX:String = "f $0/$0/$0 $1/$1/$1 $2/$2/$2\r\n";
		private static const OBJ_INDEX_END:String = "# $0 faces\r\n";
		
		
		private static var _data:Array;
		private static var _pos:int;
		
		public function TerrainDataSaveToObj()
		{
		}
		
		public static function clearGroundObj():void
		{
			if(_data == null)
			{
				_data = [];
			}
			else
			{
				_data.length = 0;
			}
			_pos = 1;
		}
		
        private var vertexLen:uint=0
        private var uvLen:uint=0
        private var indexLen:uint=0
		public static function terrainToObj(terrainDataArr:Vector.<TerrainData>):void
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
				
				clearGroundObj();
				for each(var $terrainData:TerrainData in terrainDataArr){
					
					GroundMath.getInstance().mathIndexNode($terrainData,2,new Vector3D,2);
					mathNrmForBmp($terrainData)
					var mx:Number=$terrainData.cellX*GroundMath.getInstance().Area_Size
					var my:Number= $terrainData.cellZ*GroundMath.getInstance().Area_Size
					makeObjData($terrainData,my,mx);
				}
				writeGroundObj(saveFiledic)
				Alert.show("导出地形obj完成");
			}
			
			
		}
		
		public static function getTerrainToByteObj($terrainData:TerrainData):Object{
			GroundMath.getInstance().mathIndexNode($terrainData,2,new Vector3D,2);
			mathNrmForBmp($terrainData);
			var obj:Object = new Object;
			obj.vertices = $terrainData.vertices;
			obj.normals = $terrainData.normals;
			obj.uvs = $terrainData.uvs;
			obj.indexs = $terrainData.indexs;
			return obj;
		}
		
		
		private static function mathNrmForBmp($terrainData:TerrainData):void
		{
			for(var i:uint=0;i<$terrainData.vertices.length/3;i++){
				var p:Vector3D=new Vector3D($terrainData.vertices[i*3+0],0,$terrainData.vertices[i*3+2]);
				p.scaleBy(1/$terrainData.area_Size*$terrainData.area_Cell_Num)
				var c:Vector3D=MathCore.hexToArgbNum($terrainData.normalMap.getPixel(p.x,p.z))
				c=c.subtract(new Vector3D(0.5,0.5,0.5))	
				c.normalize()
				$terrainData.normals[i*3+0]=c.x
				$terrainData.normals[i*3+1]=c.y
				$terrainData.normals[i*3+2]=c.z
			}
		}
		private static function writeObjData(objData:ObjData, i:int, j:int, sceneID:String):void
		{
			var obj:Object=new Object;
			obj.vertices=objData.vertices;
			obj.uvs=objData.uvs;
			obj.indexs=objData.indexs;
			var _url:String=File.desktopDirectory.nativePath + "/" + sceneID + "/output/_high" + j +"_" + i + ".obj";
			var file:File = new File(_url);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
		}
		
		private static function makeObjData(objData:TerrainData, mx:int, my:int):void
		{
			var objName:String = mx + "_" + my;
			_data.push(setInfo(OBJ_TITLE, [objName]));
			makeVertexData(objData.vertices, mx, my);
			makeNormalData(objData.normals)
			makeUVData(objData.uvs);
			makeIndexData(objData.indexs, objName);
			_pos += objData.uvs.length/2;
		}
		private static var vScale:Number=1
		private static function makeVertexData(vertices:Vector.<Number>, mx:int, my:int):void
		{
			var len:int = vertices.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_VERTEX, [(vertices[i+2] + mx)*vScale, vertices[i + 1]*vScale, (vertices[i + 0] + my)*vScale]));
			}
			_data.push(setInfo(OBJ_VERTEX_END, [(len / 3)]));
		}
		

		private static function makeNormalData(normals:Vector.<Number>):void
		{
			var len:int = normals.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_NORMAL, [normals[i+2], normals[i + 1], normals[i + 0] ]));
			}
			_data.push(setInfo(OBJ_NORMAL_END, [(len / 3)]));
		}
		
		private static function makeUVData(uvs:Vector.<Number>):void
		{
			var len:int = uvs.length;
			for(var i:int = 0; i < len; i+=2)
			{
				_data.push(setInfo(OBJ_UV, [uvs[i+0], 1-uvs[i + 1]]));
			}
			_data.push(setInfo(OBJ_UV_END, [len / 2]));
		}
		
		private static function makeIndexData(indexs:Vector.<uint>, objName:String):void
		{
			_data.push(setInfo(OBJ_INDEX_TITLE, [objName]));
			var len:int = indexs.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_INDEX, [indexs[i] + _pos, indexs[i+1] + _pos, indexs[i+2] + _pos]));
			}
			_data.push(setInfo(OBJ_INDEX_END, [len/3]));
		}
		
		public static function writeGroundObj($file:File):void
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
		
		private static function setInfo(template:String, data:Array):String
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
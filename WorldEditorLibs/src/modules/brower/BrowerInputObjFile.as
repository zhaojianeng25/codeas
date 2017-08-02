package modules.brower
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import PanV2.loadV2.ObjToObjs;
	
	import _Pan3D.base.ObjData;
	

	public class BrowerInputObjFile
	{
		private static var instance:BrowerInputObjFile;
		public function BrowerInputObjFile()
		{
		}
		public static function getInstance():BrowerInputObjFile{
			if(!instance){
				instance = new BrowerInputObjFile();
			}
			return instance;
		}
		private var _bFun:Function
		private static var _toUrl:String;
		private static var _fileName:String
		public function inputFileUrl($url:String,$toUrl:String,$fileName:String,$bfun:Function=null):void
		{
			_fileName=$fileName
			_toUrl=$toUrl
			_bFun=$bfun
			var $objToObjs:ObjToObjs=new ObjToObjs
			$objToObjs.loadObjUrl($url,loadOBJFun)
				
		}
		private function loadOBJFun($arr:Array):void
		{
			var arr:Array=new Array
			for(var i:uint=0;i<$arr.length;i++)
			{
				var obj:Object=$arr[i];
				var $objData:ObjData=new ObjData
				$objData.vertices=obj.vertices
				$objData.uvs=obj.uvs
				$objData.normals=obj.normals
				$objData.indexs=obj.indexs
				var $fileName:String=_fileName+"_"+i+".obj"
				makeObjData($objData,$fileName)
				arr.push($fileName)
			}
			
			if(Boolean(_bFun)){
				_bFun(arr)
			}

		}
		private static const OBJ_TITLE:String = "# object $0\r\n";
		private static const OBJ_VERTEX:String = "v  $0 $1 $2\r\n";
		private static const OBJ_VERTEX_END:String = "# $0 vertices\r\n";
		private static const OBJ_NORMAL:String = "vn $0.0000 $1.0000 $0.0000\r\n";
		private static const OBJ_NORMAL_END:String = "# $0 vertex normals\r\n";
		private static const OBJ_UV:String = "vt $0 $1 0.0000\r\n";
		private static const OBJ_UV_END:String = "# $0 texture coords\r\n";
		private static const OBJ_INDEX_TITLE:String = "g $0 \r\ns 1 \r\n";
		private static const OBJ_INDEX:String = "f $0/$0/$0 $1/$1/$1 $2/$2/$2\r\n";
		private static const OBJ_INDEX_END:String = "# $0 faces\r\n";
		private static var _data:Array;
		private static var _pos:int;

			
		private static function makeObjData(objData:ObjData,$name:String):void
		{

			_data = [];
			_pos=1
			_data.push(setInfo(OBJ_TITLE, [$name]));
			makeVertexData(objData.vertices);
			makeNormalData(objData.normals)
			makeUVData(objData.uvs);
			makeIndexData(objData.indexs, $name);

			writeToObjFile(new File(_toUrl+"/"+$name),_data)

		}
		public static function writeToObjFile($file:File,$data:Array):void
		{
			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);
			var len:int = $data.length;
			for(var i:int = 0; i < len; i++)
			{
				fs.writeMultiByte($data[i],"utf-8");
			}
			fs.close();
		}
		
		private static function makeVertexData(vertices:Vector.<Number>):void
		{
			var len:int = vertices.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_VERTEX, [(vertices[i+0] ), vertices[i + 1], (vertices[i +2] )]));
			}
			_data.push(setInfo(OBJ_VERTEX_END, [(len / 3)]));
		}
		
		
		private static function makeNormalData(normals:Vector.<Number>):void
		{
			var len:int = normals.length;
			for(var i:int = 0; i < len; i+=3)
			{
				_data.push(setInfo(OBJ_NORMAL, [normals[i+0], normals[i + 1], normals[i + 2]]));
			}
			_data.push(setInfo(OBJ_NORMAL_END, [(len / 3)]));
		}
		
		private static function makeUVData(uvs:Vector.<Number>):void
		{
			var len:int = uvs.length;
			for(var i:int = 0; i < len; i+=2)
			{
				_data.push(setInfo(OBJ_UV, [uvs[i+0], uvs[i + 1]]));
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
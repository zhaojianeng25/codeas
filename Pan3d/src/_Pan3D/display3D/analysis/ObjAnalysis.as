package _Pan3D.display3D.analysis {
	import _Pan3D.base.ObjData;
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class ObjAnalysis
	{

		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX_DATA:String = "f";
		private const USEMTL:String = "usemtl";

		private var _faceIndex:uint;
		private var _vertices:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		protected var _Indexs:Vector.<uint>;
		private var _mtl:String;
		//private var _cachedRawNormalsBuffer:Vector.<Number>;
		
		// the raw data that is used to create Molehill buffers
		protected var _rawPositionsBuffer:Vector.<Number>;
		protected var _rawUvBuffer:Vector.<Number>;
		protected var _rawIndexBuffer:Vector.<uint>;
		protected var _rawNormalsBuffer:Vector.<Number>;

		public function ObjAnalysis()
		{
			
		}
		public function analysis(definition:String):ObjData{
			_Indexs = new Vector.<uint>();
			_vertices = new Vector.<Number>();
			_normals = new Vector.<Number>();
			_uvs = new Vector.<Number>();
			
			_rawPositionsBuffer = new Vector.<Number>;
			_rawUvBuffer = new Vector.<Number>;
			_rawIndexBuffer = new Vector.<uint>;
			_rawNormalsBuffer = new Vector.<Number>;
			
			_faceIndex = 0;
			
			// Split data in to lines and parse all lines.
			var lines:Array = definition.split(LINE_FEED);
			var loop:uint = lines.length;
			for(var i:uint = 0; i < loop; ++i)
				parseLine(lines[i]);
			var objdata:ObjData = new ObjData();
			objdata.indexs = _rawIndexBuffer;
			objdata.vertices = _rawPositionsBuffer;
			objdata.uvs = _rawUvBuffer;
			/*objdata.indexs = _Indexs;
			objdata.vertices = _vertices;
			objdata.uvs = _uvs;*/
			
			objdata.normals = _rawNormalsBuffer;
			objdata.mtl = _mtl;
			return objdata;
		}
		private function parseLine(line:String):void
		{
			// Split line into words.
			var words:Array = line.split(SPACE);
			// Prepare the data of the line.
			if (words.length > 0)
				var data:Array = words.slice(1);
			else
				return;
			// Check first word and delegate remainder to proper parser.
			var firstWord:String = words[0];
			if (firstWord == VERTEX)
				parseVertex(data);
			else if (firstWord == NORMAL)
				parseNormal(data);
			else if (firstWord == UV)
				parseUV(data);
			else if (firstWord == INDEX_DATA)
				parseIndex(data);
			else if (firstWord == USEMTL)
				parseUsemtl(data);
		}
		
		private function parseVertex(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' '))
				data = data.slice(1); // delete blanks
			//if (!_vertices.length) trace('parseVertex: ' + data);
//			if (_vertex_data_is_zxy)
//			{
//				_vertices.push(Number(data[1]));
//				_vertices.push(Number(data[2]));
//				_vertices.push(Number(data[0]));
//			}
//			else // normal operation: x,y,z
//			{
				var loop:uint = data.length;
				if (loop > 3) loop = 3;
				for (var i:uint = 0; i < loop; ++i)
				{
					var element:String = data[i];
					_vertices.push(Number(element));
				}
//			}
		}
		
		private function parseNormal(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' '))
				data = data.slice(1); // delete blanks
			//if (!_normals.length) trace('parseNormal:' + data);
			var loop:uint = data.length;
			if (loop > 3) loop = 3;
			for (var i:uint = 0; i < loop; ++i)
			{
				var element:String = data[i];
				if (element != null) // handle 3dsmax extra spaces
					_normals.push(Number(element));
			}
		}
		private function parseUV(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' '))
				data = data.slice(1); // delete blanks
			//if (!_uvs.length) trace('parseUV:' + data);
			/*var loop:uint = data.length;
			if (loop > 2) loop = 2;
			for (var i:uint = 0; i < loop; ++i)
			{
				var element:String = data[i];
				_uvs.push(1-Number(element));
			}*/
			
			var element:String = data[0];
			_uvs.push(Number(element));
			
			element = data[1];
			_uvs.push(1-Number(element));
		}
		
		private function parseIndex(data:Array):void
		{
			//if (!_Indexs.length) trace('parseIndex:' + data);
			var triplet:String;
			var subdata:Array;
			var vertexIndex:int;
			var uvIndex:int;
			var normalIndex:int;
			var index:uint;
			// Process elements.
			var i:uint;
			var loop:uint = data.length;
			var starthere:uint = 0;
			while ((data[starthere] == '') || (data[starthere] == ' ')) 
				starthere++; // ignore blanks
			
			loop = starthere + 3;

			/*for(i = starthere; i < loop; ++i)
			{
				triplet = data[i];
				subdata = triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				_Indexs.push(vertexIndex);
			}*/
			for(i = starthere; i < loop; ++i)
			{
				triplet = data[i];
				subdata = triplet.split(SLASH);
				vertexIndex = int(subdata[0]) - 1;
				uvIndex = int(subdata[1]) - 1;
				normalIndex = int(subdata[2]) - 1;
				// sanity check
				if(vertexIndex < 0) vertexIndex = 0;
				if(uvIndex < 0) uvIndex = 0;
				if(normalIndex < 0) normalIndex = 0;
				// Extract from parse raw data to mesh raw data.
				// Vertex (x,y,z)
				index = 3*vertexIndex;
				_rawPositionsBuffer.push(_vertices[index + 0],_vertices[index + 1],
					(xpos?1:-1)* _vertices[index + 2]);
				
				index = 3*normalIndex;
				_rawNormalsBuffer.push(_normals[index + 0],	_normals[index + 1],
					(xpos?1:-1)* _normals[index + 2]);
				// Texture coordinates (u,v)
				index = 2*uvIndex;
				_rawUvBuffer.push(_uvs[index+0], _uvs[index+1]);
			}
			// Create index buffer - one entry for each polygon
			_rawIndexBuffer.push(_faceIndex+0,_faceIndex+1,_faceIndex+2);
			_faceIndex += 3;
		}
		public static var xpos:Boolean=true;
		private function parseUsemtl(data:Array):void{
			
			_mtl = String(data[0]).split(".")[0];
			var index:int = _mtl.indexOf("\r");
			if(index>1){
			_mtl = _mtl.substr(0,index);
			}
		}

	}
}
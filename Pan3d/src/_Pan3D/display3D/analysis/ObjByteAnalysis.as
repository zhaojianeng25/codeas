package _Pan3D.display3D.analysis
{
	import _Pan3D.base.ObjData;
	
	import flash.utils.ByteArray;

	public class ObjByteAnalysis
	{
		public function ObjByteAnalysis()
		{
		}
		public function analysis(byte:ByteArray):ObjData{
			var _objData:ObjData = new ObjData;
			
			var length:int = byte.readInt();
			var ver:Vector.<Number> = new Vector.<Number>;
			for(var i:int;i<length;i++){
				ver.push(byte.readFloat());
			}
			_objData.vertices = ver;
			
			length = byte.readInt();
			var uvs:Vector.<Number> = new Vector.<Number>;
			for(i=0;i<length;i++){
				uvs.push(byte.readFloat());
			}
			_objData.uvs = uvs;
			
			length = byte.readInt();
			var indexs:Vector.<uint> = new Vector.<uint>;
			for(i=0;i<length;i++){
				indexs.push(byte.readInt());
			}
			_objData.indexs = indexs;
			
			return _objData;
		}
		
		
	}
}
package _Pan3D.display3D.ground
{
	import _Pan3D.base.ObjData;
	
	import terrain.TerrainData;
	
	public class GroundObjData extends ObjData
	{
//		public var lodLevelArr:Array;
//		public var posArr:Array;
//		public var nodeList:Vector.<Vector.<GroundNode>>;
		public function GroundObjData()
		{
			super();
		}
		
		public function getDataByTerrain(tdata:TerrainData):void{
			this.vertices = tdata.vertices;
			this.uvs = tdata.uvs;
			this.indexs = tdata.indexs;
		}
	}
}
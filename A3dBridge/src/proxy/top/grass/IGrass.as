package proxy.top.grass
{
	import flash.geom.Vector3D;
	
	import proxy.top.model.IModel;

	public interface IGrass extends IModel
	{

		function get lastQuadPos():Vector3D
		function listGrassQuad($pos:Vector3D):void;
		function setGrassInfoItem($arr:Array):void;
		function addGrassArr($arr:Array):void;

	}
}
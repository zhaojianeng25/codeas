package proxy.top.ground
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	
	import proxy.top.model.IModel;
	
	import terrain.TerrainData;

	public interface IGround extends IModel
	{
		function setNrmBitmapdata($bmp:BitmapData):void;
		function set idInfoBitmapData($bmp:BitmapData):void;
		function set grassInfoBitmapData($bmp:BitmapData):void;
		function set normalMap($bmp:BitmapData):void;
		function set sixteenUvTexture($texture:RectangleTexture):void;
		
		function get cellX():uint
		function get cellZ():uint
		
//		function set x(value:Number):void;
//		function get x():Number;
//		function set y(value:Number):void;
//		function get y():Number;
//		function set z(value:Number):void;
//		function get z():Number;
		
		
		
		
		function set lastLodPos(value:Vector3D):void;
		function get lastLodPos():Vector3D;
		
		function set terrainData($terrainData:TerrainData):void;
		function get terrainData():TerrainData;
		
		function set brushData(value:Vector3D):void
		function set lightMapTexture(value:Texture):void
		
		function scanQuickTexture():void
		function upLodAndToIndex():void
		function changeQuickTextureLod():void
		function showTriLine(value:Boolean):void
	}
}
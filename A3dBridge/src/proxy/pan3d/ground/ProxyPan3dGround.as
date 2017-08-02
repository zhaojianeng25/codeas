package proxy.pan3d.ground
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.ground.quick.QuickModelMath;
	
	import pack.Prefab;
	
	import proxy.top.ground.IGround;
	
	import terrain.TerrainData;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dGround implements IGround
	{
		
		public var ground:GroundEditorSprite;
		public function ProxyPan3dGround()
		{
		}
		public function setNrmBitmapdata($bmp:BitmapData):void
		{
			ground.terrainData.normalMap=$bmp
			ground.resetNrmText();
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function get cellX():uint
		{
			return ground.terrainData.cellX;
		}
		
		public function get cellZ():uint
		{
			return ground.terrainData.cellZ;
		}
		
		public function set grassInfoBitmapData($bmp:BitmapData):void
		{
			ground.grassInfoBitmapData=$bmp
		}
		public function set idInfoBitmapData($bmp:BitmapData):void
		{
			ground.idInfoBitmapData=$bmp
		}
		
		public function set sixteenUvTexture($texture:RectangleTexture):void
		{
			ground.sixteenUvTexture=$texture
			
		}
		
		
		public function scanQuickTexture():void
		{
			ground.scanQuickTexture()
			
		}
		
		public function upLodAndToIndex():void
		{
			ground.upLodAndToIndex()
			
		}
		
		public function set x(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get x():Number
		{
			// TODO Auto Generated method stub
			return ground.x;
		}
		
		public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get y():Number
		{
			// TODO Auto Generated method stub
			return ground.y;
		}
		
		public function set z(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set normalMap($bmp:BitmapData):void
		{
			ground.terrainData.normalMap=$bmp
			ground.resetNrmText()
			
		}
		
		public function set lastLodPos(value:Vector3D):void
		{
			ground.lastLodPos=value
			
		}
		
		public function set terrainData($terrainData:TerrainData):void
		{
			// TODO Auto Generated method stub
			
		}

		
		public function changeQuickTextureLod():void
		{
			
			QuickModelMath.getInstance().changeQuickTextureLod(ground)
			
		}
		
		
		public function get lastLodPos():Vector3D
		{
			// TODO Auto Generated method stub
			return ground.lastLodPos;
		}
		
		
		public function get z():Number
		{
			// TODO Auto Generated method stub
			return ground.z;
		}
		
		public function get terrainData():TerrainData
		{
			// TODO Auto Generated method stub
			return ground.terrainData;
		}
		
		public function set brushData(value:Vector3D):void
		{
			ground.brushSize=value.x
			ground.brushPow=value.y
			ground.brushBluer=value.z
				
			QuickModelMath.getInstance().brushSize=value.x
			QuickModelMath.getInstance().brushPow=value.y
			QuickModelMath.getInstance().brushBluer=value.z

				
		}
		
		public function showTriLine(value:Boolean):void
		{
			ground.showTriLine(value);
			
		}
		
		public function addStage():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function dele():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set prefab($prefab:Prefab):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get readObject():Object
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function removeStage():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function reset():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set rotationX(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationX():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set rotationY(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationY():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set rotationZ(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationZ():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleX():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set scaleY(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleY():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set scaleZ(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set select(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get select():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set uid(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get uid():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function set lightMapTexture(value:Texture):void
		{
			ground.lightMapTexture=value
			
		}
		
		public function set visible(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
	}
}
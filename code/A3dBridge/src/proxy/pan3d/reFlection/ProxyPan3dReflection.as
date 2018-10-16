package proxy.pan3d.reFlection
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.display3D.reflection.Display3DReflectionSprite;
	
	import _me.Scene_data;
	
	import light.ReflectionStaticMesh;
	import light.ReflectionTextureVo;
	
	import pack.Prefab;
	
	import proxy.top.model.IReflection;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dReflection  implements IReflection
	{
		public var sprite:Display3DReflectionSprite
		private var _reFlectionMesh:ReflectionStaticMesh
		public function ProxyPan3dReflection()
		{
		}
		
		public function get reFlectionMesh():ReflectionStaticMesh
		{
			return _reFlectionMesh;
		}

		public function set reFlectionMesh(value:ReflectionStaticMesh):void
		{
			

			
			_reFlectionMesh = value;
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
			sprite.scale_x=value
			
		}
		
		public function get scaleX():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_x;
		}
		
		public function set scaleY(value:Number):void
		{
			sprite.scale_y=value
			
		}
		
		public function get scaleY():Number
		{
			// TODO Auto Generated method stub
			return  sprite.scale_y;
		}
		
		public function set scaleZ(value:Number):void
		{
			sprite.scale_z=value
			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return  sprite.scale_z;
		}
		
		public function set select(value:Boolean):void
		{
			sprite.select=value
			
		}
		
		public function get select():Boolean
		{
			// TODO Auto Generated method stub
			return sprite.select;
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			// TODO Auto Generated method stub
			
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
		
		public function set visible(value:Boolean):void
		{
			sprite.visible=value
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return sprite.visible;
		}
		
		public function set x(value:Number):void
		{
			sprite.x=value
			
		}
		
		public function get x():Number
		{
			// TODO Auto Generated method stub
			return sprite.x;
		}
		
		public function set y(value:Number):void
		{
			sprite.y=value
			
		}
		
		public function get y():Number
		{
			// TODO Auto Generated method stub
			return sprite.y;
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value
			
		}
		
		public function get z():Number
		{
			// TODO Auto Generated method stub
			return sprite.z;
		}
		
		public function set reflectionTextureVo(value:ReflectionTextureVo):void
		{
			if(value.ZeTexture){
				value.ZeTexture.dispose()
			}
			if(value.texture){
				value.texture.dispose()
			}
			var $sizeNum:uint=_reFlectionMesh.reFlectionMapSize
			value.ZeTexture=Scene_data.context3D.createRectangleTexture($sizeNum,$sizeNum, Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			value.texture=Scene_data.context3D.createRectangleTexture($sizeNum,$sizeNum, Context3DTextureFormat.RGBA_HALF_FLOAT,true);

			sprite.reflectionTextureVo=value
			
		}
		
		
		public function get reflectionTextureVo():ReflectionTextureVo
		{
			// TODO Auto Generated method stub
			return sprite.reflectionTextureVo;
		}
		
	}
}
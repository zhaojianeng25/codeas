package proxy.pan3d.navMesh
{
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.navMesh.NavMeshDisplay3DSprite;
	
	import navMesh.NavMeshStaticMesh;
	
	import pack.Prefab;
	
	import proxy.top.model.INavMesh;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dNavMesh implements INavMesh
	{
		public var navMeshDisplay3DSprite:NavMeshDisplay3DSprite;
		private var sprite:Display3D
		private var _navMeshStaticMesh:NavMeshStaticMesh
		public function ProxyPan3dNavMesh()
		{
			sprite=new Display3D()
		}
		
		public function get navMeshStaticMesh():NavMeshStaticMesh
		{
			return _navMeshStaticMesh;
		}

		public function set navMeshStaticMesh(value:NavMeshStaticMesh):void
		{
			_navMeshStaticMesh = value;
	

			navMeshDisplay3DSprite.setNavMeshDataItem(_navMeshStaticMesh.listData)
			
			
			
		}


		public function set uid(value:String):void
		{
		}
		
		public function get uid():String
		{
			return null;
		}
		
		
		public function set rotationX(value:Number):void
		{
			
			sprite.rotationX=value
		}
		
		public function get rotationX():Number
		{
			return sprite.rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			sprite.rotationY=value
			
		}
		
		public function get rotationY():Number
		{
			// TODO Auto Generated method stub
			return sprite.rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			sprite.rotationZ=value
			
		}
		
		public function get rotationZ():Number
		{
			return sprite.rotationZ;
		}
		
		public function set x(value:Number):void
		{
			sprite.x=value
			
		}
		
		public function get x():Number
		{
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
			return sprite.scale_y
		}
		
		public function set scaleZ(value:Number):void
		{
			sprite.scale_z=value
			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_z;
		}
		

		public function get readObject():Object
		{
			return null;
		}
		
		public function dele():void
		{
		}
		
		public function set prefab($prefab:Prefab):void
		{
		}
		
		public function set select(value:Boolean):void
		{
		}
		
		public function get select():Boolean
		{
			return false;
		}
		
		public function set visible(value:Boolean):void
		{
			navMeshDisplay3DSprite.visible=value
		}
		
		public function get visible():Boolean
		{
			return navMeshDisplay3DSprite.visible;
		}
		
		public function addStage():void
		{
		}
		
		public function removeStage():void
		{
		}
		
		public function reset():void
		{
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
		}
	}
}
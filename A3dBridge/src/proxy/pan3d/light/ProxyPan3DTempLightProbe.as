package proxy.pan3d.light
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.lightProbe.Display3DLightProbeItemSprite;
	
	import light.LightProbeTempStaticMesh;
	
	import pack.Prefab;
	
	import proxy.top.model.ITempLightProbe;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3DTempLightProbe implements ITempLightProbe
	{
		
		public var sprite:Display3DLightProbeItemSprite
		private var _lightProbeTempStaticMesh:LightProbeTempStaticMesh
		private var _perentModel:ProxyPan3DLightProbe
		public var idPos:Vector3D
		
		
		public function ProxyPan3DTempLightProbe()
		{
		}

		public function get perentModel():ProxyPan3DLightProbe
		{
			return _perentModel;
		}

		public function set perentModel(value:ProxyPan3DLightProbe):void
		{
			_perentModel = value;
			resetPos()
		}
		public function resetPos(needResetLine:Boolean=true):void
		{
			if(_lightProbeTempStaticMesh&&_perentModel){
				sprite.x=_perentModel.x+_lightProbeTempStaticMesh.postion.x
				sprite.y=_perentModel.y+_lightProbeTempStaticMesh.postion.y
				sprite.z=_perentModel.z+_lightProbeTempStaticMesh.postion.z
				if(needResetLine){
					_perentModel.restLightProbeLine()	
				}
				
				if(_lightProbeTempStaticMesh.isUse||_perentModel.lightProbeMesh.seeAll){
					visible=true
				}else{
					visible=false
				}
			}
			
		
		}
		public function setSH(arr:Vector.<Vector3D>):void{
			
			sprite.setSH(arr)
			_lightProbeTempStaticMesh.resultSHVec=arr
			
		}

		public function get lightProbeTempStaticMesh():LightProbeTempStaticMesh
		{
			return _lightProbeTempStaticMesh;
		}

		public function set lightProbeTempStaticMesh(value:LightProbeTempStaticMesh):void
		{
			_lightProbeTempStaticMesh = value;
			_lightProbeTempStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
				
			sprite.setSH(_lightProbeTempStaticMesh.resultSHVec)
			
			resetPos()
		}
		
		protected function onMeshChange(event:Event):void
		{
			resetPos()
			
		}
		
		public function set uid(value:String):void
		{
		}
		
		public function get uid():String
		{
			return null;
		}
		
		public function set x(value:Number):void
		{
			
		
			_lightProbeTempStaticMesh.postion.x	=	value-_perentModel.x
			resetPos()
		}
		
		public function get x():Number
		{
			return sprite.x;
		}
		
		public function set y(value:Number):void
		{
	
			_lightProbeTempStaticMesh.postion.y	=	value-_perentModel.y
			resetPos()
		}
		
		public function get y():Number
		{
			return sprite.y;
		}
		
		public function set z(value:Number):void
		{
			//sprite.z=value
			_lightProbeTempStaticMesh.postion.z	=value-_perentModel.z
			resetPos()
		}
		
		public function get z():Number
		{
			return sprite.z;
		}
		
		public function set rotationX(value:Number):void
		{
		}
		
		public function get rotationX():Number
		{
			return 0;
		}
		
		public function set rotationY(value:Number):void
		{
		}
		
		public function get rotationY():Number
		{
			return 0;
		}
		
		public function set rotationZ(value:Number):void
		{
		}
		
		public function get rotationZ():Number
		{
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
		}
		
		public function get scaleX():Number
		{
			return 1;
		}
		
		public function set scaleY(value:Number):void
		{
		}
		
		public function get scaleY():Number
		{
			return 1;
		}
		
		public function set scaleZ(value:Number):void
		{
		}
		
		public function get scaleZ():Number
		{
			return 1;
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
			sprite.visible=value
		}
		
		public function get visible():Boolean
		{
			return sprite.visible;
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
package proxy.pan3d.light
{
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.lightProbe.Display3DLightProbeItemSprite;
	import _Pan3D.display3D.lightProbe.Display3DLightProbeSprite;
	
	import _me.Scene_data;
	
	import light.LightProbeStaticMesh;
	import light.LightProbeTempStaticMesh;
	
	import materials.Material;
	
	import pack.Prefab;
	
	import proxy.top.model.ILightProbe;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3DLightProbe implements ILightProbe
	{
		public var sprite:Display3DLightProbeSprite
		private var _lightProbeMesh:LightProbeStaticMesh

		public function ProxyPan3DLightProbe()
		{
			
		}
		
		public function get lightProbeTempItem():Vector.<ProxyPan3DTempLightProbe>
		{
			return _lightProbeTempItem;
		}

		public function set lightProbeTempItem(value:Vector.<ProxyPan3DTempLightProbe>):void
		{
			_lightProbeTempItem = value;
		}

		public function get lightProbeMesh():LightProbeStaticMesh
		{
			return _lightProbeMesh;
		}
        private var _ballItem:Vector.<Display3DLightProbeItemSprite>
		private var _lightProbeTempItem:Vector.<ProxyPan3DTempLightProbe>
		
		
		public function set lightProbeMesh(value:LightProbeStaticMesh):void
		{
			_lightProbeMesh = value;
			_ballItem=new Vector.<Display3DLightProbeItemSprite>
			_lightProbeTempItem=new Vector.<ProxyPan3DTempLightProbe>
			var $modelUrl:String=_lightProbeMesh.modelUrl
			var $material:Material=_lightProbeMesh.material
			var arr:Array=_lightProbeMesh.posItem
			
			for(var i:uint=0;i<arr.length;i++){
				for(var j:uint=0;j<arr[i].length;j++){
					for(var k:uint=0;k<arr[i][j].length;k++){
		
						var $proxyPan3DTempLightProbe:ProxyPan3DTempLightProbe=new ProxyPan3DTempLightProbe
						var $display3DMaterialSprite:Display3DLightProbeItemSprite=new Display3DLightProbeItemSprite(Scene_data.context3D)
						$proxyPan3DTempLightProbe.idPos=new Vector3D(i,j,k)
							
							
						var $objsUrl:String=Scene_data.fileRoot+$modelUrl
						$objsUrl="assets/obj/Sphere.objs"
						$display3DMaterialSprite.url=$objsUrl
							
							
					
						$display3DMaterialSprite.scale_x=_lightProbeMesh.lightModelScal*0.05
						$display3DMaterialSprite.scale_y=_lightProbeMesh.lightModelScal*0.05
						$display3DMaterialSprite.scale_z=_lightProbeMesh.lightModelScal*0.05
						_ballItem.push($display3DMaterialSprite)
						
						$proxyPan3DTempLightProbe.sprite=$display3DMaterialSprite
				
						var tempLightProbeMesh:LightProbeTempStaticMesh=LightProbeTempStaticMesh(arr[i][j][k])
						$proxyPan3DTempLightProbe.perentModel=this
						$proxyPan3DTempLightProbe.lightProbeTempStaticMesh=tempLightProbeMesh
					
						_lightProbeTempItem.push($proxyPan3DTempLightProbe)
					}
				}
				
				
			}
			
			
			restLightProbeLine()

		
			sprite.ballItem=_ballItem

		}
		public function restLightProbeLine():void
		{
			sprite.lineSprite.clear()
			sprite.lineSprite.thickness=0.3
			var arr:Array=_lightProbeMesh.posItem
			for(var i:uint=0;i<arr.length;i++){
				for(var j:uint=0;j<arr[i].length;j++){
					for(var k:uint=0;k<arr[i][j].length;k++){
						drawPosLine(i,j,k)
					}
				}
			}
			sprite.lineSprite.reSetUplodToGpu()

		}
		private function drawPosLine(i:uint,j:uint,k:uint):void
		{
			
			var arr:Array=_lightProbeMesh.posItem
			var $centerPos:LightProbeTempStaticMesh=arr[i][j][k]
				
			if((i+1)<arr.length){
				var a:Vector3D=LightProbeTempStaticMesh(arr[i+1][j][k]).postion
				sprite.lineSprite.makeLineMode($centerPos.postion,a)
			}
			if((j+1)<arr[0].length){
				var b:Vector3D=LightProbeTempStaticMesh(arr[i][j+1][k]).postion
				sprite.lineSprite.makeLineMode($centerPos.postion,b)
			}
			if((k+1)<arr[0][0].length){
				var c:Vector3D=LightProbeTempStaticMesh(arr[i][j][k+1]).postion
				sprite.lineSprite.makeLineMode($centerPos.postion,c)
			}
			
			
		
		}
		
		private function resetPos():void
		{
			for(var i:uint=0;i<_lightProbeTempItem.length;i++){
				_lightProbeTempItem[i].resetPos(false)
			}
			
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
			sprite.x=value
				
			_lightProbeMesh.postion.x=value
			resetPos()

		}
		
		public function get x():Number
		{
			
			return sprite.x;
		}
		
		public function set y(value:Number):void
		{
			sprite.y=value
			_lightProbeMesh.postion.y=value
			resetPos()
		}
		
		public function get y():Number
		{
			return sprite.y;
			
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value
			_lightProbeMesh.postion.z=value
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
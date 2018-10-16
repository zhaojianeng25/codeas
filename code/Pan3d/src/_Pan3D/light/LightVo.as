package _Pan3D.light
{
	import flash.geom.Vector3D;
	

	public class LightVo
	{
		public var ClearColor:Vector3D
		public var AmbientLight:Light;
		public var SunLigth:Light;
		public var Zhenqiang:Number;    //   光传递增强
		public var Yanseyichu:Number    //   颜色溢出
		public var Shuaijian:Number    //   颜色溢出
		public var Envscale:Number    //   颜色溢出
		private var _patchPrecision:Number    //   颜色溢出
		public var lightPassNum:Number    //   颜色溢出
		public var shadowIntensity:Number    //   阴影强度
		public var SkyBoxUrl:String=""
		public var ShowSkyBox:Boolean;
		public var aoNum:Number = 0.25;

		
		public function LightVo()
		{
			init();
		}

		public function get patchPrecision():Number
		{
			return _patchPrecision;
		}

		public function set patchPrecision(value:Number):void
		{
			_patchPrecision = value;
			_patchPrecision=Math.max(1,_patchPrecision)
		}

		public function init():void
		{
			AmbientLight=new Light(Light.AMBIENT,new Vector3D(50,50,50),1); 
			SunLigth=new Light(Light.AMBIENT,new Vector3D(255,255,255),1); 
			ClearColor=new Vector3D(0.5,0.5,0.5,1)
			
	
		}
		
		public function getSun():Vector3D{
			var v3d:Vector3D = new Vector3D;
			v3d.setTo(SunLigth.color.x/255,SunLigth.color.y/255,SunLigth.color.z/255);
			v3d.scaleBy(SunLigth.intensity);
			return v3d;
		}
		
		public function getAmbient():Vector3D{
			var v3d:Vector3D = new Vector3D;
			v3d.setTo(AmbientLight.color.x/255,AmbientLight.color.y/255,AmbientLight.color.z/255);
			v3d.scaleBy(AmbientLight.intensity);
			return v3d;
		}
		
		
		public function readObject():Object{
			var obj:Object = new Object;
			obj.AmbientLight = AmbientLight.readObject();
			obj.SunLigth = SunLigth.readObject();
			obj.Zhenqiang=Zhenqiang
			obj.Yanseyichu=Yanseyichu
			obj.Shuaijian=Shuaijian
			obj.patchPrecision=patchPrecision
			obj.lightPassNum=lightPassNum
			obj.shadowIntensity=shadowIntensity
			obj.Envscale=Envscale
			obj.ShowSkyBox=ShowSkyBox
			obj.SkyBoxUrl=String(SkyBoxUrl)
			obj.ClearColor={x:ClearColor.x,y:ClearColor.y,z:ClearColor.z};
				

			return obj;
		}
		
		public function writeObject(obj:Object):void{
			AmbientLight = new Light(Light.AMBIENT,new Vector3D(0,0,0),0);
			if(obj && obj.AmbientLight){
				AmbientLight.writeObject(obj.AmbientLight);
			}
			SunLigth = new Light(Light.DIRECTIONAL,new Vector3D(255,255,255),0.5);

			if(obj && obj.SunLigth){
				SunLigth.writeObject(obj.SunLigth);
			}
			if(obj)
			{
				Zhenqiang=obj.Zhenqiang
			}else
			{
				Zhenqiang=2
			}
			if(obj)
			{
				Yanseyichu=obj.Yanseyichu
			}else{
				Yanseyichu=0.5
			}
			if(obj)
			{
				Shuaijian=obj.Shuaijian
			}else{
				Shuaijian=0.2
			}
			if(obj)
			{
				patchPrecision=obj.patchPrecision
			}else{
				patchPrecision=5
			}
			if(obj)
			{
				lightPassNum=obj.lightPassNum
			}else{
				lightPassNum=5
			}
			if(obj)
			{
				Envscale=obj.Envscale
			}else{
				Envscale=1
			}
			if(obj)
			{
				shadowIntensity=obj.shadowIntensity
			}else{
				shadowIntensity=0
			}
			if(obj)
			{
				ShowSkyBox=obj.ShowSkyBox
			}else{
				ShowSkyBox=false
			}
			if(obj)
			{
				SkyBoxUrl=obj.SkyBoxUrl
				if(SkyBoxUrl==""){
					SkyBoxUrl="assets/white.jpg"
				}
			}else{
				SkyBoxUrl="assets/white.jpg"
			}
			
			if(obj && obj.ClearColor)
			{
				ClearColor=new Vector3D(obj.ClearColor.x,obj.ClearColor.y,obj.ClearColor.z);
			}else{
				ClearColor=new Vector3D(0.5,0.5,0.5,1)
			}
		}
		
	}
}
package _Pan3D.particle.bone
{
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	
	public class Display3DBoneParticleNew extends Display3DBonePartilce
	{
		private var _maskUrl:String;
		public function Display3DBoneParticleNew(context:Context3D)
		{
			super(context);
			this.particleType = 20;
		}
		
		override protected function setVa():void{
			_context3D.setTextureAt(2,ParticleBoneData(_particleData).maskTexture);
			super.setVa();
		}

		
		override protected function setVaBatch():void{
			_context3D.setTextureAt(2,ParticleBoneData(_particleData).maskTexture);
			super.setVaBatch();
		}
		
		override public function setAllInfo(obj:Object, isClone:Boolean=false):void{
			
			if(!isClone){
				maskUrl = obj.maskUrl;
			}else{
				_maskUrl = obj.maskUrl;
			}
			
			super.setAllInfo(obj,isClone);
			
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.maskUrl = _maskUrl;
			return obj;
		}
		
		public function set maskUrl(value:String):void
		{
			_maskUrl = value;
			if(_maskUrl){
				TextureManager.getInstance().addTexture(Scene_data.particleRoot + value,onMaskTextureLoad,null,priority);
			}
		}
		
		public function get maskUrl():String{
			return _maskUrl;
		}
		
		private function onMaskTextureLoad(textureVo : TextureVo,info:Object):void{
			ParticleBoneData(particleData).maskTexture = textureVo.texture;
			ParticleBoneData(particleData).maskTextureVo = textureVo;
			textureVo.useNum++;
			sourceLoadCom();
		}
		
	}
}
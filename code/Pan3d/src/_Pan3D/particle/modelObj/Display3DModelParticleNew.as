package _Pan3D.particle.modelObj
{
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.mask.ParticleMaskData;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	
	public class Display3DModelParticleNew extends Display3DModelPartilce
	{
		private var _maskUrl:String;
		public function Display3DModelParticleNew(context:Context3D)
		{
			super(context);
			
			//this._context3D = context;
			_particleData = new ParticleMaskData;
			this.particleType = 21;
			useTextureColor = false;
		}
		
		override protected function setVa() : void {
			_context3D.setTextureAt(2,ParticleMaskData(_particleData).maskTexture);
			super.setVa();
		}
		
		
		override protected function setVaBatch() : void {
			_context3D.setTextureAt(2,ParticleMaskData(_particleData).maskTexture);
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
			ParticleMaskData(particleData).maskTexture = textureVo.texture;
			ParticleMaskData(particleData).maskTextureVo = textureVo;
			textureVo.useNum++;
			sourceLoadCom();
		}
		
		override public function clone():Display3DParticle{
			var display:Display3DModelParticleNew = new Display3DModelParticleNew(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function get loadNum():int{
			return 3;
		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3dModelNewShader.DISPLAY3DMODELNEWSHADER);
		}
		
		override public function clear():void{
			super.clear();
			_maskUrl = null;
		}
	}
}
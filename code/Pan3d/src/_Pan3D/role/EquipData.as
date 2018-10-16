package _Pan3D.role
{
	import _Pan3D.base.MeshData;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.pos.PosVo;
	import _Pan3D.vo.texture.TextureVo;
	
	import flash.display3D.textures.Texture;

	/**
	 * 装备资源数据
	 * 1.模型数据
	 * 2.贴图数据
	 * 3.粒子特效数据
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class EquipData
	{
		public var key:String;
		public var meshData:MeshData;
		public var textureVo:TextureVo;
		public var textureUrl:String;
		public var particleList:Vector.<CombineParticle>;
		public var data:AvatarParamData;
		private var _visible:Boolean = true;
		/**
		 * 渲染优先级 
		 */		
		public var renderPriority:int;
//		public var posVec:Vector.<PosVo>;
		public function EquipData()
		{
			
		}
		
		public function addToRender(bindTarget:IBind):void{
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					ParticleManager.getInstance().addParticle(particleList[i]);
					particleList[i].bindTarget = bindTarget;
					particleList[i].visible = _visible;
				}
			}
		}
		public function removeRender():void{
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					ParticleManager.getInstance().removeParticle(particleList[i]);
				}
			}
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					particleList[i].visible = value;
				}
			}
		}
		
		public function set particleScale(value:Number):void{
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					particleList[i].scale = value;
				}
			}
		}
		
		public function dispose():void{
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					particleList[i].dispose();
				}
			}
			
			key = null;
			meshData = null;
			textureVo = null;
			textureUrl = null;
			particleList = null;
			data = null;
		}
		
		public function reload():void{
			textureVo.texture = TextureManager.getInstance().reloadTexture(textureUrl);
			
			if(particleList){
				for(var i:int;i<particleList.length;i++){
					particleList[i].reload();
				}
			}
			
		}
		
	}
}
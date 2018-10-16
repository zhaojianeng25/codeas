package _Pan3D.vo.mesh
{
	import _Pan3D.role.EquipData;
	import _Pan3D.vo.particle.ParticleVo;
	
	import _me.Scene_data;
	
	import flash.geom.Vector3D;

	public dynamic class MeshVo
	{
		/**
		 * mesh模型的url 
		 */		
		public var meshUrl:String;
		/**
		 * 粒子的url和相关绑定信息 
		 */		
		public var particleList:Vector.<ParticleVo>;
		
		public var particleList2:Vector.<ParticleVo>;
		
		/**
		 * 贴图资源的url 
		 */		
		public var textureUrl:String;
		
		public var textureLightUrl:String;
		
		/**
		 * 加载完成后 整合的所有资源数据包 
		 */		
		public var equipData:EquipData;
		/**
		 * 渲染优先级 
		 */		
		public var renderPriority:int;
		
		public function MeshVo()
		{
			
		}
		
		public static function getVo(obj:Object):MeshVo{
			var meshVo:MeshVo = new MeshVo;
			if(Scene_data.fileByteMode){
				var str:String = obj.meshUrl;
				str = str.split(".")[0] + ".mb";
				meshVo.meshUrl = str;
			}else{
				meshVo.meshUrl = obj.meshUrl;
			}
			meshVo.particleList = getList(obj.particleList);
			meshVo.particleList2 = getList(obj.particleList2);
			meshVo.textureUrl = obj.textureUrl;
			meshVo.textureLightUrl = obj.textureLightUrl;
			return meshVo;
		}
		
		private static function getList(ary:Array):Vector.<ParticleVo>{
			if(ary){
				var vec:Vector.<ParticleVo> = new Vector.<ParticleVo>;
				for(var i:int;i<ary.length;i++){
					vec.push(ParticleVo.getVo(ary[i]));
				}
				return vec;
			}else{
				return null;
			}
		}
		
		public function dispose():void{
			meshUrl = null;
			
			particleList = null;
			
			textureUrl = null;
			
			equipData = null;
			
		}
		
	}
}
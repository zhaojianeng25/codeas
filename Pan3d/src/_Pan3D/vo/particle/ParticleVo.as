package _Pan3D.vo.particle
{
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.particle.ctrl.CombineParticle;
	
	import flash.geom.Vector3D;

	/**
	 * 粒子信息模型 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParticleVo
	{
		/**
		 * 粒子id编号 
		 */		
		public var id:int;
		/**
		 * 路径 lid+id+.lyf 
		 */		
		public var url:String;
		/**
		 * 绑定点的骨骼id号 
		 */		
		public var bindIndex:int;
		/**
		 * 绑定点的骨骼名字（预留） 
		 */		
		public var bindName:String;
		/**
		 * 绑定偏移 
		 */		
		public var bindOffset:Vector3D;
		/**
		 * 绑定旋转 
		 */		
		public var bindRatation:Vector3D;
		/**
		 * 绑定目标类型 
		 */		
		public var target:int;
		/**
		 * 关键字（关键字相同说明引用的资源完全相同） 
		 */		
		public var key:String;
		/**
		 * 数据对应的粒子对象 
		 */		
		public var particle:CombineParticle;
		/**
		 * 绑定对象 
		 */		
		public var bindTarget:IBind;
		
		public var isList:Boolean;
		
		public var nextList:Vector.<ParticleVo>;
		
		public function ParticleVo()
		{
			
		}
		public static function getVo(obj:Object):ParticleVo{
			var particleVo:ParticleVo = new ParticleVo;
			particleVo.id = obj.id;
			particleVo.url = obj.url;
			particleVo.bindIndex = obj.bindIndex;
			particleVo.bindName = obj.bindName;
			particleVo.bindOffset = objToV3d(obj.bindOffset);
			particleVo.bindRatation = objToV3d(obj.bindRatation);
			
			if(obj.isList){
				particleVo.isList = true;
				particleVo.nextList = new Vector.<ParticleVo>;
				
				var ary:Array = obj.nextList;
				
				for(var i:int;i<ary.length;i++){
					particleVo.nextList.push(getVo(ary[i]));
				}
				
			}
			
			return particleVo;
		}
		public static function objToV3d(obj:Object):Vector3D{
			if(obj)
				return new Vector3D(obj.x,obj.y,obj.z);
			else
				return null;
		}
		
		public function dispose():void{
			url = null;
					
			bindName = null;
			
			bindOffset = null;
					
			bindRatation = null;
			
			key = null;
			
			particle = null;
					
			bindTarget = null;
			
			if(nextList){
				for(var i:int;i<nextList.length;i++){
					nextList[i].dispose();
				}
				nextList = null;
			}
		}
		
	}
}
package _Pan3D.vo.pos
{
	import flash.geom.Vector3D;
	/**
	 * 骑乘位置 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class PosVo
	{
		/**
		 * 位置序号 
		 */		
		public var index:int;
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
		
		public function PosVo()
		{
			
		}
		
		public static function getVo(obj:Object):PosVo{
			var posVo:PosVo = new PosVo;
			posVo.index = obj.index;
			posVo.bindIndex = obj.bindIndex;
			posVo.bindName = obj.bindName;
			posVo.bindOffset = objToV3d(obj.bindOffset);
			posVo.bindRatation = objToV3d(obj.bindRotation);
			return posVo;
		}
		
		public static function objToV3d(obj:Object):Vector3D{
			if(obj)
				return new Vector3D(obj.x,obj.y,obj.z);
			else
				return null;
		}
		
	}
}
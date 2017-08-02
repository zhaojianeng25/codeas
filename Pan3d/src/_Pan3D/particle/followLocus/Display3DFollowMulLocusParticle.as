package _Pan3D.particle.followLocus
{
	import flash.display3D.Context3D;
	
	import _Pan3D.base.enum.EnumParticleType;
	
	public class Display3DFollowMulLocusParticle extends Display3DFollowLocusPartilce
	{
		protected var _itemNum:int;
		public function Display3DFollowMulLocusParticle(context:Context3D)
		{
			super(context);
			
			this._particleType = EnumParticleType.FOLLOW_MUL_LOCUS;
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.itemNum = _itemNum;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._itemNum = obj.itemNum;
			super.setAllInfo(obj,isClone);
			
		}
		
	}
}
package _Pan3D.particle
{
	import _Pan3D.base.ObjData;
	import _Pan3D.vo.texture.TextureVo;
	
	import flash.display3D.VertexBuffer3D;
	
	public class ParticleData extends ObjData
	{
		public var vaData:Vector.<Number>;
		
		public var vaDataBuffer:VertexBuffer3D;
		/**
		 * 使用次数 
		 */		
		public var useTime:int = 1;
		
		//public var callBackList:Vector.<Function>;
		public function ParticleData()
		{
			super();
			//callBackList = new Vector.<Function>;
		}
		
		override public function dispose():void{
			super.dispose();
			if(vaDataBuffer){
				vaDataBuffer.dispose();
			}
			if(vaData){
				vaData.length = 0;
				vaData = null;
			}
			
			/*if(callBackList){
				callBackList.length = 0;
				callBackList = null;
			}*/
		}
		
		override public function unload():void{
			super.unload();
			if(vaDataBuffer){
				vaDataBuffer.dispose();
			}
		}
		
		/*public function callBack(fun:Function):void{
			//callBackList.push(fun);
		}*/
		
		/*public function applyCallBack():void{
			if(callBackList){
				for(var i:int;i<callBackList.length;i++){
					callBackList[i]();
				}
				callBackList.length = 0;
			}
		}*/
		
	}
}
package _Pan3D.role
{
	import flash.display.BitmapData;
	
	import _Pan3D.vo.anim.AnimVo;
	import _Pan3D.vo.anim.BoneLoadVo;

	public class BoneLoadUtils
	{
		private var _callBackFun:Function;
		private var _errorCallBackFun:Function;
		public var isInterrupt:Boolean;
		public function BoneLoadUtils()
		{
			
		}
		
		public function addAnim(url:String,name:String,fun:Function,$priority:int,$errorFun:Function):void{
			_callBackFun = fun;
			_errorCallBackFun = $errorFun;
			//var obj:Object = {"name":name,"url":url};
			//obj.bmp = new BitmapData(512,512);
			var obj:BoneLoadVo = new BoneLoadVo(name,url);
			AnimDataManager.getInstance().addAnim(url,onAnimLoad2,obj,$priority,error);
		}
		
		protected function onAnimLoad2(ary:Array,info:Object,animVo:AnimVo):void{
			if(!isInterrupt){
				_callBackFun(ary,info,animVo,this);
			}
		}
		
		private function error():void{
			if(!isInterrupt){
				_errorCallBackFun(this)
			}
		}
		
		public function dispose():void{
			_callBackFun = null;
			_errorCallBackFun = null;
		}
		
	}
}
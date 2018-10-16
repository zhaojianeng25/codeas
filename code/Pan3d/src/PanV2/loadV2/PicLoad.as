package  PanV2.loadV2
{
	import flash.utils.Dictionary;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class PicLoad
	{
		public function PicLoad()
		{
		}
		public static function getInstance():PicLoad{
			if(!_instance)
				_instance = new PicLoad();
			return _instance;
		}
		private var _infoDic:Dictionary=new Dictionary;
		private var _funDic:Dictionary=new Dictionary;
		private static var _instance:PicLoad;
		
		public function addSingleLoad($url:String,$fun:Function,info:Object):void{
			
			
			if(_infoDic[$url]){
				if(_infoDic[$url].isFinish){
					$fun(TextureVo(_infoDic[$url].data),Object(info))
				}else{
					addPushFun($url,$fun,info)
				}
				
			}else{
				addPushFun($url,$fun,info)
				tempLoad($url,info);
			}
		}
		private function addPushFun($url:String,$fun:Function,info:Object):void
		{
			if(!Boolean(_funDic[$url])){
				_funDic[$url]=new Object
				_funDic[$url].funItem=new Array
				_funDic[$url].infoItem=new Array
			}
			_funDic[$url].funItem.push($fun)
			_funDic[$url].infoItem.push(info)
		}
		private function tempLoad($url:String,info:Object):void
		{
			_infoDic[$url]={isFinish:false,info:info}
			TextureManager.getInstance().addTexture($url,onDefaultTexture,info);	
			function onDefaultTexture(textVo:TextureVo,$buildData:ObjData):void{
				_infoDic[$url].isFinish=true
				_infoDic[$url].data=textVo
				backFun($url)
	
			}
		}
		
		private function backFun($url:String):void
		{

			var cc:Array=_funDic[$url].funItem
			for(var i:uint=0;i<cc.length;i++){
				var $fun:Function=cc[i]
				$fun(TextureVo(_infoDic[$url].data),Object(_funDic[$url].infoItem[i]))
			}
			
			
			
		}
	}
}
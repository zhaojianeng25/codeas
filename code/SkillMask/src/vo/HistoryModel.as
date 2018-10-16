package vo
{
	import flash.geom.Rectangle;
	
	

	public class HistoryModel
	{
		private static var instance:HistoryModel;
		private var _item:Vector.<HistoryVo>;
		public function HistoryModel()
		{
			clearHistoryAll()
		}


		public static function getInstance():HistoryModel{
			if(!instance){
				instance = new HistoryModel();
			}
			return instance;
		}
		private var _readId:uint=0;
		public function saveSeep():void
		{
			
			if(!UiData.nodeItem){
				return ;
			}
			if(_item.length){
				//数据量都一样的情况下
				if(_item[0].infoNodeItem.length==UiData.nodeItem.length){

				}else{
					_item=new Vector.<HistoryVo>;//数量变化时将清空
				}
			}
			if(_item.length){
				
				if(_readId<_item.length){  //将撤销后的去掉
					_item.splice(_readId+1,_item.length-_readId-1)
				}
				
				if(isNeedSave){
					_item.push(getNeedSaveVo())
				}else{
				}
			}else{
				_item.push(getNeedSaveVo())
			}
			
			_readId=_item.length-1;
			
			trace("_item",_item.length)

		}
		private function get isNeedSave():Boolean
		{
			var $HistoryVo:HistoryVo=_item[_item.length-1]
			for(var j:uint=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode:H5UIFileNode=UiData.nodeItem[j] as H5UIFileNode;
				var $rectInfo:Rectangle=$HistoryVo.infoNodeItem[j] as Rectangle
				if($rectInfo.equals($H5UIFileNode.rect)){
					
				}else{
					trace("需要修改----info")
					return true
					
				}
			}
			return false
			
		}
		public function clearHistoryAll():void
		{
			_readId=0
			_item=new Vector.<HistoryVo>
		}
		public function cancelScene():void
		{
			if(_readId>0){
				resetData(_readId-1);
			}
		}
		public function nextScene():void
		{
			if(_readId<(_item.length-1)){
				resetData(_readId+1);
			}
		}
		private function resetData($num:uint):void
		{
			_readId=$num;
			var $HistoryVo:HistoryVo=_item[_readId]
			for(var j:uint=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode:H5UIFileNode=UiData.nodeItem[j] as H5UIFileNode;
				var $rectInof:Rectangle=$HistoryVo.infoNodeItem[j];
				$H5UIFileNode.rect.x=$rectInof.x
				$H5UIFileNode.rect.y=$rectInof.y
				$H5UIFileNode.rect.width=$rectInof.width
				$H5UIFileNode.rect.height=$rectInof.height
				$H5UIFileNode.sprite.updata();
			}
			
			
		}
		private function getNeedSaveVo():HistoryVo
		{
			var $HistoryVo:HistoryVo=new HistoryVo
			$HistoryVo.infoNodeItem=new Vector.<Rectangle>
		
			for(var j:uint=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode:H5UIFileNode=UiData.nodeItem[j] as H5UIFileNode;
				$HistoryVo.infoNodeItem.push($H5UIFileNode.rect.clone())
			}
			return $HistoryVo
		}
	}
}
import flash.geom.Rectangle;
class HistoryVo
{

	public var infoNodeItem:Vector.<Rectangle>
}









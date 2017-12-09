package mvc.frame.lightbmp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import mx.charts.AreaChart;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.texture.TextureManager;
	
	import modules.hierarchy.h5.ExpResourcesModel;
	
	import mvc.frame.FrameModel;
	import mvc.frame.view.FrameFileNode;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.top.render.Render;
	

	public class LightBmpModel
	{
		private static var instance:LightBmpModel;
		public function LightBmpModel()
		{
		}
		public static function getInstance():LightBmpModel{
			if(!instance){
				instance = new LightBmpModel();
			}
			return instance;
		}
		public function resetLightNodel():void
		{
			 this.bmpKeyData=new Dictionary
			 var $hasCookArr:Array=getAllNeedCookFrameItem();
			 for(var i:Number=0;i<$hasCookArr.length;i++){
				 this.makeLightBitmapItem($hasCookArr[i])
			 }
		}

		public function getAllNeedCookFrameItem():Array
		{
			var $cookNodeItem:Vector.<FrameFileNode>=new Vector.<FrameFileNode>;
			var $arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<$arr.length;i++){
				var $frameA:FrameFileNode=$arr[i]
				if($frameA.type==FrameFileNode.build1&&$frameA.url.indexOf(".prefab")!=-1){
					
					
					if(ProxyPan3dModel($frameA.iModel).sprite.material){
						var $needCook:Boolean=!ProxyPan3dModel($frameA.iModel).sprite.material.noLight;
						if($needCook){
							$cookNodeItem.push($frameA)
						}
					}
				}
			}
			var $ke:Dictionary=new Dictionary;
			for(var j:Number=0;j<$cookNodeItem.length;j++){
				var $frameB:FrameFileNode=$cookNodeItem[j];
				$ke[$frameB.pointitem[0].time]=$frameB.pointitem[0].time
			}
			var $arrkey:Array=new Array
			for (var $keystr:String in $ke){
				$arrkey.push(Number($keystr))
			}
			return $arrkey
		}

		private function makeLightBitmapItem( $frameNum:uint):void
		{
			var $numsikp:uint=0;
			var $arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<$arr.length;i++){
				var $frameFileNode:FrameFileNode=$arr[i];
				if($frameFileNode.isVisible($frameNum)&&$frameFileNode.type==FrameFileNode.build1){
					$numsikp++
					var $frameUrl:String=Render.lightUvRoot+$frameNum+"/"+$frameFileNode.id+".jpg";
					if(	$frameFileNode.url.search(".prefab")!=-1&&ProxyPan3dModel($frameFileNode.iModel).sprite.material){
						var $needCook:Boolean=!ProxyPan3dModel($frameFileNode.iModel).sprite.material.noLight;
						if($needCook){
							BmpLoad.getInstance().addSingleLoad($frameUrl,function ($bitmap:Bitmap,$obj:Object):void{
								insetBitmapByKeyAndId($bitmap.bitmapData,$obj.id,$obj.frameNum);
							},{id:$frameFileNode.id,frameNum:$frameNum})
						}
					}
					
		
				}
			}
		}
		private function insetBitmapByKeyAndId($bmp:BitmapData,$id:uint,$frameNum:uint):void
		{
			if(!this.bmpKeyData.hasOwnProperty($frameNum)){
				this.bmpKeyData[$frameNum]=new Dictionary;
			}
			this.bmpKeyData[$frameNum][$id]=$bmp;
			
			FrameModel.getInstance().framePanel.refrishFrameList()
		}
		public function setLightBmpToNode($node:FrameFileNode):void
		{
		
			var $nowNum:uint=Math.floor(AppDataFrame.frameNum)
			if(bmpKeyData){
				var $selectFrame:int=-1;
				for (var $frameKey:Object in bmpKeyData){
					if($nowNum>=Number($frameKey)){
						if($selectFrame<Number($frameKey)){
							$selectFrame=Number($frameKey)
						}
					}
				}
				if(bmpKeyData[$selectFrame]){
					
					
					if(bmpKeyData[$selectFrame][$node.id]){
						var $bmp:BitmapData=bmpKeyData[$selectFrame][$node.id];
						if($node.lightTexture){
							$node.lightTexture.uploadFromBitmapData($bmp);
						}else{
							$node.lightTexture=TextureManager.getInstance().bitmapToTexture($bmp)
							ProxyPan3dModel($node.iModel).sprite.lightMapTexture=$node.lightTexture
						}
					}
				}
			
			}
	
		}
		//输出全部灯光来
		public function makeLightBmpToResModel(_rootUrl:String):void
		{
			var $hasCookArr:Array=getAllNeedCookFrameItem();
			for(var k:Number=0;k<$hasCookArr.length;k++){
				var $frameNum:uint=$hasCookArr[k]
				var $numsikp:uint=0;
				var $arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
				for(var i:Number=0;i<$arr.length;i++){
					var $frameFileNode:FrameFileNode=$arr[i];
					if($frameFileNode.isVisible($frameNum)&&$frameFileNode.type==FrameFileNode.build1){
						$numsikp++
						var $frameUrl:String=Render.lightUvRoot+$frameNum+"/"+$frameFileNode.id+".jpg";
						if($frameFileNode.url.search(".prefab")!=-1&&ProxyPan3dModel($frameFileNode.iModel).sprite.material){
							var $needCook:Boolean=!ProxyPan3dModel($frameFileNode.iModel).sprite.material.noLight;
							if($needCook){
								var $burl:String=ExpResourcesModel.getInstance().expPicByUrl($frameUrl,_rootUrl)
								trace($burl)
							}
						}
					}
				}
			}
	
		
		}
		public function getBmpByNodeAndFrame($node:FrameFileNode,$nowNum:uint):BitmapData
		{

			if(bmpKeyData){
				var $selectFrame:int=-1;
				for (var $frameKey:Object in bmpKeyData){
					if($nowNum>=Number($frameKey)){
						if($selectFrame<Number($frameKey)){
							$selectFrame=Number($frameKey)
						}
					}
				}
				if(bmpKeyData[$selectFrame]){
					if(bmpKeyData[$selectFrame][$node.id]){
						var $bmp:BitmapData=bmpKeyData[$selectFrame][$node.id];
						return $bmp
					}
				}
				
			}
			return null
			
		}
		public  var bmpKeyData:Dictionary;
	}
}
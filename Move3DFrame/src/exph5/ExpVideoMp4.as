package exph5
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import PanV2.loadV2.BmpLoad;
	
	import _me.Scene_data;
	
	import common.utils.ui.file.FileNodeManage;
	
	import leelib.util.flvEncoder.ByteArrayFlvEncoder;
	
	import mvc.frame.FrameModel;
	import mvc.frame.lightbmp.LightBmpModel;
	import mvc.frame.view.FrameFileNode;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.top.render.Render;

	public class ExpVideoMp4
	{
		private const OUTPUT_WIDTH:Number = 256;
		private const OUTPUT_HEIGHT:Number = 256;
		
		private const FLV_FRAMERATE:int = 36;
		
		private static var instance:ExpVideoMp4;
		public function ExpVideoMp4()
		{
		}
		public static function getInstance():ExpVideoMp4{
			if(!instance){
				instance = new ExpVideoMp4();
			}
			return instance;
		}
		private var bmpItem:Vector.<BitmapData>
		private var _baFlvEncoder:ByteArrayFlvEncoder;
		public  function expMp4():void
		{
			this.getAllLightBmpItem();
			MergeVideoModel.getInstance().clear()
			this._baFlvEncoder = new ByteArrayFlvEncoder(FLV_FRAMERATE);
			_baFlvEncoder.setVideoProperties(OUTPUT_WIDTH,OUTPUT_HEIGHT);
			_baFlvEncoder.start();

			this.onebyone()

		}
		private var skipNextFrameNum:Number=0;
		private var vidoeBitmapData:BitmapData
		private function onebyone():void
		{
			var $maxTime:uint= FrameModel.getInstance().getTotalTime();
			//$maxTime=10
			if(this.skipNextFrameNum<$maxTime){
	
				var $skipNum:Number=0	
				var $frameId:Number=this.skipNextFrameNum
				var $arr:Vector.<FrameFileNode>=FrameModel.getInstance().getAllFrameFileNode();
				var $urlArr:Array=new Array();
				$arr.sort(upperCaseFunc);
				function upperCaseFunc(a:FrameFileNode,b:FrameFileNode):int{
					return a.id-b.id;
				}
				for(var i:Number=0;i<$arr.length;i++){
					var $nodeFrame:FrameFileNode=$arr[i];
					if($nodeFrame.type==FrameFileNode.build1&&$nodeFrame.url.indexOf(".prefab")!=-1){
						if(ProxyPan3dModel($nodeFrame.iModel).sprite.material){
							var $needCook:Boolean=!ProxyPan3dModel($nodeFrame.iModel).sprite.material.noLight;
							if($needCook&&$nodeFrame.isVisible($frameId)){
								
								var $frameUrl:String=Render.lightUvRoot+$frameId+"/"+$nodeFrame.id+".jpg";
								$urlArr.push($frameUrl);
								if(!new File($frameUrl).exists){
									Alert.show($frameUrl,"文件没有");
								}
								
								$skipNum++
							}
						}
					}
				}
				
				loadJpgItemToBitmapdata($urlArr)
			
			}else{
				this.onThisClickSave()
			}
			
		}
		private var frameLightUrlNum:Number=0;
		private var drawBmpNum:Number=0;
		private var oneFrameBmpItem:Vector.<ExpVideoBmpVo>;
		private function insetBitmapByKeyAndId($bmp:BitmapData,$i:uint,$url:String):void
		{
			//trace($bmp,$i,$url)
			this.drawBmpNum++
			trace(this.skipNextFrameNum,"---",this.drawBmpNum,"/",this.frameLightUrlNum)
			var $m:Matrix=new Matrix();
			$m.tx=Math.floor($i%4)*256;
			$m.ty=Math.floor($i/4)*256;
			this.vidoeBitmapData.draw($bmp,$m);
			
			
			var $nodeId:Number=Number(new File($url).name.replace(".jpg",""));
	
			var $vo:ExpVideoBmpVo=new ExpVideoBmpVo($nodeId,$bmp,FrameModel.getInstance().getNodeById($nodeId).lightuvSize)
			this.oneFrameBmpItem.push($vo);
			
			if(this.drawBmpNum==this.frameLightUrlNum){

				this.vidoeBitmapData=new BitmapData(1024,1024,false,0xffffff);
				var $mergeBmp:BitmapData=MergeVideoModel.getInstance().mathLightUvInfo(this.oneFrameBmpItem,this.skipNextFrameNum)
				this.vidoeBitmapData.draw($mergeBmp)
				_baFlvEncoder.addFrame(this.vidoeBitmapData, null);
				
				if(this.skipNextFrameNum==100){
					Scene_data.stage.addChild(new Bitmap($mergeBmp))
				}
				this.skipNextFrameNum++
				this.onebyone();
			}
		}

		private function loadJpgItemToBitmapdata($arr:Array):void
		{
			this.frameLightUrlNum=$arr.length;
			this.drawBmpNum=0;
			this.vidoeBitmapData=new BitmapData(1024,1024,false,0xffffff);
			this.oneFrameBmpItem=new Vector.<ExpVideoBmpVo>
			for(var i:Number=0;i<$arr.length;i++){
				BmpLoad.getInstance().addSingleLoad($arr[i],function ($bitmap:Bitmap,$obj:Object):void{
					insetBitmapByKeyAndId($bitmap.bitmapData,$obj.i,$obj.url);
				},{i:i,url:$arr[i]})
			}
		
		}
			

		
		
		private function getAllLightBmpItem():void
		{
			this.bmpItem=new Vector.<BitmapData>;
			var $bmpKeyData:Dictionary=LightBmpModel.getInstance().bmpKeyData;
			for(var $frameKey :Object in $bmpKeyData){
				for(var $idKey :Object in $bmpKeyData[$frameKey]){
					this.bmpItem.push($bmpKeyData[$frameKey][$idKey])
				}
			}
		}
		private var _audioData:ByteArray;
		private var _encodeFrameNum:Number=1
		private function encodeNextFrame():void
		{
			var bmdVideo:BitmapData;
			 bmdVideo =new BitmapData(OUTPUT_WIDTH,OUTPUT_HEIGHT,false,0xffffff);
			_baFlvEncoder.addFrame(bmdVideo, null);

		}
		private function onThisClickSave():void
		{
			MergeVideoModel.getInstance().playEnd()
			var $fileRef:FileReference = new FileReference();
			$fileRef.save(_baFlvEncoder.byteArray, "no_server_required.flv");			


		}
	}
}
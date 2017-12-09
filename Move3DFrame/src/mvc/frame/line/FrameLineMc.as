package mvc.frame.line
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import _me.Scene_data;
	
	import common.msg.event.scene.MEvent_Show_Imodel;
	import common.utils.frame.BaseComponent;
	
	import mvc.charview.ChangeCharActionPanel;
	import mvc.frame.FrameEvent;
	import mvc.frame.FrameInSetOneByOne;
	import mvc.frame.FrameModel;
	import mvc.frame.view.FrameFileNode;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.draw.TooXyzMoveData;
	
	public class FrameLineMc extends BaseComponent
	{
		public var frameFileNode:FrameFileNode;
		private var copyMoveSprite:BaseComponent
		public function FrameLineMc()
		{
			super();
			this._pointSpriteArr=new Vector.<FrameLinePointSprite>;
			this.draw();
			this.addMoveSprite()
			
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onPointMouseUp);
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onPointMouseMove);
			

		
		
		}
		
		public function get pointSpriteArr():Vector.<FrameLinePointSprite>
		{
			return _pointSpriteArr;
		}

		public function set pointSpriteArr(value:Vector.<FrameLinePointSprite>):void
		{
			_pointSpriteArr = value;
		}

		private function addMoveSprite():void
		{
			this.copyMoveSprite=new BaseComponent;
			this.copyMoveSprite.graphics.clear();
			this.copyMoveSprite.graphics.beginFill(0xffffff,1);
			this.copyMoveSprite.graphics.lineStyle(1,0x000000);
			
			this.copyMoveSprite.graphics.drawRect(-4,2,8,16);
			this.copyMoveSprite.graphics.endFill();
			this.copyMoveSprite.mouseEnabled=false
			
		}
		
		protected function lineMcClik(event:MouseEvent):void
		{

			//FramePanel(this.parent.parent.parent).playFrameTo(Math.floor(this.mouseX/AppDataFrame.numW8))
			
		}
		private var bg:UIComponent;
		private var _pointSpriteArr:Vector.<FrameLinePointSprite>;
	
		private function draw():void
		{
		
		
			this.bg= new UIComponent();
			this.addChild(this.bg)
			this.bg.addEventListener(MouseEvent.CLICK,lineMcClik)
			this.bg.addEventListener(MouseEvent.RIGHT_CLICK,onRightBgClick);
		}
		private var bgselectFrameNum:uint
		protected function onRightBgClick(event:MouseEvent):void
		{
			
			this.bgselectFrameNum=	Math.floor(this.mouseX/AppDataFrame.numW8)
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			item = new NativeMenuItem("插入关键帧")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,insetKeyFrame);
			
			var $preFrameLinePointVo:FrameLinePointVo= this.frameFileNode.getPreFrameLinePointVoByTime(this.bgselectFrameNum)
			if($preFrameLinePointVo){
				if($preFrameLinePointVo.isAnimation){
					
					var $xyzMoveData:TooXyzMoveData=MoveScaleRotationLevel.getInstance().xyzMoveData;
					if($xyzMoveData&&$xyzMoveData.dataItem.length>1){
						item = new NativeMenuItem("设置为逐帧补间")
						_menuFile.addItem(item);
						item.addEventListener(Event.SELECT,insetFrameOneByOne);
					}
					item = new NativeMenuItem("取消动画效果")
				}else{
					item = new NativeMenuItem("设置为动画效果")
				}
				_menuFile.addItem(item);
				item.addEventListener(Event.SELECT,changePointAnimation);
				
			
			}

			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		
		protected function insetFrameOneByOne(event:Event):void
		{
			FrameInSetOneByOne.getInstance().insetFrameOneByOne(this.frameFileNode)
		}
		
		protected function changePointAnimation(event:Event):void
		{
			var $vo:FrameLinePointVo= this.frameFileNode.getPreFrameLinePointVoByTime(this.bgselectFrameNum)
			$vo.isAnimation=!$vo.isAnimation;
			this.refrish()
			
		}		
		
		protected function insetKeyFrame(event:Event):void
		{
			this.frameFileNode.insetKey(this.bgselectFrameNum)
			this.frameFileNode.frameLineMc.refrish()
		}
		
		public function refrish():void
		{
			

			
					
	
			if(this.frameFileNode.pointitem.length!=this._pointSpriteArr.length){
				while(this._pointSpriteArr.length){
					this.removeChild(this._pointSpriteArr.pop());
				}
				for(var i:Number=0;i<this.frameFileNode.pointitem.length;i++){
					var $temp:FrameLinePointSprite=new FrameLinePointSprite();
					$temp.frameLinePointVo=this.frameFileNode.pointitem[i];
					$temp.addEventListener(MouseEvent.MOUSE_DOWN,onPointMouseDown);
					$temp.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
					this.addChild($temp);
					this._pointSpriteArr.push($temp);
				}
			}
			this.drawBack();
	
		}
		private var selectframeLinePointVo:FrameLinePointVo
		protected function onRightClick(event:MouseEvent):void
		{
			var $taget:FrameLinePointSprite=event.target as FrameLinePointSprite;
			if(FrameModel.getInstance().selectPointVoItem&&FrameModel.getInstance().selectPointVoItem.length){
				if(	FrameModel.getInstance().selectPointVoItem.indexOf($taget.frameLinePointVo)==-1){
					FrameModel.getInstance().selectPointVoItem=null
					FrameModel.getInstance().selectFrameLinePointVoByArr()
					onRightClick(event)
					return 
				}else{
					this.initMenuItemFile();
					trace("有复选数据")
				}
			}else{
			
				this.selectframeLinePointVo=$taget.frameLinePointVo
				this.initMenuFile()
			}
			_menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}
		public function initMenuItemFile():void{
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			item = new NativeMenuItem("删除选中的所有")
			item.addEventListener(Event.SELECT,deleKeyGroup);
			_menuFile.addItem(item);
			item = new NativeMenuItem("全部设置为关键帧")
			item.addEventListener(Event.SELECT,changeKeyGroup);
			_menuFile.addItem(item);
			
			
		}
		
		protected function changeKeyGroup(event:Event):void
		{
			// TODO Auto-generated method stub
			for(var i:Number=0;i<FrameModel.getInstance().selectPointVoItem.length;i++){
				FrameModel.getInstance().selectPointVoItem[i].iskeyFrame=true;
				FrameModel.getInstance().selectPointVoItem[i].isAnimation=true;
			}
			FrameModel.getInstance().framePanel.refrishFrameList();
			
		}
		
		protected function deleKeyGroup(event:Event):void
		{
			if(FrameModel.getInstance().selectPointVoItem&&FrameModel.getInstance().selectPointVoItem.length){
				FrameModel.getInstance().deleFrameLinePointVoByArr();
				FrameModel.getInstance().framePanel.refrishFrameList();
			}
			
		}
		private var _menuFile:NativeMenu;
		public function initMenuFile():void{

			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;

			item = new NativeMenuItem("删除")
			item.addEventListener(Event.SELECT,deleKeyPoint);
			_menuFile.addItem(item);
			if(this.selectframeLinePointVo.iskeyFrame){
				item = new NativeMenuItem("清除关键帧")
			}else{
				item = new NativeMenuItem("设置为关键帧")
			}
			item.addEventListener(Event.SELECT,changeKeyFrame);
			_menuFile.addItem(item);
			if(this.frameFileNode.url.search(".zzw")!=-1){
				item = new NativeMenuItem("设置动作")
				_menuFile.addItem(item);
				item.addEventListener(Event.SELECT,setAction);
			}

		}
		protected function setAction(event:Event):void
		{
			// TODO Auto-generated method stub
			ChangeCharActionPanel.getInstance().initExpPanel(this.frameFileNode,this.selectframeLinePointVo)
		}
		
		protected function changeKeyFrame(event:Event):void
		{
			this.selectframeLinePointVo.iskeyFrame=!this.selectframeLinePointVo.iskeyFrame;

			var $temp:FrameLinePointVo=this.findLeftKey(this.selectframeLinePointVo.time)
			if($temp){
				this.selectframeLinePointVo.x=$temp.x;
				this.selectframeLinePointVo.y=$temp.y;
				this.selectframeLinePointVo.z=$temp.z;
					
				this.selectframeLinePointVo.scale_x=$temp.scale_x;
				this.selectframeLinePointVo.scale_y=$temp.scale_y;
				this.selectframeLinePointVo.scale_z=$temp.scale_z;
					
				this.selectframeLinePointVo.rotationX=$temp.rotationX;
				this.selectframeLinePointVo.rotationY=$temp.rotationY;
				this.selectframeLinePointVo.rotationZ=$temp.rotationZ;
				
		
			}
					
		
			this.refrish()
			
		}
		private function findLeftKey($time:Number):FrameLinePointVo
		{
		
			var $left:FrameLinePointVo;
			for(var i:Number=0;i<this.frameFileNode.pointitem.length;i++){
				var $temp:FrameLinePointVo=this.frameFileNode.pointitem[i];
				if($temp.time<$time){
					if(!$left||$left.time<$temp.time){
						$left=$temp
					}
				}
			
			}
			return $left;
		}
		
		protected function clearData(event:Event):void
		{
			var $back:FrameLinePointVo= this.getPrePointData(this.selectframeLinePointVo)
			if($back){
				FrameLinePointVo.copyto($back,this.selectframeLinePointVo)
				ModuleEventManager.dispatchEvent( new FrameEvent(FrameEvent.REFRISH_FRAME_LINE_CAVANS));
			}
		}
		private function getPrePointData($temp:FrameLinePointVo):FrameLinePointVo   //上一个位置点的数据
		{
		
			var $back:FrameLinePointVo
			for(var i:Number=0;i<this.frameFileNode.pointitem.length;i++){
				if(this.frameFileNode.pointitem[i].time<this.selectframeLinePointVo.time){
					
					if($back){
						if($back.time<this.frameFileNode.pointitem[i].time){
							$back=this.frameFileNode.pointitem[i]
						}
					}else{
						$back=this.frameFileNode.pointitem[i]
					}
				}
			}
			return $back
		}
		
		protected function deleKeyPoint(event:Event):void
		{

			for(var i:Number=0;i<this.frameFileNode.pointitem.length&&this.frameFileNode.pointitem.length>2;i++){
				if(this.frameFileNode.pointitem[i]==this.selectframeLinePointVo){
					this.frameFileNode.pointitem.splice(i,1);
					if(this.frameFileNode.frameLineMc.parent){
						this.frameFileNode.frameLineMc.parent.removeChild(this.frameFileNode.frameLineMc)
					}
					ModuleEventManager.dispatchEvent( new FrameEvent(FrameEvent.REFRISH_FRAME_LINE_CAVANS));
					return;
				}
			}

		}		
		protected function onPointMouseMove(event:MouseEvent):void
		{
			if(this.beginMoveSlectPointItem){
	
			}
			else{
				if(this.selectPoint ){
					var $knum:Number=int(this.mouseX/AppDataFrame.numW8)
					$knum=Math.max(0,int($knum))
					if(this.makeCopyFrameLinePointVo){
						this.makeCopyFrameLinePointVo.time=$knum
						this.copyMoveSprite.x=this.mouseX
					}else{
						this.selectPoint.x=$knum
						this.selectPoint.frameLinePointVo.time=$knum;
						this.drawBack();
					}
				
				}
			}
		}
		private function tatalMoveSlectPointItem(value:Number):void
		{
			var baseW:int=FrameModel.getInstance().baseW
			for(var i:Number=0;i<FrameModel.getInstance().selectPointVoItem.length;i++){
				var $num:int=FrameModel.getInstance().selectPointVoItem[i].time+Math.floor(value/baseW);
				$num=Math.max(0,$num)
				FrameModel.getInstance().selectPointVoItem[i].time=$num
	
			}
		
			FrameModel.getInstance().framePanel.refrishFrameList()
		}
		
		protected function onPointMouseUp(event:MouseEvent):void
		{
			
			if(this.beginMoveSlectPointItem){
				var $tx:Number=Scene_data.stage.mouseX-this.lastItemBegintMouse
				this.tatalMoveSlectPointItem($tx)
			}
			
			this.selectPoint=null;
			this.beginMoveSlectPointItem=false
				
		
			
			
			if(this.makeCopyFrameLinePointVo){
				trace("准备生存关键帧",this.makeCopyFrameLinePointVo.time)
				this.frameFileNode.pointitem.push(this.makeCopyFrameLinePointVo)
				this.makeCopyFrameLinePointVo=null;
				this.refrish();
				if(this.copyMoveSprite.parent){
					this.removeChild(this.copyMoveSprite)
				}
			}

			
		}

        private var makeCopyFrameLinePointVo:FrameLinePointVo
		private var selectPoint:FrameLinePointSprite;
		private var beginMoveSlectPointItem:Boolean;
		private var lastItemBegintMouse:Number
		protected function onPointMouseDown(event:MouseEvent):void
		{
			var $taget:FrameLinePointSprite=event.target as FrameLinePointSprite;
			if(FrameModel.getInstance().selectPointVoItem&&FrameModel.getInstance().selectPointVoItem.length){
			
				
				if(	FrameModel.getInstance().selectPointVoItem.indexOf($taget.frameLinePointVo)==-1){
					FrameModel.getInstance().selectPointVoItem=null
					FrameModel.getInstance().selectFrameLinePointVoByArr()
					onPointMouseDown(event)
					return 
				}else{
					this.beginMoveSlectPointItem=true;
					this.lastItemBegintMouse=Scene_data.stage.mouseX;
				}
		
			}else{
				if(event.ctrlKey){
					var baseW:int=FrameModel.getInstance().baseW
					FrameModel.getInstance().framePanel.playFrameTo(Math.floor(this.mouseX/baseW));
	
					var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SHOW_IMODEL);
					evt.iModel=this.frameFileNode.iModel;
					ModuleEventManager.dispatchEvent(evt);
				}else{
					this.selectPoint=$taget
					if(event.altKey){
						this.makeCopyFrameLinePointVo=selectPoint.frameLinePointVo.cloneVo()
							
						this.copyMoveSprite.x=this.mouseX
						if(!this.copyMoveSprite.parent){
							this.addChild(this.copyMoveSprite)
						}
					}
				}
			}
		}
		private function drawBack():void
		{
			this.frameFileNode.pointitem.sort(upperCaseFunc);
			function upperCaseFunc(a:FrameLinePointVo,b:FrameLinePointVo):int{
				return a.time-b.time;
			}

			var $min:Number=this.frameFileNode.pointitem[0].time*AppDataFrame.numW8;
			var $max:Number=this.frameFileNode.pointitem[this.frameFileNode.pointitem.length-1].time*AppDataFrame.numW8;
			

		
			this.bg.graphics.clear();
			
			
			this.bg.graphics.beginFill(0xffffff,this.frameFileNode.select?0.3:0.2);
			this.bg.graphics.lineStyle(0.1,0xffffff,0);
		
			this.bg.graphics.drawRect($min,1,$max-$min,18);
			this.bg.graphics.endFill();
			
			
			this.bg.graphics.lineStyle(1,0x000000);
//			this.bg.graphics.moveTo($min,10);
//			this.bg.graphics.lineTo($max,10);
			
			for(var i:Number=0;i<this.frameFileNode.pointitem.length;i++){
				this._pointSpriteArr[i].x=this._pointSpriteArr[i].frameLinePointVo.time*AppDataFrame.numW8;
				this._pointSpriteArr[i].refrishDraw();
				
	
				
				if(i!=0){
					var $a:FrameLinePointVo=this.frameFileNode.pointitem[i-1];
					var $b:FrameLinePointVo=this.frameFileNode.pointitem[i];
					
		
			
					var $num0:Number=$a.time*AppDataFrame.numW8+10
					var $num1:Number=$b.time*AppDataFrame.numW8-2

					if($a.isAnimation){
						this.bg.graphics.lineStyle(1,0x00ff00);
						
						this.bg.graphics.moveTo($num1-4,6);
						this.bg.graphics.lineTo($num1,10);
						this.bg.graphics.moveTo($num1-4,14);
						this.bg.graphics.lineTo($num1,10);
					
					}else{
						this.bg.graphics.lineStyle(1,0x000000);
					}
					this.bg.graphics.moveTo($num0,10);
					this.bg.graphics.lineTo($num1,10);
				}
			}

			
			this.width=$max+6
		
	
		}
		
	}
}
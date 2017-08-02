package mesh.ui
{
	import flash.events.MouseEvent;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	import vo.AlighNode;
	



	public class AlignRect extends BaseComponent
	{

		private var _iconBmp:PicBut;
		private var _align_but_1:PicBut;
		private var _align_but_2:PicBut;
		private var _align_but_3:PicBut;
		private var _align_but_4:PicBut;
		private var _align_but_5:PicBut;
		private var _align_but_6:PicBut;
		private var _align_but_7:PicBut;
		private var _align_but_8:PicBut;
		private var _align_but_9:PicBut;
		private var _align_but_10:PicBut;
		private var _align_but_11:PicBut;
		public function AlignRect()
		{
			super();
		
		
	
			addButAlign1();
			addButAlign2();
			addButAlign3()
			addButAlign4()
			addButAlign5()
			addButAlign6()
			addButAlign7()
			addButAlign8()
			addButAlign9()
			addButAlign10()
			addButAlign11()
			
			
			
			addEvents();
			this.height=200
			this.isDefault=false
			
		}
		
		private function addButAlign7():void
		{
			_align_but_7=new PicBut
			this.addChild(_align_but_7)
			_align_but_7.setBitmapdata(BrowerManage.getIcon("h5uia7"),20,20)
			
			_align_but_7.y=50-25
			_align_but_7.x=20
			
		}
		
		private function addButAlign8():void
		{
			_align_but_8=new PicBut
			this.addChild(_align_but_8)
			_align_but_8.setBitmapdata(BrowerManage.getIcon("h5uia8"),20,20)
			
			_align_but_8.y=50-25
			_align_but_8.x=50
			
		}
		
		private function addButAlign9():void
		{
			_align_but_9=new PicBut
			this.addChild(_align_but_9)
			_align_but_9.setBitmapdata(BrowerManage.getIcon("h5uia9"),20,20)
			
			_align_but_9.y=50-25
			_align_but_9.x=80
			
		}
		
		private function addButAlign10():void
		{
			_align_but_10=new PicBut
			this.addChild(_align_but_10)
			_align_but_10.setBitmapdata(BrowerManage.getIcon("h5uia10"),20,20)
			
			_align_but_10.y=75-50
			_align_but_10.x=20+90
			
		}
		
		private function addButAlign11():void
		{
			_align_but_11=new PicBut
			this.addChild(_align_but_11)
			_align_but_11.setBitmapdata(BrowerManage.getIcon("h5uia11"),20,20)
			
			_align_but_11.y=75-50
			_align_but_11.x=50+90
			
			
		}
		private function addButAlign4():void
		{
			_align_but_4=new PicBut
			this.addChild(_align_but_4)
			_align_but_4.setBitmapdata(BrowerManage.getIcon("h5uia4"),20,20)
			
			_align_but_4.y=25-25
			_align_but_4.x=20+90
			
		}
		private function addButAlign5():void
		{
			_align_but_5=new PicBut
			this.addChild(_align_but_5)
			_align_but_5.setBitmapdata(BrowerManage.getIcon("h5uia5"),20,20)
			
			_align_but_5.y=25-25
			_align_but_5.x=50+90
		}
		
		private function addButAlign6():void
		{
			_align_but_6=new PicBut
			this.addChild(_align_but_6)
			_align_but_6.setBitmapdata(BrowerManage.getIcon("h5uia6"),20,20)
			
			_align_but_6.y=25-25
			_align_but_6.x=80+90
		}
		
		
		
		private function addButAlign1():void
		{
			_align_but_1=new PicBut
			this.addChild(_align_but_1)
			_align_but_1.setBitmapdata(BrowerManage.getIcon("h5uia1"),20,20)
			
			_align_but_1.y=0
			_align_but_1.x=20
			
			
		}
		private function addButAlign2():void
		{
			_align_but_2=new PicBut
			this.addChild(_align_but_2)
			_align_but_2.setBitmapdata(BrowerManage.getIcon("h5uia2"),20,20)
			
			_align_but_2.y=0
			_align_but_2.x=50
			
			
		}
		private function addButAlign3():void
		{
			_align_but_3=new PicBut
			this.addChild(_align_but_3)
			_align_but_3.setBitmapdata(BrowerManage.getIcon("h5uia3"),20,20)
			
			_align_but_3.y=0
			_align_but_3.x=80
			
		}
		
		private function addEvents():void
		{
			_align_but_1.addEventListener(MouseEvent.CLICK,onMouseAlign1)
			_align_but_2.addEventListener(MouseEvent.CLICK,onMouseAlign2)
			_align_but_3.addEventListener(MouseEvent.CLICK,onMouseAlign3)
			_align_but_4.addEventListener(MouseEvent.CLICK,onMouseAlign4)
			_align_but_5.addEventListener(MouseEvent.CLICK,onMouseAlign5)
			_align_but_6.addEventListener(MouseEvent.CLICK,onMouseAlign6)
			_align_but_7.addEventListener(MouseEvent.CLICK,onMouseAlign7)
			_align_but_8.addEventListener(MouseEvent.CLICK,onMouseAlign8)
			_align_but_9.addEventListener(MouseEvent.CLICK,onMouseAlign9)
			_align_but_10.addEventListener(MouseEvent.CLICK,onMouseAlign10)
			_align_but_11.addEventListener(MouseEvent.CLICK,onMouseAlign11)
			
		}
		
		protected function onMouseAlign11(event:MouseEvent):void
		{
			
			var $arr:*=(this.target).selectItem
			var $sortArr:Array=new Array
			var $minX:Number
			var $maxX:Number
			var $tatolW:Number=0
			for(var i:uint=0;$arr&&i<$arr.length;i++)
			{
				var $px:Number=$arr[i].rect.x
				if($minX||$maxX){
					$minX=Math.min($minX,$px)
					$maxX=Math.max($maxX,$px+$arr[i].rect.width)
				}else{
					
					$minX=$px;
					$maxX=$px+$arr[i].rect.width;
				}
				$sortArr.push($arr[i])
				$tatolW+=$arr[i].rect.width;
			}
			$sortArr.sort(upperCaseFunc);
			function upperCaseFunc(a:AlighNode,b:AlighNode):int{
				var dis0:Number=a.rect.x+a.rect.width/2-$minX;
				var dis1:Number=b.rect.x+b.rect.width/2-$minX;
				return dis0-dis1;
			}
			var speedPos:Number=($maxX-$minX)-$tatolW
			var nextPos:Number=$minX
			for(var j:uint=0;j<$sortArr.length&&$sortArr.length>1;j++)
			{
				$sortArr[j].rect.x=nextPos;
				nextPos=$sortArr[j].rect.x+$sortArr[j].rect.width+(speedPos/($sortArr.length-1))

			}
			
			changeData()
			
		}
		private function changeData():void
		{
			target[FunKey]=true;
		}
		
		protected function onMouseAlign10(event:MouseEvent):void
		{
			
			
			var $arr:*=(this.target).selectItem
			var $sortArr:Array=new Array;
			var $minY:Number
			var $maxY:Number
			var $tatolW:Number=0
			for(var i:uint=0;$arr&&i<$arr.length;i++)
			{
				var $py:Number=$arr[i].rect.y
				if($minY||$maxY){
					$minY=Math.min($minY,$py)
					$maxY=Math.max($maxY,$py+$arr[i].rect.height)
				}else{
					
					$minY=$py;
					$maxY=$py+$arr[i].rect.height;
				}
				$sortArr.push($arr[i])
				$tatolW+=$arr[i].rect.height;
			}
			$sortArr.sort(upperCaseFunc);
			function upperCaseFunc(a:AlighNode,b:AlighNode):int{
				var dis0:Number=a.rect.y+a.rect.height/2-$minY;
				var dis1:Number=b.rect.y+b.rect.height/2-$minY;
				return dis0-dis1;
			}
			var speedPos:Number=($maxY-$minY)-$tatolW
			var nextPos:Number=$minY
			for(var j:uint=0;j<$sortArr.length&&$sortArr.length>1;j++)
			{
				$sortArr[j].rect.y=nextPos;
				nextPos=$sortArr[j].rect.y+$sortArr[j].rect.height+(speedPos/($sortArr.length-1))
	
			}
			
			changeData()
			
			
			
		}
		
		protected function onMouseAlign9(event:MouseEvent):void
		{
			onMouseAlign8(new MouseEvent(MouseEvent.CLICK))
			onMouseAlign7(new MouseEvent(MouseEvent.CLICK))
			
		}
		
		protected function onMouseAlign8(event:MouseEvent):void
		{
			
			var arr:*=(this.target).selectItem
			if(arr){
				var sh:Number
				for(var i:uint=0;i<arr.length;i++){
					if(sh){
						sh+=arr[i].rect.height;
					}else{
						sh=arr[i].rect.height;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.height=sh/arr.length
	
				}
				
			}
			changeData()
			
		}
		
		protected function onMouseAlign7(event:MouseEvent):void
		{
			
			
			var arr:*=(this.target).selectItem
			if(arr){
				var sw:Number
				for(var i:uint=0;i<arr.length;i++){
					if(sw){
						sw+=arr[i].rect.width;
					}else{
						sw=arr[i].rect.width;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.width=sw/arr.length
		
				}
				
			}
			
			changeData()
			
			
		}
		
		protected function onMouseAlign6(event:MouseEvent):void
		{
			var arr:*=(this.target).selectItem
			if(arr){
				var maxY:Number
				for(var i:uint=0;i<arr.length;i++){
					if(maxY){
						maxY=Math.max(maxY,arr[i].rect.y+arr[i].rect.height);
					}else{
						maxY=arr[i].rect.y+arr[i].rect.height;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.y=maxY-arr[j].rect.height;

				}
				
			}
			changeData()
		}
		
		protected function onMouseAlign5(event:MouseEvent):void
		{
			
			var arr:*=(this.target).selectItem
			if(arr){
				var centenY:Number
				for(var i:uint=0;i<arr.length;i++){
					
					if(centenY){
						centenY+=(arr[i].rect.y+arr[i].rect.height/2);
					}else{
						centenY=(arr[i].rect.y+arr[i].rect.height/2)
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.y=centenY/arr.length-arr[j].rect.height/2;
	
				}
				
			}
			
			changeData()
			
			
		}
		
		protected function onMouseAlign4(event:MouseEvent):void
		{
			var arr:*=(this.target).selectItem
			if(arr){
				var miny:Number
				for(var i:uint=0;i<arr.length;i++){
					if(miny){
						miny=Math.min(miny,arr[i].rect.y);
					}else{
						miny=arr[i].rect.y;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.y=miny;

				}
				
			}
			changeData()
			
		}
		
		protected function onMouseAlign3(event:MouseEvent):void
		{
			var arr:*=(this.target).selectItem
			if(arr){
				var maxX:Number
				for(var i:uint=0;i<arr.length;i++){
					if(maxX){
						maxX=Math.max(maxX,arr[i].rect.x+arr[i].rect.width);
					}else{
						maxX=arr[i].rect.x+arr[i].rect.width;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.x=maxX-arr[j].rect.width;

				}
				
			}
			changeData()
			
		}
		
		protected function onMouseAlign2(event:MouseEvent):void
		{
			var arr:*=(this.target).selectItem
			if(arr){
				var centenX:Number
				for(var i:uint=0;i<arr.length;i++){
					
					if(centenX){
						centenX+=(arr[i].rect.x+arr[i].rect.width/2);
					}else{
						centenX=(arr[i].rect.x+arr[i].rect.width/2)
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.x=centenX/arr.length-arr[j].rect.width/2;
	
				}
				
			}
			
			changeData()
			
		}
		
		protected function onMouseAlign1(event:MouseEvent):void
		{
			
			var arr:*=(this.target).selectItem
			if(arr){
				var minx:Number
				for(var i:uint=0;i<arr.length;i++){
					if(minx){
						minx=Math.min(minx,arr[i].rect.x);
					}else{
						minx=arr[i].rect.x;
					}
				}
				for(var j:uint=0;j<arr.length;j++){
					arr[j].rect.x=minx;
			
				}
				
			}
			changeData()
		}
		
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				var dde:Object=target[FunKey]
				//	setData(target[FunKey])
			}
			
		}
		
		
		
		
	}
}



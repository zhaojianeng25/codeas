package common.utils.ui.prefab
{
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import common.AppData;
	import common.utils.frame.BaseComponent;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.brower.fileWin.FileWinData;
	
	import proxy.top.model.IModel;
	
	public class AlignPanelPic extends BaseComponent
	{
		private var _iconBmp:PicBut;
		private var _align_a_but:PicBut;
		private var _align_b_but:PicBut;
		private var _align_c_but:PicBut;
		public function AlignPanelPic()
		{
			super();
			addButA()
			addButB()
			addButC()
			addEvents();
			this.height=200
			this.isDefault=false
		
		}
		private function addButA():void
		{
			_align_a_but=new PicBut
			this.addChild(_align_a_but)
			_align_a_but.setBitmapdata(BrowerManage.getIcon("align_a"),20,20)
			_align_a_but.y=0
			_align_a_but.x=20
			
			
		}
		private function addButB():void
		{
			_align_b_but=new PicBut
			this.addChild(_align_b_but)
			_align_b_but.setBitmapdata(BrowerManage.getIcon("align_b"),20,20)
			_align_b_but.y=0
			_align_b_but.x=50
			
			
		}
		private function addButC():void
		{
			_align_c_but=new PicBut
			this.addChild(_align_c_but)
			_align_c_but.setBitmapdata(BrowerManage.getIcon("align_c"),20,20)
			_align_c_but.y=0
			_align_c_but.x=80
			
			
		}
		private function addEvents():void
		{
			_align_a_but.addEventListener(MouseEvent.CLICK,onMouseAClik)
			_align_b_but.addEventListener(MouseEvent.CLICK,onMouseBClik)
			_align_c_but.addEventListener(MouseEvent.CLICK,onMouseCClik)
			
		}
		protected function onMouseCClik(event:MouseEvent):void
		{
			var $arr:Vector.<IModel>=target[FunKey]
            var baseY:Number
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(baseY){
					baseY+=$arr[i].y
				}else{
					baseY=$arr[i].y
				}
				trace($arr[i].y)
			}
			for(var j:uint=0;j<$arr.length;j++)
			{
				$arr[j].y=baseY/$arr.length
			}
			trace("------------")
			
		}
		protected function onMouseBClik(event:MouseEvent):void
		{
			var $arr:Vector.<IModel>=target[FunKey]
			var $sortArr:Vector.<IModel>=new Vector.<IModel>
			var $min:Vector3D
			var $max:Vector3D
			for(var i:uint=0;i<$arr.length;i++)
			{
				var $p:Vector3D=new Vector3D($arr[i].x,$arr[i].y,$arr[i].z)
				if($min||$max){
					$min.x=Math.min($min.x,$p.x)
					$min.y=Math.min($min.y,$p.y)
					$min.z=Math.min($min.z,$p.z)
						
					$max.x=Math.max($max.x,$p.x)
					$max.y=Math.max($max.y,$p.y)
					$max.z=Math.max($max.z,$p.z)
					
					
				}else{
					$min=$p.clone()
					$max=$p.clone()
				}
				$sortArr.push($arr[i])
			}
			
			$sortArr.sort(upperCaseFunc);
			function upperCaseFunc(a:IModel,b:IModel):int{
				var dis0:Number=Vector3D.distance(new Vector3D(a.x,a.y,a.z),($min))
				var dis1:Number=Vector3D.distance(new Vector3D(b.x,b.y,b.z),($min))
				return dis0-dis1;
			}
			
			
			var speedPos:Vector3D=$max.subtract($min)
				
			for(var j:uint=0;j<$sortArr.length;j++)
			{
				$sortArr[j].x=$min.x+speedPos.x*((j)/($sortArr.length-1))
				$sortArr[j].y=$min.y+speedPos.y*((j)/($sortArr.length-1))
				$sortArr[j].z=$min.z+speedPos.z*((j)/($sortArr.length-1))
			}
			
			
		}
		
		protected function onMouseAClik(event:MouseEvent):void
		{
			var $arr:Vector.<IModel>=target[FunKey]
			var $pos:Vector3D
			for(var i:uint=0;i<$arr.length;i++)
			{
				if($pos){
					$pos=$pos.add(new Vector3D($arr[i].x,$arr[i].y,$arr[i].z))
				}else
				{
					$pos=new Vector3D($arr[i].x,$arr[i].y,$arr[i].z)
				}
			}
			$pos.scaleBy(1/$arr.length)
			for(var j:uint=0;j<$arr.length;j++)
			{
				$arr[j].x=$pos.x
				$arr[j].y=$pos.y
				$arr[j].z=$pos.z
			}
			
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



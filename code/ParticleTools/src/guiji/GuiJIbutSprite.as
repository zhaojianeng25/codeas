package guiji
{
	import _Pan3D.base.Object3D;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GuiJIbutSprite extends MovieClip
	{
		private var an1:MovieClip;
		private var an0:MovieClip;
		private var OneguijiLizhiVO:GuijiLizhiVO;
		private var TwoguijiLizhiVO:GuijiLizhiVO;
		private var addNewPoint:MovieClip;
		private var delPoint:MovieClip;
		public function GuiJIbutSprite(preantDisplay:*)
		{
			preantDisplay.addChild(this)
		    addButs();
			addEvents();
			initData();
		}
		
		private function initData():void
		{
			OneguijiLizhiVO=new GuijiLizhiVO();
			var tempArr:Array;
			tempArr=new Array;
			tempArr.push(new Object3D(0,0,0))
			tempArr.push(new Object3D(100,0,100))
			tempArr.push(new Object3D(200,0,0))
			tempArr.push(new Object3D(300,0,0))
			tempArr.push(new Object3D(350,0,0))
			OneguijiLizhiVO.PointArr=tempArr
			OneguijiLizhiVO.id=0;
			OneguijiLizhiVO.midu=10;
			OneguijiLizhiVO.beginVector3D=new Vector3D(0,100,0)
			OneguijiLizhiVO.endVector3D=new Vector3D(0,-100,0)
			OneguijiLizhiVO.fun=oneFun;
			
			//
			TwoguijiLizhiVO=new GuijiLizhiVO();
			 tempArr=new Array;
			tempArr.push(new Object3D(400,0,0))
			tempArr.push(new Object3D(500,0,-0))
			tempArr.push(new Object3D(600,0,-0))
			tempArr.push(new Object3D(700,0,-0))
			tempArr.push(new Object3D(750,0,0))
			tempArr.push(new Object3D(800,0,0))
			TwoguijiLizhiVO.PointArr=tempArr
			TwoguijiLizhiVO.id=1;
			TwoguijiLizhiVO.midu=100;
			TwoguijiLizhiVO.beginVector3D=new Vector3D(0,0,-70)
			TwoguijiLizhiVO.endVector3D=new Vector3D(0,0,70)
			TwoguijiLizhiVO.fun=twoFun
			
		}
		
		private function addButs():void
		{
			an0=addTempBut(3,50," 第一个");
			an1=addTempBut(3,75," 第二个");
			
			
			addNewPoint=addTempBut(3,100," 加一点");
			delPoint=addTempBut(3,125," 删一点");
		
		}
		private function addTempBut(_x:Number=0,_y:Number=0,title:String="-"):MovieClip
		{
			var mc:MovieClip=new MovieClip;
			mc.graphics.beginFill(0x3300ee,1)
			mc.graphics.drawRect(0,0,50,20);
			var tempText:TextField=new TextField();
			tempText.width=100;
			tempText.height=20;
			tempText.htmlText=title;
			tempText.mouseEnabled=false;
			mc.addChild(tempText)
			mc.x=_x
			mc.y=_y
			this.addChild(mc);
			return mc;
		}
		
		private function addEvents():void
		{
			an0.addEventListener(MouseEvent.MOUSE_DOWN,an0Clik)
			an1.addEventListener(MouseEvent.MOUSE_DOWN,an1Clik)
			addNewPoint.addEventListener(MouseEvent.MOUSE_DOWN,addNewPointClik)
			delPoint.addEventListener(MouseEvent.MOUSE_DOWN,delPointClik)
			
		}
		
		protected function an0Clik(event:MouseEvent):void
		{
			GuijiLevel.Instance().setGuijiLizhiVO=OneguijiLizhiVO
		}
		private function oneFun(obj:GuijiLizhiVO):void
		{
	
		
		}
		private function twoFun(obj:GuijiLizhiVO):void
		{
	
			
		}
		protected function an1Clik(event:MouseEvent):void
		{

			GuijiLevel.Instance().setGuijiLizhiVO=TwoguijiLizhiVO
			
		}
		protected function addNewPointClik(event:MouseEvent):void
		{

			GuijiLevel.Instance().addNewPoint()
			
		}
		protected function delPointClik(event:MouseEvent):void
		{

			GuijiLevel.Instance().delePoint()
			
		}
	}
}
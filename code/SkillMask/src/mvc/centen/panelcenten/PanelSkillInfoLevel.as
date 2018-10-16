package mvc.centen.panelcenten
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	import mvc.top.OutTxtModel;
	
	public class PanelSkillInfoLevel extends UIComponent
	{
		private var _setItem:ArrayCollection;
		public function PanelSkillInfoLevel()
		{
			super();
		}

		public function get setItem():ArrayCollection
		{
			return _setItem;
		}

		public function set setItem(value:ArrayCollection):void
		{
			_setItem = value;
			clearLevel();
			for(var i:uint=0;i<_setItem.length;i++)
			{
				var $PanelRectInfoNode:PanelSkillMaskNode=_setItem[i]
				$PanelRectInfoNode.select=false
				this.addChild($PanelRectInfoNode.sprite)
				$PanelRectInfoNode.sprite.updata();
			
			}
		}
		public function addPanelRectInfoNode($PanelRectInfoNode:PanelSkillMaskNode):void
		{
			this.addChild($PanelRectInfoNode.sprite)
			$PanelRectInfoNode.sprite.updata();
		}
	
		private function clearLevel():void
		{
		
			while(this.numChildren){
			
				this.removeChildAt(0)
			}
		}
		public function expMask(panelNodeVo:PanelNodeVo,ctrlKey:Boolean):void
		{
			
			this.hideline(false);
			//trace(panelNodeVo.canverRect.width)
			var bmp:BitmapData=new BitmapData(panelNodeVo.canverRect.width,panelNodeVo.canverRect.height,true,0);
			bmp.draw(this);
			var $maskBitmapData:BitmapData=new BitmapData(panelNodeVo.canverRect.width,panelNodeVo.canverRect.height,false,0xffffffff);

			var aplpahBmp:BitmapData=new BitmapData(panelNodeVo.canverRect.width,panelNodeVo.canverRect.height,true,0);
			
		
			
			makeMaskDataToBmp(bmp,$maskBitmapData,aplpahBmp)
			this.makeBitmapline($maskBitmapData)
				
				
				
			var endBmp:BitmapData=new BitmapData($maskBitmapData.width*2,$maskBitmapData.height,true,0)
			//endBmp.draw(bmp)
			//endBmp.draw(aplpahBmp)
			var m:Matrix=new Matrix;
			m.tx=$maskBitmapData.width;
			endBmp.draw($maskBitmapData,m);
			ShowMc.getInstance().setBitMapData(endBmp);
			this.hideline(true);
			if(!ctrlKey){
				outStr()
			}
			
		}
		private function outStr():void
		{
			var str:String=""
			for(var i:Number=0;i<astartItem.length;i++)
			{
				for(var j:Number=0;j<astartItem[i].length;j++)
				{
					str+=astartItem[i][j]+", "
				}	
				str+="\n"
			}
			var temp:Array=new Array;
			this.dfs2(astartItem,(astartItem.length/2),0,0,temp);
			
			var ret:Array = new  Array;
			for ( i = 0; i < temp.length; i += 32) {
				var val:Number = 0;
				for ( j = Math.min(i+31, temp.length-1); j >= i; -- j) {
					val = (val * 2) + temp[j];
				}
				ret.push(val);
			}
			while(ret[ret.length-1]==0){
				ret.pop();
			}
			str+="\n";
			str+="\n";
			str+="\n";
			for(i=0;i<ret.length;i++){
				if(i>0){
					str+=",";
				}
				str+=ret[i];
			}
			
			OutTxtModel.getInstance().initSceneConfigPanel(str);
		}
		private function  dfs2( mask:Array,  offset:int,  x:int, y:int, data :Array):void {
			if (offset + x < 0) {
				return;
			}
			
			var  bx:int = Math.abs(x);
			var  by:int = Math.abs(y);
			// search top
			var i:int
			for ( i = x; i <= bx; ++ i) {
				data.push(mask[y+offset][i+offset]);
			}
			
			// search right
			for ( i = y + 1; i <= by; ++ i) {
				data.push(mask[i+offset][bx+offset]);
			}
			
			// search bottom
			for ( i = bx - 1; i >= x; -- i) {
				data.push(mask[by+offset][i+offset]);
			}
			
			// search left
			for ( i = by - 1; i >= y + 1; -- i) {
				data.push(mask[i+offset][x+offset]);
			}
			
			dfs2(mask, offset, x-1, y-1, data);
		}
		

		
		private function makeBaseArr(tw:Number,th:Number):void
		{
			astartItem=new Array
			for(var j:Number=0;j<th;j++){
				var temp:Array=new Array()
				for(var i:Number=0;i<tw;i++){
					temp.push(0)
				}
				astartItem.push(temp)
			}
		}
		private var astartItem:Array
		private function makeMaskDataToBmp(a:BitmapData,$dataBmp:BitmapData,c:BitmapData):void
		{
			var tw:Number=$dataBmp.width/10
			var th:Number=$dataBmp.height/10
			makeBaseArr(tw,th)
			var colorint:Number=0x000000
			
		
			for(var i:Number=0;i<tw;i++){
				for(var j:Number=0;j<th;j++){
					var $p:Point=new Point(i*10+5,j*10+5);
					//if(a.getPixel32($p.x,$p.y)!=0){

					if(this.isHaveMask(a,new Point(i*10,j*10))){
						$dataBmp.setPixel($p.x,$p.y,colorint)
						$dataBmp.fillRect(new Rectangle(i*10,j*10,10,10),colorint)
							
						c.fillRect(new Rectangle(i*10,j*10,10,10),0x55555555)
						c.setPixel($p.x-1,$p.y,0xff000000)
						c.setPixel($p.x+1,$p.y,0xff000000)
						c.setPixel($p.x,$p.y-1,0xff000000)
						c.setPixel($p.x,$p.y+1,0xff000000)
						c.setPixel($p.x,$p.y,0xff000000)
						astartItem[j][i]=1
					}else{
						c.fillRect(new Rectangle(i*10,j*10,10,10),0x55555555)
						c.setPixel($p.x-1,$p.y,0xffff0000)
						c.setPixel($p.x+1,$p.y,0xffff0000)
						c.setPixel($p.x,$p.y-1,0xffff0000)
						c.setPixel($p.x,$p.y+1,0xffff0000)
						c.setPixel($p.x,$p.y,0xffff0000)
						astartItem[j][i]=0
					}
				}
			}
			$dataBmp.fillRect(new Rectangle(int(tw/2)*10,int(th/2)*10,10,10),0xff0000)
		}
		private function isHaveMask(bmp:BitmapData,$p:Point):Boolean
		{
			//return bmp.getPixel32($p.x,$p.y)!=0
	
		
			var num:Number=0
			for(var i:Number=0;i<10;i++){
				for(var j:Number=0;j<10;j++){
					if(bmp.getPixel32($p.x+i,$p.y+j)!=0){
						num++
					}
				}
			
			}
			if(num>1){
				return true;
			}else{
				return false;
			}
				
				
			return true
		}
		
		private function makeBitmapline($bmp:BitmapData):void
		{
			var tw:Number=$bmp.width/10
			var th:Number=$bmp.height/10
			var colorint:Number=0xffffff*0.5
			for(var i:Number=0;i<tw;i++){
				$bmp.fillRect(new Rectangle(i*10,0,1,$bmp.height),colorint)
			}
			for(var j:Number=0;j<th;j++){
				$bmp.fillRect(new Rectangle(0,j*10,$bmp.width,1),colorint)
			}
		
		}
		private function hideline(value:Boolean):void
		{
			for(var i:uint=0;i<_setItem.length;i++)
			{
				var $PanelRectInfoNode:PanelSkillMaskNode=_setItem[i]
				$PanelRectInfoNode.sprite.hideLine(value)
			}
		}

	}
}
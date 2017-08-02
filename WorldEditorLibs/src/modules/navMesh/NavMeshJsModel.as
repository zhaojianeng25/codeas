package modules.navMesh
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.core.TestTriangle;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.collision.Display3DCollisionSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.display3D.navMesh.NavMeshDisplay3DSprite;
	import _Pan3D.display3D.water.ScanWaterHightMapModel;
	
	import _me.Scene_data;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import navMesh.NavMeshStaticMesh;
	
	import org.navmesh.geom.Triangle;
	import org.navmesh.geom.Vector2f;
	
	import pack.BuildMesh;
	
	import proxy.pan3d.ground.ProxyPan3dGround;
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.navMesh.ProxyPan3dNavMesh;
	import proxy.top.ground.IGround;
	
	import render.build.BuildManager;
	import render.ground.GroundManager;
	
	import terrain.GroundData;

	public class NavMeshJsModel
	{
		public function NavMeshJsModel()
		{
		}
		private static var instance:NavMeshJsModel;
		public static function getInstance():NavMeshJsModel{
			if(!instance){
				instance = new NavMeshJsModel();
			}
			return instance;
		}
		public function setTirItem( $vecTri:Vector.<Triangle>,$proxyPan3dNavMesh:ProxyPan3dNavMesh):void
		{
	
			var $infoRect:Rectangle=this.getAstarRect($vecTri);
			this._infoRect=$infoRect.clone()
	        
			this.scanGroundHigth($infoRect);
			this.changeNavMeshTriHigth($proxyPan3dNavMesh.navMeshStaticMesh)
				
			$proxyPan3dNavMesh.navMeshDisplay3DSprite.refeshData()



		}
	
	    private var astarMd:Number=10
		public function restAstartData($vecTri:Vector.<Triangle>,$baseVectItem:Vector.<Vector3D>,$proxyPan3dNavMesh:ProxyPan3dNavMesh,$jumpVecTri:Vector.<Triangle>):void
		{
			
			trace("$jumpVecTri",$jumpVecTri)
			var $navMeshStaticMesh:NavMeshStaticMesh=$proxyPan3dNavMesh.navMeshStaticMesh;
			this.astarMd=$navMeshStaticMesh.midu;
			var $infoRect:Rectangle=this.getAstarRect($vecTri);
	
			
			this._infoRect=$infoRect.clone();
			this.scanGroundHigth($infoRect);
			
			//ShowMc.getInstance().setBitMapData(this._dephtBmp)

			
			var md:Number=$navMeshStaticMesh.midu;
			var w:Number=Math.floor($infoRect.width/md)
			var h:Number=Math.floor($infoRect.height/md)
			$navMeshStaticMesh.aPos=new Vector3D($infoRect.x,0,$infoRect.y)
			$navMeshStaticMesh.astarItem=new Array();	
			$navMeshStaticMesh.heightItem=new Array();	
			
			var objVectItem:Vector.<Vector3D>=new Vector.<Vector3D>;
			for (var i: Number = 0; i < w; i++) {
				var $aItem:Array=new Array()
				var $hItem:Array=new Array()
				for (var j: Number = 0; j <h; j++) {
					
					var $pos:Vector3D=new Vector3D;
					$pos.x = i * md +$infoRect.x
	
					$pos.z = j * md  +$infoRect.y
					
					$pos.y=this.getHightData(new Vector3D($pos.x+md/2,$pos.y,$pos.z+md/2))
						
					//$pos.y = 0
						
					var a:Vector3D=new Vector3D	($pos.x,$pos.y,$pos.z);
					var b:Vector3D=new Vector3D	($pos.x+md,$pos.y,$pos.z);
					var c:Vector3D=new Vector3D	($pos.x+md,$pos.y,$pos.z+md);
					var d:Vector3D=new Vector3D	($pos.x,$pos.y,$pos.z+md);
					
					var $rect:Rectangle=new Rectangle($pos.x,$pos.z,md,md)
					
				
					if(($pos.y>-(scanHeightNum/2-1))&&this.testRectInVectItem($rect,$vecTri))
					{
						objVectItem.push(a,b,c)
						objVectItem.push(a,c,d)
						$aItem.push(1)
					}else{
						$aItem.push(0)
					}
					$hItem.push($pos.y)
				}
				
				$navMeshStaticMesh.astarItem.push($aItem)
				$navMeshStaticMesh.heightItem.push($hItem)
			
			}
			//this.smoothHight($navMeshStaticMesh)
			$navMeshStaticMesh.jumpItem=null
			if($jumpVecTri){
				this.findJumpAre($jumpVecTri,$navMeshStaticMesh,$proxyPan3dNavMesh.navMeshDisplay3DSprite) //原来画A星数据
			}else{
				$proxyPan3dNavMesh.navMeshDisplay3DSprite.makeNewLine($navMeshStaticMesh);//加入跳点区域为不可走的区域
			}
				
			this.specialChangeheightItem($navMeshStaticMesh.heightItem)
				
			var $tipStr:String="宽x"+w+"宽x"+h;
			Alert.show($tipStr)
				
		}
		private function findJumpAre($jumpVecTri:Vector.<Triangle>,$navMeshStaticMesh:NavMeshStaticMesh,mc:NavMeshDisplay3DSprite):void
		{
			var w: Number = $navMeshStaticMesh.heightItem.length;
			var h: Number = $navMeshStaticMesh.heightItem[0].length;
			var midu: Number = $navMeshStaticMesh.midu;
			var aPos: Vector3D = $navMeshStaticMesh.aPos;
			
			var vecItem: Vector.<Vector3D> = new Vector.<Vector3D>
			var ty: Number = 0;
			for (var i: Number = 0; i < w; i++) {
				for (var j: Number = 0; j < h; j++) {
					ty = $navMeshStaticMesh.heightItem[i][j];
					var pos: Vector3D = new Vector3D(i * midu, ty, j * midu);
					pos.x = pos.x + aPos.x;
					pos.z = pos.z + aPos.z;
					vecItem.push(pos);
					
					if (i < 2 || j < 2 || i > (w - 2) || j > (h - 2)) {
						//	$navMeshStaticMesh.astarItem[i][j] = 0  //特殊边缘为不可寻走
					}
					
				}
			}
			mc.lingSprite.clear()
			mc.refeshData();
			$navMeshStaticMesh.jumpItem=this.copyItem($navMeshStaticMesh.astarItem);
			for (i = 0; i < w - 1; i++) {
				for (j = 0; j < h - 1; j++) {
					var a: Number = i * h + j;
					var b: Number = a + 1
					var c: Number = a + 1 + h
					var d: Number = a + h
					$navMeshStaticMesh.jumpItem[i][j]=0
					if ($navMeshStaticMesh.astarItem[i][j] == 1) {
					
						var $thickness:Number=3;
						var $color:Vector3D=new Vector3D(1,1,1,1);
				
						if(this.inJumpAreByPos(vecItem[a],$jumpVecTri)){
							$navMeshStaticMesh.jumpItem[i][j]=1
							$color=new Vector3D(0,1,0,1);
							mc.lingSprite.makeLineMode(vecItem[a], vecItem[c],$thickness,$color);
							mc.lingSprite.makeLineMode(vecItem[b], vecItem[d],$thickness,$color);
						}
					
						mc.lingSprite.makeLineMode(vecItem[a], vecItem[b],$thickness,$color);
						mc.lingSprite.makeLineMode(vecItem[a], vecItem[d],$thickness,$color);
						
						if ($navMeshStaticMesh.astarItem[i + 1][j] == 0) {
							mc.lingSprite.makeLineMode(vecItem[c], vecItem[d],$thickness,$color);
						}
						if ($navMeshStaticMesh.astarItem[i][j + 1] == 0) {
							mc.lingSprite.makeLineMode(vecItem[b], vecItem[c],$thickness,$color);
						}
					   
						
						
					}
				}
			}
			mc.lingSprite.reSetUplodToGpu();
			//Triangle
//			for(var i:Number=0;i<$jumpVecTri.length;i++){
//	
//			}
		}
		private function inJumpAreByPos($pos:Vector3D, $jumpVecTri:Vector.<Triangle>):Boolean
		{
			for(var i:Number=0;i<$jumpVecTri.length;i++){
				if($jumpVecTri[i].isPointIn(new Vector2f($pos.x,$pos.z))){
					return true;
				}
			}
			return false
		}
		
	
		
		
		private function getRoundHeight($baseAstarItem:Array,$baseHeightItem:Array,$tx:Number,$ty:Number):Number
		{
			

			
			var $item:Vector.<Point>=new Vector.<Point>
			
			
			$item.push(new Point($tx-1,$ty-1));
			$item.push(new Point($tx,$ty-1));
			$item.push(new Point($tx+1,$ty-1));
			
			$item.push(new Point($tx-1,$ty));
			$item.push(new Point($tx+1,$ty));
			
			$item.push(new Point($tx-1,$ty+1));
			$item.push(new Point($tx,$ty+1));
			$item.push(new Point($tx+1,$ty+1));
			
			var addNum:Number=0;
			var totalNum:Number=0
			for(var i:Number=0;i<$item.length;i++){
				var pos:Point=$item[i]
				if($baseAstarItem[pos.x]&&$baseAstarItem[pos.x][pos.y]){
					addNum++
					totalNum+=	$baseHeightItem[pos.x][pos.y]
				}
			}
			if(addNum>0){
				return totalNum/addNum;
			}
			
			return -999999
		}
		private function  smoothHight($navMeshStaticMesh:NavMeshStaticMesh):void
		{
			var w:Number=$navMeshStaticMesh.astarItem.length
			var h:Number=$navMeshStaticMesh.astarItem[0].length
			var $baseAstarItemOld:Array=this.copyItem($navMeshStaticMesh.astarItem)
			var $baseHeightItemOld:Array=this.copyItem($navMeshStaticMesh.heightItem)

				
				
			var $baseAstarItemNew:Array=this.copyItem($baseAstarItemOld)
			var $baseHeightItemNew:Array=this.copyItem($baseHeightItemOld)
				
				
			var needNext:Boolean=true;
			var mashId:Number=0;
			
			var $nextNum:Number=0
			
			while(needNext){
			
				needNext=false;
				for(var i1:Number=0;i1<w;i1++){
					for(var j1:Number=0;j1< h;j1++){
						 if($baseAstarItemOld[i1][j1]==0){
							 var $th:Number=this.getRoundHeight($baseAstarItemOld,$baseHeightItemOld,i1,j1)
							 if($th==-999999){
								 //还得重来
								 needNext=true
							 }else{
								 $baseAstarItemNew[i1][j1]=1;
								 $baseHeightItemNew[i1][j1]=$th;
							 }
							
						 }
					}
				}
				$baseAstarItemOld=this.copyItem($baseAstarItemNew);
				$baseHeightItemOld=this.copyItem($baseHeightItemNew);
				
				$nextNum++
				trace("$nextNum",$nextNum)
				if($nextNum>1000){
	
					needNext=false
					Alert.show("可能有错，确定所有地面包围盒有显示正确")
				}
			//	trace("-----------"+mashId+++"---------")
			}
		
			//$navMeshStaticMesh.astarItem=$baseAstarItemOld;
			$navMeshStaticMesh.heightItem= $baseHeightItemOld;
			
		}
		private function copyItem($base:Array):Array
		{
			var $backArr:Array=new Array
			for(var i:Number=0;i<$base.length;i++){
				$backArr.push(new Array)
				for(var j:Number=0;j< $base[i].length;j++){
					$backArr[i].push($base[i][j]) 
				}
			}
			
			return $backArr
		}
		//如果没有扫描到有高度。那就自动填补。这一目的是为让边缘能取到正确的高度
		private function specialChangeheightItem($heightItem:Array):void
		{
			var kNum:Number=-(scanHeightNum/2-1);  //最低的位置
			for(var i:uint=0;i<$heightItem.length;i++){
				for(var j:uint=0;j<$heightItem[i].length;j++){
					if($heightItem[i][j]<=kNum){
						$heightItem[i][j]=getRoundNearH(i,j);
					}
				}
			}
			function getRoundNearH($ii:int,$jj:int):Number
			{
				var temp:Number
				if($ii>=1){//左上
					if($jj>=1){
						temp=$heightItem[$ii-1][$jj-1]
						if(temp>kNum){
							return temp
						}
					}
				}
				if($ii>=1){//左中
					temp=$heightItem[$ii-1][$jj]
					if(temp>kNum){
						return temp
					}
				}
				if($ii>=1){//左下
					if($jj<$heightItem[0].length-1){
						temp=$heightItem[$ii-1][$jj+1]
						if(temp>kNum){
							return temp
						}
					}
				}
				
	
					if($jj>=1){  //上
						temp=$heightItem[$ii][$jj-1]
						if(temp>kNum){
							return temp
						}
					}
		
					if($jj<$heightItem[0].length-1){ //下
						temp=$heightItem[$ii][$jj+1]
						if(temp>kNum){
							return temp
						}
					}
		
					
					
					/*****/
					
					if($ii<$heightItem.length-1){//右上
						if($jj>=1){
							temp=$heightItem[$ii+1][$jj-1]
							if(temp>kNum){
								return temp
							}
						}
					}
					if($ii<$heightItem.length-1){//右上
						temp=$heightItem[$ii+1][$jj]
						if(temp>kNum){
							return temp
						}
					}
					if($ii<$heightItem.length-1){//右上
						if($jj<$heightItem[0].length-1){
							temp=$heightItem[$ii+1][$jj+1]
							if(temp>kNum){
								return temp
							}
						}
					}
				
				
				
			
				return kNum
			}
			
		
		}
			
			



		private function changeNavMeshTriHigth($navMeshStaticMesh:NavMeshStaticMesh):void
		{
			var _item:*=$navMeshStaticMesh.listData
			for(var i:Number=0;i<_item.length;i++)
			{
		
					
				for(var j:Number=0;j<_item[i].data.length;j++){
					
			
					
					_item[i].data[j].y=this.getHightData(new Vector3D(_item[i].data[j].x,_item[i].data[j].y,_item[i].data[j].z))
					
				}
				
			}
			
		}
		private var _infoRect:Rectangle;
		private var _hightRectInfo:Rectangle;
		private var _dephtBmp:BitmapData;
		private function scanGroundHigth($infoRect:Rectangle):void
		{
			_hightRectInfo=$infoRect.clone()
			_hightRectInfo.x-=1
			_hightRectInfo.y-=1
			_hightRectInfo.width+=2
			_hightRectInfo.height+=2
	
			var $w:uint=512;
			var $pos:Vector3D=new Vector3D(_hightRectInfo.x+_hightRectInfo.width/2,scanHeightNum/2,_hightRectInfo.y+_hightRectInfo.height/2,scanHeightNum);
			var $rect:Rectangle=new Rectangle(0,0,_hightRectInfo.width/2,_hightRectInfo.height/2);
			this._dephtBmp=this.scanGroundAndBuildHightMap($pos,$rect,Math.max($w,64));
		//	ShowMc.getInstance().setBitMapData(_dephtBmp)
				
			if(Display3DModelSprite.collistionState){ 
				ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SHOW_SCENE_COLLISTION));
			}
		}
		public  function scanGroundAndBuildHightMap($pos:Vector3D,$rect:Rectangle,$textureSize:Number):BitmapData
		{
			var $arr:Vector.<Display3DSprite>;
	
		    $arr=getScanModelItem();
		
			return ScanWaterHightMapModel.getInstance().scanHightBitmap($pos,$rect,$textureSize,$arr)
			
			
		}

		private  function getScanModelItem():Vector.<Display3DSprite>
		{
			var $arr:Vector.<Display3DSprite>=new Vector.<Display3DSprite>
			
			for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
			{
				var $sprite:ProxyPan3dGround=ProxyPan3dGround($IGround )
		
				if(GroundData.showTerrain){
					$arr.push($sprite.ground)
				}
				
			}
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(BuildManager.getInstance().listArr)
			for(var i:uint=0;i<$item.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$item[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					
					var $buildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh
					var $proxyPan3dModel:ProxyPan3dModel=$hierarchyFileNode.iModel as ProxyPan3dModel
						
					if($buildMesh.isGround){
						if($proxyPan3dModel&&$proxyPan3dModel.sprite){
							$arr.push($proxyPan3dModel.sprite)
						}
					}else{
					
					
						if($proxyPan3dModel.sprite.objData.isField&&$proxyPan3dModel.sprite.display3DCollistionGrop){
							var item:Vector.<Display3DCollisionSprite>=$proxyPan3dModel.sprite.display3DCollistionGrop.item;
							for each(var $display3DCollisionSprite:Display3DCollisionSprite in item){
								var $tempDis:Display3DSprite=new Display3DSprite(Scene_data.context3D)
								$tempDis.posMatrix=$display3DCollisionSprite.modelMatrix.clone();
								$tempDis.objData=$display3DCollisionSprite.objData
								$arr.push($tempDis)
							}
						}
				
					
					}
				
				}
			}
				
			return $arr
		}
		private var scanHeightNum:Number=1600 //800
		
		private function getHightData($pos:Vector3D):Number
		{
			var kpos:Vector3D=new Vector3D($pos.x- _hightRectInfo.x,0,$pos.z- _hightRectInfo.y)
		
			var tx:Number=	kpos.x/_hightRectInfo.width*_dephtBmp.width;
			var tz:Number=	kpos.z/_hightRectInfo.height*_dephtBmp.height;
				
			var p:Vector3D=MathCore.hexToArgb(_dephtBmp.getPixel32(int(tx), int(tz)))
	
	
			return (scanHeightNum/2-p.x/255*scanHeightNum)+1
		
		}

			
		private function getAstarRect($vecTri:Vector.<Triangle>):Rectangle
		{
			var $min:Point
			var $max:Point
			for(var i:Number=0;i<$vecTri.length;i++){
				
				var a:Point=new Point($vecTri[i].pointA.x,$vecTri[i].pointA.y)
				var b:Point=new Point($vecTri[i].pointB.x,$vecTri[i].pointB.y)
				var c:Point=new Point($vecTri[i].pointC.x,$vecTri[i].pointC.y)
			
				if(!$min){
					$min=a.clone()
				}	
				if(!$max){
					$max=a.clone()
				}	
					
				if($min.x>a.x){
					$min.x=a.x
				}
				if($min.x>b.x){
					$min.x=b.x
				}
				if($min.x>c.x){
					$min.x=c.x
				}
				
				if($min.y>a.y){
					$min.y=a.y
				}
				if($min.y>b.y){
					$min.y=b.y
				}
				if($min.y>c.y){
					$min.y=c.y
				}
				
				
				if($max.x<a.x){
					$max.x=a.x
				}
				if($max.x<b.x){
					$max.x=b.x
				}
				if($max.x<c.x){
					$max.x=c.x
				}
				
				
				if($max.y<a.y){
					$max.y=a.y
				}
				if($max.y<b.y){
					$max.y=b.y
				}
				if($max.y<c.y){
					$max.y=c.y
				}
				
				
			
				
			}
		    //整化
			var md:Number=this.astarMd*3
			$min.x-=md
			$min.y-=md;
			$max.x+=md;
			$max.y+=md;
		
	
			return new Rectangle($min.x,$min.y,$max.x-$min.x,$max.y-$min.y)
		}
		private function testRectInVectItem($rect:Rectangle,$vecTri:Vector.<Triangle>):Boolean
		{
			
			var $isHit:Boolean=false
			for(var i:Number=0;i<$vecTri.length;i++){
			
				var a:Point=new Point($vecTri[i].pointA.x,$vecTri[i].pointA.y)
				var b:Point=new Point($vecTri[i].pointB.x,$vecTri[i].pointB.y)
				var c:Point=new Point($vecTri[i].pointC.x,$vecTri[i].pointC.y)
					
				if(this.triHitBox(a,b,c,$rect)){
					$isHit=true
					i=$vecTri.length
				}
			
			}
			
		
			return $isHit
		}
		
		
		private var _triangleClass:TestTriangle=new TestTriangle()
		private function triHitBox(a:Point,b:Point,c:Point,rect:Rectangle):Boolean
		{
			if(lineHitBox(a,b,rect)){
			   return true
			}
			
			if(lineHitBox(a,c,rect)){
			
				return true
			}
		     if(lineHitBox(b,c,rect)){
				 return true 
			 }
			
			_triangleClass.setAllPoint(a,b,c)
			if(	_triangleClass.checkPointIn(new Point(rect.x,rect.y))){
				return true
			}
			if(	_triangleClass.checkPointIn(new Point(rect.x+rect.width,rect.y))){
				return true
			}
			if(	_triangleClass.checkPointIn(new Point(rect.x+rect.width,rect.y+rect.height))){
				return true
			}
			if(	_triangleClass.checkPointIn(new Point(rect.x,rect.y+rect.height))){
				return true
			}

			return false
		}
		private function lineHitBox(a:Point,b:Point,rect:Rectangle):Boolean
		{
		
			var temp:Boolean=isLineIntersectRectangle(a.x,a.y,b.x,b.y,rect.x,rect.y,rect.x+rect.width,rect.y+rect.height)
			return temp
		}
		private function isLineIntersectRectangle(linePointX1:Number,
												  linePointY1:Number,
												  linePointX2:Number,
												  linePointY2:Number,
												  rectangleLeftTopX:Number,
												  rectangleLeftTopY:Number,
												  rectangleRightBottomX:Number,
												  rectangleRightBottomY:Number):Boolean
		{
			var  lineHeight:Number = linePointY1 - linePointY2;
			var lineWidth:Number = linePointX2 - linePointX1;  // 计算叉乘 
			var c:Number = linePointX1 * linePointY2 - linePointX2 * linePointY1;
			if ((lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c <= 0)   
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c >= 0)   
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c <= 0)   
				|| (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c >= 0))
			{
				
				if (rectangleLeftTopX > rectangleRightBottomX) {
					var temp:Number = rectangleLeftTopX;
					rectangleLeftTopX = rectangleRightBottomX;
					rectangleRightBottomX = temp;  
				}  
				if (rectangleLeftTopY < rectangleRightBottomY) {
					var temp1:Number = rectangleLeftTopY;   
					rectangleLeftTopY = rectangleRightBottomY;   
					rectangleRightBottomY = temp1;   }  
				if ((linePointX1 < rectangleLeftTopX && linePointX2 < rectangleLeftTopX)     
					|| (linePointX1 > rectangleRightBottomX && linePointX2 > rectangleRightBottomX)     
					|| (linePointY1 > rectangleLeftTopY && linePointY2 > rectangleLeftTopY)     
					|| (linePointY1 < rectangleRightBottomY && linePointY2 < rectangleRightBottomY)) {   
					return false;  
				} else {   
					return true;  
				} 
			} else { 
				return false; 
			}
		}
	}
}
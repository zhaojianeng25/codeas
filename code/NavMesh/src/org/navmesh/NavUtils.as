package org.navmesh
{
	import flash.utils.getTimer;
	
	import org.navmesh.findPath.Cell;
	import org.navmesh.geom.Delaunay;
	import org.navmesh.geom.Polygon;
	import org.navmesh.geom.Triangle;
	
	/**
	 * 寻路工具 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class NavUtils
	{
		private var polygonV:Vector.<Polygon>;		//所有多边形
		private var triangleV:Vector.<Triangle>; 	//生成的Delaunay三角形
		
		public var cellV:Vector.<Cell>;		//已生成的寻路数据
		
		public function NavUtils()
		{
		}
		
		public function buildTriangle($polygonV:Vector.<Polygon>):Vector.<Triangle> {
			polygonV = $polygonV;
			
			var timer:int = getTimer();
			this.unionAll();
			
			
			var d:Delaunay = new Delaunay();
			triangleV = d.createDelaunay(polygonV);
			
			
			
			//构建寻路数据
			cellV = new Vector.<Cell>();
			var trg:Triangle;
			var cell:Cell;
			for (var j:int=0; j<triangleV.length; j++) {
				trg = triangleV[j];
				cell = new Cell(trg.getVertex(0), trg.getVertex(1), trg.getVertex(2));
				cell.index = j;
				cellV.push(cell);
				
			}
			trace("创建用时：" + (getTimer() - timer))
			
			timer = getTimer();
			
			linkCells(cellV);
			trace("连接用时：" + (getTimer() - timer))
			
			return triangleV;
		}
		
		private function unionAll():void {
			for (var n:int=1; n<polygonV.length; n++) {
				var p0:Polygon = polygonV[n];
				for (var m:int=1; m<polygonV.length; m++) {
					var p1:Polygon = polygonV[m];
					//					trace("p0", p0.isCW(), p0);
					//					trace("p1", p1.isCW(), p1);
					if (p0 != p1 && p0.isCW() && p1.isCW()) {
						var v:Vector.<Polygon> = p0.union(p1);	//合并
						
						if (v != null && v.length > 0) {
							trace("delete");
							polygonV.splice(polygonV.indexOf(p0), 1);
							polygonV.splice(polygonV.indexOf(p1), 1);
							
							for each (var pv:Polygon in v) {
								polygonV.push(pv);
							}
							
							n = 1;	//重新开始
							break;
						}
					}
				}
			}
		}
		
		/**
		 * 搜索单元网格的邻接网格，并保存链接数据到网格中，以提供给寻路用
		 * @param pv
		 */		
		public function linkCells(pv:Vector.<Cell>):void {
			for each (var pCellA:Cell in pv) {
				for each (var pCellB:Cell in pv) {
					if (pCellA != pCellB) {
						pCellA.checkAndLink(pCellB);
					}
				}
			}
		}
		
		
		
		
		
		
	}
}
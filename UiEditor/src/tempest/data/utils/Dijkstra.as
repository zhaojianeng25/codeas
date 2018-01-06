package tempest.data.utils
{


	/**
	 *
	 */
	public class Dijkstra
	{
		public static const NO_PATH:int=int.MAX_VALUE;

		public function Dijkstra()
		{
		}

		//从某一源点出发，找到到某一结点的最短路径
		public static function getShortedPath(G:Array, star:int, end:int, maxlong:int=1000):Object
		{
			var len:int=G.length; //G记录了所有节点到它的下一节点的距离
			var s:Array=new Array();
			var min:int;
			var curNode:int=0;
			var dist:Array=new Array();
			var prev:Array=new Array();

			var path:Array=new Array();

			for (var v:int=0; v < len; v++) //找出起点的所有下个点
			{
				s[v]=false;
				dist[v]=G[star][v]; //记录从开始节点到当前节点的路程  如果不能通过就为int.MAXVALUE
				if (dist[v] > maxlong)
				{
					prev[v]=0;
				}
				else
				{
					prev[v]=star;
				}
			}
			path[0]=end;
			dist[star]=0; //
			s[star]=true; //记录从开始节点到最后节点中找出的所有的最短节点

			for (var i:int=1; i < len; i++)
			{
				min=maxlong; //记录走到当前节点的所有路程长度
				for (var w:int=0; w < len; w++) //找出当前节点到下一节点的最短路径  
				{
					if ((!s[w]) && (dist[w] < min)) //会过滤已记录为路点的节点
					{
						curNode=w;
						min=dist[w];
					}
				}
				s[curNode]=true;
				for (var j:int=0; j < len; j++) //记录当前节点到下一节点的所有路程
				{
					if ((!s[j]) && ((min + G[curNode][j]) < dist[j])) //会过滤已记录为路点的节点;
					{
						dist[j]=min + G[curNode][j];
						prev[j]=curNode; //记录下一节点的前一个节点
					}
				}
			}

			var e:int=end;
			var step:int=0;
			const maxTitl:uint=3000;
			var curTitl:uint=0;
			while (e != star)
			{
				curTitl++;
				if (curTitl > maxTitl)
				{
					//currentDomain.alert.show("Dijkstra.getShortedPath异常，超过了循环最大限制。");
					return {dist: dist[end], path: []};
				}

				step++;
				path[step]=prev[e];
				e=prev[e];
			}
			for (var q:int=step; q > (step / 2); q--)
			{
				var temp:int=path[step - q];
				path[step - q]=path[q];
				path[q]=temp;
			}
			return {dist: dist[end], path: path};
		}



		//从某一源点出发,找出到所有节点的最短路径
		public static function getShortedPathList(G:Array, star:int, maxlong:int=1000):Object
		{
			var len:int=G.length;
			var pathID:Array=new Array(len);
			var s:Array=new Array(len);
			var max:int;
			var curNode:int=0;
			var dist:Array=new Array(len);
			var prev:Array=new Array(len);

			var path:Array=new Array();
			for (var n:int=0; n < len; n++)
			{
				path[path.length]=[];
			}

			for (var v:int=0; v < len; v++)
			{
				s[v]=false;
				dist[v]=G[star][v];
				if (dist[v] > maxlong)
				{
					prev[v]=0;
				}
				else
				{
					prev[v]=star;
				}
				path[v][0]=v;
			}
			dist[star]=0;
			s[star]=true;

			for (var i:int=1; i < len; i++)
			{
				max=maxlong;
				for (var w:int=0; w < len; w++)
				{
					if ((!s[w]) && (dist[w] < max))
					{
						curNode=w;
						max=dist[w];
					}
				}
				s[curNode]=true;
				for (var j:int=0; j < len; j++)
				{
					if ((!s[j]) && ((max + G[curNode][j]) < dist[j]))
					{
						dist[j]=max + G[curNode][j];
						prev[j]=curNode;
					}
				}
			}

			for (var k:int=0; k < len; k++)
			{
				var e:int=k;
				var step:int=0;
				const maxTitl:uint=3000;
				var curTitl:uint=0;
				while (e != star)
				{
					curTitl++;
					if (curTitl > maxTitl)
					{
						//currentDomain.alert.show("Dijkstra.getShortedPath异常，超过了循环最大限制。");
						return {dist: dist, path: []};
					}
					step++;
					path[k][step]=prev[e];
					e=prev[e];
				}
				for (var p:int=step; p > (step / 2); p--)
				{
					var temp:int=path[k][step - p];
					path[k][step - p]=path[k][p];
					path[k][p]=temp;
				}
			}
			return {dist: dist, path: path};
		}
	}
}

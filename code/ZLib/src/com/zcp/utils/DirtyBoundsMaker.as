package com.zcp.utils
{
	import com.zcp.vo.Bounds;
	import com.zcp.vo.LNode;

	/**
	 * 脏矩形(此处为线性双向链表)
	 * @author zcp
	 */
	public class DirtyBoundsMaker
	{
		/**
		 * @private
		 * 第一个 
		 */
		private var first:LNode;
		/**
		 * @private
		 * 最后一个 
		 */
		private var last:LNode;
		/**
		 * @private
		 * 从该位置开始比较
		 */
		private var beginLN:LNode;
		public function DirtyBoundsMaker()
		{
			
		}
		/**
		 * 清空
		 */
		public function clear():void
		{
			first = null;
			last = null;
			beginLN = null;
			return;
		}
		
		/**
		 * 添加一个Bounds
		 * @parm $b
		 * @parm $beginFrist 是否从头开始检测
		 */
		public function addBounds($b:Bounds, $beginFrist:Boolean=false):void
		{
			
//			if(!first)
//			{
//				first = new LNode($b);
//			}
//			else
//			{
//				(first.data as Bounds).extend($b);
//			}
//			return;
			
			var head:LNode = $beginFrist? first : (beginLN || first);
			//如果head存在
			if(head!=null)
			{
				//遍历链表
				while(head!=null)
				{
					//取出head的Bounds
					var b:Bounds = head.data as Bounds;
					
					//如果b.bottom<=$b.top,则直接循环next
					if(b.bottom<=$b.top)
					{
						//向下循环
						head = head.next;
						continue;
					}
						//如果b.top>=$b.bottom,则直接添加，并直接返回
					else if(b.top>=$b.bottom)
					{
						add(new LNode($b),head.pre);
						return;
					}
						//否则判断是否有交集，有就递归添加并跳出循环，否则继续循环
					else
					{
						//如果有交集就添加，并直接返回
						if(b.intersects($b))
						{	
							var ib:Bounds = b.intersection($b);
							
							//如果新添加进来的角色已经全包含在已有角色之中,则不处理
							if(ib.equals($b))
							{
								
							}
							//如果新添加进来的角色全包含已经存在的角色b，则移除原角色，并添加新角色
							else if(ib.equals(b))
							{
								//移除当前的
								remove(head);
								//如果不是末尾则递归添加
								if(beginLN!=null)
								{
									addBounds($b);
								}
									//否则直接添加到末尾
								else
								{
									add(new LNode($b),last);
								}
							}
								//否则直接合并
							else
							{
								var ub:Bounds = b.union($b);
								//移除当前的
								remove(head);
								beginLN = first;//注意这里，去并集的时候需要重新从头开始比较
								//如果不是末尾则递归添加
								if(beginLN!=null)
								{
									addBounds(ub);
								}
									//否则直接添加到末尾
								else
								{
									add(new LNode(ub),last);
								}
							}
							//							//如果新添加进来为一条线，先忽略
							//							else if(ib.isLine())
							//							{
							//								//..........
							//							}
							//							//如果新添加进来的角色面积大于原来的两个矩形任何的0.3，则取并集(此处的面积算法可优化--预存)
							//							else if(ib.areaSize()>$b.areaSize()*0.02 || ib.areaSize()>b.areaSize()*0.02)
							//							{
							//								var ub:Bounds = b.union($b);
							//								//移除当前的
							//								remove(head);
							//								beginLN = first;//注意这里，去并集的时候需要重新从头开始比较
							//								//如果不是末尾则递归添加
							//								if(beginLN!=null)
							//								{
							//									addBounds(ub);
							//								}
							//								//否则直接添加到末尾
							//								else
							//								{
							//									add(new LNode(ub),last);
							//								}
							//							}
							//							//否则
							//							else
							//							{
							//								//求出两个矩形所分割成的不重合的所有新矩形（3个矩形：矩形大小可能为空）
							//								var arr:Array = cutTwoIntersectedBounds(b,$b);
							//								//移除当前的
							//								remove(head);
							//								//如果不是末尾则递归添加
							//								if(beginLN!=null)
							//								{
							//									addBounds(arr[0]);
							//									addBounds(arr[1]);
							//									addBounds(arr[2]);
							//								}
							//								//否则直接添加到末尾
							//								else
							//								{
							//									add(new LNode(arr[0]),last);
							//									add(new LNode(arr[1]),last);
							//									add(new LNode(arr[2]),last);
							//								}
							//
							//							}
							return;
						}
							//否则继续下一个
						else
						{
							//向下循环
							head = head.next;
							continue;
						}
					}
				}
				
				//如果均没有匹配成功，则直接添加到最后
				if(head==null)
				{
					add(new LNode($b),last);
				}
			}
				//否则直接添加为第一个
			else
			{
				add(new LNode($b),null);
			}
		}
		
		/**
		 * @private
		 * 切割两个相交Bounds为3个不想交的Bounds
		 * 
		 */
		private function cutTwoIntersectedBounds($b1:Bounds,$b2:Bounds):Array
		{
			var arr:Array = [];
			var vArr:Array = [$b1.top,$b1.bottom,$b2.top,$b2.bottom].sort(Array.NUMERIC);
			var hArr:Array = [$b1.left,$b1.right,$b2.left,$b2.right].sort(Array.NUMERIC);
			var l1:Number, r1:Number, l2:Number, r2:Number, l3:Number, r3:Number;
			var bb:Bounds = ($b1.top<=$b2.top) ? $b1 : $b2 ;
			l1 = bb.left;
			r1 = bb.right;
			l2 = hArr[0];
			r2 = hArr[3];
			bb = ($b1.bottom>=$b2.bottom) ? $b1 : $b2 ;
			l3 = bb.left;
			r3 = bb.right;
			return [
				new Bounds(l1,r1,vArr[0],vArr[1]),
				new Bounds(l2,r2,vArr[1],vArr[2]),
				new Bounds(l3,r3,vArr[2],vArr[3])
			];
		}
		/**
		 * 返回此DirtyBounds包含的所有不重合Bounds的一个数组
		 */
		public function getBoundsArr():Array
		{
			var arr:Array = [];
			var head:LNode = first;
			while(head!=null)
			{
				arr.push(head.data);
				head = head.next;
			}
			return arr;
		}
		
		
		//链表基本操作
		//============================================================================================================
		/**
		 * @private
		 * 添加一个LNode
		 * @parm $preLn 上一个元素（在此后面添加）
		 */
		private function add($ln:LNode,$preLn:LNode=null):void
		{
			//第一个
			if($preLn==null)
			{
				first = $ln;
				first.pre = null;
				first.next = null;
				last = $ln;
				last.pre = null;
				last.next = null;
			}
				//最后一个
			else if($preLn==last)
			{
				last.next = $ln;
				$ln.pre = last;
				last = $ln;
			}
				//中间的
			else
			{
				$ln.pre = $preLn;
				$ln.next = $preLn.next;
				$ln.pre.next = $ln;
				$ln.next.pre = $ln;
			}
		}
		/**
		 * @private
		 * 移除一个LNode
		 * 注意：这里不可执行
		 * $ln.pre = null;
		 * $ln.next = null;
		 */
		private  function remove($ln:LNode):void
		{
			if($ln==first)
			{
				if($ln==last)
				{
					first =null;
					last =null;
				}
				else
				{
					first = $ln.next;
					first.pre = null;
				}
			}
			else if($ln==last)
			{
				
				last = last.pre;
				last.next = null;
			}
			else
			{
				$ln.pre.next = $ln.next;
				$ln.next.pre = $ln.pre;
			}
			
			//更新beginLN
			beginLN = $ln.next;
		}
		//============================================================================================================
	}
}
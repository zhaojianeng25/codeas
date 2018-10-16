package com.zcp.cache
{
    import com.zcp.utils.Fun;
    import com.zcp.vo.LNode;
    
    import flash.display.*;

	/**
	 * @private
	 * 缓存基本数据模型
	 * @author zcp
	 * 
	 */	
    public class CacheUnit extends LNode
    {
        public function CacheUnit($data:Object, $id:String)
        {
			super($data, $id);
        }
        public function dispose() : void
        {
            if (data is BitmapData)
            {
                (data as BitmapData).dispose();
            }
			//by zcp 2010.4.28
			//=====================================
			else if (data is DisplayObject)
			{
				if(data.parent && !(data.parent is Loader))
				{
					data.parent.removeChild(data);
				}
				Fun.clearChildren(data as DisplayObject,true);
				if(data is Bitmap)
				{
					(data as Bitmap).bitmapData.dispose();
				}
			}
			//=====================================
			data = null;
			pre = null;
			next = null;
            return;
        }

    }
}

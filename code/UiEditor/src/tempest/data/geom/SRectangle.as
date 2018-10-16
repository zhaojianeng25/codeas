package tempest.data.geom
{
    import flash.geom.*;

    public class SRectangle extends Object
    {
        public var centerPoint:SPoint;
        public var centerPostion:SPoint;
        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;
        private var _left:int;
        private var _right:int;
        private var _top:int;
        private var _bottom:int;

        public function SRectangle(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
        {
            this.centerPoint = new SPoint();
            this.centerPostion = new SPoint();
            this.x = param1;
            this.y = param2;
            this.width = param3;
            this.height = param4;
            this.update();
            return;
        }// end function

        public function get x() : int
        {
            return this._x;
        }// end function

        public function set x(param1:int) : void
        {
            this._x = param1;
            this.update();
            return;
        }// end function

        public function get y() : int
        {
            return this._y;
        }// end function

        public function set y(param1:int) : void
        {
            this._y = param1;
            this.update();
            return;
        }// end function

        public function get width() : int
        {
            return this._width;
        }// end function

        public function set width(param1:int) : void
        {
            this._width = param1;
            this.update();
            return;
        }// end function

        public function get height() : int
        {
            return this._height;
        }// end function

        public function set height(param1:int) : void
        {
            this._height = param1;
            this.update();
            return;
        }// end function

        private function update() : void
        {
            this.centerPoint.x = this.width / 2;
            this.centerPoint.y = this.height / 2;
            this.centerPostion.x = this.x + this.centerPoint.x;
            this.centerPostion.y = this.y + this.centerPoint.y;
            this._left = this._x;
            this._right = this._x + this._width;
            this._top = this._y;
            this._bottom = this._y + this._height;
            return;
        }// end function

        public function setWidth(param1:int) : void
        {
            this.width = param1;
            this.update();
            return;
        }// end function

        public function setHeight(param1:int) : void
        {
            this.height = param1;
            this.update();
            return;
        }// end function

        public function contains2(param1:int, param2:int, param3:int = 0) : Boolean
        {
            if (param1 > this._left - param3)
            {
            }
            if (param1 < this._right + param3)
            {
            }
            if (param2 > this._top - param3)
            {
            }
            return param2 < this._bottom + param3;
        }// end function

        public function contains(param1:int, param2:int) : Boolean
        {
            if (param1 >= this._left)
            {
            }
            if (param1 < this._right)
            {
            }
            if (param2 >= this._top)
            {
            }
            return param2 < this._bottom;
        }// end function

        public function hitTest(param1:Rectangle, param2:uint = 0) : Boolean
        {
            if (param2 == 0)
            {
                if (param1.right >= this._left)
                {
                }
                if (param1.left <= this._right)
                {
                }
                if (param1.bottom >= this._top)
                {
                }
                return param1.top <= this._bottom;
            }
            if (param1.right >= this._left - param2)
            {
            }
            if (param1.left <= this._right + param2)
            {
            }
            if (param1.bottom >= this._top - param2)
            {
            }
            return param1.top <= this._bottom + param2;
        }// end function

        public function toString() : String
        {
            return "SRectangle{x:" + this._x + " y:" + this._y + " width:" + this._width + " height:" + this._height + "}";
        }// end function

    }
}

var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var SList = (function (_super) {
    __extends(SList, _super);
    function SList() {
        _super.apply(this, arguments);
        this._scrollY = 0;
        this._showItemNum = 0;
        this._allItemNum = 0;
        this._topSize = 0;
        this._bottomSize = 0;
        this._outSize = 0;
        this._showDataIndex = 0;
        this.scrollLock = false;
        this._minScrollY = 0;
        this._maskLevel = 2;
        this._mouseY = 0;
    }
    /**
     * $data 数据源
     *
     * UItemRender 渲染器
     *
     * $width 显示宽度
     *
     * $height 显示高度
     *
     * $itemWidth 每列宽度
     *
     * $itemHeight 每列高度
     *
     * $showItemNum 显示列数
     *
     * contentWidth 纹理宽
     *
     * contentHeight 纹理高
     *
     * contentX 纹理横向分割数
     *
     * contentY 纹理纵向分割数
     *
     */
    SList.prototype.setData = function ($data, UItemRender, $width, $height, $itemWidth, $itemHeight, $showItemNum, contentWidth, contentHeight, contentX, contentY, customRenderNum) {
        if (customRenderNum === void 0) { customRenderNum = 0; }
        //  console.log("$data", $data);
        this.width = $width;
        this._height = $height;
        this._itemHeight = $itemHeight;
        this._showIndexList = new Array;
        this._dataAry = $data;
        this._showItemNum = $showItemNum;
        this._allItemNum = contentX * contentY;
        this._contentX = contentX;
        this._contentY = contentY;
        this._outSize = (contentY - this._showItemNum) * $itemHeight;
        this._topSize = 0;
        this._bottomSize = this._outSize;
        this._showDataIndex = 0;
        this._sAtlas = new SListAtlas();
        this._sAtlas.setData(contentWidth, contentHeight, contentX, contentY);
        this.bgMask = new UIMask();
        this.bgMask.x = 0;
        this.bgMask.y = 0;
        this.bgMask.width = $width;
        this.bgMask.height = $height;
        this.bgMask.level = this._maskLevel;
        this.addMask(this.bgMask);
        this._bgRender = new SListBgRender();
        this._bgRender.uiAtlas = this._sAtlas;
        this._bgRender.slist = this;
        this.addRender(this._bgRender);
        this._baseRender = new SlistFrontRender();
        this._baseRender.uiAtlas = this._sAtlas;
        this.addRender(this._baseRender);
        this._bgRender.mask = this.bgMask;
        this._baseRender.mask = this.bgMask;
        var customRenderAry;
        if (customRenderNum != 0) {
            customRenderAry = new Array;
            for (var i = 0; i < customRenderNum; i++) {
                var cRender = new SlistFrontRender();
                cRender.uiAtlas = this._sAtlas;
                this.addRender(cRender);
                cRender.mask = this.bgMask;
                customRenderAry.push(cRender);
            }
        }
        this._itemList = new Array;
        for (var i = 0; i < this._allItemNum; i++) {
            var item = new UItemRender();
            //item.itdata = $data[i];
            item.baseY = float2int(i / contentX) * $itemHeight;
            item.baseX = (i % contentX) * $itemWidth;
            item.uiAtlas = this._sAtlas;
            item.index = i;
            item.create(this, this._bgRender, this._baseRender, customRenderAry);
            item.render($data[i]);
            item.parentTarget = this;
            this._itemList.push(item);
            this._showIndexList.push(i);
        }
        this._minScrollY = this._height - float2int(this._dataAry.length / this._contentX) * this._itemHeight;
        this.scrollY(0);
    };
    /**显示层级 */
    SList.prototype.setShowLevel = function ($num) {
        this._maskLevel = $num;
        if (this.bgMask) {
            this.bgMask.level = this._maskLevel;
        }
    };
    SList.prototype.setSelect = function ($item) {
        for (var i = 0; i < this._itemList.length; i++) {
            if (this._itemList[i] == $item) {
                if (!this._itemList[i].selected) {
                    this._itemList[i].selected = true;
                }
            }
            else {
                if (this._itemList[i].selected) {
                    this._itemList[i].selected = false;
                }
            }
        }
    };
    SList.prototype.setSelectIndex = function ($index) {
        for (var i = 0; i < this._itemList.length; i++) {
            if (i == $index) {
                // if (!this._itemList[i].selected) {
                this._itemList[i].selected = true;
            }
            else {
                if (this._itemList[i].selected) {
                    this._itemList[i].selected = false;
                }
            }
        }
    };
    SList.prototype.refreshData = function ($data) {
        this._dataAry = $data;
        this._showIndexList = new Array;
        for (var i = 0; i < this._itemList.length; i++) {
            this._itemList[i].render($data[i]);
            this._itemList[i].baseY = float2int(i / this._contentX) * this._itemHeight;
            this._showIndexList.push(i);
        }
        this._outSize = (this._contentY - this._showItemNum) * this._itemHeight;
        this._topSize = 0;
        this._bottomSize = this._outSize;
        this._showDataIndex = 0;
        this._minScrollY = this._height - Math.ceil(this._dataAry.length / this._contentX) * this._itemHeight;
        this.scrollY(0);
        if (Math.ceil($data.length / this._contentX) <= this._showItemNum) {
            this.scrollLock = true;
        }
        else {
            this.scrollLock = false;
        }
    };
    SList.prototype.scroll = function () {
    };
    SList.prototype.interactiveEvent = function ($e) {
        if ($e.type == InteractiveEvent.Down) {
            if (this.bgMask.testPoint($e.x, $e.y)) {
                this._mouseY = $e.y;
                if (!this.scrollLock) {
                    Scene_data.uiStage.addEventListener(InteractiveEvent.Move, this.onMove, this);
                    Scene_data.uiStage.addEventListener(InteractiveEvent.Up, this.onUp, this);
                }
                return true;
            }
            else {
                return false;
            }
        }
        return false;
    };
    SList.prototype.onMove = function ($e) {
        this.scrollY($e.y - this._mouseY);
        this._mouseY = $e.y;
    };
    SList.prototype.onUp = function ($e) {
        Scene_data.uiStage.removeEventListener(InteractiveEvent.Move, this.onMove, this);
        Scene_data.uiStage.removeEventListener(InteractiveEvent.Up, this.onUp, this);
    };
    SList.prototype.scrollY = function (val) {
        this._topSize -= val;
        this._bottomSize += val;
        if (this._topSize <= 0) {
            this._bottomflag = true;
            if (this._showDataIndex == 0) {
                //到最顶了
                this._topSize = 0;
                this._bottomSize = this._outSize;
                this._scrollY = 0;
                this._topflag = false;
            }
            else {
                var firstID = this._showIndexList[0];
                var topY = this._itemList[firstID].baseY - this._itemHeight;
                for (var i = 0; i < this._contentX; i++) {
                    var id = this._showIndexList.pop();
                    this._showIndexList.unshift(id);
                    this._itemList[id].baseY = topY;
                    this._itemList[id].render(this._dataAry[this._showDataIndex - 1]);
                    this._showDataIndex--;
                }
                this._bottomSize -= this._itemHeight;
                this._topSize += this._itemHeight;
                this._scrollY += val;
                this._topflag = true;
            }
        }
        else if (this._bottomSize <= 0) {
            this._topflag = true;
            // if (this._scrollY <= this._minScrollY) {
            //     this._scrollY = this._minScrollY;
            //     this._bottomSize = 0;
            //     this._topSize = this._outSize;
            // }
            if ((this._showDataIndex + this._allItemNum) >= this._dataAry.length) {
                //到最底了
                this._bottomSize = 0;
                this._topSize = this._outSize;
                this._scrollY = -(Math.ceil(this._dataAry.length / this._contentX) - this._showItemNum) * this._itemHeight;
                this._bottomflag = false;
            }
            else {
                this._bottomflag = true;
                var lastID = this._showIndexList[this._showIndexList.length - 1];
                var lastY = this._itemList[lastID].baseY + this._itemHeight;
                for (var i = 0; i < this._contentX; i++) {
                    var id = this._showIndexList.shift();
                    this._showIndexList.push(id);
                    this._itemList[id].baseY = lastY;
                    this._itemList[id].render(this._dataAry[this._showDataIndex + this._allItemNum]);
                    this._showDataIndex++;
                }
                this._bottomSize += this._itemHeight;
                this._topSize -= this._itemHeight;
                this._scrollY += val;
            }
        }
        else if (this._showItemNum >= this._dataAry.length) {
            this._topflag = false;
            this._bottomflag = false;
            this._scrollY = 0;
        }
        else {
            this._topflag = true;
            this._bottomflag = true;
            this._scrollY += val;
        }
        //如果到底部无法滚动，则重置状态
        if (this._scrollY <= this._minScrollY && this._minScrollY < 0) {
            this._scrollY = this._minScrollY;
            this._topSize += val;
            this._bottomSize -= val;
            this._topflag = true;
            this._bottomflag = false;
        }
        for (var i = 0; i < this._itemList.length; i++) {
            this._itemList[i].setY(this._scrollY);
        }
        //回调函数
        if (this.backFun) {
            this.backFun(this._topflag, this._bottomflag);
        }
    };
    SList.prototype.dispose = function () {
        //FIXME
    };
    return SList;
})(UIVirtualContainer);
var SListItem = (function () {
    function SListItem() {
        this._height = 10;
        this._list = new Array;
        this.index = 0;
        this.baseY = 0;
        this.baseX = 0;
        this._selected = false;
    }
    SListItem.prototype.addUI = function ($ui) {
        this._list.push($ui);
    };
    SListItem.prototype.create = function ($container, $bgRender, $baseRender, $customizeRenderAry) {
        if ($customizeRenderAry === void 0) { $customizeRenderAry = null; }
        this._bgRender = $bgRender;
        this._baseRender = $baseRender;
        this._customRenderAry = $customizeRenderAry;
    };
    SListItem.prototype.render = function ($data) {
    };
    SListItem.prototype.setSelect = function () {
        this.parentTarget.setSelect(this);
    };
    Object.defineProperty(SListItem.prototype, "selected", {
        get: function () {
            return this._selected;
        },
        set: function (val) {
            this._selected = val;
        },
        enumerable: true,
        configurable: true
    });
    SListItem.prototype.creatSUI = function (render, baseAtlas, $name, x, y, width, height) {
        var obj = baseAtlas.getLayoutData($name);
        var key = $name + this.index;
        this.uiAtlas.addConfig(key, this.index, obj.rect);
        var ui = render.creatBaseComponent(key);
        var obj = new Object;
        ui.name = $name;
        ui.x = obj.x = x;
        ui.y = obj.y = y;
        ui.width = obj.width = width;
        ui.height = obj.height = height;
        ui.baseRec = obj;
        this._list.push(ui);
        return ui;
    };
    SListItem.prototype.creatGrid9Component = function (render, $skinName, WH) {
        var ui = new Grid9Compenent();
        var $gridRect = this.uiAtlas.getGridRec($skinName);
        $gridRect.ogw = WH;
        $gridRect.ogh = WH;
        ui.tr.setRec($gridRect);
        ui.ogw = $gridRect.ogw;
        ui.ogh = $gridRect.ogh;
        ui.gw = ui.ogw / $gridRect.pixelWitdh;
        ui.gh = ui.ogh / $gridRect.pixelHeight;
        ui.tr.setRec($gridRect);
        ui.skinName = $skinName;
        ui.uiRender = render;
        return ui;
    };
    //WH为9宫格参数
    SListItem.prototype.creatGrid9SUI = function (render, baseAtlas, $name, x, y, width, height, WH) {
        if (WH === void 0) { WH = 5; }
        var obj = baseAtlas.getLayoutData($name);
        var key = $name + this.index;
        this.uiAtlas.addConfig(key, this.index, obj.rect);
        var ui = this.creatGrid9Component(render, key, WH);
        var obj = new Object;
        ui.name = $name;
        ui.x = obj.x = x;
        ui.y = obj.y = y;
        ui.width = obj.width = width;
        ui.height = obj.height = height;
        ui.baseRec = obj;
        this._list.push(ui);
        return ui;
    };
    SListItem.prototype.getHeight = function () {
        return this._height;
    };
    SListItem.prototype.setItemUiX = function (ui, xpos) {
        ui.baseRec.x = xpos;
        this.setY(this._sy);
    };
    SListItem.prototype.setY = function ($sy) {
        this._sy = $sy;
        var offset = $sy + this.baseY;
        for (var i = 0; i < this._list.length; i++) {
            this._list[i].y = this._list[i].baseRec.y + offset;
            this._list[i].x = this._list[i].baseRec.x + this.baseX;
        }
    };
    return SListItem;
})();
var SListItemData = (function () {
    function SListItemData() {
        //是否选中
        this.selected = false;
    }
    return SListItemData;
})();
var SListBgRender = (function (_super) {
    __extends(SListBgRender, _super);
    function SListBgRender() {
        _super.apply(this, arguments);
    }
    SListBgRender.prototype.interactiveEvent = function ($e) {
        _super.prototype.interactiveEvent.call(this, $e);
        var tf = this.slist.interactiveEvent($e);
        return tf;
    };
    return SListBgRender;
})(UIRenderComponent);
var SlistFrontRender = (function (_super) {
    __extends(SlistFrontRender, _super);
    function SlistFrontRender() {
        _super.apply(this, arguments);
    }
    // public slist: SList;
    SlistFrontRender.prototype.interactiveEvent = function ($e) {
        _super.prototype.interactiveEvent.call(this, $e);
        return false;
    };
    return SlistFrontRender;
})(UIRenderComponent);
var SListAtlas = (function (_super) {
    __extends(SListAtlas, _super);
    function SListAtlas() {
        _super.call(this);
    }
    SListAtlas.prototype.setData = function ($width, $height, $xnum, $ynum) {
        this.ctx = UIManager.getInstance().getContext2D($width, $height, false);
        this.width = $width;
        this.height = $height;
        this.textureRes = TextureManager.getInstance().getCanvasTexture(this.ctx);
        this.xNum = $xnum;
        this.yNum = $ynum;
        this.itemWidth = $width / this.xNum;
        this.itemHeight = $height / this.yNum;
        this.configData = new Array;
        // for (var i: number = 0; i < itemNum; i++){
        //     var rec: any = new Object;
        //     rec.ox = 0;
        //     rec.oy = i * itemHeight;
        //     rec.ow = itemWidth;
        //     rec.oh = itemHeight;
        //     rec.x = 0;
        //     rec.y = i * itemHeight / $height;
        //     rec.width = itemWidth / $width;
        //     rec.height = itemHeight / $height;
        //     rec.name = i.toString();
        //     this.configData.push(rec);
        // }
    };
    SListAtlas.prototype.addConfig = function ($name, $index, $baseRec) {
        var rec = new Object;
        var bx = ($index % this.xNum) * this.itemWidth;
        var by = float2int($index / this.xNum) * this.itemHeight;
        rec.ox = bx + $baseRec.x;
        rec.oy = by + $baseRec.y;
        rec.ow = $baseRec.width;
        rec.oh = $baseRec.height;
        rec.x = rec.ox / this.width;
        rec.y = rec.oy / this.height;
        rec.width = rec.ow / this.width;
        rec.height = rec.oh / this.height;
        rec.name = $name;
        this.configData.push(rec);
    };
    return SListAtlas;
})(UIAtlas);
//# sourceMappingURL=SList.js.map
class SList extends UIVirtualContainer {

    private _baseX: number;
    private _baseY: number;

    private _contentX: number;
    private _contentY: number;

    private _scrollY: number = 0;
    private _itemList: Array<SListItem>;
    private _itemHeight: number;
    private _showIndexList: Array<number>;
    private _dataAry: Array<SListItemData>;

    private _showItemNum: number = 0;
    private _allItemNum: number = 0;

    private _topSize: number = 0;
    private _bottomSize: number = 0;
    private _outSize: number = 0;

    private _showDataIndex: number = 0;

    private _bgRender: SListBgRender;
    private _baseRender: SlistFrontRender;

    private _sAtlas: SListAtlas;

    private bgMask: UIMask;

    private scrollLock: boolean = false;

    private _minScrollY: number = 0;

    private _maskLevel: number = 2;

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
    public setData($data: Array<SListItemData>, UItemRender: any, $width: number, $height: number, $itemWidth: number, $itemHeight: number, $showItemNum: number,
        contentWidth: number, contentHeight: number, contentX: number, contentY: number, customRenderNum: number = 0): void {
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

        var customRenderAry: Array<UIRenderComponent>;
        if (customRenderNum != 0) {
            customRenderAry = new Array;
            for (var i: number = 0; i < customRenderNum; i++) {
                var cRender: SlistFrontRender = new SlistFrontRender();
                cRender.uiAtlas = this._sAtlas;
                this.addRender(cRender);
                cRender.mask = this.bgMask;
                customRenderAry.push(cRender);
            }
        }

        this._itemList = new Array;


        for (var i: number = 0; i < this._allItemNum; i++) {
            var item: SListItem = new UItemRender();
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
    }
    /**显示层级 */
    public setShowLevel($num: number): void {
        this._maskLevel = $num;
        if (this.bgMask) {
            this.bgMask.level = this._maskLevel;
        }
    }


    public setSelect($item: SListItem): void {
        for (var i: number = 0; i < this._itemList.length; i++) {
            if (this._itemList[i] == $item) {
                if (!this._itemList[i].selected) {
                    this._itemList[i].selected = true;
                }
            } else {
                if (this._itemList[i].selected) {
                    this._itemList[i].selected = false;
                }
            }
        }
    }

    public setSelectIndex($index: number): void {
        for (var i: number = 0; i < this._itemList.length; i++) {
            if (i == $index) {
                // if (!this._itemList[i].selected) {
                this._itemList[i].selected = true;
                // }
            } else {
                if (this._itemList[i].selected) {
                    this._itemList[i].selected = false;
                }
            }
        }
    }

    public refreshData($data: Array<SListItemData>): void {
        this._dataAry = $data;
        this._showIndexList = new Array;
        for (var i: number = 0; i < this._itemList.length; i++) {
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
        } else {
            this.scrollLock = false;
        }
    }

    public scroll(): void {

    }

    public interactiveEvent($e: InteractiveEvent): boolean {
        if ($e.type == InteractiveEvent.Down) {
            if (this.bgMask.testPoint($e.x, $e.y)) {
                this._mouseY = $e.y;
                if (!this.scrollLock) {
                    Scene_data.uiStage.addEventListener(InteractiveEvent.Move, this.onMove, this);
                    Scene_data.uiStage.addEventListener(InteractiveEvent.Up, this.onUp, this);
                }
                return true;
            } else {
                return false;
            }
        }
        return false;
    }
    private _mouseY: number = 0;
    public onMove($e: InteractiveEvent): void {
        this.scrollY($e.y - this._mouseY);
        this._mouseY = $e.y;
    }

    public onUp($e: InteractiveEvent): void {
        Scene_data.uiStage.removeEventListener(InteractiveEvent.Move, this.onMove, this);
        Scene_data.uiStage.removeEventListener(InteractiveEvent.Up, this.onUp, this);
    }


    public backFun: Function
    private _topflag: boolean;
    private _bottomflag: boolean;
    public scrollY(val: number) {

        this._topSize -= val;
        this._bottomSize += val;
        if (this._topSize <= 0) {//下拉
            this._bottomflag = true;
            if (this._showDataIndex == 0) {
                //到最顶了
                this._topSize = 0;
                this._bottomSize = this._outSize;
                this._scrollY = 0;
                this._topflag = false;
            } else {
                var firstID: number = this._showIndexList[0];
                var topY: number = this._itemList[firstID].baseY - this._itemHeight;
                for (var i: number = 0; i < this._contentX; i++) {
                    var id: number = this._showIndexList.pop();
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
        } else if (this._bottomSize <= 0) {//上拉
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
            } else {
                this._bottomflag = true;
                var lastID: number = this._showIndexList[this._showIndexList.length - 1];
                var lastY: number = this._itemList[lastID].baseY + this._itemHeight
                for (var i: number = 0; i < this._contentX; i++) {
                    var id: number = this._showIndexList.shift();
                    this._showIndexList.push(id);
                    this._itemList[id].baseY = lastY;
                    this._itemList[id].render(this._dataAry[this._showDataIndex + this._allItemNum]);
                    this._showDataIndex++;
                }

                this._bottomSize += this._itemHeight;
                this._topSize -= this._itemHeight;
                this._scrollY += val;
            }

        } else if (this._showItemNum >= this._dataAry.length) {
            this._topflag = false;
            this._bottomflag = false;
            this._scrollY = 0;
        } else {
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

        for (var i: number = 0; i < this._itemList.length; i++) {
            this._itemList[i].setY(this._scrollY);
        }

        //回调函数
        if (this.backFun) {
            this.backFun(this._topflag, this._bottomflag);
        }
    }

    public dispose(): void {
        //FIXME
    }

}
class SListItem {
    private _height: number = 10;
    public itdata: SListItemData;
    private _list: Array<UICompenent> = new Array;
    public index: number = 0;
    public baseY: number = 0;
    public baseX: number = 0;
    public uiAtlas: SListAtlas;
    protected _selected: boolean = false;
    public parentTarget: SList;
    public _bgRender: UIRenderComponent;
    public _baseRender: UIRenderComponent;
    public _customRenderAry: Array<UIRenderComponent>;

    public addUI($ui: UICompenent): void {
        this._list.push($ui);
    }


    public create($container: UIConatiner, $bgRender: UIRenderComponent, $baseRender: UIRenderComponent, $customizeRenderAry: Array<UIRenderComponent> = null): void {
        this._bgRender = $bgRender;
        this._baseRender = $baseRender;
        this._customRenderAry = $customizeRenderAry;

    }

    public render($data: SListItemData): void {

    }

    public setSelect(): void {
        this.parentTarget.setSelect(this);
    }

    public set selected(val: boolean) {
        this._selected = val;
    }

    public get selected(): boolean {
        return this._selected;
    }

    public creatSUI(render: UIRenderComponent, baseAtlas: UIAtlas, $name: string,
        x: number, y: number, width: number, height: number): UICompenent {
        var obj: any = baseAtlas.getLayoutData($name);
        var key: string = $name + this.index;
        this.uiAtlas.addConfig(key, this.index, obj.rect);

        var ui: UICompenent = render.creatBaseComponent(key);

        var obj: any = new Object;
        ui.name = $name
        ui.x = obj.x = x;
        ui.y = obj.y = y;
        ui.width = obj.width = width;
        ui.height = obj.height = height;
        ui.baseRec = obj;

        this._list.push(ui);
        return ui;
    }

    private creatGrid9Component(render: UIRenderComponent, $skinName: string, WH: number): UICompenent {
        var ui: Grid9Compenent = new Grid9Compenent();
        var $gridRect: UIGridRentangle = this.uiAtlas.getGridRec($skinName)
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
    }
    //WH为9宫格参数
    public creatGrid9SUI(render: UIRenderComponent, baseAtlas: UIAtlas, $name: string,
        x: number, y: number, width: number, height: number, WH: number = 5): UICompenent {

        var obj: any = baseAtlas.getLayoutData($name);
        var key: string = $name + this.index;
        this.uiAtlas.addConfig(key, this.index, obj.rect);

        var ui: UICompenent = this.creatGrid9Component(render, key, WH);

        var obj: any = new Object;
        ui.name = $name
        ui.x = obj.x = x;
        ui.y = obj.y = y;
        ui.width = obj.width = width;
        ui.height = obj.height = height;
        ui.baseRec = obj;

        this._list.push(ui);
        return ui;
    }

    public getHeight(): number {
        return this._height;
    }

    public setItemUiX(ui: UICompenent, xpos: number): void {
        ui.baseRec.x = xpos;
        this.setY(this._sy);
    }

    public _sy: number;
    public setY($sy: number): void {
        this._sy = $sy;
        var offset: number = $sy + this.baseY;

        for (var i: number = 0; i < this._list.length; i++) {
            this._list[i].y = this._list[i].baseRec.y + offset;
            this._list[i].x = this._list[i].baseRec.x + this.baseX;
        }
    }

}

class SListItemData {
    public data: any;
    public resdata: any
    public id: number;
    //是否选中
    public selected: boolean = false;
    public click: Function;
}

class SListBgRender extends UIRenderComponent {
    public slist: SList;
    public interactiveEvent($e: InteractiveEvent): boolean {
        super.interactiveEvent($e);
        var tf: boolean = this.slist.interactiveEvent($e);
        return tf;
    }
}

class SlistFrontRender extends UIRenderComponent {
    // public slist: SList;
    public interactiveEvent($e: InteractiveEvent): boolean {
        super.interactiveEvent($e);
        return false;
    }

}


class SListAtlas extends UIAtlas {
    public constructor() {
        super();
    }
    public xNum: number;
    public yNum: number;
    public width: number;
    public height: number;
    public itemHeight: number;
    public itemWidth: number;
    public setData($width: number, $height: number, $xnum: number, $ynum: number): void {
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

    }
    public addConfig($name: string, $index: number, $baseRec: any): void {
        var rec: any = new Object;
        var bx: number = ($index % this.xNum) * this.itemWidth;
        var by: number = float2int($index / this.xNum) * this.itemHeight;
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
    }

}
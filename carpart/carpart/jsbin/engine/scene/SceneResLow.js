var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var SceneResLow = (function (_super) {
    __extends(SceneResLow, _super);
    function SceneResLow() {
        _super.apply(this, arguments);
    }
    SceneResLow.prototype.readImgLow = function () {
        _super.prototype.readImgLow.call(this);
        this._progressFun(0);
    };
    //public readImg(): void {
    //    this.imgNum = this._byte.readInt();
    //    this.imgLoadNum = 0;
    //    var time: number = TimeUtil.getTimer();
    //    var bytes: number = 0;
    //    for (var i: number = 0; i < this.imgNum; i++) {
    //        var url: string = Scene_data.fileRoot + this._byte.readUTF();
    //        var imgSize: number = this._byte.readInt();
    //        bytes += imgSize;
    //        //var imgByte: ByteArray = new ByteArray();
    //        //imgByte.length = imgSize;
    //        //this._byte.readBytes(imgByte, 0, imgSize);
    //        //var blob: Blob = new Blob([imgByte.buffer], { type: "application/octet-binary" });
    //        var img: any = new Image();
    //        SceneRes.imgDic[url] = img;
    //        img.onload = () => {
    //            this.loadImg(url, img);
    //        }
    //        img.src = url;
    //    }
    //    this.allImgBytes = bytes;
    //    this.read();
    //    this._progressFun(0);
    //}
    //public loadImg($url: string, img: any): void {
    //    this.imgLoadNum++;
    //    this._progressFun(this.imgLoadNum / this.imgNum);
    //    var loadevt: SceneLoadEvent = new SceneLoadEvent(SceneLoadEvent.INFO_EVENT);
    //    loadevt.str = "加载进度：" +  this.imgLoadNum + "/" + this.imgNum;
    //    ModuleEventManager.dispatchEvent(loadevt);
    //    if (this.imgLoadNum == this.imgNum) {
    //        this._imgComplete = true;
    //        this.allResCom();
    //    }
    //}
    SceneResLow.prototype.loadImg = function (img) {
        TextureManager.getInstance().addRes(img.url, img);
        this.imgLoadNum++;
        this._progressFun(this.imgLoadNum / this.imgNum);
        //var loadevt: SceneLoadEvent = new SceneLoadEvent(SceneLoadEvent.INFO_EVENT);
        //loadevt.str = "加载进度：" +  this.imgLoadNum + "/" + this.imgNum;
        //ModuleEventManager.dispatchEvent(loadevt);
        if (this.imgLoadNum == this.imgNum) {
            this._imgComplete = true;
            this.allResCom();
        }
    };
    return SceneResLow;
})(SceneRes);
//# sourceMappingURL=SceneResLow.js.map
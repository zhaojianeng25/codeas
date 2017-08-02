class SceneResLow extends SceneRes {


    public readImgLow(): void {
        super.readImgLow();
        this._progressFun(0);
    }
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

    public loadImg(img: any): void {
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
    }

} 
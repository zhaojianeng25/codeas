class IconManager {
    private static _instance: IconManager;
    public static getInstance(): IconManager {
        if (!this._instance) {
            this._instance = new IconManager();
        }
        return this._instance;
    }

    private _dic: Object;
    private _loadDic: Object;

    public constructor() {
        this._dic = new Object;
        this._loadDic = new Object;
    }

    public getIconName(name: string, $fun: Function): void {
        this.getIcon(geteqiconIconUrl(name), $fun);
    }

    public getIcon(url: string, $fun: Function): void {
        var uri = Scene_data.fileRoot + url;
        if (this._dic[uri]) {
            $fun(this._dic[uri]);
            return;
        } else if (!this._loadDic[uri]) {
            this._loadDic[uri] = new Array;

            this._loadDic[uri].push($fun);

            var _img: any = new Image();
            _img.onload = () => {
                var loadList: any = this._loadDic[uri]
                for (var i: number = 0; i < loadList.length; i++) {
                    loadList[i](_img);
                }
                delete this._loadDic[uri];
                this._dic[uri] = _img;
            }
            _img.src = uri;
        }else{
            this._loadDic[uri].push($fun);
        }


    }


}

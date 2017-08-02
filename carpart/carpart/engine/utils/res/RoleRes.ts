﻿class RoleRes extends BaseRes {

    public roleUrl: string;
    public actionAry: Array<string>;
    private _fun: Function;
    public meshBatchNum: number;

    //Scene_data.light.AmbientLight.color // Ambient颜色
    //Scene_data.light.AmbientLight.intensity  //Ambient强度
    //Scene_data.light.SunLigth.color   //sun光颜色
    //Scene_data.light.SunLigth.intensity //sun强度
    //Scene_data.light.SunLigth.dircet	//sun方向

    public ambientLightColor: Vector3D;
    public ambientLightIntensity:number;
    public sunLigthColor:Vector3D;
    public sunLigthIntensity: number;
    public nrmDircet: Vector3D;

    constructor() {
        super();
        this.meshBatchNum = 1;
    }

    public load(url: string, $fun: Function): void {
        this._fun = $fun;
        LoadManager.getInstance().load(url, LoadManager.BYTE_TYPE, ($byte: ArrayBuffer) => {
            this.loadComplete($byte);
        });
    }

    public loadComplete($byte: ArrayBuffer): void {
        this._byte = new ByteArray($byte);
        this._byte.position = 0
        this.version = this._byte.readInt();
        this.readMesh();
    }

    public readMesh(): void {
        this.roleUrl = this._byte.readUTF();
        if (this.version >= 16) { //环境参数
            this.ambientLightColor = new Vector3D;
            this.sunLigthColor = new Vector3D;
            this.nrmDircet = new Vector3D;

            this.ambientLightColor.x = this._byte.readFloat();
            this.ambientLightColor.y = this._byte.readFloat();
            this.ambientLightColor.z = this._byte.readFloat();
            this.ambientLightIntensity = this._byte.readFloat();
            this.ambientLightColor.scaleBy(this.ambientLightIntensity);

            this.sunLigthColor.x = this._byte.readFloat();
            this.sunLigthColor.y = this._byte.readFloat();
            this.sunLigthColor.z = this._byte.readFloat();
            this.sunLigthIntensity = this._byte.readFloat();
            this.sunLigthColor.scaleBy(this.sunLigthIntensity);

            this.nrmDircet.x = this._byte.readFloat();
            this.nrmDircet.y = this._byte.readFloat();
            this.nrmDircet.z = this._byte.readFloat();
        }


        MeshDataManager.getInstance().readData(this._byte, this.meshBatchNum, this.roleUrl, this.version);

        this.readAction();
    }

    public readAction(): void {
        this.actionAry = new Array;
        var actionNum: number = this._byte.readInt();
        for (var i: number = 0; i < actionNum; i++){
            var actionName: string = this._byte.readUTF();
            AnimManager.getInstance().readData(this._byte, this.roleUrl + actionName);
            this.actionAry.push(actionName);
        }

     
        this.read(() => {this.readNext() });//readimg 
        
    }

    private readNext(): void {
        this.read();//readmaterial
        this.read();//readparticle;

  

        this._fun();
    }

} 
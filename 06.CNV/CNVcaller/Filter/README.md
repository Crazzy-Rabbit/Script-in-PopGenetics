![QQ截图20230510160117](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/c46288c8-1f6e-4bf7-8a19-4b15a72eda47)
#### 过滤条件如上图所示，我们使用.tsv文件进行过滤，之后再去vcf文件提取保留下来的

    对CNVcaller结果进行过滤，条件为：
    1、所有类型： 轮廓系数（silhouette_score） > 0.6
    2、缺失型： 0.05<del<0.95且dup<=0.01 且 lenth <= 50000
    3、重复型： 0.05<dup<0.95且del<=0.01 且lenth <= 500000
    4、Both型： 0.05<dup<0.95 且 0.05<del<0.95 且 lenth <= 50000

    运行结束会输出5个文件：
    1、三个类型的CNVR文件
    Del_genotypeCNVR.txt，Del_genotypeCNVR.txt，Both_genotypeCNVR.txt
    2、.chat.rectchr，用于Rectchr绘制拷贝数图谱
    3、.Get_Region.txt，用于计算VST
    ps: 写这个脚本真是要了命了（我是新手，哭了）

    CNVFilterAfterCNVcaller.py过滤后，GetCleanCNV.py提取后的文件
    计算公式为: VST =[Vt − (V1×N1+V2×N2)Nt]/Vt
    V1和V2分别为两群体各自的拷贝数方差，
    Nt为样本量总和，Vt为总的拷贝数方差

    简化为：VST =[Vt − Vs]/Vt
    Vs为群体各自拷贝数方差加权群体大小
    Nt为样本量总和，Vt为总的拷贝数方差
    参考：An atlas of CNV maps in cattle, goat and sheep

![image](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/17dfe36c-acbb-4085-a057-94b2a0632bbe)

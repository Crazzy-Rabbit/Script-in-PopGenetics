pong -m pong_filemap.txt -i nd2pop.txt -n  pop_order.txt -l color.txt


# -m     filemap文件，里面是三列文件，第一列r1u1（字母是随便编写，第二个数字和K对应，如果想对K重复跑几次，改变第一个数字） 第二列为K，一行一个值  第三列为Q文件
# -i     ind2pop文件，一列，为个体对应的群体ID，一个个体一个
# -n     order文件，群体ID进行排序，一个群体一个ID就好
# -l     color文件，这个参数可不加，如果嫌弃默认颜色丑，可加，一行一个颜色，可为RGB，16进制以及英文

# 在本地浏览器打开http://localhost:4000（将localhost改成你的服务器IP）

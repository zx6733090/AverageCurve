# AverageCurve

#### 均速曲线路径

由于贝塞尔曲线和基本样条曲线插值形成的曲线路径不是均速的，在某些场景可能会影响效果。比如说鱼游动，一般的曲线插值会忽快忽慢，像下面这样子:

  ![curve](https://chuantu.xyz/t6/734/1589618846x3070492176.png)
  
  变速的曲线不利于精确控制速度，所以需要做额外的计算，以符合要求。
  


在插值之前，额外计算到指定长度的t变量，实现均速曲线，处理之后的效果图：

  ![curve](http://chuantu.xyz/t6/734/1589619484x992248267.png)
  
 #### 均速缓动曲线
 
前言：

物体的运动有时候需要由快变慢或者慢慢加快 这就需要叠加一个缓动曲线，游戏引擎预设的一些曲线都是初等函数叠加形成的，不能直观的感受到缓动曲线的变化趋势。
因此需要一个能够直接想象的到，并且方便自定义曲线的方式。

实现：

  >  let rom = new CatmullRom(pts,1)  
  >  rom.lerp(t).y
  

<table>
    <tr>
        <td>接口</td>
        <td>参数</td>
        <td>说明</td>
    </tr>
    <tr>
        <td rowspan="2">catmullRom=new CatmullRom(pts,usage)</td>
    <td>pts</td>
        <td>曲线经过的点数组</td>
  </tr>
    <tr>
    <td>usage</td>
        <td>0：均速路径曲线<br> 1：均速缓动曲线</td>
    </tr>
  <tr>
        <td>catmullRom.lerp(t)</td>
        <td>t</td>
        <td>插件比例，范围0-1，0：起点， 1：终点</td>
   </tr>
</table>
